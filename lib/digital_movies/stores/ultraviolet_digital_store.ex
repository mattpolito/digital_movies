defmodule DigitalMovies.Stores.UltravioletDigitalStore do
  alias DigitalMovies.Product
  alias DigitalMovies.Store, as: MovieStore

  @service_separators [
    "Vudu 4K or iTunes 4K",
    "itunes 4K",
    "itunes HD"
  ]

  use MovieStore,
    product_price_selector: "[data-sale-price]",
    product_title_selector: ".product-card .product-card__title",
    product_title_separator_regex:
      ~r/\A(?<title>.+)\s(\(\d+.+)(?<type>(#{Enum.join(@service_separators, "|")})).+\z/i,
    product_url_selector: ".product-card > a",
    products_selector: ".grid--view-items .grid__item",
    url: "https://ultravioletdigitalstore.com/collections/itunes-codes?sort_by=price-ascending"

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
