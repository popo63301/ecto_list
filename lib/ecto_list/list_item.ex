defmodule EctoList.ListItem do
  @moduledoc """
  Implements conveniences to change the items order of a list.
  """

  @doc """
  Insert an list item id in the given index of an order_list

      iex> EctoList.ListItem.insert_at([1, 2, 3, 4], 9, 2)
      [1, 9, 2, 3, 4]

      iex> EctoList.ListItem.insert_at([1, 2, 3], 9, 10)
      [1, 2, 3, 9]

      iex> EctoList.ListItem.insert_at([1, 2, 9, 3], 9, 2)
      [1, 9, 2, 3]

      iex> EctoList.ListItem.insert_at([1, 2, 9, 3], 9, 10)
      [1, 2, 3, 9]

      iex> EctoList.ListItem.insert_at([1, 2, 9, 3], 9, nil)
      [1, 2, 9, 3]
  """
  def insert_at(order_list, _list_item, nil) do
    order_list
  end

  def insert_at(order_list, list_item, index) do
    order_list
    |> Enum.reject(&(&1 == list_item))
    |> List.insert_at(index - 1, list_item)
  end

  @doc """
  Move the list item id one rank lower in the ordering.

      iex> EctoList.ListItem.move_lower([1, 2, 3, 4], 3)
      [1, 2, 4, 3]

      iex> EctoList.ListItem.move_lower([1, 2, 3, 4], 1)
      [2, 1, 3, 4]

      iex> EctoList.ListItem.move_lower([1, 2, 3, 4], 4)
      [1, 2, 3, 4]

      iex> EctoList.ListItem.move_lower([1, 2, 3, 4], 5)
      [1, 2, 3, 4]

  """
  def move_lower(order_list, list_item) do
    index = Enum.find_index(order_list, &(&1 == list_item))
    insert_at(order_list, list_item, index && index + 2)
  end

  @doc """
  Move the list item id one rank higher in the ordering.

      iex> EctoList.ListItem.move_higher([1, 2, 3, 4], 3)
      [1, 3, 2, 4]

      iex> EctoList.ListItem.move_higher([1, 2, 3, 4], 1)
      [1, 2, 3, 4]

      iex> EctoList.ListItem.move_higher([1, 2, 3, 4], 5)
      [1, 2, 3, 4]

  """
  def move_higher(order_list, list_item) do
    index = Enum.find_index(order_list, &(&1 == list_item))

    case index do
      nil ->
        order_list

      0 ->
        order_list

      _ ->
        insert_at(order_list, list_item, index)
    end
  end

  @doc """
  Move the list item id at the last position in the ordering.

      iex> EctoList.ListItem.move_to_bottom([1, 2, 3, 4], 3)
      [1, 2, 4, 3]

      iex> EctoList.ListItem.move_to_bottom([1, 2, 3, 4], 1)
      [2, 3, 4, 1]

      iex> EctoList.ListItem.move_to_bottom([1, 2, 3, 4], 4)
      [1, 2, 3, 4]

      iex> EctoList.ListItem.move_to_bottom([1, 2, 3, 4], 5)
      [1, 2, 3, 4, 5]

  """
  def move_to_bottom(order_list, list_item) do
    length = length(order_list)

    case Enum.member?(order_list, list_item) do
      true -> insert_at(order_list, list_item, length)
      false -> insert_at(order_list, list_item, length + 1)
    end
  end

  @doc """
  Move the list item id at the first position in the ordering.

      iex> EctoList.ListItem.move_to_top([1, 2, 3, 4], 3)
      [3, 1, 2, 4]

      iex> EctoList.ListItem.move_to_top([1, 2, 3, 4], 1)
      [1, 2, 3, 4]

      iex> EctoList.ListItem.move_to_top([1, 2, 3, 4], 5)
      [5, 1, 2, 3, 4]

  """
  def move_to_top(order_list, list_item) do
    insert_at(order_list, list_item, 1)
  end

  @doc """
  Remove the list item id in the ordering.

      iex> EctoList.ListItem.remove_from_list([1, 2, 3, 4], 3)
      [1, 2, 4]

      iex> EctoList.ListItem.remove_from_list([1, 2, 3, 4], 1)
      [2, 3, 4]

      iex> EctoList.ListItem.remove_from_list([1, 2, 3, 4], 5)
      [1, 2, 3, 4]

  """
  def remove_from_list(order_list, list_item) do
    Enum.reject(order_list, &(&1 == list_item))
  end

  @doc """
  Check if list item id is the first element in the ordering.

      iex> EctoList.ListItem.first?([1, 2, 3, 4], 1)
      true

      iex> EctoList.ListItem.first?([1, 2, 3, 4], 3)
      false

      iex> EctoList.ListItem.first?([1, 2, 3, 4], 5)
      false

  """
  def first?(order_list, list_item) do
    List.first(order_list) == list_item
  end

  @doc """
  Check if list item id is the last element in the ordering.

      iex> EctoList.ListItem.last?([1, 2, 3, 4], 4)
      true

      iex> EctoList.ListItem.last?([1, 2, 3, 4], 2)
      false

      iex> EctoList.ListItem.last?([1, 2, 3, 4], 5)
      false

  """
  def last?(order_list, list_item) do
    List.last(order_list) == list_item
  end

  @doc """
  Check if list item id is in the ordering.

      iex> EctoList.ListItem.in_list?([1, 2, 3, 4], 3)
      true

      iex> EctoList.ListItem.in_list?([1, 2, 3, 4], 5)
      false

  """
  def in_list?(order_list, list_item) do
    Enum.member?(order_list, list_item)
  end

  @doc """
  Check if list item id is in the ordering.

      iex> EctoList.ListItem.not_in_list?([1, 2, 3, 4], 5)
      true

      iex> EctoList.ListItem.not_in_list?([1, 2, 3, 4], 3)
      false
  """
  def not_in_list?(order_list, list_item) do
    !Enum.member?(order_list, list_item)
  end

  @doc """
  Return the list item id which is one rank higher in the ordering.

      iex> EctoList.ListItem.higher_item([1, 7, 3, 4], 3)
      7

      iex> EctoList.ListItem.higher_item([1, 2, 3, 4], 1)
      nil

      iex> EctoList.ListItem.higher_item([1, 2, 3, 4], 5)
      nil
  """
  def higher_item(order_list, list_item) do
    index = Enum.find_index(order_list, &(&1 == list_item))

    case index do
      nil -> nil
      0 -> nil
      _ -> Enum.fetch!(order_list, index - 1)
    end
  end

  @doc """
  Return the list of ids above the list item id.

      iex> EctoList.ListItem.higher_items([1, 2, 3, 4], 3)
      [1, 2]

      iex> EctoList.ListItem.higher_items([1, 2, 3, 4], 4)
      [1, 2, 3]

      iex> EctoList.ListItem.higher_items([1, 2, 3, 4], 1)
      []

      iex> EctoList.ListItem.higher_items([1, 2, 3, 4], 5)
      nil
  """
  def higher_items(order_list, list_item) do
    index = Enum.find_index(order_list, &(&1 == list_item))

    case index do
      nil -> nil
      0 -> []
      _ -> Enum.slice(order_list, 0, index)
    end
  end

  @doc """
  Return the list item id which is one rank lower in the ordering.

      iex> EctoList.ListItem.lower_item([1, 2, 3, 7], 3)
      7

      iex> EctoList.ListItem.lower_item([1, 2, 3, 4], 4)
      nil

      iex> EctoList.ListItem.lower_item([1, 2, 3, 4], 5)
      nil
  """
  def lower_item(order_list, list_item) do
    index = Enum.find_index(order_list, &(&1 == list_item))
    last_index = length(order_list) - 1

    case index do
      nil -> nil
      ^last_index -> nil
      _ -> Enum.fetch!(order_list, index + 1)
    end
  end

  @doc """
  Return the list of ids below the list item id.

      iex> EctoList.ListItem.lower_items([1, 2, 3, 4], 2)
      [3, 4]

      iex> EctoList.ListItem.lower_items([1, 2, 3, 4], 1)
      [2, 3, 4]

      iex> EctoList.ListItem.lower_items([1, 2, 3, 4], 4)
      []

      iex> EctoList.ListItem.lower_items([1, 2, 3, 4], 5)
      nil
  """
  def lower_items(order_list, list_item) do
    index = Enum.find_index(order_list, &(&1 == list_item))
    last_index = length(order_list) - 1

    case index do
      nil -> nil
      ^last_index -> []
      _ -> Enum.slice(order_list, index + 1, last_index - index)
    end
  end
end
