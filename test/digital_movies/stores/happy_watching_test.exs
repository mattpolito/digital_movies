defmodule DigitalMovies.Stores.HappyWatchingTest do
  alias DigitalMovies.Stores.HappyWatching
  alias DigitalMovies.Stores.Product
  use ExUnit.Case

  test "parse_product" do
    filename = Path.join(__DIR__, "../../fixtures/stores/happy_watching_product.html")
    {:ok, product_fixture} = File.read(filename)
    {:ok, product} = Floki.parse_document(product_fixture)

    assert HappyWatching.parse_product(product) == %Product{
             available: false,
             price: 145,
             title: "Jack Reacher Never Go Back",
             type: "iTunes 4K",
             url:
               "https://happywatching.com/collections/itunes/products/jack-reacher-never-go-back-hd-itunes"
           }
  end

  describe "parse type from title" do
    test "iTunes HD title" do
      title = "Jack Reacher Never Back Down HD iTunes"

      assert HappyWatching.parse_type_from_title(title) == %{
               title: "Jack Reacher Never Back Down",
               type: "iTunes HD"
             }
    end

    test "iTunes 4K title" do
      title = "Jack Reacher Never Back Down 4K iTunes"

      assert HappyWatching.parse_type_from_title(title) == %{
               title: "Jack Reacher Never Back Down",
               type: "iTunes 4K"
             }
    end

    test "HDX VUDU & HD iTunes (Full Code!) title" do
      title = "Jack Reacher Never Back Down HDX VUDU & HD iTunes (Full Code!)"

      assert HappyWatching.parse_type_from_title(title) == %{
               title: "Jack Reacher Never Back Down",
               type: "iTunes HD"
             }
    end
  end
end
