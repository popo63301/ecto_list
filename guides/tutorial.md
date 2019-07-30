# Tutorial

The goal of this tutorial is to explain you how to setup ecto_list.
We will use a basic example to make the process clearer. We will build a simple Serie/Video app, it will be called... **drum roll 🥁** ... Netflix .
A Serie is a set of videos with a certain order.

### 1) Generating the model

We will run the generators for our models: Series and Videos.

mix phx.gen.html Series Serie series title items_order:array:id
mix phx.gen.html Videos Video videos title serie_id:references:series

We will store the videos order inside the serie with the field `:items_order`. In this example, we decide to call it "items_order" but you can change the name as you wish.
Also, we didn't care much about the name of the context so we created a separate context for each model but you could definitely put them together in the same context.

### 2) Run migration

Run the migration with `mix ecto.migrate`.
Add the following lines in the router:

```elixir
resources "/series", SerieController
resources "/videos", VideoController
```

### 3) Change schemas

Add the right relationships to the models. In the Serie schema module `Netflix.Series.Serie`, add a default to items_order:

```diff
defmodule Netflix.Series.Serie do
# ...
+ alias Netflix.Videos.Video

  schema "lists" do
    field :title, :string
-   field :items_order, {:array, :id}
+   field :items_order, {:array, :id}, default: []

+   has_many :videos, Video

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
-    |> cast(attrs, [:title])
-    |> validate_required([:title])
+    |> cast(attrs, [:title, :serie_id])
+    |> validate_required([:title, :serie_id])
  end

end
```

```diff
defmodule Netflix.Videos.Video do
# ...
+ alias Netflix.Series.Serie

  schema "videos" do
    field :title, :string
-   field :serie_id, :id

+   belongs_to :serie, Serie

    timestamps()
  end
# ...
end
```

### 4) Install `ecto_list`

Add `ecto_list` to your list of dependencies in `mix.exs` (you can check the last version on hex.pm).

```elixir
def deps do
  [
    # ...
    {:ecto_list, "~> 0.1.2"}
    # ...
  ]
end
```

### 5) use `EctoList.Context`

You can use the EctoList.Context module to add Context functions to the Serie Context.

```diff
defmodule Netflix.Series do
  @moduledoc """
  The Series context.
  """

  import Ecto.Query, warn: false
  alias Netflix.Repo

  alias Netflix.Series.Serie

+ use EctoList.Context,
+   list: Serie,
+   repo: Repo,
+   list_items_key: :videos,
+   items_order_key: :items_order
```

Options:

- `list`: the schema containing the list of items. Here it is Serie because each Serie can contain a list of Videos.
- `repo`: the Repo module of the app
- `list_items_key`: the key used in the `has_many` relationship to access the list of items
- `items_order_key`: the key used in the field that contains the items order. Here it's `items_order` because that's how we decided to call it.

### 6) Preload videos

Add `Repo.preload/2` to load the videos while fetching for a specific serie.

```diff
- def get_serie!(id), do: Repo.get!(Serie, id)
+ def get_serie!(id), do: Repo.get!(Serie, id) |> Repo.preload(:videos)
```

### 7) Change `show` action (SerieController)

In the show action of the Serie Controller, add a call to `EctoList.ordered_items_list/2` which will return the list of videos ordered according the list of ids set in second position of entries.
The first entry is the list of items set in the `has_many` relationship. The second entry is the list of ids which corresponds to the items order.

```diff
defmodule NetflixWeb.SerieController do
#...
  def show(conn, %{"id" => id}) do
    serie = Series.get_serie!(id)
+   videos = EctoList.ordered_items_list(serie.videos, serie.items_order)

-    render(conn, "show.html", serie: serie)
+    render(conn, "show.html", serie: serie, videos: videos)
  end
#...
end
```

### 8) Change `show` template

In the show template of Serie, add the following lines:

```diff
<h1>Show Serie</h1>

<ul>

  <li>
    <strong>Title:</strong>
    <%= @serie.title %>
  </li>

  <li>
    <strong>Items order:</strong>
    <%= @serie.items_order %>
  </li>

+ <%= for video <- @videos do %>
+   <div>
+     <%= video.title %>
+   </div>
+ <% end %>

</ul>

<span><%= link "Edit", to: Routes.serie_path(@conn, :edit, @serie) %></span>
<span><%= link "Back", to: Routes.serie_path(@conn, :index) %></span>

```

