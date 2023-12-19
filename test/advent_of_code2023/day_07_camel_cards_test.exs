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

  describe "lte/2" do
    test "higher type wins" do
      refute lte("AAAAA", "A2345")
      assert lte("AAA23", "22233")
    end

    test "with same rank, highest rank in order wins" do
      refute lte("33332", "2AAAA")
      assert lte("77788", "77888")
    end

    test "with jacks wild, J is lowest rank" do
      assert lte("TTTT3", "JKKKK", :straight)
      refute lte("TTTT3", "JKKK3", :jacks_wild)
    end
  end

  test "type/1" do
    assert pretty_type(type("AAAAA")) == :five_of_a_kind
    assert pretty_type(type("AAA8A")) == :four_of_a_kind
    assert pretty_type(type("AAAKK")) == :full_house
    assert pretty_type(type("AAA23")) == :three_of_a_kind
    assert pretty_type(type("23432")) == :two_pair
    assert pretty_type(type("A23A4")) == :one_pair
    assert pretty_type(type("23456")) == :high_card
  end

  test "best_hand/2" do
    assert best_hand("AAAKK", :jacks_wild) == "AAAKK"
    assert best_hand("AAAAJ", :jacks_wild) == "AAAAA"
    assert best_hand("QQQJA", :jacks_wild) == "QQQQA"
  end

  test "total_winnings/1" do
    assert total_winnings(@example) == 6440
  end

  test "total_winnings/2" do
    assert total_winnings(@example, :jacks_wild) == 5905
  end

  defp pretty_type(7), do: :five_of_a_kind
  defp pretty_type(6), do: :four_of_a_kind
  defp pretty_type(5), do: :full_house
  defp pretty_type(4), do: :three_of_a_kind
  defp pretty_type(3), do: :two_pair
  defp pretty_type(2), do: :one_pair
  defp pretty_type(1), do: :high_card
end
