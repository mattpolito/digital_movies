defmodule DigitalMoviesWeb.ModalComponent do
  use DigitalMoviesWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div id={assigns.id} class="phx-modal"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target={assigns.id}
      phx-page-loading>

      <div class="phx-modal-content">
        <%= live_patch raw("&times;"), to: assigns.return_to, class: "phx-modal-close" %>
        <%= live_component assigns.component, assigns.opts %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
