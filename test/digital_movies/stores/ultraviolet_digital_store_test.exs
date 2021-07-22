defmodule DigitalMovies.Stores.UltravioletDigitalStoreTest do
  alias DigitalMovies.Stores.UltravioletDigitalStore
  alias DigitalMovies.Product
  use ExUnit.Case

  test "parse_product" do
    filename = Path.join(__DIR__, "../../fixtures/stores/ultraviolet_digital_store_product.html")
    {:ok, product_fixture} = File.read(filename)
    {:ok, product} = Floki.parse_document(product_fixture)

    assert UltravioletDigitalStore.parse_product(product) == %Product{
             available: true,
             price: 210,
             title: "Paranormal Activity 3 [Unrated Edition]",
             type: "iTunes HD",
             url:
               "https://ultravioletdigitalstore.com/collections/itunes-codes/products/paranormal-activity-3-unrated-itunes-hd-redemption-only"
           }
  end

  describe "parse type from title" do
    test "iTunes HD title" do
      title = "Paranormal Activity 3 [Unrated Edition] (2011) iTunes HD redemption only"

      assert UltravioletDigitalStore.parse_type_from_title(title) == %{
               "title" => "Paranormal Activity 3 [Unrated Edition]",
               "type" => "iTunes HD"
             }
    end

    test "iTunes 4K title" do
      title = "Mission: Impossible - Fallout (2018) iTunes 4K redemption only"

      assert UltravioletDigitalStore.parse_type_from_title(title) == %{
               "title" => "Mission: Impossible - Fallout",
               "type" => "iTunes 4K"
             }
    end

    test "iTunes 4K with longer extra content in year" do
      title = "The Mummy: Tomb of the Dragon Emperor (2008: Ports Via MA) iTunes 4K code"

      assert UltravioletDigitalStore.parse_type_from_title(title) == %{
               "title" => "The Mummy: Tomb of the Dragon Emperor",
               "type" => "iTunes 4K"
             }
    end

    test "Vudu 4K or iTunes 4K" do
      title = "13 Hours: The Secret Soldiers of Benghazi (2016) Vudu 4K or iTunes 4K code"

      assert UltravioletDigitalStore.parse_type_from_title(title) == %{
               "title" => "13 Hours: The Secret Soldiers of Benghazi",
               "type" => "iTunes 4K"
             }
    end
  end
end
