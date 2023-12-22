defmodule AdventOfCode2023.Day12HotSpringsTest do
  use ExUnit.Case, async: true

  import AdventOfCode2023.Day12HotSprings

  describe "parse/1" do
    test "parses complete records" do
      assert parse("#.#.### 1,1,3") == [
               {[:damaged, :operational, :damaged, :operational, :damaged, :damaged, :damaged],
                [1, 1, 3]}
             ]
    end

    test "parses unknowns records" do
      assert parse("""
             ???.### 1,1,3
             .??..??...?##. 1,1,3
             """) == [
               {[:unknown, :unknown, :unknown, :operational, :damaged, :damaged, :damaged],
                [1, 1, 3]},
               {[
                  :operational,
                  :unknown,
                  :unknown,
                  :operational,
                  :operational,
                  :unknown,
                  :unknown,
                  :operational,
                  :operational,
                  :operational,
                  :unknown,
                  :damaged,
                  :damaged,
                  :operational
                ], [1, 1, 3]}
             ]
    end
  end

  test "arrangements/2" do
    assert arrangements("???.### 1,1,3") == 1
    assert arrangements(".??..??...?##. 1,1,3") == 4
  end

  defp arrangements(condition_record) do
    [{conditions, counts}] = parse(condition_record)

    valid_arrangements(conditions, counts) |> length()
  end
end
