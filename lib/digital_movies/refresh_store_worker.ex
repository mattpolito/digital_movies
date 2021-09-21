defmodule DigitalMovies.RefreshStoreWoker do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    schedule_worker()
    {:ok, :nostate}
  end

  def schedule_worker() do
    Process.send_after(__MODULE__, :refresh_stores, :timer.hours(12))
  end

  def handle_info(:refresh_stores, state) do
    schedule_worker()

    DigitalMovies.Stores.refresh_listings()

    {:noreply, state}
  end
end
