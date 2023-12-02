defmodule AdventOfCode2023.Day01TrebuchetTest do
  use ExUnit.Case, async: true

  import AdventOfCode2023.Day01Trebuchet

  describe "calibration/1" do
    test "example" do
      doc = """
      1abc2
      pqr3stu8vwx
      a1b2c3d4e5f
      treb7uchet
      """ |> String.split("\n", trim: true)

      assert calibration(doc) == 142
    end
  end
end
