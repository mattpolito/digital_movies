defmodule DigitalMovies.Stores.UVCodeShop do
  alias DigitalMovies.Product
  alias DigitalMovies.Store, as: MovieStore

  @price_selector ".product-item--price"
  @product_url_selector "a.product-grid-item"
  @products_selector ".grid-uniform .grid-item:not(.sold-out)"
  @service_types [
    Regex.escape("SD VUDU/MA or itunes SD via MA"),
    "SD or itunes SD via MA",
    "HD VUDU/MA or itunes HD via MA",
    "HDX or itunes HD via MA",
    Regex.escape("itunes 4K UHD (Does not port)"),
    "itunes 4K UHD",
    "itunes HD"
  ]
  @title_selector "p"
  @url "https://www.uvcodeshop.com/collections/itunes-hd?sort_by=price-ascending"

  use MovieStore

  @impl MovieStore
  def parse_product(product_markup) do
    %Product{available: true}
    |> parse_product_price(product_markup)
    |> parse_product_url(product_markup)
    |> parse_product_title(product_markup)
    |> parse_product_type()
  end

  def parse_product_price(product, product_markup) do
    price =
      product_markup
      |> Floki.find(@price_selector)
      |> Floki.text()
      |> String.replace(~r/[^\d]/, "")
      |> Integer.parse()
      |> elem(0)

    %Product{product | price: price}
  end

  def parse_product_url(product, product_markup) do
    path =
      product_markup
      |> Floki.find(@product_url_selector)
      |> Floki.attribute("href")
      |> List.first()

    %URI{host: host, scheme: scheme} = URI.parse(@url)

    url = "#{scheme}://#{host}#{path}"

    %Product{product | url: url}
  end

  def parse_product_title(product, product_markup) do
    title =
      product_markup
      |> Floki.find(@title_selector)
      |> Floki.text()

    %Product{product | title: title}
  end

  def parse_product_type(product) do
    %{title: title, type: type} =
      case parse_type_from_title(product.title) do
        %{"title" => title, "type" => type} ->
          %{
            title: title,
            type: type
          }

        _ ->
          %{
            title: product.title,
            type: nil
          }
      end

    %Product{product | title: title, type: type}
  end

  def parse_type_from_title(title) do
    regex = ~r/^(?<title>.+)\s(?<type>(#{Enum.join(@service_types, "|")}))$/i
    Regex.named_captures(regex, title)
  end
end
