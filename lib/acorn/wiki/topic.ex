defmodule Acorn.Wiki.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :text, :string
    many_to_many :pages, Acorn.Wiki.Page, join_through: "page_topics"


    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
