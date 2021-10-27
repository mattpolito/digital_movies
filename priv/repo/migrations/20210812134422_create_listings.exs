defmodule DigitalMovies.Repo.Migrations.CreateListings do
  use Ecto.Migration

  def change do
    create table(:listings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :available, :boolean, default: false, null: false
      add :price_in_cents, :integer
      add :title, :string
      add :type, :string
      add :url, :string

      timestamps()
    end

    create unique_index(:listings, :url)
  end
end
