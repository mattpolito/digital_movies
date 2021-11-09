defmodule DigitalMoviesWeb.SortLinkComponent do
  use Phoenix.Component

  def sort_link(assigns) do
    ~H"""
    <a href="#" id={"sort-#{assigns.sort_key}"} phx-click="toggle-sort" phx-value-sort-by={assigns.sort_key}>
      <%= assigns.title %>
      <%= if elem(assigns.sort_by, 0) == assigns.sort_key do %>
        <%= if elem(assigns.sort_by, 1) == :asc, do: "👆", else: "👇" %>
      <% end %>
    </a>
    """
  end
end
