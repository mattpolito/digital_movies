defmodule DigitalMovies.Stores.HDMovieCodes do
  alias DigitalMovies.Product
  alias DigitalMovies.Store, as: MovieStore

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
      title: title,
      price: parse_product_price(product),
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

  def parse_type_from_title(title) do
    regex = ~r/^(?<title>.+)\s(?<type>(#{Enum.join(@service_types, "|")}))$/i
    Regex.named_captures(regex, title)
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
end
