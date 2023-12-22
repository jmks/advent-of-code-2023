defmodule AdventOfCode2023.Day12HotSprings do
  @moduledoc """
  --- Day 12: Hot Springs ---

  You finally reach the hot springs! You can see steam rising from secluded areas attached to the primary, ornate building.

  As you turn to enter, the researcher stops you. "Wait - I thought you were looking for the hot springs, weren't you?" You indicate that this definitely looks like hot springs to you.

  "Oh, sorry, common mistake! This is actually the onsen! The hot springs are next door."

  You look in the direction the researcher is pointing and suddenly notice the massive metal helixes towering overhead. "This way!"

  It only takes you a few more steps to reach the main gate of the massive fenced-off area containing the springs. You go through the gate and into a small administrative building.

  "Hello! What brings you to the hot springs today? Sorry they're not very hot right now; we're having a lava shortage at the moment." You ask about the missing machine parts for Desert Island.

  "Oh, all of Gear Island is currently offline! Nothing is being manufactured at the moment, not until we get more lava to heat our forges. And our springs. The springs aren't very springy unless they're hot!"

  "Say, could you go up and see why the lava stopped flowing? The springs are too cold for normal operation, but we should be able to find one springy enough to launch you up there!"

  There's just one problem - many of the springs have fallen into disrepair, so they're not actually sure which springs would even be safe to use! Worse yet, their condition records of which springs are damaged (your puzzle input) are also damaged! You'll need to help them repair the damaged records.

  In the giant field just outside, the springs are arranged into rows. For each row, the condition records show every spring and whether it is operational (.) or damaged (#). This is the part of the condition records that is itself damaged; for some springs, it is simply unknown (?) whether the spring is operational or damaged.

  However, the engineer that produced the condition records also duplicated some of this information in a different format! After the list of springs for a given row, the size of each contiguous group of damaged springs is listed in the order those groups appear in the row. This list always accounts for every damaged spring, and each number is the entire size of its contiguous group (that is, groups are always separated by at least one operational spring: #### would always be 4, never 2,2).

  So, condition records with no unknown spring conditions might look like this:

  #.#.### 1,1,3
  .#...#....###. 1,1,3
  .#.###.#.###### 1,3,1,6
  ####.#...#... 4,1,1
  #....######..#####. 1,6,5
  .###.##....# 3,2,1

  However, the condition records are partially damaged; some of the springs' conditions are actually unknown (?). For example:

  ???.### 1,1,3
  .??..??...?##. 1,1,3
  ?#?#?#?#?#?#?#? 1,3,1,6
  ????.#...#... 4,1,1
  ????.######..#####. 1,6,5
  ?###???????? 3,2,1

  Equipped with this information, it is your job to figure out how many different arrangements of operational and broken springs fit the given criteria in each row.

  In the first line (???.### 1,1,3), there is exactly one way separate groups of one, one, and three broken springs (in that order) can appear in that row: the first three unknown springs must be broken, then operational, then broken (#.#), making the whole row #.#.###.

  The second line is more interesting: .??..??...?##. 1,1,3 could be a total of four different arrangements. The last ? must always be broken (to satisfy the final contiguous group of three broken springs), and each ?? must hide exactly one of the two broken springs. (Neither ?? could be both broken springs or they would form a single contiguous group of two; if that were true, the numbers afterward would have been 2,3 instead.) Since each ?? can either be #. or .#, there are four possible arrangements of springs.

  The last line is actually consistent with ten different arrangements! Because the first number is 3, the first and second ? must both be . (if either were #, the first number would have to be 4 or higher). However, the remaining run of unknown spring conditions have many different ways they could hold groups of two and one broken springs:

  ?###???????? 3,2,1
  .###.##.#...
  .###.##..#..
  .###.##...#.
  .###.##....#
  .###..##.#..
  .###..##..#.
  .###..##...#
  .###...##.#.
  .###...##..#
  .###....##.#

  In this example, the number of possible arrangements for each row is:

  ???.### 1,1,3 - 1 arrangement
  .??..??...?##. 1,1,3 - 4 arrangements
  ?#?#?#?#?#?#?#? 1,3,1,6 - 1 arrangement
  ????.#...#... 4,1,1 - 1 arrangement
  ????.######..#####. 1,6,5 - 4 arrangements
  ?###???????? 3,2,1 - 10 arrangements
  Adding all of the possible arrangement counts together produces a total of 21 arrangements.

  For each row, count all of the different arrangements of operational and broken springs that meet the given criteria. What is the sum of those counts?
  """
  def parse(condition_records) do
    condition_records
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  def valid_arrangements(conditions, damaged_counts) do
    unknown = Enum.count(conditions, &(&1 == :unknown))

    all_arrangements(unknown)
    |> Enum.map(&(update_conditions(conditions, &1)))
    |> Enum.filter(&valid?(&1, damaged_counts))
  end

  defp parse_row(row) do
    [conditions, damaged_spring_counts] = String.split(row, " ", trim: true, parts: 2)
    parsed_conditions =
      conditions
      |> String.codepoints()
      |> Enum.map(&parse_condition/1)
    counts =
      damaged_spring_counts
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    {parsed_conditions, counts}
  end

  defp parse_condition("."), do: :operational
  defp parse_condition("#"), do: :damaged
  defp parse_condition("?"), do: :unknown

  defp all_arrangements(total) do
    do_all_arrangements([], total)
  end

  defp do_all_arrangements(arrangements, 0), do: Enum.map(arrangements, &Enum.reverse/1)

  defp do_all_arrangements([], count) do
    do_all_arrangements([[:damaged], [:operational]], count - 1)
  end

  defp do_all_arrangements(arrangements, count) do
    new_arrangements =
      Enum.flat_map(arrangements, fn arrangement ->
        [[:damaged | arrangement], [:operational | arrangement]]
      end)

    do_all_arrangements(new_arrangements, count - 1)
  end

  defp update_conditions([], _), do: []

  defp update_conditions([:unknown | rest], [value | values]) do
    [value | update_conditions(rest, values)]
  end

  defp update_conditions([other | rest], arrangement) do
    [other | update_conditions(rest, arrangement)]
  end

  defp valid?(conditions, damaged_counts) do
    groups_of_damaged_springs(conditions) == damaged_counts
  end

  defp groups_of_damaged_springs(conditions) do
    Enum.chunk_while(
      conditions,
      [],
      fn
        :damaged, acc -> {:cont, [:damaged | acc]}
        :operational, acc -> {:cont, acc, []}
      end,
      fn acc -> {:cont, acc, []} end
    )
    |> Enum.filter(&Enum.any?/1)
    |> Enum.map(&Kernel.length/1)
  end
end
