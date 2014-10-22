defmodule DataServer do

  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_all_lines do
    GenServer.call __MODULE__, :get_prepped_data
  end

  def cause_error do
    GenServer.cast __MODULE__, :cause_error
  end

  def handle_call(:get_prepped_data, _from, []) do
    #IO.puts "i got nothing"
    attendance_list = build_data_store
    {:reply, attendance_list, attendance_list}
  end

  def handle_call(:get_prepped_data, _from, attendance_list) do
    #IO.puts "been there done that"
    {:reply, attendance_list, attendance_list}
  end

  def handle_cast(:cause_error, attendance_list) do
    {:noreply, 42/0}
  end



  def build_data_store do
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

