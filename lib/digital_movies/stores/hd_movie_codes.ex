defmodule DigitalMovies.Stores.HDMovieCodes do
  alias DigitalMovies.Product
  alias DigitalMovies.Store, as: MovieStore

  @availability_selector "[itemprop='itemCondition']"
  @title_selector "[itemprop='name']"
  @price_selector "[itemprop='price']"
  @product_url_selector "[itemprop='url']"
  @service_separators [
    "VUDU HD or iTunes HD via Movies Anywhere",
    "VUDU 4K through iTunes 4K",
    "VUDU HD or iTunes HD via MA",
    "iTunes 4K",
    "iTunes HD"
  ]
  @title_type_separator_regex ~r/^(?<title>.+)\s(?<type>(#{Enum.join(@service_separators, "|")}))$/i

  use MovieStore,
    products_selector: ".products [itemprop='itemListElement']",
    url: "https://hdmoviecodes.com/collections/itunes-hd?sort_by=price-ascending"

  @impl MovieStore
  def parse_product(product) do
    %{title: title, type: type} = parse_product_title(product)

    %Product{
      available: parse_product_availability(product),
      title: title,
      price: parse_product_price(product),
      type: type,
      url: parse_product_url(product)
    }
  end

  def parse_product_price(product) do
    product
    |> Floki.find(@price_selector)
    |> Floki.attribute("content")
    |> List.first()
    |> String.replace(~r/[^\d]/, "")
    |> Integer.parse()
    |> elem(0)
  end

  def parse_product_availability(product) do
    product
    |> Floki.find(@availability_selector)
    |> Floki.text()
    |> String.match?(~r/Sold Out/)
    |> Kernel.not()
  end
end
