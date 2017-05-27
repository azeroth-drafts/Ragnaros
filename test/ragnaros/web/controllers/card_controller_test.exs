defmodule Ragnaros.Web.CardControllerTest do
  use Ragnaros.Web.ConnCase

  alias Ragnaros.Game
  alias Ragnaros.Game.Card

  @create_attrs %{attack: 42, cardId: "some cardId", cardSet: "some cardSet", cost: 42, faction: "some faction", health: 42, img: "some img", name: "some name", race: "some race", rarity: "some rarity", text: "some text", type: "some type"}
  @update_attrs %{attack: 43, cardId: "some updated cardId", cardSet: "some updated cardSet", cost: 43, faction: "some updated faction", health: 43, img: "some updated img", name: "some updated name", race: "some updated race", rarity: "some updated rarity", text: "some updated text", type: "some updated type"}
  @invalid_attrs %{attack: nil, cardId: nil, cardSet: nil, cost: nil, faction: nil, health: nil, img: nil, name: nil, race: nil, rarity: nil, text: nil, type: nil}

  def fixture(:card) do
    {:ok, card} = Game.create_card(@create_attrs)
    card
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, card_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates card and renders card when data is valid", %{conn: conn} do
    conn = post conn, card_path(conn, :create), card: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, card_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "attack" => 42,
      "cardId" => "some cardId",
      "cardSet" => "some cardSet",
      "cost" => 42,
      "faction" => "some faction",
      "health" => 42,
      "img" => "some img",
      "name" => "some name",
      "race" => "some race",
      "rarity" => "some rarity",
      "text" => "some text",
      "type" => "some type"}
  end

  test "does not create card and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, card_path(conn, :create), card: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen card and renders card when data is valid", %{conn: conn} do
    %Card{id: id} = card = fixture(:card)
    conn = put conn, card_path(conn, :update, card), card: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, card_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "attack" => 43,
      "cardId" => "some updated cardId",
      "cardSet" => "some updated cardSet",
      "cost" => 43,
      "faction" => "some updated faction",
      "health" => 43,
      "img" => "some updated img",
      "name" => "some updated name",
      "race" => "some updated race",
      "rarity" => "some updated rarity",
      "text" => "some updated text",
      "type" => "some updated type"}
  end

  test "does not update chosen card and renders errors when data is invalid", %{conn: conn} do
    card = fixture(:card)
    conn = put conn, card_path(conn, :update, card), card: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen card", %{conn: conn} do
    card = fixture(:card)
    conn = delete conn, card_path(conn, :delete, card)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, card_path(conn, :show, card)
    end
  end
end
