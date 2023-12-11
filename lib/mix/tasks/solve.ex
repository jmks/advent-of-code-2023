defmodule Mix.Tasks.Solve do
  def run([day, part]) do
    day = String.to_integer(day)
    part = String.to_integer(part)

    result = solve(day, part)

    IO.puts("Day #{day}, part #{part}: #{result}")
  end

  defp solve(day, part)

  defp solve(2, 1) do
    import AdventOfCode2023.Day02CubeConundrum

    Input.strings(2)
    |> Enum.map(&parse_game/1)
    |> Enum.filter(&possible?(&1, red: 12, green: 13, blue: 14))
    |> Enum.map(fn {game_id, _sets} -> game_id end)
    |> Enum.sum()
  end

  defp solve(2, 2) do
    import AdventOfCode2023.Day02CubeConundrum

    Input.strings(2)
    |> Enum.map(&parse_game/1)
    |> Enum.map(&min_cubes/1)
    |> Enum.map(&power/1)
    |> Enum.sum()
  end

  defp solve(3, 1) do
    import AdventOfCode2023.Day03GearRatios

    Input.raw(3)
    |> part_numbers()
    |> Enum.sum()
  end

  defp solve(3, 2) do
    import AdventOfCode2023.Day03GearRatios

    Input.raw(3)
    |> gear_ratios()
    |> Enum.sum()
  end

  defp solve(4, 1) do
    import AdventOfCode2023.Day04Scratchcards

    Input.raw(4)
    |> total_points()
  end

  defp solve(4, 2) do
    import AdventOfCode2023.Day04Scratchcards

    Input.raw(4)
    |> scratchcards()
    |> Enum.sum()
  end

  defp solve(5, 1) do
    import AdventOfCode2023.Day05IfYouGiveSeedFertilizer

    Input.raw(5)
    |> lowest_location()
  end

  defp solve(6, 1) do
    import AdventOfCode2023.Day06WaitForIt

    Input.raw(6)
    |> parse()
    |> Enum.map(fn {ms, distance} -> count_better_plans(ms, distance) end)
    |> Enum.reduce(&Kernel.*/2)
  end

  defp solve(6, 2) do
    import AdventOfCode2023.Day06WaitForIt

    Input.raw(6)
    |> parse(:bad_kerning)
    |> Enum.map(fn {ms, distance} -> count_better_plans(ms, distance) end)
    |> Enum.reduce(&Kernel.*/2)
  end

  defp solve(7, 1) do
    import AdventOfCode2023.Day07CamelCards

    Input.raw(7)
    |> total_winnings()
  end

  defp solve(7, 2) do
    import AdventOfCode2023.Day07CamelCards

    Input.raw(7)
    |> total_winnings(:jacks_wild)
  end
end
