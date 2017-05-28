defmodule Ticker do
  def start_link(users) do
    spawn_link(Ticker, :wait_for_notification, users)
  end

  def wait_for_notification(users) do
    receive do
      :notify ->
        tick(users)
    end
  end

  def tick(users) do
    receive do
      :stop_ticking ->
        wait_for_notification(users)
    after 1000 ->
        Ragnaros.Registry.tick(users)
        tick(users)
    end
  end
end
