defmodule Card do
  defstruct rank: "", suit: ""

  @suits %{
    s: %{ name: "SPADES",   char: "♠" },
    h: %{ name: "HEARTS",   char: "♥" },
    d: %{ name: "DIAMONDS", char: "♦" },
    c: %{ name: "CLUBS",    char: "♣" }
  }

  @rank_abbreviations %{
    10 => "T",
    11 => "J",
    12 => "Q",
    13 => "K",
    14 => "A"
  }

  @rank_translations Map.merge(
    Map.new(Enum.map(Map.to_list(@rank_abbreviations), fn({k, v}) -> {v, k} end)),
    Map.new(Enum.map(2..9, fn(rank) -> {<<rank + 48>>, rank} end))
  )

  def suits, do: Map.keys(@suits)

  def rank(%Card{rank: rank}), do: @rank_abbreviations[rank] || rank

  def card(<<rank :: utf8, suit :: utf8>>), do: card({<<rank>>, String.downcase(<<suit>>)})
  def card([rank, suit]), do: card({<<rank>>, String.downcase(<<suit>>)})
  def card({rank, suit}) when is_bitstring(rank), do: card({@rank_translations[rank] || rank, suit})
  def card({rank, suit}) when is_bitstring(suit), do: card({rank, String.to_atom(String.downcase(suit))})
  def card({[rank], suit}), do: card({<<rank>>, suit})
  def card({rank, [suit]}), do: card({rank, <<suit>>})
  def card({rank, suit}) do
    suit = Enum.find(Map.keys(@suits), fn(s) -> suit == s end)
    if suit && rank <= 14 && rank >= 2, do: %Card{rank: rank, suit: suit}, else: nil
  end

  def suit(%Card{suit: suit}), do: @suits[suit][:name]

  def suit_character(%Card{suit: suit}), do: @suits[suit][:char]
end