### 9) Change `edit` and `update` action (SerieController)

Back at the Serie controller, add the following lines to the edit and to the update action:

```diff
defmodule NetflixWeb.SerieController do
#...
  def edit(conn, %{"id" => id}) do
    serie = Series.get_serie!(id)
+   videos = EctoList.ordered_items_list(serie.videos, serie.items_order)

    changeset = Series.change_serie(serie)
-   render(conn, "edit.html", serie: serie, changeset: changeset)
+   render(conn, "edit.html", serie: serie, videos: videos, changeset: changeset)
  end

-  def update(conn, %{"id" => id, "serie" => serie_params}) do
+  def update(conn, %{"id" => id, "serie" => serie_params, "items_order" => items_order}) do
    serie = Series.get_serie!(id)
+   serie_params = Map.put(serie_params, "items_order", items_order)

    case Series.update_serie(serie, serie_params) do
      {:ok, serie} ->
        conn
        |> put_flash(:info, "Serie updated successfully.")
        |> redirect(to: Routes.serie_path(conn, :show, serie))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", serie: serie, changeset: changeset)
    end
  end
#...
end
```

### 10) Change form template for `edit` action

Inside the form template of serie, add those changes:

```diff
<%= form_for @changeset, @action, fn f -> %>
  <%= if @changeset.action do %>
    <div class="alert alert-danger">
      <p>Oops, something went wrong! Please check the errors below.</p>
    </div>
  <% end %>

  <%= label f, :title %>
  <%= text_input f, :title %>
  <%= error_tag f, :title %>

- <%= label f, :items_order %>
- <%= multiple_select f, :items_order, ["Option 1": "option1", "Option 2": "option2"] %>
- <%= error_tag f, :items_order %>

+ <%= if @view_template == "edit.html" do %>
+   <div>
+   <%= for video <- @videos do %>
+     <div>
+        <%= hidden_input f, :items_order, name: "items_order[]", value: video.id %>
+       <%= video.id %> - <%= video.title %>
+     </div>
+   <% end %>
+   </div>
+ <% end %>

  <div>
    <%= submit "Save" %>
  </div>
<% end %>

```

We made a simple if condition to add this block of code only if we are in the `edit` action because the form is shared also for the `new` action.

### 11) Create sample data to test

We can add some data so that we can see what we get now.
Inside the iex console, run:

```
Netflix.Series.create_serie(%{title: "Serie 1"})
Netflix.Videos.create_video(%{title: "Video 1", serie_id: 1})
Netflix.Videos.create_video(%{title: "Video 2", serie_id: 1})
Netflix.Videos.create_video(%{title: "Video 3", serie_id: 1})
```

If you go to "/series" and click the first serie, you'll get the list of the 3 videos we created. Now, we will add a drag and drop library so that we can change the order.

### 12) Install Drag&Drop library

For this example, I will use [draggable](https://github.com/Shopify/draggable), a library made by Shopify but you can use whatever drag and drop library.
In the terminal, go to the assets folder and run `npm i @shopify/draggable`.

In `assets/js`, create a file called "ectoListSorting.js" and add this content.

```js
import { Sortable } from "@shopify/draggable";

export default function ectoListSorting() {
  const containerSelector = ".StackedList";
  const containers = document.querySelectorAll(containerSelector);

  new Sortable(containers, {
    draggable: ".StackedListItem",
    mirror: {
      appendTo: containerSelector,
      constrainDimensions: true
    }
  });
}
```

In `assets/js/app.js`, add the following lines:

```diff
// ...
import "phoenix_html";

+ import ectoListSorting from "./ectoListSorting";

+ ectoListSorting();
// ...
```

Now back to the edit form of serie (`templates/serie/form.html.eex`), add the following changes:

```diff
  <%= if @view_template == "edit.html" do %>
-    <div>
+    <div class="StackedList">
    <%= for video <- @videos do %>
-      <div>
+      <div class="StackedListItem">
        <%= hidden_input f, :items_order, name: "items_order[]", value: video.id %>
        <%= video.id %> - <%= video.title %>
      </div>
    <% end %>
    </div>
  <% end %>

  <div>
    <%= submit "Save" %>
  </div>
```

Now, you can drag and drop the videos of a serie and save the modified order.

## Conclusion

There is still a lot of code copy pasting but it's worth it because you have the control of your code.
This library is pretty basic. The most important function is `EctoList.ordered_items_list/2` that render the list of items in the appropriate order.
