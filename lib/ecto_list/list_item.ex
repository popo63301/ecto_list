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
end
