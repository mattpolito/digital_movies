defmodule DigitalMovies.Stores do
  alias DigitalMovies.Stores

  @stores [
    Stores.BoxOfficeDigital,
    Stores.HDMovieCodes,
    Stores.HappyWatching,
    Stores.InstantDigitalMovies,
    Stores.MovieCodes,
    Stores.UVCodeShop,
    Stores.UVDigitalNow,
    Stores.UltravioletDigitalStore
  ]

  def run(stores \\ @stores) do
    # for store <- stores,
    #     %HTTPoison.Response{body: body, status_code: 200} <- Crawly.fetch(store.url) do
    #   {:ok, document} = Floki.parse_document(body)

    listings =
      for store <- stores do
        %HTTPoison.Response{body: body, status_code: status_code} = Crawly.fetch(store.url)

        case status_code do
          200 ->
            parse_body(body, store)

          _ ->
            []
        end
      end

    List.flatten(listings)
  end

  defp parse_body(body, store) do
    {:ok, document} = Floki.parse_document(body)

    document
    |> store.parse
  end

  def refresh_listings() do
    for store_product <- run() do
      DigitalMovies.Movies.refresh_listing(store_product)
    end
  end
end
