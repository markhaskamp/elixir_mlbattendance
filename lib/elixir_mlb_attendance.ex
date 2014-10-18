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


  def attendance_for_all_teams do
    build_data_store
    |>
    get_teams

    # build list of {team, attendance} tuples
    |>
    team_attendance_list

    
  end

  defp team_attendance_list(teams) do
    all_attendance = build_data_store
    _team_attendance_list([], teams, all_attendance)
  end

  defp _team_attendance_list(acc, [], _all) do
    acc
  end
  defp _team_attendance_list(acc, [head | tail], all) do
    team_list = filter_for_team(all, head)
    team_attendance = get_total_attendance team_list
    _team_attendance_list([{head, team_attendance} | acc], tail, all)
  end

  defp get_teams(list) do
    _get_teams HashSet.new,list
  end

  defp _get_teams(acc, []) do 
    Set.to_list(acc)
  end
  defp _get_teams(acc, [head | tail]) do
    _get_teams(Set.put(acc, Enum.at(head,2)), tail)
  end

  
  defp get_total_attendance(list) do
    Enum.reduce(list, 0, fn(x, acc) -> 
      {attendance, _s} = Integer.parse(Enum.at(x,9))
      attendance + acc end)
  end

  defp filter_for_team(list, team) do
    Enum.filter(list, fn(x) -> Enum.at(x,2) == team end)
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
