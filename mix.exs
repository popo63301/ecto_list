defmodule EctoList.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_list,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "ecto_list",
      source_url: "https://github.com/popo63301/ecto_list",
      docs: [
        main: "ecto_list",
        extras: ["README.md": [], "guides/tutorial.md": [title: "Tutorial"]]
      ],
      groups_for_extras: [
        Guides: Path.wildcard("guides/*.md")
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.20.2", only: [:dev, :doc]}
    ]
  end
end
