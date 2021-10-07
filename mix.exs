defmodule Figlet.MixProject do
  use Mix.Project

  @version "0.2.0"
  @source_url "https://github.com/fireproofsocks/figlet"

  def project do
    [
      app: :figlet,
      description: description(),
      version: @version,
      elixir: "~> 1.10",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
        source_ref: "v#{@version}",
        source_url: @source_url,
        logo: "assets/logo.png",
        extras: extras()
      ]
    ]
  end

  def extras do
    [
      "README.md",
      "CHANGELOG.md"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    An Elixir implementation of Figlets: lets you write huge ASCII letters!
    """
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.24.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Everett Griffiths"],
      licenses: ["Apache 2.0"],
      logo: "assets/logo.png",
      links: links(),
      files: [
        "lib",
        "assets/logo.png",
        "mix.exs",
        "README*",
        "CHANGELOG*",
        "LICENSE*",
        "fonts/*"
      ]
    ]
  end

  def links do
    %{
      "GitHub" => @source_url,
      "Readme" => "#{@source_url}/blob/v#{@version}/README.md",
      "Changelog" => "#{@source_url}/blob/v#{@version}/CHANGELOG.md"
    }
  end
end
