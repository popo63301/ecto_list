defmodule EctoList.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_list,
      version: "0.1.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Hex
      description: "Simple ordered model management with Ecto.",
      package: package(),
      # Docs
      name: "ecto_list",
      source_url: "https://github.com/popo63301/ecto_list",
      docs: [
        main: "readme",
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

  defp package do
    [
      maintainers: ["Sofiane Baddag"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/popo63301/ecto_list"},
      files: ~w(lib LICENSE mix.exs README.md)
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.20.2", only: [:dev, :doc], runtime: false},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false}
    ]
  end
end
