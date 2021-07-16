defmodule DigitalMovies.Stores.HappyWatching do
  alias DigitalMovies.Product
  alias DigitalMovies.Stores.StoreBehavior

  @behaviour StoreBehavior

  @products_selector ".products .product"
  @title_selector ".details h4"
  @price_selector ".details .price"
  @url "https://happywatching.com/collections/itunes?sort_by=price-ascending"

  @impl StoreBehavior
  def url, do: @url

  @impl StoreBehavior
  def parse(document) do
    document
    |> Floki.find(@products_selector)
    |> Enum.map(&parse_product/1)
  end

  defp parse_product(product) do
    %Product{
      title: parse_product_title(product),
      price: parse_product_price(product)
    }
  end

  defp parse_product_title(product) do
    product
    |> Floki.find(@title_selector)
    |> Floki.text
  end

  defp parse_product_price(product) do
    product
    |> Floki.find(@price_selector)
    |> Floki.filter_out("del")
    |> Floki.text
    |> String.replace(~r/[^\d]/, "")
    |> Integer.parse
    |> elem(0)
  end
end
