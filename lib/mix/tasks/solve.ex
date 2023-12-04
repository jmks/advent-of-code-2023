defmodule Mix.Tasks.Solve do
  def run([day, part]) do
    day = String.to_integer(day)
    part = String.to_integer(part)

    result = solve(day, part)

    IO.puts("Day #{day}, part #{part}: #{result}")
  end

  defp solve(2, 1) do
    import AdventOfCode2023.Day02CubeConundrum

    Input.strings(2)
    |> Enum.map(&parse_game/1)
    |> Enum.filter(&possible?(&1, [red: 12, green: 13, blue: 14]))
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
end
