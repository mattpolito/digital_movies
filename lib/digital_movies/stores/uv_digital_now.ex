defmodule DigitalMovies.Stores.UVDigitalNow do
  alias DigitalMovies.Stores.Product
  alias DigitalMovies.Stores.Store

  @service_separators [
    Regex.escape("(4K) VUDU"),
    Regex.escape("(4K) iTunes"),
    Regex.escape("(HD) GOOGLE PLAY"),
    Regex.escape("(HD) MA OR (HDX) VUDU"),
    Regex.escape("(HDX) VUDU"),
    Regex.escape("(SD) Moviesanywhere Code"),
    Regex.escape("(SD) VUDU")
  ]

  use Store,
    product_price_selector: ".product-price",
    product_title_selector: ".product-name",
    product_title_separator_regex:
      ~r/^(?:\* )?(?<title>.+)\s(?<type>(#{Enum.join(@service_separators, "|")}).*)$/,
    product_url_selector: ".product-name a",
    products_selector: ".product-grid-item",
    url: "https://uvdigitalnow.dpdcart.com"

  @impl Store
  def parse_product(product) do
    %{title: title, type: type} = parse_product_title(product)

    %Product{
      available: true,
      price: parse_product_price(product),
      title: title,
      type: type,
      url: parse_product_url(product)
    }
  end

  def normalize_type(type) do
    cond do
      String.match?(type, ~r/(?:itunes in sd|\(SD\) itunes)/i) ->
        "iTunes SD"

      String.match?(type, ~r/(?:itunes in hd|\(HD\) iTunes)/i) ->
        "iTunes HD"

      String.match?(type, ~r/(?:iTunes for 4K|\(4K\) itunes)/i) ->
        "iTunes 4K"

      true ->
        type
    end
  end

  def parse_product_url(product) do
    path =
      product
      |> Floki.find(product_url_selector())
      |> Floki.attribute("href")
      |> List.first()
      |> String.split("?")
      |> List.first()

    %URI{host: host, scheme: scheme} = URI.parse(url())

    "#{scheme}://#{host}#{path}"
  end
end
