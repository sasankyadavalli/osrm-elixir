defmodule OSRM.Mixfile do
  use Mix.Project

  def project do
    [app: :osrm,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end


  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  defp description do
    """
    Elixir bindings for OSRM.
    """
  end

  defp package do
    [maintainers: ["Commut", "Aditya Sanka"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/smart-commut/osrm-elixir"}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.11"},
     {:poison, "~> 3.0"},
     # Local dependencies
     {:credo, "~> 0.6", only: [:dev, :test ]},
     {:ex_doc, "~> 0.15", only: [:dev, :test]},]
  end
end
