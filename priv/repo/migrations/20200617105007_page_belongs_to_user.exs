defmodule Acorn.Repo.Migrations.PageBelongsToUser do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :user_id, references(:users)
    end
  end
end
