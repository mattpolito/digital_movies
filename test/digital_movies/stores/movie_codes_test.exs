defmodule DigitalMovies.Stores.MovieCodesTest do
  alias DigitalMovies.Stores.MovieCodes
  alias DigitalMovies.Stores.Product
  use ExUnit.Case

  test "parse_product" do
    filename = Path.join(__DIR__, "../../fixtures/stores/movie_codes_product.html")
    {:ok, product_fixture} = File.read(filename)
    {:ok, product} = Floki.parse_document(product_fixture)

    assert MovieCodes.parse_product(product) == %Product{
             available: true,
             price: 125,
             title: "Transformers The Last Knight",
             type: "iTunes 4K",
             url:
               "https://movie-codes.com/collections/itunes/products/transformers-the-last-knight-itunes-4k-uhd"
           }
  end

  describe "parse type from title" do
    test "iTunes HD title" do
      title = "Jack Reacher Never Back Down itunes HD"

      assert MovieCodes.parse_type_from_title(title) == %{
               title: "Jack Reacher Never Back Down",
               type: "iTunes HD"
             }
    end

    test "UVHDX or itunes title" do
      title = "Why Him UVHDX or itunes HD via MA"

      assert MovieCodes.parse_type_from_title(title) == %{
               title: "Why Him",
               type: "iTunes HD"
             }
    end

    test "iTunes 4K title" do
      title = "Jack Reacher Never Back Down itunes 4K"

      assert MovieCodes.parse_type_from_title(title) == %{
               title: "Jack Reacher Never Back Down",
               type: "iTunes 4K"
             }
    end

    test "HD VUDU (Must redeem in VUDU) title" do
      title = "Jack Reacher Never Back Down HD VUDU (Must redeem in VUDU)"

      assert MovieCodes.parse_type_from_title(title) == %{
               title: "Jack Reacher Never Back Down",
               type: "HD VUDU (Must redeem in VUDU)"
             }
    end
  end
end
