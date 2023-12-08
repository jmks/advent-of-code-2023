defmodule AdventOfCode2023.Day03GearRatiosTest do
  use ExUnit.Case, async: true

  import AdventOfCode2023.Day03GearRatios

  @schematic """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """

  describe "parse/1" do
    test "line" do
      assert parse("467..114..") == {[{467, 0, 0..2}, {114, 0, 5..7}], []}
    end

    test "symbols" do
      assert parse("...$.*....") == {[], [{"$", 0, 3}, {"*", 0, 5}]}
    end

    test "example" do
      assert parse(@schematic) == {
               [
                 {467, 0, 0..2},
                 {114, 0, 5..7},
                 {35, 2, 2..3},
                 {633, 2, 6..8},
                 {617, 4, 0..2},
                 {58, 5, 7..8},
                 {592, 6, 2..4},
                 {755, 7, 6..8},
                 {664, 9, 1..3},
                 {598, 9, 5..7}
               ],
               [{"*", 1, 3}, {"#", 3, 6}, {"*", 4, 3}, {"+", 5, 5}, {"$", 8, 3}, {"*", 8, 5}]
             }
    end
  end

  describe "part_numbers/1" do
    test "example" do
      assert part_numbers(@schematic) == [
               467,
               35,
               633,
               617,
               592,
               755,
               664,
               598
             ]

      assert Enum.sum(part_numbers(@schematic)) == 4_361
    end
  end

  describe "gear_ratios/1" do
    test "gears are *" do
      assert gear_ratios(String.replace(@schematic, "*", "?")) == MapSet.new()
    end

    test "gears are adjacent to exactly two numbers" do
      assert gear_ratios("*123") == MapSet.new()

      assert gear_ratios("123*345") == MapSet.new([123 * 345])

      assert gear_ratios("""
             123*456
             ..789..
             """) == MapSet.new()

      assert gear_ratios("""
             12*34
             56.78
             """) == MapSet.new()

      assert gear_ratios("""
      123
      4*5
      678
      """) == MapSet.new()
    end

    test "example" do
      expected = MapSet.new([16_345, 451_490])

      assert gear_ratios(@schematic) == expected
      assert Enum.sum(gear_ratios(@schematic)) == 467_835
    end
  end
end
