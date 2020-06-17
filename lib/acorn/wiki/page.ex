defmodule Acorn.Wiki.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pages" do
    field :content, :string
    field :title, :string
    belongs_to :parent, Acorn.Wiki.Page
    belongs_to :user, Acorn.Auth.User
    has_many :children, Acorn.Wiki.Page, foreign_key: :parent_id
    many_to_many :topics, Acorn.Wiki.Topic, join_through: "page_topics"
    timestamps()
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:title, :content, :parent_id, :user_id])
    |> validate_required([:title, :content])
    |> cast_assoc(:topics, required: false)
  end
end
