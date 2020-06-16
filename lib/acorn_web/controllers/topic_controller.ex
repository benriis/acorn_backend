defmodule AcornWeb.TopicController do
  use AcornWeb, :controller

  alias Acorn.Wiki
  alias Acorn.Wiki.Topic
  import Ecto.Query

  action_fallback AcornWeb.FallbackController

  def index(conn, _params) do
    topics = Wiki.list_topics()
    render(conn, "render_topics_with_count.json", topics: topics)
  end

  def create(conn, %{"topic" => topic_params}) do
    with {:ok, %Topic{} = topic} <- Wiki.create_topic(topic_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.topic_path(conn, :show, topic))
      |> render("show.json", topic: topic)
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Wiki.get_topic!(id)
    render(conn, "show.json", topic: topic)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Wiki.get_topic!(id)

    with {:ok, %Topic{} = topic} <- Wiki.update_topic(topic, topic_params) do
      render(conn, "show.json", topic: topic)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Wiki.get_topic!(id)

    with {:ok, %Topic{}} <- Wiki.delete_topic(topic) do
      send_resp(conn, :no_content, "")
    end
  end
end
