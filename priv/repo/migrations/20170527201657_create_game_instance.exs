defmodule Ragnaros.Repo.Migrations.CreateRagnaros.Game.Instance do
  use Ecto.Migration

  def change do
    create table(:game_instances) do
      add :players, {:array, :integer}

      timestamps()
    end

  end
end
