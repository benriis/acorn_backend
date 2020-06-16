defmodule Acorn.Repo.Migrations.CreatePageTopics do
  use Ecto.Migration

  def change do
    create table(:page_topics) do
      add :page_id, references(:pages, on_delete: :nothing)
      add :topic_id, references(:topics, on_delete: :nothing)

      timestamps()
    end

    create index(:page_topics, [:page_id])
    create index(:page_topics, [:topic_id])
    create unique_index(:page_topics, [:page_id, :topic_id])
  end
end
