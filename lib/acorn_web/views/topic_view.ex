defmodule AcornWeb.TopicView do
  use AcornWeb, :view
  alias AcornWeb.TopicView

  def render("index.json", %{topics: topics}) do
    %{data: render_many(topics, TopicView, "topic.json")}
  end

  def render("show.json", %{topic: topic}) do
    %{data: render_one(topic, TopicView, "topic.json")}
  end

  def render("topic.json", %{topic: topic}) do
    %{id: topic.id,
      text: topic.text}
  end

  def render("render_topics_with_count.json", %{topics: topics}) do
    %{data: render_many(topics, TopicView, "custom_topic.json")}
  end

  def render("custom_topic.json", %{topic: topic}) do 
    %{id: topic.id,
    text: topic.text,
    count: topic.count}
  end
end
