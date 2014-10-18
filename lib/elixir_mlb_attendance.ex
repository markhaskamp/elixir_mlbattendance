defmodule ElixirMlbAttendance do

  def total_league_attendance do
    build_data_store

    |>
    get_total_attendance
  end


  def attendance_for(team) do
    build_data_store

    |>
    filter_for_team(team)

    |>
    get_total_attendance

  end

  
  defp get_total_attendance(list) do
    Enum.reduce(list, 0, fn(x, acc) -> 
      {attendance, _s} = Integer.parse(Enum.at(x,9))
      attendance + acc end)
  end

  defp filter_for_team(list, team) do
    Enum.filter(list, fn(x) -> Enum.at(x,2) == team end)
  end


  defp build_data_store do
    slurp("data/2014MlbDailyAttendance.csv")

    |>
    Enum.drop(1)

    |>
    convert_items_to_lists

    |>
    remove_attendance_non_integers

  end


  def slurp(file) do
    case File.read(file) do
      {:ok, body} -> String.split(body, "\n")
      {:error, reason} -> IO.puts("=== #{reason}")
    end
  end


  defp convert_items_to_lists(list) do
    lists_accumulator([], list)
  end

  defp lists_accumulator(acc, [hd | tail]) do
    lists_accumulator([String.split(hd, ",") | acc], tail)
  end

  defp lists_accumulator(acc, []) do
    acc
  end


  defp remove_attendance_non_integers(list) do
    Enum.filter(list, fn(x) ->
      case Enum.at(x, 9) do
        nil   -> false
        ""    -> false
        "N/A" -> false
        _     -> true
      end
    end)
        
  end
end
