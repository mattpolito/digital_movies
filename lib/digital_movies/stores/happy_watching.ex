defmodule DigitalMovies.Stores.HappyWatching do
  alias DigitalMovies.Product
  alias DigitalMovies.Stores.StoreBehavior

  @behaviour StoreBehavior

  @products_selector ".products .product"
  @product_url_selector ".details > a"
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
    |> Floki.filter_out("del")
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
    regex = ~r/^(?<title>.+)\s(?<type>(#{Enum.join(@service_types, "|")}))$/i
    Regex.named_captures(regex, title)
  end
end
