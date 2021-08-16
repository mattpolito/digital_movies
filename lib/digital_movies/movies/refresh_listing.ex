defmodule DigitalMovies.Movies.RefreshListing do
  alias DigitalMovies.Movies
  alias DigitalMovies.Movies.Listing
  alias DigitalMovies.Movies.Movie
  alias DigitalMovies.Repo
  alias DigitalMovies.Stores.Product

  import Ecto.Query, warn: false

  def run(%Product{} = product) do
    match_to_movie(product)
    |> update_listing(product)
  end

  def update_listing(%Movie{} = movie, %Product{} = product) do
    attrs = %{
      available: product.available,
      movie_id: movie.id,
      price_in_cents: product.price,
      title: product.title,
      type: product.type,
      url: product.url
    }

    %Listing{}
    |> Listing.changeset(attrs)
    |> Repo.insert(
      conflict_target: [:url],
      on_conflict: {:replace_all_except, [:id, :inserted_at, :url]}
    )
  end

  def match_to_movie(%Product{} = product) do
    title_to_match =
      product.title
      |> String.downcase()
      |> String.replace(~r/\W/, "")

    query =
      from m in Movie,
        where: fragment("regexp_replace(lower(?), '\\W', '', 'g') = ?", m.title, ^title_to_match)

    movie = Repo.one(query)

    if is_nil(movie) do
      {:ok, movie} = Movies.create_movie(%{title: product.title})
      movie
    else
      movie
    end
  end
end
