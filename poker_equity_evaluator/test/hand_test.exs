defmodule HandTest do
  import Hand
  use ExUnit.Case, async: true

  defp hand(card_strings) do
    Enum.map(card_strings, fn(card) -> Card.card(card) end)
  end

  defp ranks(cards) do
    Enum.map(cards, fn(card) -> card.rank end)
  end

  test "high card" do
    high_card = high(hand( ~w{AC TD 8H 9C 3D 4H 6H} ))
    %{hand: :high_card, kickers: kickers} = high_card
    assert ranks(kickers) == [14, 10, 9, 8, 6]
  end

  test "pair" do
    pair = high(hand( ~w{AC TD AD 9C 3D 4H 6H} ))
    %{hand: :pair, rank: rank, kickers: kickers} = pair
    assert rank == 14
    assert ranks(kickers) == [10, 9, 6]
  end

  test "two pair" do
    two_pair = high(hand( ~w{KC TD KD 9C TC 4H 6H} ))
    %{hand: :two_pair, high_rank: high_rank, low_rank: low_rank, kickers: kickers} = two_pair
    assert high_rank == 13
    assert low_rank == 10
    assert ranks(kickers) == [9]
  end

  test "three of a kind" do
    three_of_a_kind = high(hand( ~w{KC 9D KD KH TC 4H 6H} ))
    %{hand: :three_of_a_kind, rank: rank, kickers: kickers} = three_of_a_kind
    assert rank == 13
    assert ranks(kickers) == [10, 9]
  end

  test "straight" do
    straight = high(hand( ~w{KC QD JD KH TC 4H 9H} ))
    %{hand: :straight, high: high} = straight
    assert high.rank == 13
  end

  test "flush" do
    flush = high(hand( ~w{KC QC JD 9C TC 4H 3C} ))
    %{hand: :flush, suit: suit, high: high} = flush 
    assert suit == :c
    assert high.rank == 13
  end

  test "full house" do
    full_house = high(hand( ~w{4C 3H JD 9C 4D 4S 3C} ))
    %{hand: :full_house, rank: rank, over: over} = full_house
    assert rank == 4
    assert over == 3
  end

  test "four of a kind" do
    four_of_a_kind = high(hand( ~w{4C 4H JD 9C 4D 4S 3C} ))
    %{hand: :four_of_a_kind, rank: rank, kickers: kickers} = four_of_a_kind
    assert rank == 4
    assert ranks(kickers) == [11]
  end

  test "straight flush" do
    straight_flush = high(hand( ~w{4C 5C JD 7C 4D 6C 3C} ))
    %{hand: :straight_flush, high: high, suit: suit} = straight_flush 
    assert high.rank == 7
    assert suit == :c
  end

  test "royal flush" do
    royal_flush = high(hand( ~w{KD JD JD AD 4D TD QD} ))
    %{hand: :royal_flush, high: high, suit: suit} = royal_flush
    assert high.rank == 14
    assert suit == :d
  end

  test "sorts hands properly" do
    high_card = high(hand( ~w{AC TD 8H 9C 3D 4H 6H} ))
    four_of_a_kind = high(hand( ~w{4C 4H JD 9C 4D 4S 3C} ))
    straight = high(hand( ~w{KC QD JD KH TC 4H 9H} ))

    [best, middle, worst] =
      Enum.sort([high_card, four_of_a_kind, straight], &Hand.high_sorter(&1, &2))

    assert best == four_of_a_kind
    assert middle == straight
    assert worst == high_card
  end
end
