defmodule AcornWeb.UserView do
  use AcornWeb, :view
  alias AcornWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      is_active: user.is_active}
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end

  def render("jwt_with_user.json", %{jwt: jwt, username: username}) do
    %{jwt: jwt, username: username}
  end

  def render("sign_in.json", %{user: user}) do
    %{
      data: %{
        user: %{
          id: user.id,
          username: user.username
        }
      }
    }
  end

  def render("401.json", %{message: message}) do
    %{errors: %{detail: message}}
  end

  def render("log_out.json", %{message: message}) do
    %{message: message}
  end
end
