defmodule Ragnaros.Repo.Migrations.AddPityTimerToUsers do
  use Ecto.Migration

  def change do
    alter table(:accounts_users) do
      add :pity_timer, {:array, :integer}
    end
  end
end
