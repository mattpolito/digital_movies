defmodule DigitalMoviesWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `DigitalMoviesWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, DigitalMoviesWeb.MovieLive.FormComponent,
        id: @movie.id || :new,
        action: @live_action,
        movie: @movie,
        return_to: Routes.movie_index_path(@socket, :index) %>
  """
  def live_modal(_socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(DigitalMoviesWeb.ModalComponent, modal_opts)
  end

  def price_to_money(price_in_cents) do
    Money.new(price_in_cents, :USD)
  end
end
