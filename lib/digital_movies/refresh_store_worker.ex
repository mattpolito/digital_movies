defmodule DigitalMovies.RefreshStoreWorker do
  use Oban.Worker, max_attempts: 3

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"module" => "all"}}) do
    DigitalMovies.Stores.refresh_listings()

    :ok
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"module" => module}}) do
    [String.to_existing_atom(module)]
    |> DigitalMovies.Stores.refresh_listings()

    :ok
  end
end
