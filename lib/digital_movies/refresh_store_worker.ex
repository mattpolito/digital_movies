defmodule DigitalMovies.RefreshStoreWorker do
  use Oban.Worker, max_attempts: 3

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"module" => module}}) do
    [String.to_existing_atom(module)]
    |> DigitalMovies.Stores.run()
    |> Enum.each(&DigitalMovies.Movies.refresh_listing/1)

    :ok
  end
end
