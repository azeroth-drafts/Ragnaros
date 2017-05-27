defmodule Ragnaros.Web.CardView do
  use Ragnaros.Web, :view
  alias Ragnaros.Web.CardView

  def render("index.json", %{cards: cards}) do
    %{data: render_many(cards, CardView, "card.json")}
  end

  def render("show.json", %{card: card}) do
    %{data: render_one(card, CardView, "card.json")}
  end

  def render("card.json", %{card: card}) do
    %{id: card.id,
      cardId: card.cardId,
      name: card.name,
      cardSet: card.cardSet,
      type: card.type,
      faction: card.faction,
      rarity: card.rarity,
      cost: card.cost,
      attack: card.attack,
      health: card.health,
      text: card.text,
      race: card.race,
      img: card.img}
  end
end
