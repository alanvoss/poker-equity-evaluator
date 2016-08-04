defmodule Hand do
  @hands %{
    high_card:       1,
    pair:            2,
    two_pair:        3,
    three_of_a_kind: 4,
    straight:        5,
    flush:           6,
    full_house:      7,
    four_of_a_kind:  8,
    straight_flush:  9,
    royal_flush:     10
  }

  def high(hand) do
    hand = Enum.sort_by(hand, &(15 - &1.rank))
    ranks = _divide_by_ranks(hand)
    suits = _divide_by_suits(hand)
    possible_flush = _is_flush(suits)
    possible_three_of_a_kind = _is_three_of_a_kind(hand, ranks)
    possible_pair = _is_pair(hand, ranks)
    possible_straight_flush = _is_straight_flush(suits, possible_flush)

    _is_royal_flush(possible_straight_flush)
    || possible_straight_flush 
    || _is_four_of_a_kind(hand, ranks)
    || _is_full_house(possible_three_of_a_kind, ranks)
    || possible_flush
    || _is_straight(hand)
    || possible_three_of_a_kind
    || _is_two_pair(hand, ranks)
    || possible_pair
    || _is_high_card(hand)
  end

  def high_eval_sorter(hand1, hand2) do
    high_sorter(high(hand1), high(hand2))
  end

  def high_sorter(hand1 = %{hand: h1}, hand2 = %{hand: h2}) when h1 == h2 do
    _royal_flush_high_sorter(hand1, hand2)
    || _straight_flush_high_sorter(hand1, hand2)
    || _four_of_a_kind_high_sorter(hand1, hand2)
    || _full_house_high_sorter(hand1, hand2)
    || _flush_high_sorter(hand1, hand2)
    || _straight_high_sorter(hand1, hand2)
    || _three_of_a_kind_high_sorter(hand1, hand2)
    || _two_pair_high_sorter(hand1, hand2)
    || _pair_high_sorter(hand1, hand2)
    || _high_card_high_sorter(hand1, hand2)
    || false
  end

  def high_sorter(hand1, hand2) do
    @hands[hand1[:hand]] >= @hands[hand2[:hand]]
  end

  def equal(hand1, hand2) do
    Map.delete(hand1, :suit) == Map.delete(hand2, :suit)
  end

  defp _is_royal_flush(possible_straight_flush) do
    if possible_straight_flush do
      %{hand: :straight_flush, high: high, suit: suit} = possible_straight_flush
      if high == 14 do
        %{hand: :royal_flush, high: high, suit: suit}
      end
    end
  end

  defp _royal_flush_high_sorter(%{hand: :royal_flush}, %{hand: :royal_flush}), do: true
  defp _royal_flush_high_sorter(_, _), do: nil

  defp _is_straight_flush(suits, possible_flush) do
    if possible_flush do
      %{suit: suit} = possible_flush
      possible_straight = _is_straight(suits[suit])

      if possible_straight do
        %{high: high} = possible_straight
        %{hand: :straight_flush, high: high, suit: suit}
      end
    end
  end

  defp _straight_flush_high_sorter(
    %{hand: :straight_flush, high: high1},
    %{hand: :straight_flush, high: high2}
  ) do
    high1 >= high2
  end
  defp _straight_flush_high_sorter(_, _), do: nil

  defp _is_four_of_a_kind(hand, ranks) do
    rank = _find_highest_rank_with_count(ranks, 4)
    if rank do
      cards = ranks[rank]
      kicker = Enum.at(Deck.remove(hand, cards), 0).rank
      %{hand: :four_of_a_kind, rank: rank, kickers: [kicker]}
    end
  end

  defp _four_of_a_kind_high_sorter(
    %{hand: :four_of_a_kind, rank: rank1, kickers: kickers1 },
    %{hand: :four_of_a_kind, rank: rank2, kickers: kickers2 }
  ) when rank1 == rank2 do
    kickers1 >= kickers2
  end
  defp _four_of_a_kind_high_sorter(
    %{hand: :four_of_a_kind, rank: rank1},
    %{hand: :four_of_a_kind, rank: rank2}
  ) do
    rank1 >= rank2
  end
  defp _four_of_a_kind_high_sorter(_, _), do: nil

  defp _is_full_house(possible_three_of_a_kind, ranks) do
    if possible_three_of_a_kind do
      %{rank: rank} = possible_three_of_a_kind
      remaining_ranks = Map.delete(ranks, rank)

      eligible_ranks = Enum.filter([
        _find_highest_rank_with_count(remaining_ranks, 3),
        _find_highest_rank_with_count(remaining_ranks, 2)
      ], &(&1))

      if length(eligible_ranks) > 0 do
        max = Enum.max(eligible_ranks)
        %{hand: :full_house, rank: rank, over: max}
      end
    end
  end

  defp _full_house_high_sorter(
    %{hand: :full_house, rank: rank1, over: over1},
    %{hand: :full_house, rank: rank2, over: over2}
  ) when rank1 == rank2 do
    over1 >= over2
  end
  defp _full_house_high_sorter(
    %{hand: :full_house, rank: rank1},
    %{hand: :full_house, rank: rank2}
  ) do
    rank1 >= rank2
  end
  defp _full_house_high_sorter(_, _), do: nil

  defp _is_flush(suits) do
    {suit, count} = _suit_with_most_cards(suits)
    if count >= 5 do
      %{hand: :flush, suit: suit, high: Enum.at(suits[suit], 0).rank}
    end
  end

  defp _flush_high_sorter(%{hand: :flush, high: high1}, %{hand: :flush, high: high2}) do
    high1 >= high2
  end
  defp _flush_high_sorter(_, _), do: nil

  defp _is_straight(hand) do
    unique_rank_cards = Enum.dedup_by(hand, &(&1.rank))
    possible_ace = Enum.at(unique_rank_cards, 0)

    if Card.rank(possible_ace) == "A" do
      # dummy entry for ace-low straights
      unique_rank_cards = unique_rank_cards ++ [%Card{rank: 1, suit: possible_ace.suit}]
    end

    ranks = Enum.map(unique_rank_cards, &(&1.rank))
    highest_rank = _is_consecutive(ranks, 5, nil, nil)

    if highest_rank do
      %{hand: :straight, high: highest_rank}
    end
  end

  defp _straight_high_sorter(%{hand: :straight, high: high1}, %{hand: :straight, high: high2}) do
    high1 >= high2
  end
  defp _straight_high_sorter(_, _), do: nil

  defp _is_three_of_a_kind(hand, ranks) do
    rank = _find_highest_rank_with_count(ranks, 3)
    if rank do
      cards = ranks[rank]
      kickers = Enum.map(Enum.take(Deck.remove(hand, cards), 2), &(&1.rank))
      %{hand: :three_of_a_kind, rank: rank, kickers: kickers}
    end
  end

  defp _three_of_a_kind_high_sorter(
    %{hand: :three_of_a_kind, rank: rank1, kickers: kickers1},
    %{hand: :three_of_a_kind, rank: rank2, kickers: kickers2}
  ) when rank1 == rank2 do
    kickers1 >= kickers2
  end
  defp _three_of_a_kind_high_sorter(
    %{hand: :three_of_a_kind, rank: rank1},
    %{hand: :three_of_a_kind, rank: rank2}
  ) do
    rank1 >= rank2
  end
  defp _three_of_a_kind_high_sorter(_, _), do: nil

  defp _is_two_pair(hand, ranks) do
    pair_ranks = Enum.reduce(Enum.reverse(Map.keys(ranks)), [], fn(rank, acc)
      -> if length(ranks[rank]) == 2, do: acc ++ [rank], else: acc end)

    if length(pair_ranks) >= 2 do
      [high_rank, low_rank] = Enum.take(pair_ranks, 2)
      high_rank_cards = ranks[high_rank]
      low_rank_cards = ranks[low_rank]
      kickers = Enum.map(Enum.take(Deck.remove(hand, high_rank_cards ++ low_rank_cards), 1), &(&1.rank))
      %{hand: :two_pair, high_rank: high_rank, low_rank: low_rank,
        kickers: kickers}
    end
  end

  def _two_pair_high_sorter(
    %{hand: :two_pair, high_rank: high_rank1, low_rank: low_rank1, kickers: kickers1},
    %{hand: :two_pair, high_rank: high_rank2, low_rank: low_rank2, kickers: kickers2}
  ) when high_rank1 == high_rank2 and low_rank1 == low_rank2 do
    kickers1 >= kickers2
  end
  def _two_pair_high_sorter(
    %{hand: :two_pair, high_rank: high_rank1, low_rank: low_rank1},
    %{hand: :two_pair, high_rank: high_rank2, low_rank: low_rank2}
  ) when high_rank1 == high_rank2 do
    low_rank1 >= low_rank2
  end
  def _two_pair_high_sorter(
    %{hand: :two_pair, high_rank: high_rank1},
    %{hand: :two_pair, high_rank: high_rank2}
  ) do
    high_rank1 >= high_rank2
  end
  def _two_pair_high_sorter(_, _), do: nil

  defp _is_pair(hand, ranks) do
    rank = _find_highest_rank_with_count(ranks, 2)
    if rank do
      cards = ranks[rank]
      kickers = Enum.map(Enum.take(Deck.remove(hand, cards), 3), &(&1.rank))
      %{hand: :pair, rank: rank, kickers: kickers}
    end
  end

  defp _pair_high_sorter(
    %{hand: :pair, rank: rank1, kickers: kickers1},
    %{hand: :pair, rank: rank2, kickers: kickers2}
  ) when rank1 == rank2 do
    kickers1 >= kickers2
  end
  defp _pair_high_sorter(
    %{hand: :pair, rank: rank1},
    %{hand: :pair, rank: rank2}
  ) do
    rank1 >= rank2
  end
  defp _pair_high_sorter(_, _), do: nil

  defp _is_high_card(hand) do
    %{hand: :high_card, kickers: Enum.map(Enum.take(hand, 5), &(&1.rank))}
  end

  defp _high_card_high_sorter(%{hand: :high_card, kickers: kickers1}, %{hand: :high_card, kickers: kickers2}) do
    kickers1 >= kickers2
  end
  defp _high_card_high_sorter(_, _), do: nil

  defp _find_highest_rank_with_count(ranks, count) do
    Enum.find(Enum.reverse(Map.keys(ranks)), &(length(ranks[&1]) == count))
  end

  defp _is_consecutive([this | rest], remaining, nil, nil), do: _is_consecutive(rest, remaining - 1, this, this)
  defp _is_consecutive(_, 0, _, highest_rank), do: highest_rank
  defp _is_consecutive([], _, _, _), do: nil
  defp _is_consecutive([this | rest], remaining, prev, highest_rank) do
    if prev - this == 1 do
      _is_consecutive(rest, remaining - 1, this, highest_rank)
    else
      _is_consecutive(rest, 4, this, this)
    end
  end

  defp _divide_by_ranks(hand) do
    Enum.reduce(hand, %{}, fn(card, ranks)
      -> Map.update(ranks, card.rank, [card], &(Enum.into(&1, [card])))
    end)
  end

  defp _divide_by_suits(hand) do
    Enum.reduce(hand, %{}, fn(card, suits)
      -> Map.update(suits, card.suit, [card], &(&1 ++ [card]))
    end)
  end

  defp _suit_with_most_cards(divided_suits) do
    suits = Map.keys(divided_suits)
    suits_with_counts = Enum.map(suits, &({ &1, length(divided_suits[&1]) }))
    Enum.max_by(suits_with_counts, fn({_suit, count}) -> count end)
  end
end
