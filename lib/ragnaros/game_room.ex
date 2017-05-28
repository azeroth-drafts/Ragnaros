defmodule GameRoom do
  use GenServer

  @lobby 1

  def ready(pid) do
    GenServer.cast(pid, :ready)
  end

  def accept(game_pid, user_id) do
    GenServer.cast(game_pid, {:accepted, user_id})
  end

  def get_id(pid) do
    GenServer.call(pid, :get_game_id)
  end

  def reject(game_pid, user_id) do
    GenServer.cast(game_pid, {:reject, user_id})
  end

  def start_link(args) do
    IO.inspect(args)
    GenServer.start_link(__MODULE__, args)
  end

  # Server callbacks
  #
  def init(lobby) do
    {:ok, game} = Ragnaros.Repo.insert(%Ragnaros.Game.Instance{players: lobby})

    {:ok, %{accepted: %{}, lobby: lobby, game_id: game.id}}
  end

  def handle_call(:get_game_id, state) do
    {:ok, state[:game_id], state}
  end

  def handle_cast({:accepted, user_id}, state) do
    accepted_hash = get_in(state, [:accepted])
    accepted = 1 + (accepted_hash |> Enum.count)

    if accepted == @lobby do
      Ragnaros.Registry.notify_game_started(state[:lobby], state.game_id)
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
end
