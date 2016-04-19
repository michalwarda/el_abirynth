defmodule ElAbirynth.GameTest do
  use ExUnit.Case
  alias ElAbirynth.Game

  test "new game returns an array" do
    assert Game.new == %{
      map: [
        [1, 1, 1, 1, 1],
        [1, 2, 1, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 1, 0, 1],
        [1, 1, 1, 3, 1],
      ],
      players: %{},
    }
  end

  test "add player adds a player at start point" do
    assert %{players: %{1 => %{x: 1, y: 1}}} = Game.new |> Game.add_player(1)
  end

  test "move player moves player in the specified direction" do
    game = Game.new |> Game.add_player(1)
    assert %{x: 1, y: 2} = Game.move_player(game, 1, 'down')[:players][1]
  end

  test "remove player removes player from game" do
    game = Game.new |> Game.add_player(1) |> Game.remove_player(1)
    assert %{} = game[:players]
  end

  test "move player is'nt allowed when moving into wall" do
    game = Game.new |> Game.add_player(1)
    assert_raise RuntimeError, fn ->
      game |> Game.move_player(1, 'up')
    end
  end

  test "game restarts when player reaches end" do
    game = Game.new
    |> Game.add_player(1)
    |> Game.move_player(1, 'down')
    |> Game.move_player(1, 'right')
    |> Game.move_player(1, 'right')
    |> Game.move_player(1, 'down')
    |> Game.move_player(1, 'down')
    assert %{x: 1, y: 1} = game[:players][1]
  end
end
