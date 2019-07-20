# ecto_list

Ecto_list is a simple library that helps you manage ordered model with Ecto.

## Description

Let's take an example of an ordered model: a Serie which contains an ordered list of videos.

Instead of storing the position of each video in the videos themselves, we will store the ordering in the serie and we will call `EctoList.ordered_items_list/2` to return for us the list of items properly ordered.

## Installation

Read the [tutorial](guides/tutorial.md) to understand the process of installation of the library.

## Documentation

The documentation can be found here: [https://hexdocs.pm/ecto_list](https://hexdocs.pm/ecto_list).
