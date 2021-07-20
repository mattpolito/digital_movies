defmodule DigitalMovies.Stores.BoxOfficeDigitalTest do
  alias DigitalMovies.Stores.BoxOfficeDigital
  alias DigitalMovies.Product
  use ExUnit.Case

  test "parse_product" do
    filename = Path.join(__DIR__, "../../fixtures/stores/box_office_digital_product.html")
    {:ok, product_fixture} = File.read(filename)
    {:ok, product} = Floki.parse_document(product_fixture)

    assert BoxOfficeDigital.parse_product(product) == %Product{
             price: 190,
             title: "Fifty Shades Darker",
             type: "iTunes 4K",
             url: "https://boxofficedigital.com/fifty-shades-darker-itunes-4k/"
           }
  end

  describe "parse type from title" do
    test "iTunes HD title" do
      title = "Aloha [iTunes HD]"

      assert BoxOfficeDigital.parse_type_from_title(title) == %{
               "title" => "Aloha",
               "type" => "iTunes HD"
             }
    end

    test "iTunes 4K title" do
      title = "Aloha [iTunes 4K]"

      assert BoxOfficeDigital.parse_type_from_title(title) == %{
               "title" => "Aloha",
               "type" => "iTunes 4K"
             }
    end
  end
end
