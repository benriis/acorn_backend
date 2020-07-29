# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :acorn,
  ecto_repos: [Acorn.Repo]

# Configures the endpoint
config :acorn, AcornWeb.Endpoint,
  url: [host: "192.168.86.45"],
  secret_key_base: "VxmYfN6Q6795ekEIKp792NKK97BoDO09RwgkZv2L42xtrwds5uX8DGwaybpoLKdR",
  render_errors: [view: AcornWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Acorn.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "Eyjh7ShG"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :acorn, Acorn.Guardian,
      issuer: "acorn",
      secret_key: "ISNyoGcgmIRG+gZsjuuCEUPLMPJ1wjM22svXdnhMJKXNZzc1ZCPBJBMG+zu8JW3o"
