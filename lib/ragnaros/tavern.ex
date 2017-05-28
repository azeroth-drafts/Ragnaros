defmodule Ragnaros.Tavern do
  use GenServer

  import Supervisor.Spec

  alias Ragnaros.Registry

  @full_lobby 1

  # Client API

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def connected?(user_id) do
    GenServer.call(__MODULE__, {:is_connected, user_id})
  end

  def selected(user_id, card_id) do
    GenServer.cast(__MODULE__, {:select_card, user_id, card_id})
  end

  def registered(user_id) do
    GenServer.cast(__MODULE__, {:registered, user_id})
  end

  def remove_user(id) do
    GenServer.cast(__MODULE__, {:remove_user, id})
  end

  def accept(id) do
    GenServer.cast(__MODULE__, {:accept, id})
  end

  def save_deck(id, cards) do
    GenServer.cast(__MODULE__, {:save_deck, id, cards})
  end

  def reject(id) do
    GenServer.cast(__MODULE__, {:reject, id})
  end

  def join({user_id, pid}) do
    GenServer.cast(__MODULE__, {:join_lobby, {user_id, pid}})
  end

  defp join_game(lobby) do
    {:ok, gameroom_pid} =
      Supervisor.start_child(Ragnaros.GamesSupervisor,
        worker(GameRoom, [lobby], restart: :temporary))

    send(self(), {:game_room, lobby, gameroom_pid})
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

  def handle_cast({:join_lobby, {user_id, channel_pid}}, {in_lobby, in_game} = state) do
    in_lobby = [user_id | in_lobby]
    Registry.register(user_id, channel_pid) #cast
    if length(in_lobby) == @full_lobby do
      join_game(in_lobby)
      {:noreply, {[], in_game}}
    else
      {:noreply, {in_lobby, in_game}}
    end
  end

  def handle_cast({:accept, user_id}, {_, in_game} = state) do
    game_pid = in_game[user_id]
    GameRoom.accept(game_pid, user_id)
    {:noreply, state}
  end

  def handle_cast({:reject, user_id}, {_, in_game} = state) do
    game_pid = in_game[user_id]
    GameRoom.reject(game_pid, user_id)
    {:noreply, state}
  end

  def handle_cast({:remove_user, id}, {list, in_game}) do
    new = Map.delete(in_game, id)
    Ragnaros.Registry.notify_game_canceled(id)
    {:noreply, {list, new}}
  end

  def handle_cast({:registered, user_id}, {_, in_game}) do
    game_pid = in_game[user_id]
    GameRoom.registered(game_pid)
  end

  def handle_cast({:select_card, user_id, card_id}, {_, in_game} = state) do
    game_pid = in_game[user_id]
    GameRoom.save_selection(game_pid, user_id, card_id)
    {:noreply, state}
  end

  def handle_cast({:save_deck, id, cards}, {_, games} = state) do
    Task.start(fn ->
      Ragnaros.Repo.insert(%Ragnaros.Game.Deck{cards: cards, user_id: id, game_id: games[id]})
    end)
    {:noreply, state}
  end

  def handle_info({:game_room, in_lobby, gameroom_pid}, {list, in_game}) do
    lobby_users_with_game = Enum.reduce(in_lobby, %{}, fn el, map ->
      Ragnaros.Registry.notify_game_found(el)
      put_in(map, [el], gameroom_pid)
    end)
    {:noreply, {list, Map.merge(in_game, lobby_users_with_game)}}
  end
end
