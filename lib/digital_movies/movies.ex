defmodule DigitalMovies.Movies do
  @moduledoc """
  The Movies context.
  """

  import Ecto.Query, warn: false
  alias DigitalMovies.Repo

  alias DigitalMovies.Movies.Listing
  alias DigitalMovies.Movies.Movie

  @doc """
  Returns the list of listings.

  ## Examples

      iex> list_listings()
      [%Listing{}, ...]

  """
  def list_listings do
    Repo.all(Listing)
  end

  @doc """
  Gets a single listing.

  Raises `Ecto.NoResultsError` if the Listing does not exist.

  ## Examples

      iex> get_listing!(123)
      %Listing{}

      iex> get_listing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_listing!(id), do: Repo.get!(Listing, id)

  def refresh_listing(%DigitalMovies.Stores.Product{} = product) do
    DigitalMovies.Movies.RefreshListing.run(product)
  end

  @doc """
  Returns the list of movies.

  ## Examples

      iex> list_movies()
      [%Movie{}, ...]

  """
  def list_movies(opts \\ []) do
    query = from(
      m in Movie,
      join: l in Listing,
      on: m.id == l.movie_id,
      group_by: m.id,
      select: %{
        movie: m,
        listings_count: fragment("count(?) as count_listings", m.id),
        min_price: fragment("min(?) as min_price", l.price_in_cents),
        recent_listing: fragment("max(?) as max_inserted_at", l.inserted_at)
      }
    )

    opts
    |> Enum.reduce(query, &filter_by/2)
    |> Repo.all()
  end

  defp filter_by({:filter_by, {}}, query), do: query

  defp filter_by({:filter_by, %{"title" => title}}, query) do
    filter = "%#{title}%"
    where(query, [m], ilike(m.title, ^filter))
  end

  defp filter_by({:sort_by, {"title", dir}}, query), do: order_by(query, [m], [{^dir, m.title}])
  defp filter_by({:sort_by, {"count_listings", dir}}, query), do: order_by(query, [{^dir, fragment("count_listings")}])
  defp filter_by({:sort_by, {"min_price", dir}}, query), do: order_by(query, [{^dir, fragment("min_price")}])
  defp filter_by({:sort_by, {"max_inserted_at", dir}}, query), do: order_by(query, [{^dir, fragment("max_inserted_at")}])

  @doc """
  Gets a single movie.

  Raises `Ecto.NoResultsError` if the Movie does not exist.

  ## Examples

      iex> get_movie!(123)
      %Movie{}

      iex> get_movie!(456)
      ** (Ecto.NoResultsError)

  """
  def get_movie!(id), do: Repo.get!(Movie, id) |> Repo.preload(:listings)

  @doc """
  Creates a movie.

  ## Examples

      iex> create_movie(%{field: value})
      {:ok, %Movie{}}

      iex> create_movie(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_movie(attrs \\ %{}) do
    %Movie{}
    |> Movie.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a movie.

  ## Examples

      iex> update_movie(movie, %{field: new_value})
      {:ok, %Movie{}}

      iex> update_movie(movie, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_movie(%Movie{} = movie, attrs) do
    movie
    |> Movie.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a movie.

  ## Examples

      iex> delete_movie(movie)
      {:ok, %Movie{}}

      iex> delete_movie(movie)
      {:error, %Ecto.Changeset{}}

  """
  def delete_movie(%Movie{} = movie) do
    Repo.delete(movie)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking movie changes.

  ## Examples

      iex> change_movie(movie)
      %Ecto.Changeset{data: %Movie{}}

  """
  def change_movie(%Movie{} = movie, attrs \\ %{}) do
    Movie.changeset(movie, attrs)
  end
end
