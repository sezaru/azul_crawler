defmodule AzulCrawler.MixProject do
  use Mix.Project

  def project do
    [
      app: :azul_crawler,
      version: "0.1.0",
      elixir: "~> 1.14",
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
      {:wallaby, "~> 0.30.1"},
      {:money, "~> 1.11"},
      {:timex, "~> 3.7.9"},
      {:gen_retry, "~> 1.4.0"},
      {:elixlsx, "~> 0.5.1"},
      {:owl, "~> 0.5.1"}
    ]
  end
end
