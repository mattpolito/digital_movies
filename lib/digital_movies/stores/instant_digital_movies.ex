defmodule DigitalMovies.Stores.InstantDigitalMovies do
  alias DigitalMovies.Stores.Product
  alias DigitalMovies.Stores.Store

  use Store,
    product_price_selector: ".price-value",
    product_title_selector: ".product-grid-item-name",
    product_title_separator_regex: ~r/^(?<title>.+)\s\[(?<type>.+)\]/i,
    product_url_selector: ".product-grid-item-name > a",
    products_selector: ".product-grid .product-grid-item",
    url: "https://instantdigitalmovies.com/formats/itunes/itunes-4k/?sort=priceasc"

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

  def parse_product_url(product) do
    product
    |> Floki.find(@product_url_selector)
    |> Floki.attribute("href")
    |> List.first()
    |> String.replace_suffix("/", "")
  end
end
