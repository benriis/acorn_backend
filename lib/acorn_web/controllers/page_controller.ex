defmodule AcornWeb.PageController do
  use AcornWeb, :controller

  alias Acorn.Wiki
  alias Acorn.Wiki.Page
  alias Acorn.Auth.User
  alias Acorn.Auth

  alias Acorn.Repo
  require Logger

  action_fallback AcornWeb.FallbackController

  def index(conn, _params) do
    IO.inspect(conn.cookies)
    pages = Wiki.list_pages(conn.query_params)
    render(conn, "index.json", pages: pages)
  end

  def create(conn, %{"page" => page_params}) do
    with {:ok, %Page{} = page} <- Wiki.create_page(page_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.page_path(conn, :show, page))
      |> render("show.json", page: page |> Repo.preload(:children) |> Repo.preload(:parent) |> Repo.preload(:topics))
    end
  end

  def show(conn, %{"id" => id}) do
    Logger.info inspect(conn, pretty: true)
    page = Wiki.get_page!(id)
    render(conn, "show.json", page: page)
  end

  def update(conn, %{"id" => id, "page" => page_params}) do
    page = Wiki.get_page!(id)
    with {:ok, %Page{} = page} <- Wiki.update_page(page, page_params) do
      render(conn, "show.json", page: page)
    end
  end

  def delete(conn, %{"id" => id}) do
    page = Wiki.get_page!(id)

    with {:ok, %Page{}} <- Wiki.delete_page(page) do
      send_resp(conn, :no_content, "")
    end
  end
end
