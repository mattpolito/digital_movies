defmodule DigitalMovies.Stores.UltravioletDigitalStore do
  alias DigitalMovies.Stores.StoreBehavior

  @price_selector ".product-item--price"
  @products_selector ".grid--view-items"
  @title_selector "p"
  @url "https://ultravioletdigitalstore.com/collections/itunes-codes?sort_by=price-ascending"

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
