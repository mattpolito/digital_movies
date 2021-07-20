defmodule DigitalMovies.Store do
  @callback url :: String.t()
  @callback parse_product(Floki.html_tree()) :: %DigitalMovies.Product{}
  @callback products_selector :: String.t()

  defmacro __using__(_opts) do
    quote do
      @behaviour DigitalMovies.Store

      def parse(document), do: DigitalMovies.Store.parse(__MODULE__, document)
      def products_selector, do: @products_selector
      def url, do: @url
    end
  end

  def parse(module, document) do
    document
    |> Floki.find(module.products_selector)
    |> Enum.map(&module.parse_product/1)
  end
end
