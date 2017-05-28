defmodule Ragnaros.Tavern do
  use GenServer

  alias Ragnaros.Registry

  @full_lobby 4

  # Client API

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def connected?(user_id) do
    {:ok, result} = GenServer.call(__MODULE__, {:is_connected, user_id})
    result
  end

  def accepted(id) do
  end

  def rejected(id) do
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

  def handle_cast({:join_lobby, {user_id, pid}}, {in_lobby, in_game}) do
    in_lobby = [user_id, in_lobby]
    Registry.register(user_id, pid) #cast
    if length(Map.keys(in_lobby)) == @full_lobby do
      {:ok, game_pid} = join_game(in_lobby)
      {:noreply, {%{}, Map.merge(in_game, %{game_pid => in_lobby})}}
    else
      {:noreply, {in_lobby, in_game}}
    end
  end

  def handle_cast({:join_game, lobby}, state) do
    import Supervisor.Spec

    children = [worker(GameRoom, [lobby], restart: :temporary)]
    Ragnaros.GamesSupervisor.start_link(children, strategy: :one_for_one)

    {:noreply, state}
  end
end
