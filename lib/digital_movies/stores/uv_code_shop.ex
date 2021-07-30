defmodule DigitalMovies.Stores.UVCodeShop do
  alias DigitalMovies.Product
  alias DigitalMovies.Store, as: MovieStore

  @price_selector ".product-item--price"
  @product_url_selector "a.product-grid-item"
  @products_selector ".grid-uniform .grid-item:not(.sold-out)"
  @service_separators [
    Regex.escape("SD VUDU/MA or itunes SD via MA"),
    "SD or itunes SD via MA",
    "HD VUDU/MA or itunes HD via MA",
    "HDX or itunes HD via MA",
    Regex.escape("itunes 4K UHD (Does not port)"),
    "itunes 4K UHD",
    "itunes HD"
  ]
  @title_selector "p"
  @title_type_separator_regex ~r/^(?<title>.+)\s(?<type>(#{Enum.join(@service_separators, "|")}))$/i
  @url "https://www.uvcodeshop.com/collections/itunes-hd?sort_by=price-ascending"

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
end
