defmodule DigitalMovies.Stores.UVCodeShopTest do
  alias DigitalMovies.Stores.UVCodeShop
  alias DigitalMovies.Product
  use ExUnit.Case

  test "parse_product" do
    filename = Path.join(__DIR__, "../../fixtures/stores/uv_code_shop_product.html")
    {:ok, product_fixture} = File.read(filename)
    {:ok, product} = Floki.parse_document(product_fixture)

    assert UVCodeShop.parse_product(product) == %Product{
             available: true,
             price: 125,
             title: "Sherlock Gnomes",
             type: "itunes 4K UHD",
             url:
               "https://www.uvcodeshop.com/collections/itunes-hd/products/sherlock-gnomes-itunes-hd"
           }
  end

  describe "parse type from title" do
    test "iTunes HD title" do
      title = "12 Strong HDX or itunes HD via MA"

      assert UVCodeShop.parse_type_from_title(title) == %{
               "title" => "12 Strong",
               "type" => "HDX or itunes HD via MA"
             }
    end

    test "iTunes 4K title" do
      title = "10 Cloverfield Lane itunes 4K UHD (Does not port)"

      assert UVCodeShop.parse_type_from_title(title) == %{
               "title" => "10 Cloverfield Lane",
               "type" => "itunes 4K UHD (Does not port)"
             }
    end

    test "Vudu or iTunes" do
      title = "Godzilla Vs Kong HD VUDU/MA or itunes HD via MA"

      assert UVCodeShop.parse_type_from_title(title) == %{
               "title" => "Godzilla Vs Kong",
               "type" => "HD VUDU/MA or itunes HD via MA"
             }
    end
  end
end
