defmodule AcornWeb.UserController do
  use AcornWeb, :controller

  alias Acorn.Auth
  alias Acorn.Auth.User
  alias Acorn.Guardian

  action_fallback AcornWeb.FallbackController

  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Auth.create_user(user_params),
      {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
        conn
        |> render("jwt.json", jwt: token)
      end
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Auth.get_user!(id)

    with {:ok, %User{} = user} <- Auth.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)

    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  # def sign_in(conn, %{"email" => email, "password" => password}) do
  #   case Acorn.Auth.authenticate_user(email, password) do
  #     {:ok, user} ->
  #       conn
  #       |> put_session(:current_user_id, user.id)
  #       |> put_status(:ok)
  #       |> put_view(AcornWeb.UserView)
  #       |> render("sign_in.json", user: user)

  #     {:error, message} ->
  #       conn
  #       |> delete_session(:current_user_id)
  #       |> put_status(:unauthorized)
  #       |> put_view(AcornWeb.ErrorView)
  #       |> render("401.json", message: message)
  #   end
  # end

  def sign_in(conn, %{"username" => username, "password" => password}) do
    case Auth.token_sign_in(username, password) do
      {:ok, token, _claims} ->
        conn
          |> render("jwt_with_user.json", %{jwt: token, username: username})
        _ -> {:error, :unauthorized}
    end
  end

  def log_out(conn, _params) do
    conn
    |> clear_session()
    |> put_status(:ok)
    |> render("log_out.json", message: "logged out")
  end
end
