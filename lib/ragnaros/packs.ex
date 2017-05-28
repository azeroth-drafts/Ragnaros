defmodule Ragnaros.Packs do
  def generate_pack(id) do
    cards =
    Ragnaros.Game.list_cards
    |> Enum.filter(fn card -> card.cardSet != "Basic" end)

    cards_size = Enum.count(cards)

    (for i <- 1..15, do: (:rand.uniform(cards_size) - 1))
    |> Enum.map(&Enum.at(cards, &1))
  end

  def generate_basic() do
    Ragnaros.Game.list_cards
    |> Enum.filter(fn card -> card.cardSet == "Basic" end)
  end
end
