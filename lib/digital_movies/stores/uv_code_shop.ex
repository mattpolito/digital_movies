defmodule DigitalMovies.Stores.UVCodeShop do
  alias DigitalMovies.Product
  alias DigitalMovies.Stores.StoreBehavior

  @behaviour StoreBehavior

  @price_selector ".product-item--price"
  @product_url_selector "a.product-grid-item"
  @products_selector ".grid-uniform .grid-item:not(.sold-out)"
  @service_types [
    Regex.escape("SD VUDU/MA or itunes SD via MA"),
    "SD or itunes SD via MA",
    "HD VUDU/MA or itunes HD via MA",
    "HDX or itunes HD via MA",
    Regex.escape("itunes 4K UHD (Does not port)"),
    "itunes 4K UHD",
    "itunes HD"
  ]
  @title_selector "p"
  @url "https://www.uvcodeshop.com/collections/itunes-hd?sort_by=price-ascending"

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
          title: title,
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
    regex = ~r/^(?<title>.+)\s(?<type>(#{Enum.join(@service_types, "|")}))$/i
    Regex.named_captures(regex, title)
  end
end
