# Tutorial

The goal of this tutorial is to explain you how to setup Ecto_list.
We will use a basic example to make the process clearer. We will build a simple Serie/Video app.
A Serie is a set of videos.

#TODO

// installation generateur (avec dans video reference de serie et dans serie, liste de id)

// run migration

// installer ecto_list
// dans Serie schmema = mettre default items_order à []
// dans Serie schema et Video schema, mettre les relationships
// dans Series context mettre use EctoList.Context
// dans Series context mettre Repo.preload :videos dans get_video

// Dans Serie Controller, show, dégager liste ordonnées de vidéos
// Dans show template: afficher liste vidéos

// Dans Serie Controller, edit, dégager liste ordonnées de vidéos
// Dans form template: afficher liste vidéos si on est dans edit

// Installer dans assets npm package, draggable
// Créer fichier sortItems et l'importer dans App.JS
