defmodule EctoListTest do
  use ExUnit.Case
  doctest EctoList

  @all_items [
    %{id: 1, title: "Item 1", inserted_at: ~N[2019-07-16 16:03:15]},
    %{id: 2, title: "Item 2", inserted_at: ~N[2019-07-16 16:04:15]},
    %{id: 3, title: "Item 3", inserted_at: ~N[2019-07-16 16:05:15]},
    %{id: 4, title: "Item 4", inserted_at: ~N[2019-07-16 16:06:15]},
    %{id: 5, title: "Item 5", inserted_at: ~N[2019-07-16 16:07:15]}
  ]

  test "ordered_items_list/2" do
    assert EctoList.ordered_items_list(@all_items, [5, 3, 1]) ==
             [
               %{id: 5, title: "Item 5", inserted_at: ~N[2019-07-16 16:07:15]},
               %{id: 3, title: "Item 3", inserted_at: ~N[2019-07-16 16:05:15]},
               %{id: 1, title: "Item 1", inserted_at: ~N[2019-07-16 16:03:15]},
               %{id: 2, title: "Item 2", inserted_at: ~N[2019-07-16 16:04:15]},
               %{id: 4, title: "Item 4", inserted_at: ~N[2019-07-16 16:06:15]}
             ]
  end

  test "ordered_items_list/2 when item missing" do
    all_items_1 = [
      %{id: 1, title: "Item 1", inserted_at: ~N[2019-07-16 16:03:15]},
      %{id: 2, title: "Item 2", inserted_at: ~N[2019-07-16 16:04:15]},
      %{id: 4, title: "Item 4", inserted_at: ~N[2019-07-16 16:06:15]},
      %{id: 5, title: "Item 5", inserted_at: ~N[2019-07-16 16:07:15]}
    ]

    assert EctoList.ordered_items_list(all_items_1, [5, 3, 1]) ==
             [
               %{id: 5, title: "Item 5", inserted_at: ~N[2019-07-16 16:07:15]},
               %{id: 1, title: "Item 1", inserted_at: ~N[2019-07-16 16:03:15]},
               %{id: 2, title: "Item 2", inserted_at: ~N[2019-07-16 16:04:15]},
               %{id: 4, title: "Item 4", inserted_at: ~N[2019-07-16 16:06:15]}
             ]
  end

  test "complete_items_order/2" do
    assert EctoList.complete_items_order(@all_items, [5, 3, 1]) ==
             [5, 3, 1, 2, 4]
  end

  test "complete_items_order/2 when nil" do
    assert EctoList.complete_items_order(@all_items, nil) ==
             [1, 2, 3, 4, 5]
  end

  test "complete_items_order/2 when items order = []" do
    assert EctoList.complete_items_order(@all_items, []) ==
             [1, 2, 3, 4, 5]
  end

  test "missing_ids_list/1" do
    assert EctoList.missing_ids_list(@all_items) == [1, 2, 3, 4, 5]
  end

  test "missing_ids_list/2" do
    assert EctoList.missing_ids_list(@all_items, [5, 3, 1]) == [2, 4]
  end

  test "missing_ids_list/2 with nil" do
    assert EctoList.missing_ids_list(@all_items, nil) == [1, 2, 3, 4, 5]
  end
end
