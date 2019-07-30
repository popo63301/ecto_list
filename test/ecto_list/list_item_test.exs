defmodule EctoList.ListItemTest do
  use ExUnit.Case
  doctest EctoList.ListItem

  #  List.insert_at([1, 2, 3, 4], 2, 0)
  # [1, 2, 0, 3, 4]

  # List.insert_at([1, 2, 3], 10, 0)
  # [1, 2, 3, 0]

  # List.insert_at([1, 2, 3], -1, 0)
  # [1, 2, 3, 0]

  # List.insert_at([1, 2, 3], -10, 0)
  # [0, 1, 2, 3]
end
