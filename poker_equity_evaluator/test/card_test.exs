defmodule CardTest do
  import Card
  use ExUnit.Case, async: true

  @ace_of_spades  %Card{suit: :s, rank: 14}
  @three_of_clubs %Card{suit: :c, rank: 3}

  test "that the suit atoms are property returned" do
    assert suits() == [:c, :d, :h, :s]
  end

  test "that the name of the suit is returned" do
    assert suit(@ace_of_spades) == "SPADES"
  end

  test "the suit character is returned" do
    assert suit_character(@three_of_clubs) == "♣"
  end

  test "the numeric rank is returned" do
    assert rank(@three_of_clubs) == 3
  end

  test "the alpha rank is returned" do
    assert rank(@ace_of_spades) == "A"
  end

  test "a card can be formed with a bitstring" do
    assert card("AS") == %Card{suit: :s, rank: 14}
    assert card("9d") == %Card{suit: :d, rank: 9}
  end

  test "a card can be formed with a charlist" do
    assert card('TD') == %Card{suit: :d, rank: 10}
    assert card('2h') == %Card{suit: :h, rank: 2}
  end

  test "a card can be formed with a tuple" do
    assert card({"K", 'S'}) == %Card{suit: :s, rank: 13}
    assert card({2, "d"}) == %Card{suit: :d, rank: 2}
    assert card({5, :d}) == %Card{suit: :d, rank: 5}
  end

  test "a card can be formed with a combination of a tuple and a charlist" do
    assert card({'Q', 'D'}) == %Card{suit: :d, rank: 12}
    assert card({2, "d"}) == %Card{suit: :d, rank: 2}
  end
end
