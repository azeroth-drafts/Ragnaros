defmodule Ragnaros.GameTest do
  use Ragnaros.DataCase

  alias Ragnaros.Game

  describe "cards" do
    alias Ragnaros.Game.Card

    @valid_attrs %{attack: 42, cardId: "some cardId", cardSet: "some cardSet", cost: 42, faction: "some faction", health: 42, img: "some img", name: "some name", race: "some race", rarity: "some rarity", text: "some text", type: "some type"}
    @update_attrs %{attack: 43, cardId: "some updated cardId", cardSet: "some updated cardSet", cost: 43, faction: "some updated faction", health: 43, img: "some updated img", name: "some updated name", race: "some updated race", rarity: "some updated rarity", text: "some updated text", type: "some updated type"}
    @invalid_attrs %{attack: nil, cardId: nil, cardSet: nil, cost: nil, faction: nil, health: nil, img: nil, name: nil, race: nil, rarity: nil, text: nil, type: nil}

    def card_fixture(attrs \\ %{}) do
      {:ok, card} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Game.create_card()

      card
    end

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Game.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Game.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      assert {:ok, %Card{} = card} = Game.create_card(@valid_attrs)
      assert card.attack == 42
      assert card.cardId == "some cardId"
      assert card.cardSet == "some cardSet"
      assert card.cost == 42
      assert card.faction == "some faction"
      assert card.health == 42
      assert card.img == "some img"
      assert card.name == "some name"
      assert card.race == "some race"
      assert card.rarity == "some rarity"
      assert card.text == "some text"
      assert card.type == "some type"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      assert {:ok, card} = Game.update_card(card, @update_attrs)
      assert %Card{} = card
      assert card.attack == 43
      assert card.cardId == "some updated cardId"
      assert card.cardSet == "some updated cardSet"
      assert card.cost == 43
      assert card.faction == "some updated faction"
      assert card.health == 43
      assert card.img == "some updated img"
      assert card.name == "some updated name"
      assert card.race == "some updated race"
      assert card.rarity == "some updated rarity"
      assert card.text == "some updated text"
      assert card.type == "some updated type"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_card(card, @invalid_attrs)
      assert card == Game.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Game.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Game.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Game.change_card(card)
    end
  end

  describe "instances" do
    alias Ragnaros.Game.Instance

    @valid_attrs %{players: []}
    @update_attrs %{players: []}
    @invalid_attrs %{players: nil}

    def instance_fixture(attrs \\ %{}) do
      {:ok, instance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Game.create_instance()

      instance
    end

    test "list_instances/0 returns all instances" do
      instance = instance_fixture()
      assert Game.list_instances() == [instance]
    end

    test "get_instance!/1 returns the instance with given id" do
      instance = instance_fixture()
      assert Game.get_instance!(instance.id) == instance
    end

    test "create_instance/1 with valid data creates a instance" do
      assert {:ok, %Instance{} = instance} = Game.create_instance(@valid_attrs)
      assert instance.players == []
    end

    test "create_instance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_instance(@invalid_attrs)
    end

    test "update_instance/2 with valid data updates the instance" do
      instance = instance_fixture()
      assert {:ok, instance} = Game.update_instance(instance, @update_attrs)
      assert %Instance{} = instance
      assert instance.players == []
    end

    test "update_instance/2 with invalid data returns error changeset" do
      instance = instance_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_instance(instance, @invalid_attrs)
      assert instance == Game.get_instance!(instance.id)
    end

    test "delete_instance/1 deletes the instance" do
      instance = instance_fixture()
      assert {:ok, %Instance{}} = Game.delete_instance(instance)
      assert_raise Ecto.NoResultsError, fn -> Game.get_instance!(instance.id) end
    end

    test "change_instance/1 returns a instance changeset" do
      instance = instance_fixture()
      assert %Ecto.Changeset{} = Game.change_instance(instance)
    end
  end
end
