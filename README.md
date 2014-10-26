ElixirMlbAttendance
===================

## Description

Use the mlb attendance data file to practice with elixir.

## Exercises 

- total league attendance
- team attendance
- team attendance for all teams
  - add parallelization
- team average attendance for each day of the week
- set the DataServer data
  - mostly for unit testing

- use partial-appliction instead of the _Enum.at_ methods to get\_team, get\_attendance, etc.
  - read heading line and build the get\_ methods automatically.
- team road attendance
- team average runs
  - home
  - road
- field names instead of record indices
- attendance per month
  - league
  - for each team
- league interleague average attendance
- league average attendance for each day of the week
- team highest single game attendance
- number of sellouts per team
- pitcher of record
  - home wins
  - road wins
- use the 1st line as a header line, not a data line


## Design Ideas

- server that holds data store
  - with a supervisor
  - supervisor is on separate node

## Notes

example of __currying__. probably correct. 

    get_from_list = fn(list) ->
      fn(ndx) -> 
        Enum.at(list, ndx)
      end
    end

    Usage:
    some_list = [:a, :b, :c]
    get_from_list.(some_list).(0)   # returns :a



example of __partial application__. possibly correct.

    get_first_name = fn(list) -> Enum.at(list, 0) end

    Usage:
    some_list = [:mark, :r, :haskamp]
    get_first_name.(some_list)   # returns :mark

