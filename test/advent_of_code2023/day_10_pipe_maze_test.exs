defmodule AdventOfCode2023.Day10PipeMazeTest do
  use ExUnit.Case, async: true

  import AdventOfCode2023.Day10PipeMaze

  @simple """
  |S-7.
  .L-J.
  """

  @square """
  -L|F7
  7S-7|
  L|7||
  -L-J|
  L|-JF
  """

  @complex """
  ..F7.
  .FJ|.
  SJ.L7
  |F--J
  LJ...
  """

  test "parse/1" do
    assert parse(@simple) == [
             [
               {:north_south, {0, 0}},
               {:start, {0, 1}},
               {:east_west, {0, 2}},
               {:south_west, {0, 3}},
               {:ground, {0, 4}}
             ],
             [
               {:ground, {1, 0}},
               {:north_east, {1, 1}},
               {:east_west, {1, 2}},
               {:north_west, {1, 3}},
               {:ground, {1, 4}}
             ]
           ]
  end

  describe "build_graph/1 with simple square" do
    setup do
      {graph, start} = build_graph(parse(@simple))

      [graph: graph, start: start]
    end

    test "start is found", %{start: start} do
      assert start == {0, 1}
    end

    test "all pipe tiles are in the graph", %{graph: graph, start: start} do
      # These may contain vertices that are not on the map
      vertices = MapSet.new(:digraph.vertices(graph))

      assert {0, 0} in vertices
      assert start in vertices
    end

    test "pipe over start is discovered", %{graph: graph, start: start} do
      start_neighbours = :digraph.out_neighbours(graph, start)
      assert {0, 2} in start_neighbours
      assert {1, 1} in start_neighbours

      assert start in :digraph.out_neighbours(graph, {0, 2})
      assert start in :digraph.out_neighbours(graph, {1, 1})
    end

    test "loop (cycle) from start found", %{graph: graph, start: start} do
      loop = MapSet.new(:digraph.get_cycle(graph, start))

      assert loop ==
               MapSet.new([
                 start,
                 {0, 2},
                 {0, 3},
                 {1, 3},
                 {1, 2},
                 {1, 1}
               ])
    end
  end

  describe "build_graph/1 with complex path" do
    setup do
      {graph, start} = build_graph(parse(@complex))

      [graph: graph, start: start]
    end

    test "start is found", %{start: start} do
      assert start == {2, 0}
    end

    test "all pipe tiles are in the graph", %{graph: graph, start: start} do
      # These may contain vertices that are not on the map
      vertices = MapSet.new(:digraph.vertices(graph))

      assert {0, 0} not in vertices
      assert start in vertices
      assert {3, 0} in vertices
      assert {2, 1} in vertices
    end

    test "pipe over start is discovered", %{graph: graph, start: start} do
      start_neighbours = :digraph.out_neighbours(graph, start)
      assert {3, 0} in start_neighbours
      assert {2, 1} in start_neighbours

      assert start in :digraph.out_neighbours(graph, {3, 0})
      assert start in :digraph.out_neighbours(graph, {2, 1})
    end

    test "loop (cycle) from start found", %{graph: graph} do
      # This is one giant loop
      tiles =
        parse(@complex)
        |> List.flatten()
        |> Enum.filter(fn {type, _tile} -> type != :ground end)
        |> Enum.map(fn {_, tile} -> tile end)

      loop =
        :digraph_utils.cyclic_strong_components(graph)
        |> Enum.max_by(&Kernel.length/1)

      assert MapSet.new(tiles) == MapSet.new(loop)
    end
  end

  test "pipe_ends/2" do
    assert pipe_ends({0, 0}, :east_west) == {{0, -1}, {0, 1}}
    assert pipe_ends({0, 0}, :north_south) == {{-1, 0}, {1, 0}}
    assert pipe_ends({0, 0}, :east_south) == {{0, 1}, {1, 0}}
    assert pipe_ends({0, 0}, :north_west) == {{-1, 0}, {0, -1}}
    assert pipe_ends({0, 0}, :south_west) == {{1, 0}, {0, -1}}
    assert pipe_ends({0, 0}, :north_east) == {{-1, 0}, {0, 1}}
  end

  test "walk_loop/1" do
    assert MapSet.new(walk_loop(parse(@square))) ==
             MapSet.new([
               {0, {1, 1}},
               {1, {1, 2}},
               {1, {2, 1}},
               {2, {1, 3}},
               {2, {3, 1}},
               {3, {2, 3}},
               {3, {3, 2}},
               {4, {3, 3}}
             ])

    assert MapSet.new(walk_loop(parse(@complex))) ==
             MapSet.new([
               {0, {2, 0}},
               {1, {3, 0}},
               {2, {4, 0}},
               {3, {4, 1}},
               {4, {3, 1}},
               {5, {3, 2}},
               {6, {3, 3}},
               {7, {3, 4}},
               {8, {2, 4}},
               {1, {2, 1}},
               {2, {1, 1}},
               {3, {1, 2}},
               {4, {0, 2}},
               {5, {0, 3}},
               {6, {1, 3}},
               {7, {2, 3}}
             ])
  end
end
