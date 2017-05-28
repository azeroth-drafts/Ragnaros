defmodule GameRoom do
  use GenServer

  def ready(pid) do
    GenServer.cast(pid, :ready)
  end

  def accept(game_pid, user_id) do
    GenServer.cast(game_pid, {:accepted, user_id})
  end

  def reject(game_pid, user_id) do
    GenServer.cast(game_pid, {:reject, user_id})
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  # Server callbacks
  #
  def init(lobby) do
    Ragnaros.Repo.insert(%Ragnaros.Game.Instance{players: lobby})
    {:ok, %{accepted: %{}, lobby: lobby}}
  end

  def handle_cast({:accepted, user_id}, state) do
    accepted_hash = get_in(state, [:accepted, user_id])
    accepted = 1 + accepted_hash |> Map.keys |> length

    if accepted == 4 do
      Ragnaros.Registry.notify_game_started(state[:lobby])
    end

    new = put_in(state, [:accepted, user_id], accepted)

    {:noreply, new}
  end

  def handle_cast({:reject, user_id}, state) do
    users = state[:lobby] -- [user_id]
    users |> Enum.each(fn user ->
      Ragnaros.Tavern.remove_user(user)
    end)
    {:noreply, state}
  end

  def handle_cast(:ready, state) do
    # Handle once ready
  end
end
