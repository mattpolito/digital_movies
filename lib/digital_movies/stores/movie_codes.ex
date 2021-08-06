defmodule DigitalMovies.Stores.MovieCodes do
  alias DigitalMovies.Product
  alias DigitalMovies.Store, as: MovieStore

  @service_separators [
    "HD VUDU",
    "HDX",
    "HD itunes",
    "UVHDX",
    "itunes",
    "SD or itunes SD"
  ]
  @availability_selector "[data-price]"

  use MovieStore,
    product_price_selector: "[data-sale-price]",
    product_title_selector: ".grid-view-item__title",
    product_title_separator_regex: ~r/^(?<title>.+?)\s(?<type>(#{Enum.join(@service_separators, "|")}).*)$/i,
    product_url_selector: "a.grid-view-item__link",
    products_selector: ".grid--view-items .grid__item",
    url: "https://movie-codes.com/collections/itunes?sort_by=price-ascending"

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

  def parse_product_availability(product) do
    product
    |> Floki.find(@availability_selector)
    |> Floki.text()
    |> String.match?(~r/Sold Out/i)
    |> Kernel.not()
  end

  def normalize_type(type) do
    cond do
      String.match?(type, ~r/(?:iTunes SD)/i) ->
        "iTunes SD"

      String.match?(type, ~r/(?:iTunes HD|\(HD\) itunes|HDX or itunes)/i) ->
        "iTunes HD"

      String.match?(type, ~r/(?:iTunes 4K)/i) ->
        "iTunes 4K"

      true ->
        type
    end
  end
end
