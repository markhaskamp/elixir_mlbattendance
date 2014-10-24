defmodule ElixirMlbAttendanceTest do
  use ExUnit.Case

  def foo() do
    42
  end

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "foo is 42" do
    assert foo == 42
  end

  test "can define DataServer data" do
    test_data = """
31-Mar,Mon,Reds,NL Central,NL,St. Louis 1 at Cincinnati 0,Wainwright (1-0),Cueto (0-1),Rosenthal (1),43134,,,
2-Apr,Weds,Reds,NL Central,NL,at Cincinnati 1 St. Louis 0,Hoover (1-0),Martinez (0-1),,36189,,,
4-Apr,Fri,Mets,NL East,NL,at NY Mets 4 Cincinnati 3,Mejia (1-0),Leake (0-1),Valverde (1),35845,,,
24-Sep,Weds,Cubs,NL Central,NL,at Chicago Cubs 3 St. Louis 1,Arrieta (10-5),Lackey (3-3),Rondon (27),33292,,,
23-Sep,Tues,Twins,AL Central,AL,at Minnesota 6 Arizona 3,Gibson (13-11),Chafin (0-1),,28902,y,,
"""
    DataServer.set_data(test_data)
    assert ((DataServer.get_all_lines |> Enum.count) == 5)
  end


end
