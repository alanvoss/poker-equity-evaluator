defmodule Deck do
  def deck, do: for suit <- [:s, :h, :d, :c], rank <- 1..13, do: %Card{rank: rank, suit: suit}
  def remove(deck, cards), do: Enum.reduce(cards, deck, fn(card, deck) -> List.delete(deck, card) end)
end
