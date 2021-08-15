defmodule DigitalMoviesWeb.PageControllerTest do
  use DigitalMoviesWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Digital Movies"
  end
end
