defmodule DigitalMoviesWeb.PageLive do
  use DigitalMoviesWeb, :live_view

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign(socket, processing: false)}
  end

  @impl Phoenix.LiveView
  def handle_event("refresh-listing", _params, socket) do
    Process.send_after(self(), :refresh, 1)

    {:noreply, assign(socket, processing: true)}
  end

  @impl Phoenix.LiveView
  def handle_info(:refresh, socket) do
    %{module: "all"}
    |> DigitalMovies.RefreshStoreWorker.new()
    |> Oban.insert()

    {:noreply, assign(socket, processing: false)}
  end
end
