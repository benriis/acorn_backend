defmodule Acorn.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :title, :string
      add :content, :text

      add :parent_id, references(:pages)
      timestamps()
    end

  end
end
