defmodule Ragnaros.Repo.Migrations.CreateRagnaros.Game.Selection do
  use Ecto.Migration

  def change do
    create table(:game_selections) do
      add :user_id, :integer
      add :game_id, :integer
      add :card_id, :integer

      timestamps()
    end

  end
end
