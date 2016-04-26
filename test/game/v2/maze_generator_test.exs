defmodule ElAbirynth.V2.MazeGeneratorTest do
  use ExUnit.Case, async: true
  alias ElAbirynth.V2.MazeGenerator

  test 'all_walls creates a list of walls' do
    assert MazeGenerator.all_walls(5, 5) == [{1, 2}, {2, 1}, {2, 3}, {3, 2}]
    assert MazeGenerator.all_walls(7, 7) == [{1, 2}, {1, 4}, {2, 1}, {2, 3}, {2, 5}, {3, 2}, {3, 4}, {4, 1}, {4, 3}, {4, 5}, {5, 2}, {5, 4}]
    assert MazeGenerator.all_walls(5, 7) == [{1, 2}, {1, 4}, {2, 1}, {2, 3}, {2, 5}, {3, 2}, {3, 4}]
  end

  test 'all_cells creates a list of cells' do
    assert MazeGenerator.all_cells(5, 5) == [{1, 1}, {3, 1}, {1, 3}, {3, 3}]
    assert MazeGenerator.all_cells(5, 7) == [{1, 1}, {3, 1}, {1, 3}, {3, 3}, {1, 5}, {3, 5}]
  end

  test 'all_sets' do
    assert MazeGenerator.all_sets([{1, 1}, {3, 1}]) == [[{1, 1}], [{3, 1}]]
  end

  test 'merge_sets_arround_wall merges set' do
    assert MazeGenerator.merge_sets_arround_wall([[{1, 1}], [{1, 3}]], {1, 2}) == {true, [[{1, 1}, {1, 3}]]}
    assert MazeGenerator.merge_sets_arround_wall([[{1, 1}], [{3, 1}]], {2, 1}) == {true, [[{1, 1}, {3, 1}]]}
    assert MazeGenerator.merge_sets_arround_wall([[{1, 1}], [{3, 1}], [{7, 7}]], {2, 1}) == {true, [[{7, 7}], [{1, 1}, {3, 1}]]}
  end

  test 'wall_neighbourghs returns cells around wall' do
    assert MazeGenerator.wall_neighbourghs({1, 2}) == [{1, 1}, {1, 3}]
    assert MazeGenerator.wall_neighbourghs({2, 1}) == [{1, 1}, {3, 1}]
  end

  test 'concats cells with walls' do
    assert MazeGenerator.cells_with_walls([[{1, 1}], [{1, 3}], [{3, 3}]], [{1, 2}, {2, 3}], []) |> Enum.sort == [{1, 2}, {2, 3}]
  end
end
