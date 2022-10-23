defmodule AzulCrawler do
  @moduledoc false

  alias AzulCrawler.{Crawler, XLSX}

  @processes 2

  def run(from, to, start_date, end_date, round_trip?) do
    Logger.configure_backend(:console, device: Owl.LiveScreen)

    date_range = Date.range(start_date, end_date)

    do_run(from, to, date_range)

    if round_trip? do
      do_run(to, from, date_range)
    end

    Owl.LiveScreen.await_render()
  end

  defp do_run(from, to, date_range) do
    Owl.ProgressBar.start(
      id: :fetching_flights,
      label: "Fetching flights for #{from} -> #{to} ",
      total: Enum.count(date_range)
    )

    flights =
      date_range
      |> Enum.chunk_every(@processes)
      |> Enum.flat_map(fn chunk ->
        chunk
        |> Enum.map(fn date -> Task.async(fn -> get_flight(from, to, date) end) end)
        |> Task.await_many(:infinity)
      end)

    Owl.ProgressBar.start(
      id: :creating_files,
      label: "Creating xlsx files ",
      total: Enum.count(flights)
    )

    flights |> XLSX.create() |> XLSX.save(from, to)
  end

  defp get_flight(from, to, date) do
    flights =
      GenRetry.Task.async(fn -> Crawler.get_flights(from, to, date) end,
        retries: 10,
        delay: :timer.seconds(20)
      )
      |> Task.await(:infinity)

    Owl.ProgressBar.inc(id: :fetching_flights)

    {date, flights}
  end
end
