defmodule DigitalMoviesWeb.SortLinkComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <a href="#" phx-click="toggle-sort" phx-value-sort-by="<%= @sort_key %>">
      <%= @title %>
      <%= if elem(@sort_by, 0) == @sort_key do %>
        <%= if elem(@sort_by, 1) == :asc do %>
          👆
        <% else %>
          👇
        <% end %>
      <% end %>
    </a>
    """
  end
end
