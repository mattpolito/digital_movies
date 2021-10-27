defmodule DigitalMovies.Movies.Movie do
  alias DigitalMovies.Movies.Listing

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "movies" do
    field :title, :string
    has_many :listings, Listing

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end

  def filter_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:title])
  end
end
