defmodule EctoList do
  @moduledoc """
  Documentation for EctoList.
  """

  @doc """
  Hello world.

  ## Examples

      iex> EctoList.hello()
      :world

  """
  def hello do
    :world
  end

  #########################

  def ordered_items_list(items, items_order \\ []) do
    complete_items_order = complete_items_order(items, items_order)

    search_function = fn x -> Enum.find(items, fn item -> item.id == x end) end

    Enum.map(complete_items_order, search_function)
  end

  #########################

  defp sorted_items_by_inserted_date(items) do
    items
    |> Enum.sort(&(NaiveDateTime.compare(&1.inserted_at, &2.inserted_at) == :lt))
  end

  def missing_ids_list(all_items), do: missing_ids_list(all_items, [])
  def missing_ids_list(all_items, nil), do: missing_ids_list(all_items, [])

  def missing_ids_list(all_items, items_order) do
    all_items
    |> sorted_items_by_inserted_date
    |> Enum.reduce([], fn x, acc ->
      if !Enum.member?(items_order ++ acc, x.id) do
        acc ++ [x.id]
      else
        acc
      end
    end)
  end

  def complete_items_order(items, nil), do: complete_items_order(items, [])

  def complete_items_order(items, items_order) do
    missing_ids_list = missing_ids_list(items, items_order)

    items_order ++ missing_ids_list
  end
end
