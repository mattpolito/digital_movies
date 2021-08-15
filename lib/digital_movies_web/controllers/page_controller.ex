defmodule DigitalMoviesWeb.PageController do
  use DigitalMoviesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
