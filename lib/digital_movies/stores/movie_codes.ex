defmodule DigitalMovies.Stores.MovieCodes do
  alias DigitalMovies.Product
  alias DigitalMovies.Store, as: MovieStore

  @price_selector "[data-sale-price]"
  @product_url_selector "a.grid-view-item__link"
  @products_selector ".grid--view-items .grid__item"
  @service_types [
    Regex.escape("HD VUDU (Must redeem in VUDU)"),
    Regex.escape("HD VUDU/MA or itunes HD via MA"),
    Regex.escape("HD VUDU/MA"),
    "HD VUDU",
    Regex.escape("HDX or itunes via MA (Redeems now)"),
    Regex.escape("HD itunes (Ports to VUDU/MA via MA)"),
    "UVHDX or itunes HD via MA",
    "itunes 4K UHD Early Release",
    "itunes 4k UHD ONLY",
    "itunes 4k UHD",
    "itunes 4k",
    "itunes HD via MA",
    "itunes HD ONLY",
    "itunes HD",
    "SD or itunes SD via MA"
  ]

  @title_selector ".grid-view-item__title"
  @url "https://movie-codes.com/collections/itunes?sort_by=price-ascending"

  use MovieStore

  @impl MovieStore
  def parse_product(product) do
    %{title: title, type: type} = parse_product_title(product)

    %Product{
      price: parse_product_price(product),
      title: title,
      type: type,
      url: parse_product_url(product)
    }
  end

  defp parse_product_title(product) do
    title =
      product
      |> Floki.find(@title_selector)
      |> Floki.text()

    case parse_type_from_title(title) do
      %{"title" => title, "type" => type} ->
        %{
          title: title,
          type: type
        }

      _ ->
        %{
          title: title,
          type: nil
        }
    end
  end

  defp parse_product_price(product) do
    product
    |> Floki.find(@price_selector)
    |> Floki.text()
    |> String.replace(~r/[^\d]/, "")
    |> Integer.parse()
    |> elem(0)
  end

  def parse_type_from_title(title) do
    regex = ~r/^(?<title>.+)\s(?<type>(#{Enum.join(@service_types, "|")}))$/i
    Regex.named_captures(regex, String.trim(title))
  end

  defp parse_product_url(product) do
    path =
      product
      |> Floki.find(@product_url_selector)
      |> Floki.attribute("href")
      |> List.first()

    %URI{host: host, scheme: scheme} = URI.parse(@url)

    "#{scheme}://#{host}#{path}"
  end
end
