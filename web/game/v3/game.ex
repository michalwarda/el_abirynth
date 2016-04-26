defmodule ElAbirynth.V3.Game do
  alias ElAbirynth.V3.MazeGenerator

  def generate_maze do
    MazeGenerator.new(27, 15)
  end

  def new(players \\ %{}) do
    %{map: generate_maze, players: players}
  end

  def add_player(game, id) do
    %{game | players: Map.put(game[:players], id, %{x: 1, y: 13})}
  end

  def reset_players do
    fn {id, _}, new_players -> Map.put new_players, id, %{x: 1, y: 13} end
  end

  def remove_player(game, id) do
    %{game | players: game[:players] |> Map.delete(id)}
  end

  def move_player(game, id, direction) do
    player = game[:players][id]

    moves = %{
      "down" => %{x: player[:x], y: player[:y] + 1},
      "up" => %{x: player[:x], y: player[:y] - 1},
      "right" => %{x: player[:x] + 1, y: player[:y]},
      "left" => %{x: player[:x] - 1, y: player[:y]},
    }

    new_position_value = game[:map]
    |> Enum.at(moves[direction][:y])
    |> Enum.at(moves[direction][:x])

    case new_position_value do
      1 -> game
      3 -> %{game | map: generate_maze, players: game.players |> Enum.reduce(%{}, reset_players)}
      _ -> %{game | players: %{game[:players] | id => moves[direction]}}
    end
  end
end
