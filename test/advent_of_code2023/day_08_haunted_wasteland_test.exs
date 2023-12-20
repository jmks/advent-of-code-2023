defmodule AdventOfCode2023.Day08HauntedWastelandTest do
  use ExUnit.Case, async: true

  import AdventOfCode2023.Day08HauntedWasteland

  @short_example """
  RL

  AAA = (BBB, CCC)
  BBB = (DDD, EEE)
  CCC = (ZZZ, GGG)
  DDD = (DDD, DDD)
  EEE = (EEE, EEE)
  GGG = (GGG, GGG)
  ZZZ = (ZZZ, ZZZ)
  """

  @repeating_example """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  """

  test "parse/1" do
    assert parse(@short_example) ==
             {[:right, :left],
              %{
                "AAA" => {"BBB", "CCC"},
                "BBB" => {"DDD", "EEE"},
                "CCC" => {"ZZZ", "GGG"},
                "DDD" => {"DDD", "DDD"},
                "EEE" => {"EEE", "EEE"},
                "GGG" => {"GGG", "GGG"},
                "ZZZ" => {"ZZZ", "ZZZ"}
              }}
  end

  describe "steps/4" do
    test "following the directions at most once" do
      {directions, map} = parse(@short_example)

      assert steps(directions, map, "AAA", "ZZZ") == [:right, :left]
    end

    test "following the directions multiple times" do
      {directions, map} = parse(@repeating_example)

      assert steps(directions, map, "AAA", "ZZZ") == [:left, :left, :right, :left, :left, :right]
    end
  end
end
