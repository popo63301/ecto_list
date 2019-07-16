defmodule EctoList.Context do
  defmacro __using__(opts) do
    list_items_key = Keyword.get(opts, :list_items_key)
    items_order_key = Keyword.get(opts, :items_order_key)

    quote do
      alias unquote(Keyword.get(opts, :list)), as: List
      alias unquote(Keyword.get(opts, :repo)), as: Repo

      @list_items_key unquote(list_items_key)
      @items_order_key unquote(items_order_key)

      def sync_order_list(%List{} = list) do
        items = Map.get(list, @list_items_key)
        items_order = Map.get(list, @items_order_key)
        new_order = EctoList.complete_items_order(items, items_order)

        attrs = Map.put(%{}, @items_order_key, new_order)

        list
        |> List.changeset(attrs)
        |> Repo.update()
      end

      def reset_order_list(%List{} = list) do
        items = Map.get(list, @list_items_key)
        new_order = EctoList.missing_ids_list(items)

        attrs = Map.put(%{}, @items_order_key, new_order)

        list
        |> List.changeset(attrs)
        |> Repo.update()
      end
    end
  end
end
