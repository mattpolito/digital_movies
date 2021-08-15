defmodule DigitalMovies.Stores.Store do
  @callback parse_product(Floki.html_tree()) :: %DigitalMovies.Stores.Product{}
  @callback products_selector :: String.t()

  alias DigitalMovies.Stores.Store

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @product_price_selector Keyword.fetch!(opts, :product_price_selector)
      @product_title_selector Keyword.fetch!(opts, :product_title_selector)
      @product_title_separator_regex Keyword.fetch!(opts, :product_title_separator_regex)
      @product_url_selector Keyword.fetch!(opts, :product_url_selector)
      @products_selector Keyword.fetch!(opts, :products_selector)
      @url Keyword.fetch!(opts, :url)

      @behaviour Store

      def parse(document), do: Store.parse(__MODULE__, document)

      def parse_product_title(product),
        do: Store.parse_product_title(__MODULE__, product)

      def parse_product_price(product),
        do: Store.parse_product_price(__MODULE__, product)

      def parse_product_url(product),
        do: Store.parse_product_url(__MODULE__, product)

      def parse_type_from_title(title),
        do: Store.parse_type_from_title(__MODULE__, title)

      def available?(product), do: Store.available?(__MODULE__, product)

      def product_type_is_itunes?(type),
        do: Store.product_type_is_itunes?(__MODULE__, type)

      def extract_title_and_type(map, original_title),
        do: Store.extract_title_and_type(__MODULE__, map, original_title)

      def categorize_type(%{type: nil} = map), do: map
      def categorize_type(%{type: type} = map), do: %{map | type: normalize_type(type)}

      def normalize_type(type), do: Store.normalize_type(type)

      def product_price_selector, do: @product_price_selector
      def product_title_selector, do: @product_title_selector
      def product_title_separator_regex, do: @product_title_separator_regex
      def product_url_selector, do: @product_url_selector
      def products_selector, do: @products_selector
      def url, do: @url

      defoverridable parse_product_price: 1
      defoverridable parse_product_url: 1
      defoverridable normalize_type: 1
    end
  end

  def parse(module, document) do
    document
    |> Floki.find(module.products_selector)
    |> Enum.map(&module.parse_product/1)
    |> Enum.filter(&module.available?/1)
  end

  def parse_product_title(module, product) do
    product
    |> Floki.find(module.product_title_selector)
    |> Floki.text()
    |> module.parse_type_from_title()
  end

  def parse_product_url(module, product) do
    path =
      product
      |> Floki.find(module.product_url_selector)
      |> Floki.attribute("href")
      |> List.first()

    %URI{host: host, scheme: scheme} = URI.parse(module.url)

    "#{scheme}://#{host}#{path}"
  end

  def parse_product_price(module, product) do
    product
    |> Floki.find(module.product_price_selector)
    |> Floki.text()
    |> String.replace(~r/[^\d]/, "")
    |> Integer.parse()
    |> elem(0)
  end

  def available?(module, product) do
    product.available and module.product_type_is_itunes?(product.type)
  end

  def product_type_is_itunes?(_module, nil), do: false

  def product_type_is_itunes?(_module, type) do
    Regex.match?(~r/itunes/i, type)
  end

  def extract_title_and_type(_module, nil, original_title) do
    %{
      title: String.trim(original_title),
      type: nil
    }
  end

  def extract_title_and_type(_module, %{"title" => title, "type" => type}, _original_title) do
    %{
      title: String.trim(title),
      type: String.trim(type)
    }
  end

  def normalize_type(type) do
    cond do
      String.match?(type, ~r/(?:iTunes SD)/i) ->
        "iTunes SD"

      String.match?(type, ~r/(?:iTunes HD)/i) ->
        "iTunes HD"

      String.match?(type, ~r/(?:iTunes 4K)/i) ->
        "iTunes 4K"

      true ->
        type
    end
  end

  def parse_type_from_title(module, title) do
    Regex.named_captures(module.product_title_separator_regex, String.trim(title))
    |> module.extract_title_and_type(title)
    |> module.categorize_type()
  end
end
