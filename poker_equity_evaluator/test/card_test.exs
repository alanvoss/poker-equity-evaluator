defmodule CardTest do
  import Card
  use ExUnit.Case, async: true

  @ace_of_spades  %Card{suit: :s, rank: 14}
  @three_of_clubs %Card{suit: :c, rank: 3}

  test "that the suit atoms are property returned" do
    assert suits() == [:c, :d, :h, :s]
  end

  test "that the name of the suit is returned" do
    assert suit(@ace_of_spades) == 'SPADES'
  end

  test "the suit character is returned" do
    assert suit_character(@three_of_clubs) == "♣"
  end

  test "the numeric rank is returned" do
    assert rank(@three_of_clubs) == 3
  end

  test "the alpha rank is returned" do
    assert rank(@ace_of_spades) == 'A'
  end
end
