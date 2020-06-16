defmodule Acorn.Repo.Migrations.CreatePostTags do
  use Ecto.Migration

  def change do
    create table(:post_tags) do
      add :tag_id, references :tags
      add :page_id, references :pages
      timestamps()
    end

  end
end
