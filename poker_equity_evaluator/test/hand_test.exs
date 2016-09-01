defmodule HandTest do
  import Hand
  import HandTestHelper
  use ExUnit.Case, async: true

  test "high card" do
    high_card = high(hand( ~w{AC TD 8H 9C 3D 4H 6H} ))
    %{hand: :high_card, kickers: kickers} = high_card
    assert kickers == [14, 10, 9, 8, 6]
  end

  test "pair" do
    pair = high(hand( ~w{AC TD AD 9C 3D 4H 6H} ))
    %{hand: :pair, rank: rank, kickers: kickers} = pair
    assert rank == 14
    assert kickers == [10, 9, 6]
  end

  test "two pair" do
    two_pair = high(hand( ~w{KC TD KD 9C TC 4H 6H} ))
    %{hand: :two_pair, high_rank: high_rank, low_rank: low_rank, kickers: kickers} = two_pair
    assert high_rank == 13
    assert low_rank == 10
    assert kickers == [9]
  end

  test "three of a kind" do
    three_of_a_kind = high(hand( ~w{KC 9D KD KH TC 4H 6H} ))
    %{hand: :three_of_a_kind, rank: rank, kickers: kickers} = three_of_a_kind
    assert rank == 13
    assert kickers == [10, 9]
  end

  test "straight" do
    straight = high(hand( ~w{KC QD JD KH TC 4H 9H} ))
    %{hand: :straight, high: high} = straight
    assert high == 13
  end

  test "flush" do
    flush = high(hand( ~w{KC QC JD 9C TC 4H 3C} ))
    %{hand: :flush, suit: suit, ranks: ranks} = flush
    assert suit == :c
    assert ranks == [13, 12, 10, 9, 3]
  end

  test "flush (with 6 cards)" do
    flush = high(hand( ~w{KC QC JD 9C TC 2C 3C} ))
    %{hand: :flush, suit: suit, ranks: ranks} = flush
    assert suit == :c
    assert ranks == [13, 12, 10, 9, 3]
  end

  test "full house" do
    full_house = high(hand( ~w{4C 3H JD 9C 4D 4S 3C} ))
    %{hand: :full_house, rank: rank, over: over} = full_house
    assert rank == 4
    assert over == 3

    full_house = high(hand( ~w{AC QH JD 9C AD AS QC} ))
    %{hand: :full_house, rank: rank, over: over} = full_house
    assert rank == 14
    assert over == 12
  end

  test "four of a kind" do
    four_of_a_kind = high(hand( ~w{4C 4H JD 9C 4D 4S 3C} ))
    %{hand: :four_of_a_kind, rank: rank, kickers: kickers} = four_of_a_kind
    assert rank == 4
    assert kickers == [11]
  end

  test "straight flush" do
    straight_flush = high(hand( ~w{4C 5C JD 7C 4D 6C 3C} ))
    %{hand: :straight_flush, high: high, suit: suit} = straight_flush 
    assert high == 7
    assert suit == :c

    straight_flush = high(hand( ~w{2C 3C 4C 5C 6C AC KC} ))
    %{hand: :straight_flush, high: high, suit: suit} = straight_flush 
    assert high == 6
    assert suit == :c

    straight_flush = high(hand( ~w{2C 3C 4C 5C 6C 9D KC} ))
    %{hand: :straight_flush, high: high, suit: suit} = straight_flush 
    assert high == 6
    assert suit == :c

    straight_flush = high(hand( ~w{2H 3H 4H 5H 6C AH KC} ))
    %{hand: :straight_flush, high: high, suit: suit} = straight_flush 
    assert high == 5
    assert suit == :h
  end

  test "royal flush" do
    royal_flush = high(hand( ~w{KD JD JD AD 4D TD QD} ))
    %{hand: :royal_flush, high: high, suit: suit} = royal_flush
    assert high == 14
    assert suit == :d
  end
end
