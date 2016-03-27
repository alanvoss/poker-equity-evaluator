defmodule DeckTest do
  import Deck
  use ExUnit.Case, async: true

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
