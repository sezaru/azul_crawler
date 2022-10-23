defmodule AzulCrawler.Crawler.URL do
  @moduledoc false

  @base_url "https://www.voeazul.com.br/br/pt/home/selecao-voo"

  def make(from, to, date) do
    uri_query =
      %{
        "c[0].ds" => from,
        "c[0].as" => to,
        "c[0].std" => Timex.format!(date, "{0M}/{0D}/{YYYY}"),
        "p[0].c" => 1,
        "p[0].t" => "ADT",
        "cc" => "BRL"
      }
      |> Enum.map(fn {key, value} -> "#{key}=#{value}" end)
      |> Enum.join("&")

    @base_url |> URI.new!() |> URI.append_query(uri_query) |> URI.to_string()
  end
end
