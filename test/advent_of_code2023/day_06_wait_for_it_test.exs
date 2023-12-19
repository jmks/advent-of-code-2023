defmodule AdventOfCode2023.Day06WaitForItTest do
  use ExUnit.Case, async: true

  import AdventOfCode2023.Day06WaitForIt

  @input """
  Time:        34     90     89     86
  Distance:   204   1713   1210   1780
  """

  @example """
  Time:      7  15   30
  Distance:  9  40  200
  """

  test "parse/1" do
    assert parse(@input) == [
             {34, 204},
             {90, 1713},
             {89, 1210},
             {86, 1780}
           ]

    assert parse(@example, :bad_kerning) == [{71530, 940200}]
  end

  describe "plans_upto/1" do
    test "short plans" do
      assert plans_upto(0) == [{0, 0}]
      assert plans_upto(1) == [{0, 0}, {1, 0}]
      assert plans_upto(2) == [{0, 0}, {1, 1}, {2, 0}]
      assert plans_upto(3) == [{0, 0}, {1, 2}, {2, 2}, {3, 0}]
    end

    test "example" do
      assert plans_upto(7) == [{0, 0}, {1, 6}, {2, 10}, {3, 12}, {4, 12}, {5, 10}, {6, 6}, {7, 0}]
    end
  end

  test "count_better_plans/1" do
    assert count_better_plans(7, 9) == 4
    assert count_better_plans(15, 40) == 8
    assert count_better_plans(30, 200) == 9
    assert count_better_plans(71530, 940200)
  end
end
