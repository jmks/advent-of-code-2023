defmodule AdventOfCode2023.Day10PipeMaze do
  @moduledoc """
  --- Day 10: Pipe Maze ---

  You use the hang glider to ride the hot air from Desert Island all the way up to the floating metal island. This island is surprisingly cold and there definitely aren't any thermals to glide on, so you leave your hang glider behind.

  You wander around for a while, but you don't find any people or animals. However, you do occasionally find signposts labeled "Hot Springs" pointing in a seemingly consistent direction; maybe you can find someone at the hot springs and ask them where the desert-machine parts are made.

  The landscape here is alien; even the flowers and trees are made of metal. As you stop to admire some metal grass, you notice something metallic scurry away in your peripheral vision and jump into a big pipe! It didn't look like any animal you've ever seen; if you want a better look, you'll need to get ahead of it.

  Scanning the area, you discover that the entire field you're standing on is densely packed with pipes; it was hard to tell at first because they're the same metallic silver color as the "ground". You make a quick sketch of all of the surface pipes you can see (your puzzle input).

  The pipes are arranged in a two-dimensional grid of pipe_ends:

  | is a vertical pipe connecting north and south.
  - is a horizontal pipe connecting east and west.
  L is a 90-degree bend connecting north and east.
  J is a 90-degree bend connecting north and west.
  7 is a 90-degree bend connecting south and west.
  F is a 90-degree bend connecting south and east.
  . is ground; there is no pipe in this tile.
  S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
  Based on the acoustics of the animal's scurrying, you're confident the pipe that contains the animal is one large, continuous loop.

  For example, here is a square loop of pipe:

  .....
  .F-7.
  .|.|.
  .L-J.
  .....
  If the animal had entered this loop in the northwest corner, the sketch would instead look like this:

  .....
  .S-7.
  .|.|.
  .L-J.
  .....
  In the above diagram, the S tile is still a 90-degree F bend: you can tell because of how the adjacent pipes connect to it.

  Unfortunately, there are also many pipes that aren't connected to the loop! This sketch shows the same loop as above:

  -L|F7
  7S-7|
  L|7||
  -L-J|
  L|-JF
  In the above diagram, you can still figure out which pipes form the main loop: they're the ones connected to S, pipes those pipes connect to, pipes those pipes connect to, and so on. Every pipe in the main loop connects to its two neighbors (including S, which will have exactly two pipes connecting to it, and which is assumed to connect back to those two pipes).

  Here is a sketch that contains a slightly more complex main loop:

  ..F7.
  .FJ|.
  SJ.L7
  |F--J
  LJ...
  Here's the same example sketch with the extra, non-main-loop pipe pipe_ends also shown:

  7-F7-
  .FJ|7
  SJLL7
  |F--J
  LJ.LJ
  If you want to get out ahead of the animal, you should find the tile in the loop that is farthest from the starting position. Because the animal is in the pipe, it doesn't make sense to measure this by direct distance. Instead, you need to find the tile that would take the longest number of steps along the loop to reach from the starting point - regardless of which way around the loop the animal went.

  In the first example with the square loop:

  .....
  .S-7.
  .|.|.
  .L-J.
  .....
  You can count the distance each tile in the loop is from the starting point like this:

  .....
  .012.
  .1.3.
  .234.
  .....
  In this example, the farthest point from the start is 4 steps away.

  Here's the more complex loop again:

  ..F7.
  .FJ|.
  SJ.L7
  |F--J
  LJ...
  Here are the distances for each tile on that loop:

  ..45.
  .236.
  01.78
  14567
  23...

  Find the single giant loop starting at S. How many steps along the loop does it take to get from the starting position to the point farthest from the starting position?
  """
  def parse(map) do
    map
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {line, row} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn
        {".", col} -> {:ground, {row, col}}
        {"-", col} -> {:east_west, {row, col}}
        {"|", col} -> {:north_south, {row, col}}
        {"F", col} -> {:east_south, {row, col}}
        {"J", col} -> {:north_west, {row, col}}
        {"7", col} -> {:south_west, {row, col}}
        {"L", col} -> {:north_east, {row, col}}
        {"S", col} -> {:start, {row, col}}
      end)
    end)
  end

  def walk_loop(map) do
    {graph, start} = build_graph(map)

    loop_pipe_ends =
      graph
      |> :digraph_utils.cyclic_strong_components()
      |> Enum.filter(&(start in &1))
      |> hd()
      |> MapSet.new()

    distances = do_walk_loop([{0, start}], graph, loop_pipe_ends, [], MapSet.new())

    :digraph.delete(graph)

    distances
  end

  def build_graph(map) do
    graph = :digraph.new([:cyclic])

    map
    |> List.flatten()
    |> Enum.filter(fn {type, _tile} -> type not in [:ground, :start] end)
    |> Enum.each(fn {type, tile} ->
      :digraph.add_vertex(graph, tile)

      {dest_1, dest_2} = pipe_ends(tile, type)

      :digraph.add_vertex(graph, dest_1)
      :digraph.add_vertex(graph, dest_2)

      :digraph.add_edge(graph, tile, dest_1)
      :digraph.add_edge(graph, tile, dest_2)
    end)

    [{:start, start}] =
      map
      |> List.flatten()
      |> Enum.filter(fn {type, _tile} -> type == :start end)

    # For start, we do not know the shape under it.
    # I assume there is only one loop that includes start
    :digraph.in_neighbours(graph, start)
    |> Enum.each(fn neighbour ->
      :digraph.add_edge(graph, start, neighbour)
    end)

    {graph, start}
  end

  def pipe_ends({row, col}, direction) do
    case direction do
      :east_west ->
        {{row, col - 1}, {row, col + 1}}

      :north_south ->
        {{row - 1, col}, {row + 1, col}}

      :east_south ->
        {{row, col + 1}, {row + 1, col}}

      :north_west ->
        {{row - 1, col}, {row, col - 1}}

      :south_west ->
        {{row + 1, col}, {row, col - 1}}

      :north_east ->
        {{row - 1, col}, {row, col + 1}}
    end
  end

  defp do_walk_loop([], _graph, _loop_pipe_ends, acc, _visited),
    do: Enum.sort_by(acc, fn {dist, _} -> dist end, :asc)

  defp do_walk_loop([{dist, tile} | rest], graph, loop_pipe_ends, acc, visited) do
    if tile in visited do
      do_walk_loop(rest, graph, loop_pipe_ends, acc, visited)
    else
      neighbours =
        :digraph.out_neighbours(graph, tile)
        |> Enum.filter(&(&1 in loop_pipe_ends))
        |> Enum.map(&{dist + 1, &1})

      do_walk_loop(
        rest ++ neighbours,
        graph,
        loop_pipe_ends,
        [{dist, tile} | acc],
        MapSet.put(visited, tile)
      )
    end
  end
end
