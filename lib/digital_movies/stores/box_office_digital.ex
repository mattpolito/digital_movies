defmodule DigitalMovies.Stores.BoxOfficeDigital do
  alias DigitalMovies.Stores.StoreBehavior

  @price_selector ".card .card-body .price-section .price.price--withoutTax"
  @products_selector "main .productGrid .product"
  @title_selector ".card .card-body .card-title"
  @url "https://boxofficedigital.com/formats/itunes-4k/?sort=priceasc"

  @behaviour StoreBehavior

  @impl StoreBehavior
  def url, do: @url

  @impl StoreBehavior
  def parse(document) do
    document
    |> Floki.find(@products_selector)
    |> Enum.map(fn product ->
      %{
        title: Floki.find(product, @title_selector) |> Floki.text(),
        price: Floki.find(product, @price_selector) |> Floki.text()
      }
    end)
  end
end
