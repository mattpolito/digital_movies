defmodule DigitalMoviesWeb.MovieLive.FormComponent do
  use DigitalMoviesWeb, :live_component

  alias DigitalMovies.Movies

  @impl true
  def update(%{movie: movie} = assigns, socket) do
    changeset = Movies.change_movie(movie)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"movie" => movie_params}, socket) do
    changeset =
      socket.assigns.movie
      |> Movies.change_movie(movie_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"movie" => movie_params}, socket) do
    save_movie(socket, socket.assigns.action, movie_params)
  end

  defp save_movie(socket, :edit, movie_params) do
    case Movies.update_movie(socket.assigns.movie, movie_params) do
      {:ok, _movie} ->
        {:noreply,
         socket
         |> put_flash(:info, "Movie updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_movie(socket, :new, movie_params) do
    case Movies.create_movie(movie_params) do
      {:ok, _movie} ->
        {:noreply,
         socket
         |> put_flash(:info, "Movie created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
