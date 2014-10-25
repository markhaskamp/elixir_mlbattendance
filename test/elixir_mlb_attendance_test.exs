defmodule ElixirMlbAttendanceTest do
  use ExUnit.Case

  setup do
    # Cards  at Reds,   1000
    # Cards  at Reds,   2000
    # Reds   at Mets,   4000
    # Cards  at Cubs,   8000
    # DBacks at Twins, 16000  (interleague)
    test_data = """
31-Mar,Mon,Reds,NL Central,NL,St. Louis 1 at Cincinnati 0,Wainwright (1-0),Cueto (0-1),Rosenthal (1),1000,,,
2-Apr,Weds,Reds,NL Central,NL,at Cincinnati 1 St. Louis 0,Hoover (1-0),Martinez (0-1),,2000,,,
4-Apr,Fri,Mets,NL East,NL,at NY Mets 4 Cincinnati 3,Mejia (1-0),Leake (0-1),Valverde (1),4000,,,
24-Sep,Weds,Cubs,NL Central,NL,at Chicago Cubs 3 St. Louis 1,Arrieta (10-5),Lackey (3-3),Rondon (27),8000,,,
23-Sep,Tues,Twins,AL Central,AL,at Minnesota 6 Arizona 3,Gibson (13-11),Chafin (0-1),,16000,y,,
"""
    DataServer.set_data(test_data)
  end

  test "can define DataServer data" do
    assert ((DataServer.get_all_lines |> Enum.count) == 5)
  end

  test "can sum total attendance for league" do
    assert ElixirMlbAttendance.total_league_attendance == 31000
  end

  test "can get attendance for one team" do
    assert ElixirMlbAttendance.attendance_for("Reds") == 3000
    assert ElixirMlbAttendance.attendance_for("Twins") == 16000
  end

  test "can get attendance for all teams" do
    team_list = ElixirMlbAttendance.attendance_for_all_teams
    assert Enum.count(team_list) == 4
  end

  test "can get road attendance for one team" do
    assert ElixirMlbAttendance.road_attendance_for("Cardinals") == 11000
    assert ElixirMlbAttendance.road_attendance_for("Reds") == 4000
  end

end
