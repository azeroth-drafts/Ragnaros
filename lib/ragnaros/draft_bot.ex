defmodule Ragnaros.Draft.Bot do
  alias Ragnaros.{Tavern, Registry}

  @id -1

  def start_link(_) do
    spawn_link(__MODULE__, :join, %{}, [])
  end

  def join() do
    Tavern.join({@id, self()})
    game_found()
  end

  def wait_for_game() do
    receive do
      :game_found ->
        accept()
    end
  end

  def accept() do
    Tavern.accept(@id)
    game_started()
  end

  def wait_for_start() do
    receive do
      {:game_started, game_id} ->
        Registry.register(@id, self())
        Tavern.registered(id)
        pick_or_finish()
    end
  end

  def pick_or_finish() do
    receive do
      {:draft, cards} ->
        pick(cards)
      {:draft_finish, cards} ->
        finish()
    end
  end

  def pick(cards) do
    Tavern.selected(@id, (cards |> Enum.first).id )
  end

  def finish() do
    nil
  end
end
