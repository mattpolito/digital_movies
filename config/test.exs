import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :digital_movies, DigitalMovies.Repo,
  username: "postgres",
  password: "postgres",
  database: "digital_movies_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :digital_movies, DigitalMoviesWeb.Endpoint,
  http: [port: 4002],
  server: false

config :digital_movies, Oban, queues: false, plugins: false

# Print only warnings and errors during test
config :logger, level: :warn
