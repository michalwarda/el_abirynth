defmodule ElAbirynth.Game do
  def new(players \\ %{}) do
    %{
      map: [
        [1, 1, 1, 1, 1],
        [1, 2, 1, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 1, 0, 1],
        [1, 1, 1, 3, 1],
      ],
      players: players,
    }
  end

  def add_player(game, id \\ 0) do
    %{game | players: %{id => %{x: 1, y: 1}}}
  end

  def reset_players do
    fn {id, _}, new_players -> Map.put new_players, id, %{x: 1, y: 1} end
  end

  def remove_player(game, id) do
    %{game | players: game[:players] |> Map.delete(id)}
  end

  def move_player(game, id, direction) do
    player = game[:players][id]

    moves = %{
      'down' => %{x: player[:x], y: player[:y] + 1},
      'up' => %{x: player[:x], y: player[:y] - 1},
      'right' => %{x: player[:x] + 1, y: player[:y]},
      'left' => %{x: player[:x] - 1, y: player[:y]},
    }

    new_position_value = game[:map]
    |> Enum.at(moves[direction][:y])
    |> Enum.at(moves[direction][:x])

    case new_position_value do
      1 -> game
      3 -> %{game | players: game.players |> Enum.reduce(%{}, reset_players)}
      _ -> %{game | players: %{game[:players] | id => moves[direction]}}
    end
  end
end
