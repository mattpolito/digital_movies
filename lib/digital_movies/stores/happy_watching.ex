defmodule DigitalMovies.Stores.HappyWatching do
  alias DigitalMovies.Product
  alias DigitalMovies.Stores.StoreBehavior

  @behaviour StoreBehavior

  @products_selector ".products .product"
  @title_selector ".details h4"
  @price_selector ".details .price"
  @url "https://happywatching.com/collections/itunes?sort_by=price-ascending"
  @service_types [
    "HDX VUDU & 4K iTunes Full Code",
    Regex.escape("HDX VUDU & HD iTunes (Full Code!)"),
    "SD UV or iTunes via MA",
    "SD Vudu or iTunes via MA",
    "4K iTunes",
    "HD iTunes Only",
    "HD iTunes",
    "iTunes via MA",
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
    |> Floki.filter_out("del")
    |> Floki.text()
    |> String.replace(~r/[^\d]/, "")
    |> Integer.parse()
    |> elem(0)
  end
end
