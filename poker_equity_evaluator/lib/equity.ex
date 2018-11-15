defmodule HoldEmEquity do
  def hole_cards(sets_of_cards) do
    hand_count = Enum.count(sets_of_cards)

    boards = Deck.deck -- List.flatten(sets_of_cards)
      |> Deck.combinations(5)
    combinations_sum = length(boards)

    pmap(boards, fn (board) -> winning_indexes(sets_of_cards, board) end)
    |> Enum.reduce(%{ win_counts: zeroes(hand_count), tie_counts: zeroes(hand_count)}, &sum_winners_and_ties/2)



    #{winning_counts, tie_counts} =
    #  combos
    #  |> Enum.reduce(winners_and_ties(length(sets_of_cards)), fn(combination, winners_and_ties) ->
    #       ranks = Enum.map(sets_of_cards, &Hand.high(combination ++ &1))
    #       [winner | _] = Enum.sort(ranks, &Hand.high_sorter(&1, &2))
    #       update_winners(winners_and_ties, ranks, Enum.filter(ranks, &Hand.equal(&1, winner)))
    #     end)

    # [winning_equity, split_equity] =
    #   Enum.map([winning_counts, tie_counts], fn(counts) -> Enum.map(counts, &(&1 / sum * 100)) end)
    # { winning_equity, split_equity }
  end

  def sum_winners_and_ties(winners, acc) when length(winners) > 1 do
    #Map.update(acc, :tie_counts, Enum.reduce(acc[:tie_counts], :q
  end
  def sum_winners_and_ties(winners, acc) do
    Map.update(acc, :win_counts, List.update_at(acc, Enum.at(winners, 0), fn x -> x + 1 end))
  end

  def zeroes(hand_count), do: Enum.map(1..hand_count, fn _ -> 0 end)

  def winning_indexes(sets_of_cards, board) do
    ranks = Enum.map(sets_of_cards, &Hand.high(Enum.concat(board, &1)))
    [winner | _] = Enum.sort(ranks, &Hand.high_sorter(&1, &2))
    winning_hand_indexes(ranks, winner)
  end

  def winning_hand_indexes(ranks, winner), do: find_winning_hand_indexes(ranks, winner, {0, []})
  def find_winning_hand_indexes([], winner, {index, indexes}), do: indexes
  def find_winning_hand_indexes([rank | rest], winner, {index, indexes}) when rank == winner do
    #find_matching_indexes(rest, winner, {index + 1, [index | indexes]})
  end
  def find_winning_hand_indexes([rank | rest], winner, {index, indexes}) do
    find_winning_hand_indexes(rest, winner, {index + 1, indexes})
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
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
