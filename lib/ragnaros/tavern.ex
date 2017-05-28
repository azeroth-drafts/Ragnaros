defmodule Ragnaros.Tavern do
  use GenServer

  import Supervisor.Spec

  alias Ragnaros.Registry

  @full_lobby 4

  # Client API

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def connected?(user_id) do
    GenServer.call(__MODULE__, {:is_connected, user_id})
  end

  def remove_user(id) do
    GenServer.cast(__MODULE__, {:remove_user, id})
  end

  def accept(id) do
    GenServer.cast(__MODULE__, {:accept, id})
  end

  def reject(id) do
    GenServer.cast(__MODULE__, {:reject, id})
  end

  def join({user_id, pid}) do
    GenServer.cast(__MODULE__, {:join_lobby, {user_id, pid}})
  end

  def join_game(lobby) do
    GenServer.cast(__MODULE__, {:join_game, lobby})
  end

  # Server callbacks

  def init(_) do
    # first set is for in lobby, second for in game
    {:ok, {[], %{}}}
  end

  def handle_call({:is_connected, user_id}, _from, {in_lobby, in_game} = state) do
    result = Enum.member?(in_lobby, user_id) || Map.has_key?(in_game, user_id)
    {:reply, result, state}
  end

  def handle_call({:join_game, lobby}, state) do
    {:ok, gameroom_pid} = Supervisor.start_child(Ragnaros.GamesSupervisor, worker(GameRoom, [lobby], restart: :temporary))

    {:reply, {:ok, gameroom_pid}, state}
  end

  def handle_cast({:join_lobby, {user_id, channel_pid}}, {in_lobby, in_game}) do
    in_lobby = [user_id | in_lobby]
    Registry.register(user_id, channel_pid) #cast
    if length(Map.keys(in_lobby)) == @full_lobby do
      {:ok, game_pid} = join_game(in_lobby)
      lobby_users_with_game = Enum.reduce(in_lobby, %{}, fn el, map ->
        Ragnaros.Registry.notify_game_found(el)
        put_in(map, [el], game_pid)
      end)
      {:noreply, {[], Map.merge(in_game, lobby_users_with_game)}}
    else
      {:noreply, {in_lobby, in_game}}
    end
  end

  def handle_cast({:accept, user_id}, {_, in_game}) do
    game_pid = in_game[user_id]
    GameRoom.accept(game_pid, user_id)
  end

  def handle_cast({:reject, user_id}, {_, in_game}) do
    game_pid = in_game[user_id]
    GameRoom.reject(game_pid, user_id)
  end

  def handle_cast({:remove_user, id}, {_, in_game}) do
    new = Map.delete(in_game, id)
    Ragnaros.Registry.notify_game_canceled(id)
    {:noreply, new}
  end
end
