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
             url: "https://uvdigitalnow.dpdcart.com/product/207411"
           }
  end

  @parse_type_from_title_data [
    %{
      raw_title:
        "* ANT-MAN (2015) (HD) GOOGLE PLAY CODE ONLY ( MOVIE PORTS OVER TO VUDU IN HDX & TO iTunes in HD IF ALL ARE LINKED TO MA) ** NO DMI POINTS ON THIS CODE**)",
      expected: %{
        title: "ANT-MAN (2015)",
        type: "iTunes HD"
      }
    },
    %{
      raw_title: "* A QUIET PLACE (4K) iTunes CODE ONLY (Redeem direct to itunes.com/redeem )",
      expected: %{
        title: "A QUIET PLACE",
        type: "iTunes 4K"
      }
    },
    %{
      raw_title:
        "*  DOCTOR STRANGE (HDX) VUDU / MOVIESANYWHERE CODE ( NO GOOGLE PLAY WITH THIS CODE) ",
      expected: %{
        title: "DOCTOR STRANGE",
        type: "(HDX) VUDU / MOVIESANYWHERE CODE ( NO GOOGLE PLAY WITH THIS CODE)"
      }
    },
    %{
      raw_title:
        "10 CLOVERFIELD LANE (4K) iTunes CODE ONLY (Redeem direct to itunes.com/redeem )",
      expected: %{
        title: "10 CLOVERFIELD LANE",
        type: "iTunes 4K"
      }
    },
    %{
      raw_title: "HUNGER GAMES MOCKINGJAY PART 2 (4K) iTunes CODE ONLY (Redeem direct to itunes.com/redeem )",
      expected: %{
        title: "HUNGER GAMES MOCKINGJAY PART 2",
        type: "iTunes 4K"
      }
    },
    %{
      raw_title: "THE MARTIAN (HDX) Vudu Code OR(HDX) Vudu OR (4K) iTunes ( For 4K iTunes Redeem direct to https://foxredeem.com/ Then choose iTunes for 4K New iTunes code)",
      expected: %{
        title: "THE MARTIAN",
        type: "iTunes 4K"
      }
    }
  ]

  describe "parse_type_from_title/1" do
    for data <- @parse_type_from_title_data do
      @data data
      test "parses type from title #{@data.raw_title}" do
        assert UVDigitalNow.parse_type_from_title(@data.raw_title) == @data.expected
      end
    end
  end
end
