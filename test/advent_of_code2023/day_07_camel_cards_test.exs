defmodule AdventOfCode2023.Day07CamelCardsTest do
  use ExUnit.Case, async: true

  import AdventOfCode2023.Day07CamelCards

  @example """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """

  describe "parse/1" do
    test "example" do
      assert parse(@example) == [
               {"32T3K", 765},
               {"T55J5", 684},
               {"KK677", 28},
               {"KTJJT", 220},
               {"QQQJA", 483}
             ]
    end
  end

  describe "compare/2" do
    test "higher type wins" do
      assert compare("AAAAA", "A2345") == :gt
      assert compare("AAA23", "22233") == :lt
    end

    test "with same rank, highest rank in order wins" do
      assert compare("33332", "2AAAA") == :gt
      assert compare("77888", "77788") == :gt
    end
  end

  test "type/1" do
    assert type("AAAAA") == :five_of_a_kind
    assert type("AAA8A") == :four_of_a_kind
    assert type("AAAKK") == :full_house
    assert type("AAA23") == :three_of_a_kind
    assert type("23432") == :two_pair
    assert type("A23A4") == :one_pair
    assert type("23456") == :high_card
  end

  test "total_winnings/1" do
    assert total_winnings(@example) == 6440
  end
end
