defmodule ElixirMlbAttendance do

  def total_league_attendance do
    build_data_store

    |>
    Enum.reduce( 0, fn(x,acc) ->
      items = String.split(x, ",")
      case Integer.parse(Enum.at(items, 9)) do
        {n,""} -> acc + n
        :error -> acc + 0
      end
    end)

    |>
    IO.puts

  end

  defp build_data_store do
    slurp("data/2014MlbDailyAttendance.csv")

    |>
    Enum.drop(1)

    |>
    remove_attendance_non_integers
  end


  def slurp(file) do
    case File.read(file) do
      {:ok, body} -> String.split(body, "\n")
      {:error, reason} -> IO.puts("=== #{reason}")
    end
  end


  defp remove_attendance_non_integers(list) do
    Enum.filter(list, fn(x) ->
      items = String.split(x, ",")
      Enum.at(items, 9) != "N/A" and Enum.at(items, 9) != "" and Enum.at(items, 9) != nil
    end)
  end


end
