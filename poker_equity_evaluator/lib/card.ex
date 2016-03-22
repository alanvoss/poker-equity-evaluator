defmodule Card do
  defstruct rank: "", suit: ""

  @suits %{
    s: %{ name: 'SPADES',   char: "♠" },
    h: %{ name: 'HEARTS',   char: "♥" },
    d: %{ name: 'DIAMONDS', char: "♦" },
    c: %{ name: 'CLUBS',    char: "♣" }
  }

  def suits, do: Map.keys(@suits)

  def rank(%Card{rank: 10}),   do: 'T'
  def rank(%Card{rank: 11}),   do: 'J'
  def rank(%Card{rank: 12}),   do: 'Q'
  def rank(%Card{rank: 13}),   do: 'K'
  def rank(%Card{rank: 14}),   do: 'A'
  def rank(%Card{rank: rank}), do: rank

  def suit(%Card{suit: suit}), do: @suits[suit][:name]

  def suit_character(%Card{suit: suit}), do: @suits[suit][:char]
end
