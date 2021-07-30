defmodule DigitalMovies.Stores.UVDigitalNow do
  alias DigitalMovies.Product
  alias DigitalMovies.Store, as: MovieStore

  @price_selector ".product-price"
  @product_url_selector ".product-name a"
  @products_selector ".product-grid-item"
  @type_seperators [
    Regex.escape("(4K) VUDU"),
    Regex.escape("(4K) iTunes"),
    Regex.escape("(HD) GOOGLE PLAY"),
    Regex.escape("(HD) MA OR (HDX) VUDU"),
    Regex.escape("(HDX) VUDU"),
    Regex.escape("(SD) Moviesanywhere Code"),
    Regex.escape("(SD) VUDU")
  ]
  @title_selector ".product-name"
  @url "https://uvdigitalnow.dpdcart.com"

  use MovieStore

  @impl MovieStore
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

  def parse_type_from_title(title) do
    regex = ~r/^(?:\* )?(?<title>.+)\s(?<type>(#{Enum.join(@type_seperators, "|")}).*)$/

    Regex.named_captures(regex, title)
    |> extract_title_and_type(title)
    |> categorize_type
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
end
