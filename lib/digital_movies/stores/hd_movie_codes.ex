defmodule DigitalMovies.Stores.HDMovieCodes do
  alias DigitalMovies.Product
  alias DigitalMovies.Store, as: MovieStore

  @availability_selector "[itemprop='itemCondition']"
  @products_selector ".products [itemprop='itemListElement']"
  @title_selector "[itemprop='name']"
  @price_selector "[itemprop='price']"
  @product_url_selector "[itemprop='url']"
  @url "https://hdmoviecodes.com/collections/itunes-hd?sort_by=price-ascending"
  @service_types [
    "VUDU HD or iTunes HD via Movies Anywhere",
    "VUDU 4K through iTunes 4K",
    "VUDU HD or iTunes HD via MA",
    "iTunes 4K",
    "iTunes HD"
  ]

  use MovieStore

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

  def parse_type_from_title(title) do
    regex = ~r/^(?<title>.+)\s(?<type>(#{Enum.join(@service_types, "|")}))$/i

    Regex.named_captures(regex, title)
    |> extract_title_and_type(title)
    |> categorize_type()
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
