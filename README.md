# ecto_list

Ecto_list is a simple library that helps you manage ordered model with Ecto.

![ecto_list](https://user-images.githubusercontent.com/29427340/61579593-79514200-ab07-11e9-8ee6-dac77b949cd2.gif)

## Description

Let's take an example of an ordered model: a Serie which contains an ordered list of videos.

Instead of storing the position of each video in the videos themselves, we will store the ordering in the serie and we will call `EctoList.ordered_items_list/2` to return for us the list of items properly ordered.

## Installation

Read the [tutorial](guides/tutorial.md) to understand the process of installation of the library.

## Functions available

In `EctoList.ListItem`, you have a set of functions to modify the ordering of your order list. The API is inspired by [`acts_as_list`](https://github.com/swanandp/acts_as_list) Ruby gem.

#### Functions That Change Position and Reorder List

- `EctoList.ListItem.insert_at/3`
- `EctoList.ListItem.move_lower/2` will do nothing if the item is the lowest item
- `EctoList.ListItem.move_higher/2` will do nothing if the item is the highest item
- `EctoList.ListItem.move_to_bottom/2`
- `EctoList.ListItem.move_to_top/2`
- `EctoList.ListItem.remove_from_list/2`

#### Methods That Return Data of the Item's List Position

- `EctoList.ListItem.first?/2`
- `EctoList.ListItem.last?/2`
- `EctoList.ListItem.in_list?/2`
- `EctoList.ListItem.not_in_list?/2`
- `EctoList.ListItem.higher_item/2`
- `EctoList.ListItem.higher_items/2` will return all the ids above the given list item id in the order_list
- `EctoList.ListItem.lower_item/2`
- `EctoList.ListItem.lower_items/2` will return all the ids below the given list item id in the order_list

## Demo

See the demo [here](https://github.com/popo63301/ecto_list_demo).

## Documentation

The documentation can be found here: [https://hexdocs.pm/ecto_list](https://hexdocs.pm/ecto_list).

## Contributing

Feel free to open an issue or a PR if you want to add a new feature. 😁
