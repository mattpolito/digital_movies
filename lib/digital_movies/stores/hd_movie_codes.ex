defmodule DigitalMovies.Stores.HDMovieCodes do
  alias DigitalMovies.Stores.Product
  alias DigitalMovies.Stores.Store

  @availability_selector "[itemprop='itemCondition']"
  @service_separators [
    "VUDU HD or iTunes HD via Movies Anywhere",
    "VUDU 4K through iTunes 4K",
    "VUDU HD or iTunes HD via MA",
    "iTunes 4K",
    "iTunes HD"
  ]

  use Store,
    product_price_selector: "[itemprop='price']",
    product_title_selector: "[itemprop='name']",
    product_title_separator_regex:
      ~r/^(?<title>.+)\s(?<type>(#{Enum.join(@service_separators, "|")}))$/i,
    product_url_selector: "[itemprop='url']",
    products_selector: ".products [itemprop='itemListElement']",
    url: "https://hdmoviecodes.com/collections/itunes-hd?sort_by=price-ascending"

  @impl Store
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
    |> Floki.find(@product_price_selector)
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
