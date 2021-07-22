defmodule DigitalMovies.Stores.InstantDigitalMoviesTest do
  alias DigitalMovies.Stores.InstantDigitalMovies
  alias DigitalMovies.Product
  use ExUnit.Case

  test "parse_product" do
    filename = Path.join(__DIR__, "../../fixtures/stores/instant_digital_movies_product.html")
    {:ok, product_fixture} = File.read(filename)
    {:ok, product} = Floki.parse_document(product_fixture)

    assert InstantDigitalMovies.parse_product(product) == %Product{
             available: true,
             price: 145,
             title: "Daddy's Home 2",
             type: "iTunes 4K",
             url: "https://instantdigitalmovies.com/daddys-home-2-itunes-4k"
           }
  end

  describe "parse type from title" do
    test "iTunes HD title" do
      title = "Aloha [iTunes HD]"

      assert InstantDigitalMovies.parse_type_from_title(title) == %{
               "title" => "Aloha",
               "type" => "iTunes HD"
             }
    end

    test "iTunes 4K title" do
      title = "Aloha [iTunes 4K]"

      assert InstantDigitalMovies.parse_type_from_title(title) == %{
               "title" => "Aloha",
               "type" => "iTunes 4K"
             }
    end
  end
end
