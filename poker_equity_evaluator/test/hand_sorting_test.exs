defmodule HandDifferencesTest do
  import Hand
  import HandTestHelper
  use ExUnit.Case, async: true

  test "sorts high card hands" do
    hands = [
      hand( ~w{KC TD 8H 2C 3D 4H 6H} ), # KT864
      hand( ~w{AH KD 8H 9C 3D 4H 6H} ), # AK986
      hand( ~w{AC TD 8H 9C 3D 4H 6H} ), # AT986
      hand( ~w{AC TD 8H 9C 3D 4H 5H} ), # AT985
      hand( ~w{JC TD 8H 9C 3D 4H 6H} )  # JT986
    ]

    assert hand_types(hands, :high_card)
    assert compare_sorted_indexes(hands, [1, 2, 3, 0, 4])
  end

  test "sorts pair hands" do
    hands = [
      hand( ~w{AC TD AD 9C 3D 4H 6H} ), # AAT96
      hand( ~w{8C 8H 2C 3H 5S 6D AD} ), # 88A65
      hand( ~w{AD 9C AS KC 3D 4H 6H} ), # AAK96
      hand( ~w{QS JC TD TH 4H 2C 6C} ), # TTQJ6
      hand( ~w{8C 8H KC 3H 5S 6D 9D} ), # 88K96
      hand( ~w{QS KC TD TH 4H 2C 6C} )  # TTKQ6
    ]

    assert hand_types(hands, :pair)
    assert compare_sorted_indexes(hands, [2, 0, 5, 3, 1, 4])
  end

  test "sorts two pair hands" do
    hands = [
      hand( ~w{KC TD KD 9C TC 4H 6H} ), # KKTT9
      hand( ~w{KC 7D KD QC 7C 4H 6H} ), # KK77Q
      hand( ~w{QC JD QD 9C JC 4H AH} ), # QQJJA
      hand( ~w{KC TD KD AC TC 4H 6H} ), # KKTTA
      hand( ~w{QC JD QD 9C JC 4H 6H} ), # QQJJ9
      hand( ~w{KC TD KD QC TC 4H 6H} )  # KKTTQ
    ]

    assert hand_types(hands, :two_pair)
    assert compare_sorted_indexes(hands, [3, 5, 0, 1, 2, 4])
  end

  test "sorts three of a kind hands" do
    hands = [
      hand( ~w{KC 9D KD KH TC 4H 6H} ), # KKKT9
      hand( ~w{KC TD 2D 2H 2C 4H 6H} ), # 222KT
      hand( ~w{QC 9D QD QH KC 4H 6H} ), # QQQK9
      hand( ~w{8C 9D 8D 8H TC 4H 6H} ), # 888T9
      hand( ~w{KC AD KD KH TC 3H 6H} ), # KKKAT
      hand( ~w{AC 9D 2D 2H 2C 4H 6H} )  # 222A9
    ]

    assert hand_types(hands, :three_of_a_kind)
    assert compare_sorted_indexes(hands, [4, 0, 2, 3, 5, 1])
  end

  test "sorts straight hands" do
    hands = [
      hand( ~w{8C 7D 6D 5H 4C 3H AH} ), # 87654
      hand( ~w{KC QD JD KH TC 4H 9H} ), # KQJT9
      hand( ~w{AC QD JD KH TC 4H JH} ), # AKQJT
      hand( ~w{AC 3D 2D KH TC 4H 5H} ), # 5432A
      hand( ~w{2C 3D 4D 5H 6C 4H 9H} )  # 65432
    ]

    assert hand_types(hands, :straight)
    assert compare_sorted_indexes(hands, [2, 1, 0, 4, 3])
  end

  test "flush" do
    hands = [
      hand( ~w{KC QC JD 9C TC 4H 3C} ), # K
      hand( ~w{5C 2C JC 9C TC 4H 3D} ), # J
      hand( ~w{6C 5C 2C 4C 7C 4H KH} ), # 7
      hand( ~w{5C 2C 6C 9C TC 4H 3D} ), # T
      hand( ~w{KC QC JD AC 7C 4H 3C} )  # A
    ]

    assert hand_types(hands, :flush)
    assert compare_sorted_indexes(hands, [4, 0, 1, 3, 2])
  end

  test "full house" do
    hands = [
      hand( ~w{4C 3H JD 9C 4D 4S 3C} ), # 44433
      hand( ~w{QC QH QD 6C 6D 6S 3C} ), # QQQ66
      hand( ~w{KC KH KD 6C 4D 4S 3C} ), # KKK44
      hand( ~w{QC QH QD 6C 7D 7S 3C} ), # QQQ77
      hand( ~w{2C 2H 2D 3C 3D AS KC} ), # 22233
      hand( ~w{AC AH AD 6C 4D 4S 3C} ), # AAA44
      hand( ~w{2C 2H 2D 6C 6D AS KC} )  # 22266
    ]
    assert hand_types(hands, :full_house)
    assert compare_sorted_indexes(hands, [5, 2, 3, 1, 0, 6, 4])
  end

  test "four of a kind" do
    hands = [
      hand( ~w{4C 4H JD 9C 4D 4S 3C} ), # 4444J
      hand( ~w{2C 2H JD 9C 2D 2S 3C} ), # 2222J
      hand( ~w{4C 4H 2D 2C 4D 4S 3C} ), # 44443
      hand( ~w{AC AH JD 9C AD AS 3C} ), # AAAAJ
      hand( ~w{4C 4H AD 9C 4D 4S 3C} ), # 4444A
      hand( ~w{2C 2H AD 9C 2D 2S 3C} )  # 2222A
    ]

    assert hand_types(hands, :four_of_a_kind)
    assert compare_sorted_indexes(hands, [3, 4, 0, 2, 5, 1])
  end

  test "straight flush" do
    hands = [
      hand( ~w{4C 5C JD 2C 4D 6C 3C} ), # 6
      hand( ~w{KC QC JC 8C 9D TC 9C} ), # K
      hand( ~w{6C 7C JD 5C 4C AD 3C} ), # 7
      hand( ~w{4C 5C JD 3C 4D 2C AC} )  # 5
    ]

    royal_flush = hand( ~w{KC QC JC AC TC 6C 3C} )

    assert hand_types(hands, :straight_flush)
    assert compare_sorted_indexes(hands ++ [royal_flush], [4, 1, 2, 0, 3])
  end

  test "sorts differing hands properly" do
    high_card = high(hand( ~w{AC TD 8H 9C 3D 4H 6H} ))
    four_of_a_kind = high(hand( ~w{4C 4H JD 9C 4D 4S 3C} ))
    straight = high(hand( ~w{KC QD JD KH TC 4H 9H} ))

    [best, middle, worst] =
      Enum.sort([high_card, four_of_a_kind, straight], &Hand.high_sorter(&1, &2))

    assert best == four_of_a_kind
    assert middle == straight
    assert worst == high_card
  end
end
