defmodule DigitalMovies.Stores.StoreBehavior do
  @callback parse(Floki.html_tree()) :: list(%DigitalMovies.Product{})
  @callback url :: String.t()
end
