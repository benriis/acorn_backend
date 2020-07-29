defmodule Acorn.Repo.Migrations.ChangeUserCredentials do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :email, :string, default: ""
      add :username, :string, null: false, default: ""
    end
  end
end
