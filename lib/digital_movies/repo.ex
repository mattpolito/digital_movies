defmodule DigitalMovies.Repo do
  use Ecto.Repo,
    otp_app: :digital_movies,
    adapter: Ecto.Adapters.Postgres
end
