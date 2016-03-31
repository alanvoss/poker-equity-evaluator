defmodule HoldEmEquity do
  def hole_cards(sets_of_cards) do
    winning_counts =
      Deck.deck -- List.flatten(sets_of_cards)
      |> Deck.combinations(5)
      |> Enum.reduce(Enum.map(sets_of_cards, fn _ -> 0 end), fn(combination, winners) ->
           ranks = Enum.map(sets_of_cards, fn(set) -> Hand.high(combination ++ set) end)
           [winner | _] = Enum.sort(ranks, &Hand.high_sorter(&1, &2))
           Enum.reduce(Enum.with_index(ranks), winners, fn({rank, index}, winners)
             -> if rank == winner, do: List.update_at(winners, index, &(&1 + 1)), else: winners end)
         end)
     sum = Enum.sum(winning_counts)
require IEx
IEx.pry
     Enum.map(winning_counts, fn(count) -> count / sum * 100 end)
  end
end
