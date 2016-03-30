defmodule HoldEmEquity do
  def hole_cards(sets_of_cards) do
    winning_counts =
      Enum.reduce(sets_of_cards, Deck.deck, fn(set, deck) -> deck -- set end)
      |> Deck.combinations(5)
      |> Enum.reduce(Enum.map(sets_of_cards, fn _ -> 0 end), fn(combination, winners) ->
           ranks = [winner | _] =
             Enum.map(sets_of_cards, fn(set) -> Hand.high(combination ++ set) end)
             |> Enum.sort(&Hand.high_sorter(&1, &2))

new_winners =           Enum.reduce_while(Enum.with_index(ranks), winners, fn({rank, index}, winners)
             -> if rank == winner do
require IEx
if index > 0, do: IEx.pry
                  {:cont, List.update_at(winners, index, &(&1 + 1))}
                else
                  {:halt, winners}
                end
             end)
#require IEx
#IEx.pry
new_winners
         end)
     sum = Enum.sum(winning_counts)
require IEx
IEx.pry
     Enum.map(winning_counts, fn(count) -> count / sum * 100 end)
  end
end
