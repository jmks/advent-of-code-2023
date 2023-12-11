defmodule AdventOfCode2023.Day05IfYouGiveSeedFertilizerTest do
  use ExUnit.Case, async: true

  import AdventOfCode2023.Day05IfYouGiveSeedFertilizer

  @example """
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
  """

  describe "parse/1" do
    test "extracts seeds" do
      assert parse("seeds: 123 456") == {[123, 456], []}
    end

    test "extracts seed to soil map" do
      assert parse("""
             seeds: 79 14 55 13

             seed-to-soil map:
             50 98 2
             52 50 48
             """) == {[79, 14, 55, 13], [["seed-to-soil", [50, 98, 2], [52, 50, 48]]]}
    end

    test "chunking" do
      lines = ["", "a1", "a2", "a3", "", "b1", "b2", "", "c1"]

      chunks = split_maps(lines)

      assert chunks == [["a1", "a2", "a3"], ["b1", "b2"], ["c1"]]
    end

    test "example" do
      assert parse(@example) ==
               {[79, 14, 55, 13],
                [
                  ["seed-to-soil", [50, 98, 2], [52, 50, 48]],
                  ["soil-to-fertilizer", [0, 15, 37], [37, 52, 2], [39, 0, 15]],
                  ["fertilizer-to-water", [49, 53, 8], [0, 11, 42], [42, 0, 7], [57, 7, 4]],
                  ["water-to-light", [88, 18, 7], [18, 25, 70]],
                  ["light-to-temperature", [45, 77, 23], [81, 45, 19], [68, 64, 13]],
                  ["temperature-to-humidity", [0, 69, 1], [1, 0, 69]],
                  ["humidity-to-location", [60, 56, 37], [56, 93, 4]]
                ]}
    end
  end

  describe "map/2" do
    test "a single map" do
      mappings = [["seed-to-soil", [50, 98, 2], [52, 50, 48]]]

      assert map(53, mappings) == 55
      assert map(79, mappings) == 81
      assert map(14, mappings) == 14
      assert map(55, mappings) == 57
      assert map(13, mappings) == 13
    end

    test "maps seeds through multiple mappings" do
      {_seeds, mappings} = parse(@example)

      assert map(79, mappings) == 82
      assert map(14, mappings) == 43
      assert map(55, mappings) == 86
      assert map(13, mappings) == 35
    end
  end

  describe "lowest_location/1" do
    test "example" do
      assert lowest_location(@example) == 35
    end
  end
end
