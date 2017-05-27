defmodule Ragnaros.Game.Deck do
  use Ecto.Schema

  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset

  alias Ragnaros.Game.Deck
  alias Ragnaros.Repo


  schema "game_decks" do
    field :cards, {:array, :integer}
    field :game_id, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%Deck{} = deck, attrs) do
    deck
    |> cast(attrs, [:game_id, :user_id, :cards])
    |> validate_required([:game_id, :user_id, :cards])
  end

  def deck_for_user_and_game(user_id, game_id) do
    query = from(d in Deck,
      where: d.game_id == ^game_id and d.user_id == ^user_id,
      select: d.cards)
    Repo.all(query)
  end
end
