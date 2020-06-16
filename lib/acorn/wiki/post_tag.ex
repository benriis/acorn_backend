defmodule Acorn.Wiki.PostTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post_tags" do
    belongs_to :page, Acorn.Wiki.Page
    belongs_to :tag, Acorn.Wiki.Tag
    timestamps()
  end

  @doc false
  def changeset(post_tag, attrs) do
    post_tag
    |> cast(attrs, [])
    |> validate_required([])
  end
end
