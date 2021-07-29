defmodule DigitalMovies.Stores.InstantDigitalMovies do
  alias DigitalMovies.Product
  alias DigitalMovies.Store, as: MovieStore

  @price_selector ".price-value"
  @product_url_selector ".product-grid-item-name > a"
  @products_selector ".product-grid .product-grid-item"
  @title_selector ".product-grid-item-name"
  @url "https://instantdigitalmovies.com/formats/itunes/itunes-4k/?sort=priceasc"

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
    regex = ~r/^(?<title>.+)\s\[(?<type>.+)\]/i

    Regex.named_captures(regex, title)
    |> extract_title_and_type(title)
    |> categorize_type()
  end

  def parse_product_url(product) do
    product
    |> Floki.find(@product_url_selector)
    |> Floki.attribute("href")
    |> List.first()
    |> String.replace_suffix("/", "")
  end
end
