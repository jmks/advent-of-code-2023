defmodule AdventOfCode2023.Day11CosmicExpansion do
  @moduledoc """
  --- Day 11: Cosmic Expansion ---

  You continue following signs for "Hot Springs" and eventually come across an observatory. The Elf within turns out to be a researcher studying cosmic expansion using the giant telescope here.

  He doesn't know anything about the missing machine parts; he's only visiting for this research project. However, he confirms that the hot springs are the next-closest area likely to have people; he'll even take you straight there once he's done with today's observation analysis.

  Maybe you can help him with the analysis to speed things up?

  The researcher has collected a bunch of data and compiled the data into a single giant image (your puzzle input). The image includes empty space (.) and galaxies (#). For example:

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

  The researcher is trying to figure out the sum of the lengths of the shortest path between every pair of galaxies. However, there's a catch: the universe expanded in the time it took the light from those galaxies to reach the observatory.

  Due to something involving gravitational effects, only some space expands. In fact, the result is that any rows or columns that contain no galaxies should all actually be twice as big.

  In the above example, three columns and two rows contain no galaxies:

     v  v  v
   ...#......
   .......#..
   #.........
  >..........<
   ......#...
   .#........
   .........#
  >..........<
   .......#..
   #...#.....
     ^  ^  ^
  These rows and columns need to be twice as big; the result of cosmic expansion therefore looks like this:

  ....#........
  .........#...
  #............
  .............
  .............
  ........#....
  .#...........
  ............#
  .............
  .............
  .........#...
  #....#.......
  Equipped with this expanded universe, the shortest path between every pair of galaxies can be found. It can help to assign every galaxy a unique number:

  ....1........
  .........2...
  3............
  .............
  .............
  ........4....
  .5...........
  ............6
  .............
  .............
  .........7...
  8....9.......

  In these 9 galaxies, there are 36 pairs. Only count each pair once; order within the pair doesn't matter. For each pair, find any shortest path between the two galaxies using only steps that move up, down, left, or right exactly one . or # at a time. (The shortest path between two galaxies is allowed to pass through another galaxy.)

  For example, here is one of the shortest paths between galaxies 5 and 9:

  ....1........
  .........2...
  3............
  .............
  .............
  ........4....
  .5...........
  .##.........6
  ..##.........
  ...##........
  ....##...7...
  8....9.......

  This path has length 9 because it takes a minimum of nine steps to get from galaxy 5 to galaxy 9 (the eight locations marked # plus the step onto galaxy 9 itself). Here are some other example shortest path lengths:

  Between galaxy 1 and galaxy 7: 15
  Between galaxy 3 and galaxy 6: 17
  Between galaxy 8 and galaxy 9: 5

  In this example, after expanding the universe, the sum of the shortest path between all 36 pairs of galaxies is 374.

  Expand the universe, then find the length of the shortest path between every pair of galaxies. What is the sum of these lengths?

  --- Part Two ---

  The galaxies are much older (and thus much farther apart) than the researcher initially estimated.

  Now, instead of the expansion you did before, make each empty row or column one million times larger. That is, each empty row should be replaced with 1000000 empty rows, and each empty column should be replaced with 1000000 empty columns.

  (In the example above, if each empty row or column were merely 10 times larger, the sum of the shortest paths between every pair of galaxies would be 1030. If each empty row or column were merely 100 times larger, the sum of the shortest paths between every pair of galaxies would be 8410. However, your universe will need to expand far beyond these values.)

  Starting with the same initial image, expand the universe according to these new rules, then find the length of the shortest path between every pair of galaxies. What is the sum of these lengths?
  """
  def parse(image) do
    parsed =
      image
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, row} ->
        line
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.map(fn
          {".", col} -> {:empty, {row, col}}
          {"#", col} -> {:galaxy, {row, col}}
        end)
      end)

    galaxies =
      parsed
      |> Enum.filter(fn {type, _coordinate} -> type == :galaxy end)
      |> Enum.map(fn {_type, coordinate} -> coordinate end)

    empty_rows = empty_slices(parsed, fn {_type, {row, _col}} -> row end)
    empty_cols = empty_slices(parsed, fn {_type, {_row, col}} -> col end)

    {MapSet.new(galaxies), MapSet.new(empty_rows), MapSet.new(empty_cols)}
  end

  def shortest_path({_galaxies, empty_rows, empty_cols}, {r1, c1}, {r2, c2}, expansion \\ 2) do
    row_dist = abs(r2 - r1)
    col_dist = abs(c2 - c1)

    row_expansion = crosses_expansion(empty_rows, fn row -> row in r1..r2 end, expansion)
    col_expansion = crosses_expansion(empty_cols, fn col -> col in c1..c2 end, expansion)

    row_dist + row_expansion + col_dist + col_expansion
  end

  def all_pairs(things) do
    for {x, index} <- Enum.with_index(things) do
      for y <- Enum.drop(things, index + 1) do
        {x, y}
      end
    end
    |> List.flatten()
  end

  def shortest_paths({galaxies, _, _} = universe, expansion \\ 2) do
    galaxies
    |> all_pairs()
    |> Enum.map(fn {x, y} -> shortest_path(universe, x, y, expansion) end)
    |> Enum.sum()
  end

  defp crosses_expansion(targets, cross_fun, expansion) do
    targets
    |> Enum.filter(cross_fun)
    |> length()
    |> then(fn expanses ->
      expanses * expansion - expanses
    end)
  end

  defp empty_slices(coordinates, map_fun) do
    coordinates
    |> Enum.group_by(map_fun, fn {type, _c} -> type end)
    |> Enum.filter(fn {_mapped, types} -> Enum.all?(types, &(&1 == :empty)) end)
    |> Enum.map(fn {mapped, _types} -> mapped end)
  end
end
