defmodule Mix.Tasks.Flights do
  @moduledoc "Fetch all available flights data from a date range"
  @shortdoc "Fetch all available flights data from a date range"

  alias Owl.IO

  use Mix.Task

  def run(_) do
    Application.ensure_all_started(:owl)
    Application.ensure_all_started(:wallaby)

    from =
      IO.input(
        label: "Type the departure airport code (default: FLN):",
        optional: true,
        cast: &maybe_default(&1, "FLN")
      )

    to =
      IO.input(
        label: "Type the arrival airport code (default: URG):",
        optional: true,
        cast: &maybe_default(&1, "URG")
      )

    today = Date.utc_today()

    start_date =
      IO.input(
        label:
          "Type the start departure date in ISO 8601 format (YYYY-MM-DD) (default: #{today}):",
        optional: true,
        cast: &maybe_parse_date(&1, today)
      )

    end_date =
      IO.input(
        label: "Type the end departure date in ISO 8601 format (YYYY-MM-DD) (default: #{start_date}):",
        optional: true,
        cast: &maybe_parse_date(&1, start_date)
      )

    round_trip? = IO.confirm(message: "Is this a round-trip flight?")

    AzulCrawler.run(from, to, start_date, end_date, round_trip?)
  end

  defp maybe_default(nil, default_value), do: {:ok, default_value}
  defp maybe_default(value, _), do: {:ok, value}

  defp maybe_parse_date(nil, start_date), do: {:ok, start_date}
  defp maybe_parse_date(date, _), do: Date.from_iso8601(date)
end
