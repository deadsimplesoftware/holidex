defmodule Holidex.MixProject do
  use Mix.Project

  def project do
    [
      app: :holidex,
      version: "0.1.3",
      description: description(),
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      name: "Holidex",
      source_url: "https://github.com/supertables/holidex"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Holidex.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:styler, "~> 0.7", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:stream_data, "~> 1.0", only: :test},
      {:lcov_ex, "~> 0.3", only: [:dev, :test], runtime: false},
      {:doctor, "~> 0.21.0", only: :dev},
      {:benchee, "~> 1.0", only: :dev}
    ]
  end

  defp description do
    "Holidex provides a purely functional API to retrieve public holidays by country. Effortlessly integrate holiday information into your applications."
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/supertables/holidex"}
    ]
  end
end
