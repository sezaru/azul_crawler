defmodule AzulCrawler.XLSX do
  @moduledoc false

  alias Elixlsx.{Sheet, Workbook}

  alias Timex.Duration

  @header [
    ["departure", bold: true],
    ["arrival", bold: true],
    ["connections", bold: true],
    ["time", bold: true],
    ["price", bold: true]
  ]

  @columns_widths %{1 => 20, 2 => 20, 3 => 20, 4 => 20, 5 => 20}

  def create(flights) do
    sheets = Enum.map(flights, &sheet/1)

    %Workbook{sheets: sheets}
  end

  def save(workbook, from, to), do: Elixlsx.write_to(workbook, "#{from}_#{to}.xlsx")

  defp sheet({date, flights}) do
    rows = Enum.map(flights, &row/1)

    Owl.ProgressBar.inc(id: :creating_files)

    %Sheet{
      name: Date.to_string(date),
      rows: [@header | rows],
      col_widths: @columns_widths,
      pane_freeze: {1, 0}
    }
  end

  defp row(%{departure: departure, arrival: arrival, connections: connections, price: price}) do
    flight_time =
      Timex.diff(arrival, departure, :duration) |> Duration.to_time!() |> Time.to_string()

    departure = Timex.to_erl(departure)
    arrival = Timex.to_erl(arrival)
    price = Money.to_string(price)

    [
      [departure, datetime: true],
      [arrival, datetime: true],
      connections,
      [flight_time, num_format: "hh:MM:ss"],
      [price, num_format: "[$R$-416] #,##0.00;[RED]-[$R$-416] #,##0.00"]
    ]
  end
end
