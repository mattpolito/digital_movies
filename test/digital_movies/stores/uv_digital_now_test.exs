defmodule DigitalMovies.Stores.UVDigitalNowTest do
  alias DigitalMovies.Stores.UVDigitalNow
  alias DigitalMovies.Stores.Product
  use ExUnit.Case

  test "parse_product" do
    filename = Path.join(__DIR__, "../../fixtures/stores/uv_digital_now_product.html")
    {:ok, product_fixture} = File.read(filename)
    {:ok, product} = Floki.parse_document(product_fixture)

    assert UVDigitalNow.parse_product(product) == %Product{
             available: true,
             price: 359,
             title: "AVENGERS INFINITY WAR",
             type: "iTunes HD",
             url:
               "https://uvdigitalnow.dpdcart.com/product/207411"
           }
  end

  describe "parse type from title" do
    test "iTunes HD title" do
      title =
        "* ANT-MAN (2015) (HD) GOOGLE PLAY CODE ONLY ( MOVIE PORTS OVER TO VUDU IN HDX & TO iTunes in HD IF ALL ARE LINKED TO MA) ** NO DMI POINTS ON THIS CODE**)"

      assert UVDigitalNow.parse_type_from_title(title) == %{
               title: "ANT-MAN (2015)",
               type: "iTunes HD"
             }
    end

    test "iTunes 4K title" do
      title = "* A QUIET PLACE (4K) iTunes CODE ONLY (Redeem direct to itunes.com/redeem )"

      assert UVDigitalNow.parse_type_from_title(title) == %{
               title: "A QUIET PLACE",
               type: "iTunes 4K"
             }
    end

    test "Vudu / MA" do
      title =
        "*  DOCTOR STRANGE (HDX) VUDU / MOVIESANYWHERE CODE ( NO GOOGLE PLAY WITH THIS CODE) "

      assert UVDigitalNow.parse_type_from_title(title) == %{
               title: "DOCTOR STRANGE",
               type: "(HDX) VUDU / MOVIESANYWHERE CODE ( NO GOOGLE PLAY WITH THIS CODE)"
             }
    end

    test "with no leading asterisk" do
      title = "10 CLOVERFIELD LANE (4K) iTunes CODE ONLY (Redeem direct to itunes.com/redeem )"

      assert UVDigitalNow.parse_type_from_title(title) == %{
               title: "10 CLOVERFIELD LANE",
               type: "iTunes 4K"
             }
    end
  end
end
