# Tutorial

The goal of this tutorial is to explain you how to setup Ecto*list.
We will use a basic example to make the process clearer. We will build a simple Serie/Video app, it will be called... \_drum roll 🥁* ... Netflix .
A Serie is a set of videos with a certain order.

#TODO

## Generating the model

//✅ installation generateur (avec dans video reference de serie et dans serie, liste de id)
We will run the generators for our models: Series and Videos.

mix phx.gen.html Series Serie series title items_order:array:id
mix phx.gen.html Videos Video videos title serie_id:references:series

We will store the videos order inside the serie with the field `:items_order`. In this example, we decide to call it "items_order" but you can change the name as you wish.
Also, we didn't care much about the name of the context so we created a separate context for each model but you could definitely put them together in the same context.

//✅ run migration
Run the migration with `mix ecto.migrate`.
Add the following lines in the router:

```elixir
resources "/series", SerieController
resources "/videos", VideoController
```

//✅ dans Serie schmema = mettre default items_order à []
In the Serie schema module `Netflix.Series.Serie`, add a default to items_order:

```diff
defmodule Netflix.Series.Serie do
# ...
  schema "series" do
-   field :items_order, {:array, :id}
+   field :items_order, {:array, :id}, default: []
    field :title, :string

    timestamps()
  end
# ...
end
```

//✅ dans Serie schema et Video schema, mettre les relationships
Add the right relationships to the models

```diff
defmodule Netflix.Series.Serie do
# ...
+ alias Netflix.Videos.Video

  schema "lists" do
    field :title, :string
    field :items_order, {:array, :id}, default: []

+   has_many :videos, Video

    timestamps()
  end
# ...
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

//✅ installer ecto_list
Add `ecto_list` to your list of dependencies in `mix.exs` (you can check the last version on hex.pm).

```elixir
def deps do
  [
    # ...
    {:ecto_list, "~> 0.1.0"}
    # ...
  ]
end
```

//✅ dans Series context mettre use EctoList.Context
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

- list: the schema containing the list of items. Here it is Serie because each Serie can contain a list of Videos.
- repo: the Repo module of the app
- list_items_key: the key used in the `has_many` relationship to access the list of items
- items_order_key: the key used in the field that contains the items order. Here it's `items_order` because that's how we decided to call it.

//✅ dans Series context mettre Repo.preload :videos dans get_video

Add `Repo.preload/2` to load the videos while fetching for a specific serie.

```diff
- def get_serie!(id), do: Repo.get!(Serie, id)
+ def get_serie!(id), do: Repo.get!(Serie, id) |> Repo.preload(:videos)
```

//✅ Dans Serie Controller, show, dégager liste ordonnées de vidéos
In the show action of the Serie Controlle, add a call to `EctoList.ordered_items_list/2` which will return the list of videos ordered according the list of ids set in second position of entries.
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

//✅ Dans show template: afficher liste vidéos
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

//✅ Dans Serie Controller, edit, dégager liste ordonnées de vidéos
Back at the Serie controller, add the following lines to the edit action:

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
#...
end
```

// Dans form template: afficher liste vidéos si on est dans edit

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

// Installer dans assets npm package, draggable
// Créer fichier sortItems et l'importer dans App.JS

// Conclusion
