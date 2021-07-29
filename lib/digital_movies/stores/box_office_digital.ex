defmodule DigitalMovies.Stores.BoxOfficeDigital do
  alias DigitalMovies.Product
  alias DigitalMovies.Store, as: MovieStore

  @price_selector ".card .card-body .price-section .price.price--withoutTax"
  @product_url_selector ".card-figure > a"
  @products_selector "main .productGrid .product"
  @title_selector ".card .card-body .card-title"
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

  def parse_type_from_title(title) do
    regex = ~r/^(?<title>.+)\s\[(?<type>.+)\]/i

    Regex.named_captures(regex, title)
    |> extract_title_and_type(title)
  end

  defp parse_product_url(product) do
    product
    |> Floki.find(@product_url_selector)
    |> Floki.attribute("href")
    |> List.first()
  end
end
