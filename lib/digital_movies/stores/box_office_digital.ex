defmodule DigitalMovies.Stores.BoxOfficeDigital do
  alias DigitalMovies.Product
  alias DigitalMovies.Stores.StoreBehavior

  @behaviour StoreBehavior

  @price_selector ".card .card-body .price-section .price.price--withoutTax"
  @product_url_selector ".card-figure > a"
  @products_selector "main .productGrid .product"
  @title_selector ".card .card-body .card-title"
  @url "https://boxofficedigital.com/formats/itunes-4k/?sort=priceasc"

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
    |> String.replace(~r/[^\d]/, "")
    |> Integer.parse()
    |> elem(0)
  end

  def parse_type_from_title(title) do
    regex = ~r/^(?<title>.+)\s\[(?<type>.+)\]/i
    Regex.named_captures(regex, title)
  end

  defp parse_product_url(product) do
    product
    |> Floki.find(@product_url_selector)
    |> Floki.attribute("href")
    |> List.first
  end
end
