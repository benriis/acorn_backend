defmodule AcornWeb.Router do
  use AcornWeb, :router
  require Logger

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :api_auth do
    plug :ensure_authenticated
  end

  scope "/api", AcornWeb do
    pipe_through :api

    post "/users/sign_in", UserController, :sign_in
  end

  scope "/api", AcornWeb do
    pipe_through [:api] #, :api_auth 
    
    resources "/topics", TopicController, only: [:index]
    resources "/pages", PageController
    resources "/users", UserController, except: [:new, :edit]
  end

  defp ensure_authenticated(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)
    Logger.info inspect(conn, pretty: true)
    if current_user_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(AcornWeb.ErrorView)
      |> render("401.json", message: "Unautherized user")
      |> halt()
    end
  end
end
