defmodule AdventOfCode2023.Day11CosmicExpansionTest do
  use ExUnit.Case, async: true

  import AdventOfCode2023.Day11CosmicExpansion

  @example_image """
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
  """

  test "parse/1" do
    assert parse(@example_image) ==
             {MapSet.new([{0, 3}, {1, 7}, {2, 0}, {4, 6}, {5, 1}, {6, 9}, {8, 7}, {9, 0}, {9, 4}]),
              MapSet.new([3, 7]), MapSet.new([2, 5, 8])}
  end

  test "all_pairs/1" do
    assert all_pairs([]) == []
    assert all_pairs([1, 2]) == [{1, 2}]
    assert all_pairs([1,2,3]) == [{1, 2}, {1, 3}, {2, 3}]
  end

  describe "shortest_path/4" do
    test "with expansion = 2" do
      universe = parse(@example_image)

      assert shortest_path(universe, {5, 1}, {9, 4}) == 9
      assert shortest_path(universe, {0, 3}, {8, 7}) == 15
      assert shortest_path(universe, {2, 0}, {6, 9}) == 17
      assert shortest_path(universe, {9, 0}, {9, 4}) == 5
      assert shortest_path(universe, {1, 1}, {0, 0}) == 2
    end

    test "with expansion = 10" do
      universe = parse(@example_image)

      assert shortest_path(universe, {9, 0}, {9, 4}, 10) == 4 + 9
    end
  end

  test "shortest_paths/2" do
    assert shortest_paths(parse(@example_image)) == 374
    assert shortest_paths(parse(@example_image), 10) == 1030
    assert shortest_paths(parse(@example_image), 100) == 8410
  end
end
