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

  @ghost_example """
  LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)
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

  describe "corporeal_steps/4" do
    test "following the directions at most once" do
      {directions, map} = parse(@short_example)

      assert corporeal_steps(directions, map, "AAA", "ZZZ") == ["AAA", "CCC", "ZZZ"]
    end

    test "following the directions multiple times" do
      {directions, map} = parse(@repeating_example)

      assert corporeal_steps(directions, map, "AAA", "ZZZ") == ["AAA", "BBB", "AAA", "BBB", "AAA", "BBB", "ZZZ"]
    end
  end

  describe "ghost_steps/4" do
    test "following the directions at most once" do
      {directions, map} = parse(@ghost_example)

      assert ghost_steps(directions, map) == 6
    end
  end
end
