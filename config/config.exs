# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :digital_movies,
  ecto_repos: [DigitalMovies.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :digital_movies, DigitalMoviesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pM9T212JLZJNBJtyWR1MuhnMcAx0wZERAA0icyvSyspTP7+GY5n0/XrHWMFTl492",
  render_errors: [view: DigitalMoviesWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DigitalMovies.PubSub,
  live_view: [signing_salt: "Igk5tULE"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :digital_movies, Oban,
  repo: DigitalMovies.Repo,
  plugins: [
    {Oban.Plugins.Pruner, max_age: 15 * 24 * 60 * 60},
    {Oban.Plugins.Cron,
     crontab: [
       {"0 0 * * *", DigitalMovies.RefreshStoreWorker,
        args: %{module: DigitalMovies.Stores.BoxOfficeDigital}},
       {"5 0 * * *", DigitalMovies.RefreshStoreWorker,
        args: %{module: DigitalMovies.Stores.HDMovieCodes}},
       {"10 0 * * *", DigitalMovies.RefreshStoreWorker,
        args: %{module: DigitalMovies.Stores.HappyWatching}},
       {"15 0 * * *", DigitalMovies.RefreshStoreWorker,
        args: %{module: DigitalMovies.Stores.InstantDigitalMovies}},
       {"20 0 * * *", DigitalMovies.RefreshStoreWorker,
        args: %{module: DigitalMovies.Stores.MovieCodes}},
       {"25 0 * * *", DigitalMovies.RefreshStoreWorker,
        args: %{module: DigitalMovies.Stores.UVCodeShop}},
       {"30 0 * * *", DigitalMovies.RefreshStoreWorker,
        args: %{module: DigitalMovies.Stores.UVDigitalNow}},
       {"35 0 * * *", DigitalMovies.RefreshStoreWorker,
        args: %{module: DigitalMovies.Stores.UltravioletDigitalStore}}
     ]}
  ],
  queues: [default: 10]

config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
