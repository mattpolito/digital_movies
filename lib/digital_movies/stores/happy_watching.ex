defmodule DigitalMovies.Stores.HappyWatching do
  alias DigitalMovies.Product
  alias DigitalMovies.Store, as: MovieStore

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
    "iTunes via MA"
  ]

  use MovieStore

  @impl MovieStore
  def parse_product(product) do
    %{title: title, type: type} = parse_product_title(product)

    %Product{
      available: parse_product_availability(product),
      price: parse_product_price(product),
      title: title,
      type: type,
      url: parse_product_url(product)
    }
  end

  def parse_product_price(product) do
    product
    |> Floki.find(@price_selector)
    |> Floki.filter_out("del")
    |> Floki.text()
    |> String.replace(~r/[^\d]/, "")
    |> Integer.parse()
    |> elem(0)
  end

  def parse_type_from_title(title) do
    regex = ~r/^(?<title>.+)\s(?<type>(#{Enum.join(@service_types, "|")}))$/i

    Regex.named_captures(regex, title)
    |> extract_title_and_type(title)
    |> categorize_type()
  end

  def parse_product_availability(product) do
    product
    |> Floki.find(@price_selector)
    |> Floki.text()
    |> String.match?(~r/Sold Out/)
    |> Kernel.not()
  end

  def normalize_type(type) do
    cond do
      String.match?(type, ~r/(?:iTunes SD)/i) ->
        "iTunes SD"

      String.match?(type, ~r/(?:iTunes HD|HD iTunes)/i) ->
        "iTunes HD"

      String.match?(type, ~r/(?:iTunes 4K|4K iTunes)/i) ->
        "iTunes 4K"

      true ->
        type
    end
  end
end
