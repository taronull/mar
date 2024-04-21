defmodule Mar.MixProject do
  use Mix.Project

  def project do
    [
      app: :mar,
      version: "0.1.0",
      elixir: "~> 1.16",
      description: "The Web in Elixir",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.0", only: :dev, runtime: false},
      {:bandit, "~> 1.4"},
      {:jason, "~> 1.4"}
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/taronull/mar"}
    ]
  end
end
