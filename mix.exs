defmodule Welcome2Game.MixProject do
  use Mix.Project

  def project do
    [
      app: :welcome2_game,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:welcome2_constants, path: '../welcome2_constants'},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false}
    ]
  end
end
