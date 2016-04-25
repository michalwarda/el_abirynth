defmodule ElAbirynth.V2.MazeGenerator do
  def new(width, height) do
    all_cells = all_cells(width, height)
    sets = all_sets(all_cells)
    removed_walls = concat_cells_with_walls(sets, all_walls(width, height), [])
    empty_cells = removed_walls ++ all_cells
    map = Enum.map(0..height - 1, fn(y) ->
      Enum.map(0..width - 1, fn(x) ->
        if Enum.member?(empty_cells, {x, y}), do: 0, else: 1
      end)
    end)
    map |> update_field(1, 1, 2) |> update_field(width - 2, height - 2, 3)
  end

  def update_field(map, x, y, new_val) do
    row = map |> Enum.at(y) |> List.update_at(x, fn(_) -> new_val end)
    map |> List.update_at(y, fn(_) -> row end)
  end

  def concat_cells_with_walls(cells, possible_walls, removed_walls) do
    if Enum.count(cells) == 1 do
      removed_walls
    else
      next_wall = possible_walls |> Enum.random
      next_possible_walls = List.delete(possible_walls, next_wall)
      {merged?, next_cells} = merge_sets_arround_wall(cells, next_wall)
      next_walls = []
      if merged? do
        next_walls = removed_walls ++ [next_wall]
      else
        next_walls = removed_walls
      end
      concat_cells_with_walls(next_cells, next_possible_walls, next_walls)
    end
  end

  def all_walls(width, height) do
    Enum.map(1..width - 2, fn(x) -> walls_in(x, height) end)
    |> Enum.reduce([], fn(x, acc) -> acc ++ x end)
  end

  def walls_in(x, height) do
    f = fn
      {x, y} when (rem(y, 2) == 0 and rem(x, 2) == 0) -> false
      {_, y} when rem(y, 2) == 0 -> true
      {x, _} when rem(x, 2) == 0 -> true
      _ -> false
    end

    Enum.map(1..height - 2, fn(y) -> {x, y} end) |> Enum.filter(f)
  end

  def all_cells(width, height) do
    f = fn
      {x, y} when (rem(y, 2) != 0 and rem(x, 2) != 0) -> true
      _ -> false
    end
    Enum.map(1..height - 2, fn(y) -> Enum.map(1..width - 2, fn(x) -> {x, y} end) end)
    |> Enum.reduce([], fn(x, acc) -> acc ++ x end)
    |> Enum.filter(f)
  end

  def all_sets(all_cells) do
    all_cells |> Enum.map(fn(cell) -> [cell] end)
  end

  def merge_sets_arround_wall(cell_sets, wall) do
    walls = wall_neighbourghs(wall)
    f = fn(cell_set) -> Enum.member?(cell_set, Enum.at(walls, 0)) or Enum.member?(cell_set, Enum.at(walls, 1)) end

    {nearby_sets, other_sets} = Enum.partition(cell_sets, f)
    if Enum.count(nearby_sets) == 2 do
      nearby_sets = nearby_sets |> Enum.reduce([], fn(x, acc) -> acc ++ x end)
      {true, other_sets ++ [nearby_sets]}
    else
      {false, cell_sets}
    end
  end

  def wall_neighbourghs({x, y}) do
    if rem(x, 2) == 0 do
      [{x - 1, y}, {x + 1, y}]
    else
      [{x, y - 1}, {x, y + 1}]
    end
  end
end
