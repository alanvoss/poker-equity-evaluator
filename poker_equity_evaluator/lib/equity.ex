defmodule HoldEmEquity do
  def hole_cards(sets_of_cards) do
    combos = Deck.deck -- List.flatten(sets_of_cards)
      |> Deck.combinations(5)
    sum = length(combos)

    {winning_counts, tie_counts} =
      combos
      |> Enum.reduce(winners_and_ties(length(sets_of_cards)), fn(combination, winners_and_ties) ->
           ranks = Enum.map(sets_of_cards, &Hand.high(combination ++ &1))
           [winner | _] = Enum.sort(ranks, &Hand.high_sorter(&1, &2))
           update_winners(winners_and_ties, ranks, Enum.filter(ranks, &Hand.equal(&1, winner)))
         end)

     [winning_equity, split_equity] =
       Enum.map([winning_counts, tie_counts], fn(counts) -> Enum.map(counts, &(&1 / sum * 100)) end)
       #winning_equity = Enum.map(winning_counts, fn(count) -> count / sum * 100 end)
       #split_equity = Enum.map(tie_counts, fn(count) -> count / sum * 100 end)
require IEx
IEx.pry
     { winning_equity, split_equity }
  end

  defp update_winners({winners_running_count, ties_running_count}, ranks, ties = [winner | _]) when length(ties) > 1 do
    updated_ties_running_count = Enum.reduce(Enum.with_index(ranks), ties_running_count, fn({rank, index}, ties_running_count)
      -> if rank == winner, do: List.update_at(ties_running_count, index, &(&1 + 1)), else: ties_running_count end)
    { winners_running_count, updated_ties_running_count }
  end

  defp update_winners({winners_running_count, ties_running_count}, ranks, [winner]) do
    updated_winners_running_count =
      List.update_at(winners_running_count, Enum.find_index(ranks, &(&1 == winner)), &(&1 + 1))
    { updated_winners_running_count, ties_running_count }
  end

  defp winners_and_ties(count) do
    List.to_tuple(Enum.map(1..2, fn _ -> Enum.map(1..count, fn _ -> 0 end) end))
  end
end
