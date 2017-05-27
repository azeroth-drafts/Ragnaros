require IEx;
defmodule Mix.Tasks.Cards.Import do
  alias Ragnaros.Game.Card
  alias Ragnaros.Repo

  use Mix.Task

  def run(_ ) do
    {:ok, _started} = Application.ensure_all_started(:ragnaros)
    IO.puts "Beginning to import ..."
    import_cards()
    IO.puts "Done ..."
  end

  defp import_cards do
    cards_json = get_cards()

    import_cards_for_set(cards_json, :"Basic")
    import_cards_for_set(cards_json, :"Classic")
    import_cards_for_set(cards_json, :"Mean Streets of Gadgetzan")
    import_cards_for_set(cards_json, :"Journey to Un'Goro")
  end

  defp import_cards_for_set(cards, set) do
    cards[set] |> Enum.each(fn data ->
      try do
        changeset = Card.changeset(%Card{}, data)
        Repo.insert(changeset, [on_conflict: :nothing])
      catch
        error -> IO.puts "Error occurred #{inspect error}"
      end
    end)
  end

  defp get_cards do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(url(), headers())
    Poison.Parser.parse!(body, keys: :atoms)
  end

  defp url do
    "https://omgvamp-hearthstone-v1.p.mashape.com/cards?collectible=1"
  end

  defp headers do
    [
      {"X-Mashape-Key", api()},
      {"content-type", "application/json"}
    ]
  end

  defp api do
    "jXerIETWyTmshxEf7v3e5rVxHA9mp1KLPY4jsnk73eczWLYRKQ"
  end
end

