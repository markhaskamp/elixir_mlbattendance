defmodule ElixirMlbAttendance do

  def total_league_attendance do
    build_data_store

    |>
    Enum.join("\n")

    |> 
    IO.puts
  end


  defp build_data_store do
    slurp("data/2014MlbDailyAttendance.csv")

    |>
    Enum.drop(1)

    |>
    convert_items_to_lists

  end


  def slurp(file) do
    case File.read(file) do
      {:ok, body} -> String.split(body, "\n")
      {:error, reason} -> IO.puts("=== #{reason}")
    end
  end


  defp convert_items_to_lists(list) do
    foo([], list)
  end

  defp foo(acc, [hd | tail]) do
    foo([String.split(hd, ",") | acc], tail)
  end

  defp foo(acc, []) do
    acc
  end


  defp remove_attendance_non_integers(list) do
    Enum.filter(list, fn(x) ->
      case x do
        nil   -> false
        ""    -> false
        "N/A" -> false
        _     -> true
      end
    end)
        
  end
end
