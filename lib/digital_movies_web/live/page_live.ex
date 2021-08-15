defmodule DigitalMoviesWeb.PageLive do
  use DigitalMoviesWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, processing: false)}
  end

  @impl true
  def handle_event("refresh-listing", _params, socket) do
    Process.send_after(self(), :refresh, 1)

    {:noreply, assign(socket, processing: true)}
  end

  def handle_info(:refresh, socket) do
    DigitalMovies.Stores.refresh_listings()

    {:noreply, assign(socket, processing: false)}
  end
end
