defmodule Ragnaros.Game.Instance do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ragnaros.Game.Instance


  schema "game_instances" do
    field :players, {:array, :integer}

    timestamps()
  end

  @doc false
  def changeset(%Instance{} = instance, attrs) do
    instance
    |> cast(attrs, [:players])
    |> validate_required([:players])
    |> validate_length(:players, is: 4)
    |> validate_unique_list(:players)
  end

  def validate_unique_list(changeset, :players, options \\ []) do
    validate_change(changeset, :players, fn _, players ->
      case Enum.uniq(players) == players do
        true -> []
        false -> [{:players, options[:message] || "Player ids have to be unique."}]
      end
    end)
  end
end
