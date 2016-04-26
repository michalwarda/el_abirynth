defmodule ElAbirynth.V2.MazeGenerator do
  def new(width, height) do
    all_cells = all_cells(width, height)
    sets = all_sets(all_cells)
    removed_walls = cells_with_walls(sets, all_walls(width, height), [])
    empty_cells = removed_walls ++ all_cells
    map = Enum.map 0..height - 1, fn(y) ->
      Enum.map 0..width - 1, fn(x) ->
        if Enum.member?(empty_cells, {x, y}), do: 0, else: 1
      end
    end
    map |> update_field(1, 1, 2) |> update_field(width - 2, height - 2, 3)
  end

  def update_field(map, x, y, new_val) do
    row = map |> Enum.at(y) |> List.replace_at(x, new_val)
    map |> List.replace_at(y, row)
  end

  def cells_with_walls(cells, _, removed_walls) when length(cells) == 1 do
    removed_walls
  end

  def cells_with_walls(cells, possible_walls, removed_walls) do
    next_wall = possible_walls |> Enum.random
    next_possible_walls = List.delete(possible_walls, next_wall)
    {merged?, next_cells} = merge_sets_arround_wall(cells, next_wall)
    next_walls = if merged?, do: removed_walls ++ [next_wall], else: removed_walls
    cells_with_walls(next_cells, next_possible_walls, next_walls)
  end

  def all_walls(width, height) do
    1..width - 2 |> Enum.map(&walls_in(&1, height)) |> List.flatten
  end

  def walls_in(x, height) do
    filter = fn
      {x, y} when (rem(y, 2) == 0 and rem(x, 2) == 0) -> false
      {_, y} when rem(y, 2) == 0 -> true
      {x, _} when rem(x, 2) == 0 -> true
      _ -> false
    end

    1..height - 2 |> Enum.map(&({x, &1})) |> Enum.filter(filter)
  end

  def all_cells(width, height) do
    filter = fn
      {x, y} when (rem(y, 2) != 0 and rem(x, 2) != 0) -> true
      _ -> false
    end

    Enum.map(1..height - 2, fn(y) -> Enum.map(1..width - 2, &({&1, y})) end)
    |> List.flatten
    |> Enum.filter(filter)
  end

  def all_sets(all_cells) do
    all_cells |> Enum.map(&([&1]))
  end

  def merge_sets_arround_wall(cell_sets, wall) do
    walls = wall_neighbourghs(wall)
    filter = &(Enum.member?(&1, Enum.at(walls, 0)) or Enum.member?(&1, Enum.at(walls, 1)))

    {nearby_sets, other_sets} = cell_sets |> Enum.partition(filter)

    case Enum.count(nearby_sets) == 2 do
      true -> {true, other_sets ++ [nearby_sets |> List.flatten]}
      false -> {false, cell_sets}
    end
  end

  def wall_neighbourghs({x, y}) do
    case rem(x, 2) do
      0 -> [{x - 1, y}, {x + 1, y}]
      _ -> [{x, y - 1}, {x, y + 1}]
    end
  end
end
