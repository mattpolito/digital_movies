defmodule DigitalMoviesWeb.MovieLive.Index do
  use DigitalMoviesWeb, :live_view

  alias DigitalMovies.Movies
  alias DigitalMovies.Movies.Movie

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(sort_by: {"title", :asc})
    |> assign_movies()
    |> ok()
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Movie")
    |> assign(:movie, Movies.get_movie!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Movie")
    |> assign(:movie, %Movie{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Movies")
    |> assign(:movie, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    movie = Movies.get_movie!(id)
    {:ok, _} = Movies.delete_movie(movie)

    {:noreply, assign_movies(socket)}
  end

  def handle_event("toggle-sort", %{"sort-by" => sort_by}, socket) do
    {current_sort_by, direction} = Map.get(socket.assigns, :sort_by)

    direction =
      case {sort_by, current_sort_by, direction} do
        {s, s, :asc} -> :desc
        _ -> :asc
      end

    socket
    |> assign(sort_by: {sort_by, direction})
    |> assign_movies()
    |> noreply()
  end

  defp assign_movies(%Phoenix.LiveView.Socket{assigns: assigns} = socket) do
    assign(socket, :movies, list_movies(sort_by: Map.get(assigns, :sort_by)))
  end

  defp list_movies(opts), do: Movies.list_movies(opts)

  defp ok(socket), do: {:ok, socket}
  defp noreply(socket), do: {:noreply, socket}
end
