defmodule Ragnaros.Registry do
  use GenServer

  def register(user_id, channel_pid) do
    GenServer.call(__MODULE__, {:register, user_id, channel_pid})
  end

  def notify_draft_finished(lobby, game_id) do
    basic_cards = Ragnaros.Packs.generate_basic()
    lobby |> Enum.each(fn (user) ->
      user_cards = Ragnaros.Game.Selection.cards_for_user_and_game(user, game_id)
      cards =
        basic_cards
      GenServer.cast(__MODULE__, {:notify_draft_finished, user, game_id, cards})
    end)
  end

  def notify_game_canceled(user_id) do
    GenServer.cast(__MODULE__, {:notify_canceled, user_id})
  end

  def notify_game_found(user_id) do
    GenServer.cast(__MODULE__, {:notify_found, user_id})
  end

  def notify_game_started(lobby, game_id) do
    lobby |> Enum.each(fn user ->
      GenServer.cast(__MODULE__, {:notify_started, user, game_id})
    end )
  end

  def notify_draft(lobby, draft_cards) do
    lobby |> Enum.each(fn user_id ->
      GenServer.cast(__MODULE__, {:notify_draft_cards, user_id, draft_cards[user_id]})
    end)
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Server callbacks

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:register, user_id, channel_pid}, _, state) do
    new = put_in(state, [user_id], channel_pid)
    {:reply, :ok, new}
  end

  def handle_cast({:notify_canceled, user_id}, state) do
    channel_pid = state[user_id]
    send(channel_pid, {:game_canceled, user_id})
    {:noreply, state}
  end

  def handle_cast({:notify_started, user_id, game_id}, state) do
    channel_pid = state[user_id]
    send(channel_pid, {:game_started, game_id})
    {:noreply, state}
  end

  def handle_cast({:notify_found, user_id}, state) do
    channel_pid = state[user_id]
    send(channel_pid, :game_found)
    {:noreply, state}
  end

  def handle_cast({:notify_draft_cards, user_id, cards}, state) do
    channel_pid = state[user_id]
    send(channel_pid, {:draft, cards})
    {:noreply, state}
  end

  def handle_cast({:notify_draft_finished, user_id, game_id, cards}, state) do
    channel_pid = state[user_id]
    send(channel_pid, {:draft_finish, cards})
    IO.inspect cards
    {:noreply, state}
  end
end
