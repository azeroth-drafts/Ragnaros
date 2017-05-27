defmodule Ragnaros.Repo.Migrations.CreateRagnaros.Accounts.User do
  use Ecto.Migration

  def change do
    create table(:accounts_users) do
      add :name, :string

      timestamps()
    end

  end
end
