defmodule AdventOfCode2023.Day04ScratchcardsTest do
  use ExUnit.Case, async: true

  import AdventOfCode2023.Day04Scratchcards

  @table """
  Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
  Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
  Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
  Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
  """

  describe "parse/1" do
    test "single game" do
      assert parse("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53") ==
               [{1, [41, 48, 83, 86, 17], [83, 86, 6, 31, 17, 9, 48, 53]}]
    end

    test "a few games" do
      games =
        parse("""
        Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        """)

      assert length(games) == 3
      assert Enum.map(games, &elem(&1, 0)) == [1, 2, 3]
    end
  end

  describe "points/1" do
    test "0 points for no matches" do
      assert points({1, [1], [2]}) == 0
    end

    test "1 point for a single match" do
      assert points({1, [1], [1]}) == 1
    end

    test "2 points for two matches" do
      assert points({1, [1, 2, 3], [1, 2, 4]}) == 2
    end

    test "4 points for three matches" do
      assert points({1, [1, 2, 3, 4], [1, 2, 3, 6]}) == 4
    end

    test "8 points for four matches" do
      assert points({1, [41, 48, 83, 86, 17], [83, 86, 6, 31, 17, 9, 48, 53]}) == 8
    end
  end

  describe "total_points/1" do
    test "example" do
      assert total_points(@table) == 13
    end
  end

  describe "scratchcards/1" do
    test "example" do
      assert scratchcards(@table) == [
               1,
               2,
               4,
               8,
               14,
               1
             ]
    end
  end
end
