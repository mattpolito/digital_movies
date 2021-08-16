defmodule DigitalMovies.Repo.Migrations.AddMovieToListings do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      add :movie_id, references(:movies, type: :binary_id)
    end
  end
end
