defmodule Ragnaros.Game.Card do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ragnaros.Game.Card


  schema "game_cards" do
    field :attack, :integer
    field :cardId, :string
    field :cardSet, :string
    field :cost, :integer
    field :faction, :string
    field :health, :integer
    field :img, :string
    field :name, :string
    field :race, :string
    field :rarity, :string
    field :text, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(%Card{} = card, attrs) do
    card
    |> cast(attrs, [:cardId, :name, :cardSet, :type, :faction, :rarity, :cost, :attack, :health, :text, :race, :img])
    |> validate_required([:cardId, :name, :cardSet, :type, :faction, :rarity, :cost, :attack, :health, :text, :race, :img])
  end
end
