defmodule DigitalMoviesWeb.MovieLive.Show do
  use DigitalMoviesWeb, :live_view

  alias DigitalMovies.Movies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:movie, Movies.get_movie!(id))}
  end

  def price_to_money(price_in_cents) do
    Money.new(price_in_cents, :USD)
  end

  defp page_title(:show), do: "Show Movie"
  defp page_title(:edit), do: "Edit Movie"
end
