defmodule AcornWeb.Router do
  use AcornWeb, :router
  require Logger

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :api_auth do
    plug Acorn.Guardian.AuthPipeline
  end

  scope "/api", AcornWeb do
    pipe_through :api

    post "/users/sign_in", UserController, :sign_in
    post "/users", UserController, :create
  end

  scope "/api", AcornWeb do
    pipe_through [:api, :api_auth]

    get "/users/log_out", UserController, :log_out
    resources "/topics", TopicController, only: [:index]
    resources "/pages", PageController
    resources "/users", UserController, except: [:new, :edit]
  end
end
