defmodule DigitalMovies.Movies.Listing do
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

    timestamps()
  end

  @doc false
  def changeset(listing, attrs) do
    listing
    |> cast(attrs, [:available, :price_in_cents, :title, :type, :url])
    |> validate_required([:available, :price_in_cents, :title, :type, :url])
    |> unique_constraint([:url])
  end
end
