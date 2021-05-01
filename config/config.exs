# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :transactions,
  ecto_repos: [Transactions.Repo]

config :transactions_web,
  ecto_repos: [Transactions.Repo],
  generators: [context_app: :transactions, binary_id: true]

# Configures the endpoint
config :transactions_web, TransactionsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ilw7aDcKBrRgCQlK3xfSEhKU6cyF/nZq+5mz78qSdPUdDLV6k9pDS9yMS1jsXqfh",
  render_errors: [view: TransactionsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Transactions.PubSub,
  live_view: [signing_salt: "fhh/kzDE"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
