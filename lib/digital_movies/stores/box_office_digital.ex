defmodule DigitalMovies.Stores.BoxOfficeDigital do
  alias DigitalMovies.Product
  alias DigitalMovies.Store, as: MovieStore

  @price_selector ".card .card-body .price-section .price.price--withoutTax"
  @product_url_selector ".card-figure > a"
  @products_selector "main .productGrid .product"
  @title_selector ".card .card-body .card-title"
  @title_type_separator_regex ~r/^(?<title>.+)\s\[(?<type>.+)\]/i
  @url "https://boxofficedigital.com/formats/itunes-4k/?sort=priceasc"

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

  defp parse_product_url(product) do
    product
    |> Floki.find(@product_url_selector)
    |> Floki.attribute("href")
    |> List.first()
  end
end
