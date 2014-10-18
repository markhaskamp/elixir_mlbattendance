defmodule ElixirMlbAttendance do

  def total_league_attendance do
    slurp("data/2014MlbDailyAttendance.csv")

    |>
    Enum.drop(1)

    |>
    Enum.filter(fn(x) ->
      items = String.split(x, ",")
      Enum.at(items, 9) != "N/A" and Enum.at(items, 9) != "" and Enum.at(items, 9) != nil
    end)

#    |>
#    Enum.each(fn(x) ->
#      items = String.split(x, ",")
#      IO.puts Enum.at(items, 9)
#    end)

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


  def slurp(file) do
    case File.read(file) do
      {:ok, body} -> String.split(body, "\n")
      {:error, reason} -> IO.puts("=== #{reason}")
    end
  end


  def foo(file_lines) do
    IO.puts Enum.count(file_lines)
  end

end
