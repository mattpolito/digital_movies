defmodule DigitalMoviesWeb.Router do
  use DigitalMoviesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DigitalMoviesWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DigitalMoviesWeb do
    pipe_through :browser

    live "/", PageLive, :index

    resources "/listings", ListingController

    live "/movies", MovieLive.Index, :index
    live "/movies/new", MovieLive.Index, :new
    live "/movies/:id/edit", MovieLive.Index, :edit

    live "/movies/:id", MovieLive.Show, :show
    live "/movies/:id/show/edit", MovieLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", DigitalMoviesWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: DigitalMoviesWeb.Telemetry
    end
  end
end
