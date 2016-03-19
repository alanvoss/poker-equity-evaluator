defmodule Deck do
  def deck, do: for suit <- [:s, :h, :d, :c], rank <- 1..13, do: {rank, suit}

  def card({rank, suit}), do: {rank(rank), suit(suit)}

  def rank(1),  do: 'A'
  def rank(10), do: 'T'
  def rank(11), do: 'J'
  def rank(12), do: 'Q'
  def rank(13), do: 'K'
  def rank(rank), do: rank

  def suit(:s), do: "SPADES"
  def suit(:h), do: "HEARTS"
  def suit(:d), do: "DIAMONDS"
  def suit(:c), do: "CLUBS"

  def suit_character(:s), do: "♠"
  def suit_character(:h), do: "♥"
  def suit_character(:d), do: "♦"
  def suit_character(:c), do: "♣"
end
