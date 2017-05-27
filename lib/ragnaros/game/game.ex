defmodule Ragnaros.Game do
  @moduledoc """
  The boundary for the Game system.
  """

  import Ecto.Query, warn: false
  alias Ragnaros.Repo

  alias Ragnaros.Game.Card

  @doc """
  Returns the list of cards.

  ## Examples

      iex> list_cards()
      [%Card{}, ...]

  """
  def list_cards do
    Repo.all(Card)
  end

  @doc """
  Gets a single card.

  Raises `Ecto.NoResultsError` if the Card does not exist.

  ## Examples

      iex> get_card!(123)
      %Card{}

      iex> get_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_card!(id), do: Repo.get!(Card, id)

  @doc """
  Creates a card.

  ## Examples

      iex> create_card(%{field: value})
      {:ok, %Card{}}

      iex> create_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a card.

  ## Examples

      iex> update_card(card, %{field: new_value})
      {:ok, %Card{}}

      iex> update_card(card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_card(%Card{} = card, attrs) do
    card
    |> Card.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Card.

  ## Examples

      iex> delete_card(card)
      {:ok, %Card{}}

      iex> delete_card(card)
      {:error, %Ecto.Changeset{}}

  """
  def delete_card(%Card{} = card) do
    Repo.delete(card)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking card changes.

  ## Examples

      iex> change_card(card)
      %Ecto.Changeset{source: %Card{}}

  """
  def change_card(%Card{} = card) do
    Card.changeset(card, %{})
  end

  alias Ragnaros.Game.Instance

  @doc """
  Returns the list of instances.

  ## Examples

      iex> list_instances()
      [%Instance{}, ...]

  """
  def list_instances do
    Repo.all(Instance)
  end

  @doc """
  Gets a single instance.

  Raises `Ecto.NoResultsError` if the Instance does not exist.

  ## Examples

      iex> get_instance!(123)
      %Instance{}

      iex> get_instance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_instance!(id), do: Repo.get!(Instance, id)

  @doc """
  Creates a instance.

  ## Examples

      iex> create_instance(%{field: value})
      {:ok, %Instance{}}

      iex> create_instance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_instance(attrs \\ %{}) do
    %Instance{}
    |> Instance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a instance.

  ## Examples

      iex> update_instance(instance, %{field: new_value})
      {:ok, %Instance{}}

      iex> update_instance(instance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_instance(%Instance{} = instance, attrs) do
    instance
    |> Instance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Instance.

  ## Examples

      iex> delete_instance(instance)
      {:ok, %Instance{}}

      iex> delete_instance(instance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_instance(%Instance{} = instance) do
    Repo.delete(instance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking instance changes.

  ## Examples

      iex> change_instance(instance)
      %Ecto.Changeset{source: %Instance{}}

  """
  def change_instance(%Instance{} = instance) do
    Instance.changeset(instance, %{})
  end

  alias Ragnaros.Game.Selection

  @doc """
  Returns the list of selections.

  ## Examples

      iex> list_selections()
      [%Selection{}, ...]

  """
  def list_selections do
    Repo.all(Selection)
  end

  @doc """
  Gets a single selection.

  Raises `Ecto.NoResultsError` if the Selection does not exist.

  ## Examples

      iex> get_selection!(123)
      %Selection{}

      iex> get_selection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_selection!(id), do: Repo.get!(Selection, id)

  @doc """
  Creates a selection.

  ## Examples

      iex> create_selection(%{field: value})
      {:ok, %Selection{}}

      iex> create_selection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_selection(attrs \\ %{}) do
    %Selection{}
    |> Selection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a selection.

  ## Examples

      iex> update_selection(selection, %{field: new_value})
      {:ok, %Selection{}}

      iex> update_selection(selection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_selection(%Selection{} = selection, attrs) do
    selection
    |> Selection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Selection.

  ## Examples

      iex> delete_selection(selection)
      {:ok, %Selection{}}

      iex> delete_selection(selection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_selection(%Selection{} = selection) do
    Repo.delete(selection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking selection changes.

  ## Examples

      iex> change_selection(selection)
      %Ecto.Changeset{source: %Selection{}}

  """
  def change_selection(%Selection{} = selection) do
    Selection.changeset(selection, %{})
  end
end
