defmodule Ragnaros.Game.Selection do
  import Ecto.Query, only: [from: 2]

  use Ecto.Schema
  import Ecto.Changeset
  alias Ragnaros.Game.Selection
  alias Ragnaros.Repo


  schema "game_selections" do
    field :card_id, :integer
    field :game_id, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%Selection{} = selection, attrs) do
    selection
    |> cast(attrs, [:user_id, :game_id, :card_id])
    |> validate_required([:user_id, :game_id, :card_id])
  end

  def cards_for_user_and_game(user_id, game_id) do
    query = from(s in Selection,
      where: s.game_id == ^game_id and s.user_id == ^user_id,
      select: s.card_id)
    Repo.all(query)
  end
end
