defmodule DigitalMovies.Stores.HDMovieCodesTest do
  alias DigitalMovies.Stores.HDMovieCodes
  alias DigitalMovies.Product
  use ExUnit.Case

  test "parse_product" do
    filename = Path.join(__DIR__, "../../fixtures/stores/hd_movie_codes_product.html")
    {:ok, product_fixture} = File.read(filename)
    {:ok, product} = Floki.parse_document(product_fixture)

    assert HDMovieCodes.parse_product(product) == %Product{
             available: true,
             price: 395,
             title: "Aloha",
             type: "VUDU HD or iTunes HD via Movies Anywhere",
             url:
               "https://hdmoviecodes.com/collections/itunes-hd/products/aloha-vudu-hd-or-itunes-hd-via-movies-anywhere"
           }
  end

  describe "parse type from title" do
    test "iTunes HD title" do
      title = "Aloha iTunes HD"

      assert HDMovieCodes.parse_type_from_title(title) == %{
               "title" => "Aloha",
               "type" => "iTunes HD"
             }
    end

    test "iTunes 4K title" do
      title = "Aloha iTunes 4K"

      assert HDMovieCodes.parse_type_from_title(title) == %{
               "title" => "Aloha",
               "type" => "iTunes 4K"
             }
    end

    test "VUDU 4K through iTunes 4K title" do
      title = "Aloha VUDU 4K through iTunes 4K"

      assert HDMovieCodes.parse_type_from_title(title) == %{
               "title" => "Aloha",
               "type" => "VUDU 4K through iTunes 4K"
             }
    end
  end
end
