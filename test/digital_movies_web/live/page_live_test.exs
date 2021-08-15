defmodule DigitalMoviesWeb.PageLiveTest do
  use DigitalMoviesWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Digital Movies"
    assert render(page_live) =~ "Digital Movies"
  end
end
