defmodule Acorn.Wiki.PageTopic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "page_topics" do
    field :page_id, :id
    field :topic_id, :id

    timestamps()
  end

  @doc false
  def changeset(page_topic, attrs) do
    page_topic
    |> cast(attrs, [:page_id, :topic_id])
    |> foreign_key_constraint(:name)
    |> validate_required([])
  end
end
