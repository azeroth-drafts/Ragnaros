defmodule Ragnaros.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ragnaros.Accounts.User


  schema "accounts_users" do
    field :name, :string
    field :pity_timer, {:array, :integer}

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def pity_timer_tuple(%User{} = user) do
    user.pity_timer |> List.to_tuple
  end
end
