defmodule Rotate do
  use GenServer

  def create(list, n) do
    GenServer.start_link(__MODULE__, create_initial(list, n))
  end

  def next(pid) do
    GenServer.call(pid, :next)
  end

  def handle_call(:next, _from, nil), do: nil
  def handle_call(:next, _from, elements) do
    top = Enum.reverse(Enum.map(elements, &(Enum.at(elem(&1, 0), 0))))
    {:reply, top, rotate(elements)}
  end

  def rotate(elements), do: _rotate(elements, [])

  def _rotate([], rotated_structure), do: Enum.reverse(rotated_structure)

  # [{["C", "D", "E"], []}, {["B"], []}, {["A"], []}]
  #   -> [{["D", "E"], ["C"]}, {["B"], []}, {["A"], []}]
  #   -> [{["E"], ["C", "D"]}, {["B"], []}, {["A"], []}]
  #   -> [{["D", "E"], []}, {["C"], ["B"]}, {["A"], []}]
  #   -> [{["E"], ["D"]}, {["C"], ["B"]}, {["A"], []}]
  #   -> [{["E"], []}, {["D"], ["B", "C"]}, {["A"], []}]
  #   -> [{["D", "E"], []}, {["C"], []}, {["B"], ["A"]}]
  #   -> [{["E"], ["D"]}, {["C"], []}, {["B"], ["A"]}]
  #   -> [{["E"], []}, {["D"], ["C"]}, {["B"], ["A"]}]
  #   -> [{["E"], []}, {["D"], []}, {["C"], ["A", "B"]}]

  # ABC
  # ABD
  # ABE
  # ABF
  # ACD
  # ACE
  # ACF
  # ADE
  # ADF
  # AEF
  # BCD
  # BCE
  # BCF
  # BDE
  # BDF
  # BEF
  # CDE
  # CDF
  # CEF
  # DEF


  # ABC    [{["C", "D", "E", "F"], []}, {["B"], []}, {["A"], []}]
  # ABD -> [{["D", "E", "F"], ["C"]}, {["B"], []}, {["A"], []}]
  # ABE -> [{["E", "F"], ["C", "D"]}, {["B"], []}, {["A"], []}]
  # ABF -> [{["F"], ["C", "D", "E"]}, {["B"], []}, {["A"], []}]

  # ACD -> [{["D", "E", "F"], []}, {["C"], ["B"]}, {["A"], []}]
  # ACE -> [{["E", "F"], ["D"]}, {["C"], ["B"]}, {["A"], []}]
  # ACF -> [{["F"], ["D", "E"]}, {["C"], ["B"]}, {["A"], []}]

  # ADE -> [{["E", "F"], []}, {["D"], ["B", "C"]}, {["A"], []}]
  # ADF -> [{["F"], ["E"]}, {["D"], ["B", "C"]}, {["A"], []}]
  # AEF -> [{["F"], []}, {["E"], ["B", "C", "D"]}, {["A"], []}]

  # BCD -> [{["D", "E", "F"], []}, {["C"], []}, {["B"], ["A"]}]
  # BCE -> [{["E", "F"], ["D"]}, {["C"], []}, {["B"], ["A"]}]
  # BCF -> [{["F"], ["D", "E"]}, {["C"], []}, {["B"], ["A"]}]
  # BDE -> [{["E", "F"], []}, {["D"], ["C"]}, {["B"], ["A"]}]
  # BDF -> [{["F"], ["E"]}, {["D"], ["C"]}, {["B"], ["A"]}]
  # BEF -> [{["F"], []}, {["E"], ["C", "D"]}, {["B"], ["A"]}]

  # CDE -> [{["E", "F"], []}, {["D"], []}, {["C"], ["A", "B"]}]
  # CDF -> [{["F"], ["E"]}, {["D"], []}, {["C"], ["A", "B"]}]
  # CEF -> [{["F"], []}, {["E"], ["D"]}, {["C"], ["A", "B"]}]
  # DEF -> [{["F"], []}, {["E"], []}, {["D"], ["A", "B", "C"]}]

  # ABCD -> [{["D", "E", "F"], []}, {["C"], []}, {["B"], []}, {["A"], []}]
  # ABCE -> [{["E", "F"], ["D"]}, {["C"], []}, {["B"], []}, {["A"], []}]
  # ABCF -> [{["F"], ["E", "D"]}, {["C"], []}, {["B"], []}, {["A"], []}]
  # ABDE -> [{["E", "F"], []}, {["D"], ["C"]}, {["B"], []}, {["A"], []}]
  # ABDF -> [{["F"], ["E"]}, {["D"], ["C"]}, {["B"], []}, {["A"], []}]
  # ABEF -> [{["F"], []}, {["E"], ["D", "C"]}, {["B"], []}, {["A"], []}]
  # ACDE -> [{["E", "F"], []}, {["D"], []}, {["C"], ["B"]}, {["A"], []}]
  # ACDF -> [{["F"], ["E"]}, {["D"], []}, {["C"], ["B"]}, {["A"], []}]
  # ACEF -> [{["F"], []}, {["E"], ["D"]}, {["C"], ["B"]}, {["A"], []}]
  # ADEF -> [{["F"], []}, {["E"], []}, {["D"], ["C", "B"]}, {["A"], []}]
  # BCDE -> [{["E", "F"], []}, {["D"], []}, {["C"], []}, {["B"], ["A"]}]
  # BCDF -> [{["F"], ["E"]}, {["D"], []}, {["C"], []}, {["B"], ["A"]}]
  # BCEF -> [{["F"], []}, {["E"], ["D"]}, {["C"], []}, {["B"], ["A"]}]
  # BDEF -> [{["F"], []}, {["E"], []}, {["D"], ["C"]}, {["B"], ["A"]}]
  # CDEF -> [{["F"], []}, {["E"], []}, {["D"], []}, {["C"], ["B", "A"]}]

  # ABCD -> [{["D", "E", "F", "G"], []}, {["C"], []}, {["B"], []}, {["A"], []}]
  # ABCE -> [{["E", "F", "G"], ["D"]}, {["C"], []}, {["B"], []}, {["A"], []}]
  # ABCF -> [{["F", "G"], ["E", "D"]}, {["C"], []}, {["B"], []}, {["A"], []}]
  # ABCG -> [{["G"], ["F", "E", "D"]}, {["C"], []}, {["B"], []}, {["A"], []}]
  # ABDE -> [{["E", "F", "G"], []}, {["D"], ["C"]}, {["B"], []}, {["A"], []}]
  # ABDF -> [{["F", "G"], ["E"]}, {["D"], ["C"]}, {["B"], []}, {["A"], []}]
  # ABDG -> [{["G"], ["F", "E"]}, {["D"], ["C"]}, {["B"], []}, {["A"], []}]
  # ABEF -> [{["F", "G"], []}, {["E"], ["D", "C"]}, {["B"], []}, {["A"], []}]
  # ABEG -> [{["G"], ["F"]}, {["E"], ["D", "C"]}, {["B"], []}, {["A"], []}]


  # ACDE -> [{["E", "F"], []}, {["D"], []}, {["C"], ["B"]}, {["A"], []}]
  # ACDF -> [{["F"], ["E"]}, {["D"], []}, {["C"], ["B"]}, {["A"], []}]
  # ACEF -> [{["F"], []}, {["E"], ["D"]}, {["C"], ["B"]}, {["A"], []}]
  # ADEF -> [{["F"], []}, {["E"], []}, {["D"], ["C", "B"]}, {["A"], []}]
  # BCDE -> [{["E", "F"], []}, {["D"], []}, {["C"], []}, {["B"], ["A"]}]
  # BCDF -> [{["F"], ["E"]}, {["D"], []}, {["C"], []}, {["B"], ["A"]}]
  # BCEF -> [{["F"], []}, {["E"], ["D"]}, {["C"], []}, {["B"], ["A"]}]
  # BDEF -> [{["F"], []}, {["E"], []}, {["D"], ["C"]}, {["B"], ["A"]}]
  # CDEF -> [{["F"], []}, {["E"], []}, {["D"], []}, {["C"], ["B", "A"]}]



  # ([now | next], [previous]) when length(next) == 0 && length(previous) == 0 -> store away and next
  # ([now | next], [previous]) when length(next) == 0 -> pop everything off of previous and append to now, except last element, which pass to next iteratorion
  # ([now | next], [previous]) -> ([next], [now | previous])



  def _rotate([{_current = [next | following], _finished = [to_rotate | remain]} | rest], rotated_structure) when length(following) == 0 do



    _rotate([{[to_rotate | ], []}     , [{[remain | next], []}  | rotated_struture])



  def _rotate([{[next | following], _finished = [to_rotate | remain]} | rest], rotated_structure) when length(following) == 0 do
    _rotate([{[to_rotate | rest], []}], [{[remain | next]} | rotated_structure])
  end

  def _rotate([{[next | following], finished} | rest], rotated_structure) do
    _rotate([{following, [next | finished]} | rest] 
  end

  def create_initial(list, n) when length(list) >= n do
    _create_initial(list, n - 1, [])
  end

  def _create_initial(list, 0, result), do: [{list, []} | result]
  def _create_initial([head | rest], n, result) do
    _create_initial(rest, n - 1, [{[head], []} | result])
  end
end
