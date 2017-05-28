defmodule Ragnaros.Registry do
  use GenServer

  def init(_) do
    {:ok, %{}}
  end
end
