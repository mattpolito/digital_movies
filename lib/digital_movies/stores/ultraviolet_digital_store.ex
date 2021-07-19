defmodule DigitalMovies.Stores.UltravioletDigitalStore do
  alias DigitalMovies.Product
  alias DigitalMovies.Stores.StoreBehavior

  @behaviour StoreBehavior

  @price_selector "[data-sale-price]"
  @product_url_selector ".product-card > a"
  @products_selector ".grid--view-items .grid__item"
  @service_types [
    "Vudu 4K or iTunes 4K",
    "itunes 4K",
    "itunes HD"
  ]
  @title_selector ".product-card .product-card__title"
  @url "https://ultravioletdigitalstore.com/collections/itunes-codes?sort_by=price-ascending"

  @impl StoreBehavior
  def url, do: @url

  @impl StoreBehavior
  def parse(document) do
    document
    |> Floki.find(@products_selector)
    |> Enum.map(&parse_product/1)
  end

  def parse_product(product) do
    %{title: title, type: type} = parse_product_title(product)

    %Product{
      price: parse_product_price(product),
      title: title,
      type: type,
      url: parse_product_url(product),
    }
  end

  defp parse_product_title(product) do
    title =
      product
      |> Floki.find(@title_selector)
      |> Floki.text()

    case parse_type_from_title(title) do
      %{"title" => title, "type" => type} ->
        %{
          title: String.trim(title),
          type: type
        }

      _ ->
        %{
          title: title,
          type: nil
        }
    end
  end

  defp parse_product_price(product) do
    product
    |> Floki.find(@price_selector)
    |> Floki.text()
    |> String.replace(~r/[^\d]/, "")
    |> Integer.parse()
    |> elem(0)
  end

  defp parse_product_url(product) do
    path = product
    |> Floki.find(@product_url_selector)
    |> Floki.attribute("href")
    |> List.first

    %URI{host: host, scheme: scheme} = URI.parse(@url)

    "#{scheme}://#{host}#{path}"
  end

  def parse_type_from_title(title) do
    regex = ~r/\A(?<title>.+)\s(\(\d+.+)(?<type>(#{Enum.join(@service_types, "|")})).+\z/i
    Regex.named_captures(regex, title)
  end
end
