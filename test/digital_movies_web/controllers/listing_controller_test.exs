defmodule DigitalMoviesWeb.ListingControllerTest do
  use DigitalMoviesWeb.ConnCase

  describe "index" do
    test "lists all listings", %{conn: conn} do
      conn = get(conn, Routes.listing_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Listings"
    end
  end
end
