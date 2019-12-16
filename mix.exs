defmodule TruffleHog.MixProject do
  use Mix.Project

  def project do
    [
      app: :truffle_hog,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Provides a method to search for matches within a list of documents using TF-IDF.
    """
  end

  defp package do
    [
      name: "truffle_hog",
      maintainers: ["pufe"],
      files: ~w(lib/**/*.ex test/**/*.exs .formatter.exs mix.exs README.md),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/pufe/truffle_hog"},
      source_url: "https://github.com/pufe/truffle_hog"
    ]
  end
end
