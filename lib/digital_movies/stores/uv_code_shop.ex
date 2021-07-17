defmodule DigitalMovies.Stores.UVCodeShop do
  alias DigitalMovies.Product
  alias DigitalMovies.Stores.StoreBehavior

  @behaviour StoreBehavior

  @products_selector ".grid-uniform .grid-item:not(.sold-out)"
  @title_selector "p"
  @price_selector ".product-item--price"
  @url "https://www.uvcodeshop.com/collections/itunes-hd?sort_by=price-ascending"
  @service_types [
    "SD VUDU/MA or itunes SD via MA",
    "SD or itunes SD via MA",
    "itunes 4K UHD",
    "itunes HD"
  ]

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

    regex = ~r/^(?<title>.+)\s(?<type>(#{Enum.join(@service_types, "|")}))$/i

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
    |> Integer.parse()
    |> elem(0)
  end
end
