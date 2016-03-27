defmodule HandTest do
  import Hand
  use ExUnit.Case, async: true

  defp hand(cards) do
    Enum.map(cards, &card(&1))
  end

  defp card(<<rank <> suit>>) do
require IEx
IEx.pry
"alan"
  end

  test "high card" do
    high_card = high(hand( ~w{AC TD 8H 9C 3D 4H} ))
  end

  test "one pair" do
  end

  test "two pair" do
  end

  test "three of a kind" do
  end

  test "straight" do
  end

  test "flush" do
  end

  test "full house" do
  end

  test "four of a kind" do
  end

  test "straight flush" do
  end

  test "sorts hands properly" do
  end

  @ace_of_spades  %Card{suit: :s, rank: 14}
  @three_of_clubs %Card{suit: :c, rank: 3}
  @nine_of_hearts %Card{suit: :h, rank: 9}

  test "the count of the full deck" do
    assert length(deck()) == 52
  end

  test "that a single card is removed" do
    new_deck = Deck.remove(deck(), [@ace_of_spades])
    assert length(new_deck) == 51
    assert Enum.find(new_deck, fn(c) -> c == @ace_of_spades end) == nil
    assert Enum.find(new_deck, fn(c) -> c == @three_of_clubs end) == @three_of_clubs 
  end

  test "that multiple cards are removed" do
    new_deck = Deck.remove(deck(), [@ace_of_spades, @three_of_clubs])
    assert length(new_deck) == 50
    assert Enum.find(new_deck, fn(c) -> c == @ace_of_spades end) == nil
    assert Enum.find(new_deck, fn(c) -> c == @three_of_clubs end) == nil
  end

  test "that all combinations of 2 cards are returned" do
    assert length(combinations([@ace_of_spades, @three_of_clubs, @nine_of_hearts], 2)) == 3
  end
end
