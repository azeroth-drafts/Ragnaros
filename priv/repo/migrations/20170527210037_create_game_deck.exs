defmodule Ragnaros.Repo.Migrations.CreateRagnaros.Game.Deck do
  use Ecto.Migration

  def change do
    create table(:game_decks) do
      add :game_id, :integer
      add :user_id, :integer
      add :cards, {:array, :integer}

      timestamps()
    end

  end
end
