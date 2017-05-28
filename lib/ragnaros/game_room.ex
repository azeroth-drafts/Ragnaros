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

  # def get_id(pid) do
  #   GenServer.call(pid, :get_game_id)
  # end

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

    {:ok, %{accepted: %{}, lobby: lobby, game_id: game.id, registered: 0, draft_cards: %{}, removed: 0}}
  end

  # def handle_call(:get_game_id, _, state) do
  #   {:reply, state[:game_id], state}
  # end

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
    new = update_in(state, [:registered], &(&1 + 1))
    IO.inspect new
    if new.registered == @lobby, do: send(self(), :registered)
    {:noreply, new}
  end

  def handle_cast({:save_selection, user_id, card_id}, state) do
    game_id = state[:game_id]
    insert_card(user_id, card_id, game_id)
    new = update_in(state, [:draft_cards, user_id], fn(cards) ->
      idx = Enum.find(cards, fn(x) -> x.id == card_id end)
      List.delete(cards, idx)
    end)
    new = update_in(new, [:removed], &(&1 + 1))
    case new.removed do
      x when x == @lobby -> send(self(), :draft_finish)
      _ -> send(self(), :removed)
    end
    {:noreply, new}
  end

  defp insert_card(user_id, card_id, game_id) do
    Task.start(fn ->
      Ragnaros.Repo.insert(
        %Ragnaros.Game.Selection{card_id: card_id,
                                 user_id: user_id,
                                 game_id: game_id})
    end)
  end

  def handle_info(:draft_finish, state) do
    game_id = state[:game_id]
    Ragnaros.Registry.notify_draft_finished(state.lobby, game_id)
  end

  def handle_info(:registered, state) do
    new = update_in(state, [:draft_cards], fn _ ->
      Enum.reduce(state.lobby, %{}, fn(x, acc) ->
        Map.merge(acc, %{x => Ragnaros.Packs.generate_pack})
      end)
    end)
    Ragnaros.Registry.notify_draft(state[:lobby], state[:draft_cards])

    {:noreply, new}
  end

  def handle_info(:removed, state) do
    new_lobby = state.lobby ++ state.lobby |> Enum.drop(1) |> Enum.take(@lobby)
    new = update_in(state, [:lobby], new_lobby)
    Ragnaros.Registry.notify_draft(state[:lobby], state[:draft_cards])

    {:noreply, new}
  end
end
