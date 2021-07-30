defmodule DigitalMovies.Stores.MovieCodes do
  alias DigitalMovies.Product
  alias DigitalMovies.Store, as: MovieStore

  @availability_selector "[data-price]"
  @price_selector "[data-sale-price]"
  @product_url_selector "a.grid-view-item__link"
  @products_selector ".grid--view-items .grid__item"
  @service_types [
    Regex.escape("HD VUDU (Must redeem in VUDU)"),
    Regex.escape("HD VUDU/MA or itunes HD via MA"),
    Regex.escape("HD VUDU/MA"),
    "HD VUDU",
    Regex.escape("HDX or itunes via MA (Redeems now)"),
    Regex.escape("HD itunes (Ports to VUDU/MA via MA)"),
    "UVHDX or itunes HD via MA",
    "itunes 4K UHD Early Release",
    "itunes 4k UHD ONLY",
    "itunes 4k UHD",
    "itunes 4k",
    "itunes HD via MA",
    "itunes HD ONLY",
    "itunes HD",
    "SD or itunes SD via MA"
  ]

  @title_selector ".grid-view-item__title"
  @url "https://movie-codes.com/collections/itunes?sort_by=price-ascending"

  use MovieStore,
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

  def parse_type_from_title(title) do
    regex = ~r/^(?<title>.+)\s(?<type>(#{Enum.join(@service_types, "|")}))$/i

    Regex.named_captures(regex, String.trim(title))
    |> extract_title_and_type(title)
    |> categorize_type()
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
