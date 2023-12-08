defmodule AdventOfCode2023.Day03GearRatios do
  @moduledoc """
  --- Day 3: Gear Ratios ---

  You and the Elf eventually reach a gondola lift station; he says the gondola lift will take you up to the water source, but this is as far as he can bring you. You go inside.

  It doesn't take long to find the gondolas, but there seems to be a problem: they're not moving.

  "Aaah!"

  You turn around to see a slightly-greasy Elf with a wrench and a look of surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working right now; it'll still be a while before I can fix it." You offer to help.

  The engineer explains that an engine part seems to be missing from the engine, but nobody can figure out which one. If you can add up all the part numbers in the engine schematic, it should be easy to work out which part is missing.

  The engine schematic (your puzzle input) consists of a visual representation of the engine. There are lots of numbers and symbols you don't really understand, but apparently any number adjacent to a symbol, even diagonally, is a "part number" and should be included in your sum. (Periods (.) do not count as a symbol.)

  Here is an example engine schematic:

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

  In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top right) and 58 (middle right). Every other number is adjacent to a symbol and so is a part number; their sum is 4361.

  Of course, the actual engine schematic is much larger. What is the sum of all of the part numbers in the engine schematic?

  --- Part Two ---

  The engineer finds the missing part and installs it in the engine! As the engine springs to life, you jump in the closest gondola, finally ready to ascend to the water source.

  You don't seem to be going very fast, though. Maybe something is still wrong? Fortunately, the gondola has a phone labeled "help", so you pick it up and the engineer answers.

  Before you can explain the situation, she suggests that you look out the window. There stands the engineer, holding a phone in one hand and waving with the other. You're going so slowly that you haven't even left the station. You exit the gondola.

  The missing part wasn't the only issue - one of the gears in the engine is wrong. A gear is any * symbol that is adjacent to exactly two part numbers. Its gear ratio is the result of multiplying those two numbers together.

  This time, you need to find the gear ratio of every gear and add them all up so that the engineer can figure out which gear needs to be replaced.

  Consider the same engine schematic again:

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

  In this schematic, there are two gears. The first is in the top left; it has part numbers 467 and 35, so its gear ratio is 16345. The second gear is in the lower right; its gear ratio is 451490. (The * adjacent to 617 is not a gear because it is only adjacent to one part number.) Adding up all of the gear ratios produces 467835.

  What is the sum of all of the gear ratios in your engine schematic?
  """
  def parse(schematic) do
    schematic
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({[], []}, fn {line, row}, {numbers, symbols} ->
      chars = line |> String.codepoints() |> Enum.with_index()

      {nums, syms} = parse_line(chars, row)

      {numbers ++ nums, symbols ++ syms}
    end)
  end

  def part_numbers(schematic) do
    {numbers, symbols} = parse(schematic)

    symbol_coordinates = for {_, row, col} <- symbols, into: MapSet.new(), do: {row, col}

    Enum.reduce(numbers, [], fn {number, row, col_range}, acc ->
      digit_positions = for col <- col_range, do: {row, col}
      around = Enum.flat_map(digit_positions, &adjacent/1)

      if Enum.any?(around, fn a -> a in symbol_coordinates end) do
        [number | acc]
      else
        acc
      end
    end)
    |> Enum.reverse()
  end

  def gear_ratios(schematic) do
    {numbers, symbols} = parse(schematic)

    gears = for {symbol, row, col} <- symbols, symbol == "*", into: MapSet.new(), do: {row, col}

    gear_numbers =
      Enum.reduce(numbers, %{}, fn {number, row, col_range}, map ->
        digit_positions = for col <- col_range, do: {row, col}
        around = Enum.flat_map(digit_positions, &adjacent/1) |> MapSet.new()

        MapSet.intersection(gears, around)
        |> Enum.reduce(map, fn symbol_coorindate, map ->
          {_, new_map} =
            Map.get_and_update(map, symbol_coorindate, fn
              nil -> {number, [number]}
              nums -> {number, [number | nums]}
            end)

          new_map
        end)
      end)

    Enum.reduce(gear_numbers, MapSet.new(), fn {_symbol, numbers}, acc ->
      if length(numbers) == 2 do
        MapSet.put(acc, Enum.reduce(numbers, &Kernel.*/2))
      else
        acc
      end
    end)
  end

  defp adjacent({row, col}) do
    [
      {row - 1, col},
      {row - 1, col - 1},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col},
      {row + 1, col - 1},
      {row + 1, col + 1}
    ]
  end

  defp parse_line(elements_with_index, row) do
    do_parse_line(elements_with_index, row, [], [])
  end

  defp do_parse_line(elements_with_index, row, numbers, symbols)

  defp do_parse_line([], _row, numbers, symbols) do
    {Enum.reverse(numbers), Enum.reverse(symbols)}
  end

  defp do_parse_line([{".", _} | rest], row, numbers, symbols) do
    do_parse_line(rest, row, numbers, symbols)
  end

  defp do_parse_line(elements, row, numbers, symbols) do
    numeric = for x <- 0..9, into: MapSet.new(), do: to_string(x)

    digits = Enum.take_while(elements, fn {char, _} -> char in numeric end)

    if Enum.any?(digits) do
      number = Enum.map(digits, fn {n, _} -> String.to_integer(n) end) |> Integer.undigits()
      min = elem(hd(digits), 1)
      max = elem(List.last(digits), 1)

      do_parse_line(
        Enum.drop(elements, length(digits)),
        row,
        [{number, row, min..max} | numbers],
        symbols
      )
    else
      symbol = elem(hd(elements), 0)
      column = elem(hd(elements), 1)

      do_parse_line(tl(elements), row, numbers, [{symbol, row, column} | symbols])
    end
  end
end
