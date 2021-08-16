defmodule DigitalMovies.Movies.Listing do
  alias DigitalMovies.Movies.Movie

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "listings" do
    field :available, :boolean, default: false
    field :price_in_cents, :integer
    field :title, :string
    field :type, :string
    field :url, :string

    belongs_to :movie, Movie

    timestamps()
  end

  @doc false
  def changeset(listing, attrs) do
    listing
    |> cast(attrs, [:available, :price_in_cents, :title, :type, :url, :movie_id])
    |> validate_required([:available, :price_in_cents, :title, :type, :url])
    |> unique_constraint([:url])
  end
end
