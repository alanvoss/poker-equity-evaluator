defmodule HandTestHelper do
  def hand(card_strings) do
    Enum.map(card_strings, fn(card) -> Card.card(card) end)
  end

  def original_indexes({new, original}) do
    Enum.map(new, fn(hand) ->
      Enum.find_index(original, &(hand == &1)) end)
  end

  def compare_sorted_indexes(hands, indexes) do
    original_indexes({Enum.sort(hands, &Hand.high_eval_sorter(&1, &2)), hands}) == indexes
  end

  def hand_types(hands, type) do
    Enum.all?(hands, fn(hand) ->
      %{hand: hand_type} = Hand.high(hand)
      type == hand_type
    end)
  end
end
