defmodule Ragnaros.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ragnaros.Accounts.User


  schema "accounts_users" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
