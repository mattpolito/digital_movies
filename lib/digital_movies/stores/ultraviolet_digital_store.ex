defmodule DigitalMovies.Stores.UltravioletDigitalStore do
  alias DigitalMovies.Product
  alias DigitalMovies.Stores.StoreBehavior

  @behaviour StoreBehavior

  @price_selector ".product-card .price .price__sale .price-item"
  @products_selector ".grid--view-items .grid__item"
  @title_selector ".product-card .product-card__title"
  @url "https://ultravioletdigitalstore.com/collections/itunes-codes?sort_by=price-ascending"
  @service_types [
    "Vudu 4K or iTunes 4K",
    "itunes 4K",
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

    regex = ~r/^(?<title>.+)(\(\d+.+)(?<type>(#{Enum.join(@service_types, "|")})).+$/i

    case Regex.named_captures(regex, title) do
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
end
