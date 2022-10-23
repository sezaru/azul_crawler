defmodule AzulCrawler.Crawler.Parser do
  @moduledoc false

  def price(string), do: Money.parse!(string, :BRL, separator: ".", delimiter: ",")

  def flight_connections(string) do
    string
    |> String.split(" • ")
    |> List.first()
    |> String.split(" ")
    |> List.first()
    |> String.to_integer()
  end

  def date(string, date) do
    [time, rest] = String.split(string, "\n")

    date =
      case String.split(rest, " • ") do
        [_] ->
          date = Timex.format!(date, "{0D}/{0M}/{YYYY}")

          "#{date} #{time}"

        [_, other_date] ->
          "#{other_date}/#{date.year} #{time}"
      end

    Timex.parse!(date, "{0D}/{0M}/{YYYY} {h24}:{m}")
  end
end
