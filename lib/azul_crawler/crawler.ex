defmodule AzulCrawler.Crawler do
  @moduledoc false

  alias AzulCrawler.Crawler.{Parser, URL}

  alias Wallaby.Element

  use Wallaby.DSL

  import Wallaby.Query

  require Logger

  @no_results_class "no-results-childs"
  @flights_list_selector ":is(section.card-list, div.#{@no_results_class})"
  @flights_cards_selector "#{@flights_list_selector} > div.flight-card"

  def get_flights(from, to, date) do
    {:ok, session} = Wallaby.start_session()

    url = URL.make(from, to, date)

    session = visit(session, url)

    if check_if_has_access(session) do
      session
      |> wait_flights_to_load()
      |> load_all_available_flights()
      |> get_flights_data(date)
      |> end_session()
    else
      Wallaby.end_session(session)

      Logger.warn("Got access denied, sleeping for one minute!")

      Process.sleep(60_000)

      Logger.warn("Retrying now!")

      get_flights(from, to, date)
    end
  end

  defp check_if_has_access(session) do
    case find(session, css("body > h1", count: nil, minimum: 0)) do
      [element] ->
        Element.text(element) != "Access Denied"
      _ -> true
    end
  end

  defp end_session({session, flights}) do
    Wallaby.end_session(session)

    flights
  end

  defp wait_flights_to_load(session) do
    element = find(session, css(@flights_list_selector, count: 1))

    if Element.attr(element, "class") == @no_results_class do
      {:no_results, session}
    else
      session
    end
  end

  defp load_all_available_flights({:no_results, session}), do: {:no_results, session}

  defp load_all_available_flights(session) do
    case find(session, button("load-more-button", count: nil, minimum: 0)) do
      [] ->
        session

      [button] ->
        Element.click(button)

        load_all_available_flights(session)
    end
  end

  defp get_flights_data({:no_results, session}, _), do: {session, []}

  defp get_flights_data(session, date) do
    flights =
      session
      |> all(css(@flights_cards_selector))
      |> Enum.map(fn element ->
        if not full_flight?(element) do
          %{
            departure: get_departure_date(element, date),
            arrival: get_arrival_date(element, date),
            connections: get_flight_connections(element),
            price: get_price(element)
          }
        end
      end)
      |> Enum.reject(&is_nil/1)

    {session, flights}
  end

  defp full_flight?(parent) do
    element_text = find(parent, css("div.fare-container button", count: 1)) |> Element.text()

    element_text == "Voo esgotado"
  end

  defp get_price(parent),
    do: parent |> find(css("div.fare > h4.current", count: 1)) |> Element.text() |> Parser.price()

  defp get_flight_connections(parent) do
    parent
    |> find(css("p.flight-leg-info", count: 1))
    |> Element.text()
    |> Parser.flight_connections()
  end

  defp get_departure_date(parent, date), do: query_and_parse_date(parent, "h4.departure", date)
  defp get_arrival_date(parent, date), do: query_and_parse_date(parent, "h4.arrival", date)

  defp query_and_parse_date(parent, selector, date),
    do: parent |> find(css(selector, count: 1)) |> Element.text() |> Parser.date(date)
end
