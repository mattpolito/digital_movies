defmodule DigitalMovies.Stores do
  alias DigitalMovies.Stores

  @stores [
    Stores.HDMovieCodes,
    Stores.HappyWatching,
    Stores.InstantDigitalMovies,
    Stores.MovieCodes,
    Stores.UVCodeShop,
    Stores.UVDigitalNow,
    Stores.UltravioletDigitalStore
  ]

  def fetch_store(store) do
    %HTTPoison.Response{body: body, status_code: status_code} = Crawly.fetch(store.url)

    case status_code do
      200 ->
        {:ok, document} = Floki.parse_document(body)

        document
        |> store.parse

      _ ->
        []
    end
  end

  def refresh_listings(stores \\ @stores) do
    DigitalMovies.Repo.update_all(DigitalMovies.Movies.Listing, set: [available: false])

    for store <- stores do
      store
      |> fetch_store()
      |> Enum.each(&DigitalMovies.Movies.refresh_listing/1)
    end
  end
end
