defmodule Ragnaros.Repo.Migrations.CreateRagnaros.Game.Card do
  use Ecto.Migration

  def change do
    create table(:game_cards) do
      add :cardId, :string
      add :name, :string
      add :cardSet, :string
      add :type, :string
      add :playerClass, :string
      add :rarity, :string
      add :cost, :integer
      add :attack, :integer
      add :health, :integer
      add :text, :string
      add :race, :string
      add :img, :string
    end

  end
end
