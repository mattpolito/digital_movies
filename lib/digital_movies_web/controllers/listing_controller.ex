defmodule DigitalMoviesWeb.ListingController do
  use DigitalMoviesWeb, :controller

  alias DigitalMovies.Movies

  def index(conn, _params) do
    listings = Movies.list_listings()
    render(conn, "index.html", listings: listings)
  end
end
