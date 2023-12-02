defmodule AdventOfCode2023.Day01TrebuchetTest do
  use ExUnit.Case, async: true

  import AdventOfCode2023.Day01Trebuchet

  describe "calibration/1" do
    test "example" do
      doc =
        """
        1abc2
        pqr3stu8vwx
        a1b2c3d4e5f
        treb7uchet
        """
        |> String.split("\n", trim: true)

      assert calibration(doc, [:numeric]) == 142
    end

    test "word example" do
      doc  = """
      two1nine
      eightwothree
      abcone2threexyz
      xtwone3four
      4nineeightseven2
      zoneight234
      7pqrstsixteen
      """ |> String.split("\n", trim: true)

      assert calibration(doc) == 281
    end
  end

  describe "parse_integers/1" do
    test "integers as numbers" do
      assert parse_integers("1337", [:numeric]) == [1, 3, 3, 7]
      assert parse_integers("treb7uchet", [:numeric]) == [7]
    end

    test "integers as words" do
      assert parse_integers("two1nine") == [2, 1, 9]
      assert parse_integers("eightwothree") == [8, 2, 3]
      assert parse_integers("abcone2threexyz") == [1, 2, 3]
      assert parse_integers("xtwone3four") == [2, 1, 3, 4]
      assert parse_integers("4nineeightseven2") == [4, 9, 8, 7, 2]
      assert parse_integers("zoneight234") == [1, 8, 2, 3, 4]
      assert parse_integers("7pqrstsixteen") == [7, 6]
    end

    test "overlapping in last word" do
      assert parse_integers("threeight") == [3, 8]
    end
  end
end
