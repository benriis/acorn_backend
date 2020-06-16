defmodule Acorn.Repo do
  use Ecto.Repo,
    otp_app: :acorn,
    adapter: Ecto.Adapters.Postgres
end
