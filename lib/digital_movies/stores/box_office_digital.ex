defmodule DigitalMovies.Stores.BoxOfficeDigital do
  alias DigitalMovies.Stores.Product
  alias DigitalMovies.Stores.Store

  use Store,
    product_price_selector: ".card .card-body .price-section .price.price--withoutTax",
    product_title_selector: ".card .card-body .card-title",
    product_title_separator_regex: ~r/^(?<title>.+)\s\[(?<type>.+)\]/i,
    product_url_selector: ".card-figure > a",
    products_selector: "main .productGrid .product",
    url: "https://boxofficedigital.com/formats/itunes-4k/?sort=priceasc"

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

  defp parse_product_url(product) do
    product
    |> Floki.find(@product_url_selector)
    |> Floki.attribute("href")
    |> List.first()
  end
end
