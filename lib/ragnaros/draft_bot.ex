defmodule Ragnaros.Draft.Bot do
  alias Ragnaros.{Tavern, Registry}

  @id -1

  def start_link() do
    pid = spawn_link(__MODULE__, :join, [])
    {:ok, pid}
  end

  def join() do
    Process.sleep(5000)
    Tavern.join({@id, self()})
    wait_for_game()
  end

  def wait_for_game() do
    receive do
      :game_found ->
        accept()
    end
  end

  def accept() do
    Tavern.accept(@id)
    wait_for_start()
  end

  def wait_for_start() do
    receive do
      {:game_started, game_id} ->
        Registry.register(@id, self())
        Tavern.registered(@id)
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
