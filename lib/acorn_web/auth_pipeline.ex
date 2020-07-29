defmodule Acorn.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :acorn,
  module: Acorn.Guardian,
  error_handler: Acorn.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
