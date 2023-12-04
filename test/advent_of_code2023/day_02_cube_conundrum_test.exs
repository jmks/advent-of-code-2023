defmodule AdventOfCode2023.Day02CubeConundrumTest do
  use ExUnit.Case, async: true

  import AdventOfCode2023.Day02CubeConundrum

  @example_games [
    {1, [[blue: 3, red: 4], [red: 1, green: 2, blue: 6], [green: 2]]},
    {2, [[blue: 1, green: 2], [green: 3, blue: 4, red: 1], [green: 1, blue: 1]]},
    {3,
     [
       [green: 8, blue: 6, red: 20],
       [blue: 5, red: 4, green: 13],
       [green: 5, red: 1]
     ]},
    {4,
     [
       [green: 1, red: 3, blue: 6],
       [green: 3, red: 6],
       [green: 3, blue: 15, red: 14]
     ]},
    {5, [[red: 6, blue: 1, green: 3], [blue: 2, red: 1, green: 2]]}
  ]

  describe "parse_game/1" do
    test "examples" do
      examples =
        """
        Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
        """
        |> String.split("\n", trim: true)

      assert Enum.map(examples, &parse_game/1) == @example_games
    end
  end

  describe "possible?/2" do
    test "example" do
      assert Enum.map(@example_games, &possible?(&1, red: 12, green: 13, blue: 14)) == [
               true,
               true,
               false,
               false,
               true
             ]
    end
  end

  describe "min_cubes/1" do
    test "examples" do
      assert Enum.map(@example_games, &min_cubes/1) == [
               [red: 4, green: 2, blue: 6],
               [red: 1, green: 3, blue: 4],
               [red: 20, green: 13, blue: 6],
               [red: 14, green: 3, blue: 15],
               [red: 6, green: 3, blue: 2]
             ]
    end
  end

  describe "power/1" do
    test "examples" do
      minimum_cubes = Enum.map(@example_games, &min_cubes/1)

      assert Enum.map(minimum_cubes, &power/1) == [
        48,
        12,
        1560,
        630,
        36,
      ]
    end
  end
end
