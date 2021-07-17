defmodule DigitalMovies.Stores.BoxOfficeDigital do
  alias DigitalMovies.Product
  alias DigitalMovies.Stores.StoreBehavior

  @behaviour StoreBehavior

  @price_selector ".card .card-body .price-section .price.price--withoutTax"
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

  defp parse_product(product) do
    %{title: title, type: type} = parse_product_title(product)

    %Product{
      title: title,
      price: parse_product_price(product),
      type: type
    }
  end

  defp parse_product_title(product) do
    title =
      product
      |> Floki.find(@title_selector)
      |> Floki.text()

    regex = ~r/^(?<title>.+)\s\[(?<type>.+)\]/i

    case Regex.named_captures(regex, title) do
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
end
