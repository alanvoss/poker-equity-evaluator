defmodule Deck do
  def deck, do: for suit <- [:s, :h, :d, :c], rank <- 2..14, do: %Card{rank: rank, suit: suit}
  def remove(deck, cards), do: Enum.reduce(cards, deck, fn(card, deck) -> List.delete(deck, card) end)

  def combinations(_, 0), do: [[]]
  def combinations([], _), do: []
  def combinations(_deck = [x|xs], n) when is_integer(n) do
    (for y <- combinations(xs, n - 1), do: [x|y]) ++ combinations(xs, n)
  end
end
