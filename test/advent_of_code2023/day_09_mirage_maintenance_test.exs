defmodule AdventOfCode2023.Day09MirageMaintenanceTest do
  use ExUnit.Case, async: true

  import AdventOfCode2023.Day09MirageMaintenance

  @example """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
  """

  test "parse/1" do
    assert parse(@example) == [
             [0, 3, 6, 9, 12, 15],
             [1, 3, 6, 10, 15, 21],
             [10, 13, 16, 21, 30, 45]
           ]

    assert parse("-1 -2 -3") == [[-1, -2, -3]]
  end

  test "predict_next_reading/1" do
    assert predict_next_reading([0, 3, 6, 9, 12, 15]) == 18
    assert predict_next_reading([1, 3, 6, 10, 15, 21]) == 28
    assert predict_next_reading([10, 13, 16, 21, 30, 45]) == 68
  end

  test "pairwise_difference/1" do
    assert pairwise_difference([]) == []
    assert pairwise_difference([1, -3]) == [-4]
    assert pairwise_difference([1, 3, 3, 1]) == [2, 0, -2]
    assert pairwise_difference([0, 3, 6, 9, 12, 15]) == [3, 3, 3, 3, 3]
    assert pairwise_difference([3, 3, 3, 3, 3]) == [0, 0, 0, 0]
  end

  test "extrapolate_previous_reading/1" do
    assert extrapolate_previous_reading([10, 13, 16, 21, 30, 45]) == 5
    assert extrapolate_previous_reading([0, 3, 6, 9, 12, 15]) == -3
    assert extrapolate_previous_reading([1, 3, 6, 10, 15, 21]) == 0
  end
end
