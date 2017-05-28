defmodule GameRoom do
  use GenServer

  @lobby 1

  def ready(pid) do
    GenServer.cast(pid, :ready)
  end

  def registered(pid) do
    GenServer.cast(pid, :registered)
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

  def save_selection(game_pid, user_id, card_id) do
    GenServer.cast(game_pid, {:save_selection, user_id, card_id})
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  # Server callbacks
  def init(lobby) do
    {:ok, game} = Ragnaros.Repo.insert(%Ragnaros.Game.Instance{players: lobby})

    {:ok, %{accepted: %{}, lobby: lobby, game_id: game.id, registered: 0}, draft_cards: []}
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

  def handle_cast(:registered, state) do
    new = get_and_update_in(state, [:registered], &(&1 + 1))
    if new == @lobby do
      send(self(), :registered)
    end
    {:noreply, new}
  end

  def handle_cast({:save_selection, user_id, card_id}, state) do
    game_id = state[:game_id]
    Task.start(fn ->
      Ragnaros.Repo.insert(
        %Ragnaros.Game.Selection{card_id: card_id,
                                 user_id: user_id,
                                 game_id: game_id})
    end)
    {:noreply, state}
  end

  def handle_info(:registered, state) do
    new = get_and_update_in(state, [:draft_cards], fn _ ->
      (1..@lobby) |> Enum.map(&(Ragnaros.Packs.generate_basic ++ Ragnaros.Packs.generate_pack(&1)))
    end)

    {:noreply, new}
  end
end
