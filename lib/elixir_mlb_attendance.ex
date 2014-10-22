defmodule ElixirMlbAttendance do
  
  def break_dataserver do
    DataServer.cause_error
  end

  def total_league_attendance do
    DataServer.get_all_lines
    |>
    get_total_attendance
  end


  def attendance_for(team) do
    DataServer.get_all_lines
    |>
    filter_for_team(team)
    |>
    get_total_attendance
  end


  def attendance_for_all_teams do
    DataServer.get_all_lines
    |>
    get_teams

    # build list of {team, attendance} tuples
    |>
    pmap(&(team_attendance(&1)))
  end

  def team_attendance(team) do
    {team, attendance_for(team)}
  end


  def attendance_by_day_for_team(team) do
    all_records = DataServer.get_all_lines

    get_days(all_records)
    |> 
    pmap(&(team_attendance_for_day(&1, team)))
  end


  def team_attendance_for_day(dow, team) do
      all_records = DataServer.get_all_lines
      day_records = Enum.filter(all_records, &(Enum.at(&1,1) == dow and Enum.at(&1,2) == team))
      day_total = get_total_attendance(day_records) 
      {dow, day_total, (day_total/Enum.count(day_records))}
  end

  defp team_attendance_list(teams) do
    all_attendance = DataServer.get_all_lines
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

  defp get_days(list) do
    _get_days HashSet.new,list
  end

  defp _get_days(acc, []) do 
    Set.to_list(acc)
  end
  defp _get_days(acc, [head | tail]) do
    _get_days(Set.put(acc, Enum.at(head,1)), tail)
  end
  
  defp get_total_attendance(list) do
    Enum.reduce(list, 0, fn(x, acc) -> 
      {attendance, _s} = Integer.parse(Enum.at(x,9))
      attendance + acc end)
  end

  defp filter_for_team(list, team) do
    Enum.filter(list, fn(x) -> Enum.at(x,2) == team end)
  end



  def pmap(collection, fun) do
    me = self

    collection
    |>
    Enum.map(fn (elem) ->
      spawn_link fn -> (send me, {self, fun.(elem) }) end 
    end)
    |>
    Enum.map(fn (pid) ->
      receive do { ^pid, result } -> result end
    end)
  end

end
