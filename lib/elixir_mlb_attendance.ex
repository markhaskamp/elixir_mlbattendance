defmodule ElixirMlbAttendance do

  def read_file do
    slurp("data/2014MlbDailyAttendance.csv")
    |>
    foo
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
