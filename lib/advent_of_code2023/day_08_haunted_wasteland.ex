defmodule AdventOfCode2023.Day08HauntedWasteland do
  @moduledoc """
  --- Day 8: Haunted Wasteland ---

  You're still riding a camel across Desert Island when you spot a sandstorm quickly approaching. When you turn to warn the Elf, she disappears before your eyes! To be fair, she had just finished warning you about ghosts a few minutes ago.

  One of the camel's pouches is labeled "maps" - sure enough, it's full of documents (your puzzle input) about how to navigate the desert. At least, you're pretty sure that's what they are; one of the documents contains a list of left/right instructions, and the rest of the documents seem to describe some kind of network of labeled nodes.

  It seems like you're meant to use the left/right instructions to navigate the network. Perhaps if you have the camel follow the same instructions, you can escape the haunted wasteland!

  After examining the maps for a bit, two nodes stick out: AAA and ZZZ. You feel like AAA is where you are now, and you have to follow the left/right instructions until you reach ZZZ.

  This format defines each node of the network individually. For example:

  RL

  AAA = (BBB, CCC)
  BBB = (DDD, EEE)
  CCC = (ZZZ, GGG)
  DDD = (DDD, DDD)
  EEE = (EEE, EEE)
  GGG = (GGG, GGG)
  ZZZ = (ZZZ, ZZZ)

  Starting with AAA, you need to look up the next element based on the next left/right instruction in your input. In this example, start with AAA and go right (R) by choosing the right element of AAA, CCC. Then, L means to choose the left element of CCC, ZZZ. By following the left/right instructions, you reach ZZZ in 2 steps.


  Of course, you might not find ZZZ right away. If you run out of left/right instructions, repeat the whole sequence of instructions as necessary: RL really means RLRLRLRLRLRLRLRL... and so on. For example, here is a situation that takes 6 steps to reach ZZZ:

  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)

  Starting at AAA, follow the left/right instructions. How many steps are required to reach ZZZ?
  """
  def parse(network) do
    [directions | map] = String.split(network, "\n", trim: true)

    {parse_directions(directions), parse_map(map)}
  end

  def steps(directions, map, start, stop) do
    do_steps(start, directions, map, directions, stop, [])
  end

  defp do_steps(current_node, directions_left, map, directions, destination_node, path)

  defp do_steps(destination, _dirs, _map, _all_dirs, destination, path), do: Enum.reverse(path)

  defp do_steps(current, [], map, dirs, dest, path) do
    do_steps(current, dirs, map, dirs, dest, path)
  end

  defp do_steps(current, [dir | dirs], map, all_dirs, dest, path) do
    next = elem(map[current], if(dir == :left, do: 0, else: 1))

    do_steps(next, dirs, map, all_dirs, dest, [dir | path])
  end

  defp parse_directions(dirs) do
    dirs
    |> String.codepoints()
    |> Enum.map(fn
      "L" -> :left
      "R" -> :right
    end)
  end

  defp parse_map(lines) do
    lines
    |> Enum.map(&Regex.named_captures(~r/(?<source>\w+) = \((?<left>\w+),\s+(?<right>\w+)\)/, &1))
    |> Enum.reduce(%{}, fn entry, acc ->
      Map.put(acc, entry["source"], {entry["left"], entry["right"]})
    end)
  end
end
