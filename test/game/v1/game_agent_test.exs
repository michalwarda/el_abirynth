defmodule ElAbirynth.V1.GameAgentTest do
  alias ElAbirynth.V1.Game
  alias ElAbirynth.V1.GameAgent

  use ExUnit.Case, async: true
  test "get game returns game" do
    {:ok, game} = GameAgent.start_link
    assert GameAgent.get(game) == Game.new
  end

  test "add player adds player" do
    {:ok, game} = GameAgent.start_link
    GameAgent.add_player(game, 1)
    assert GameAgent.get(game) == Game.new |> Game.add_player(1)
  end

  test "move player moves player" do
    {:ok, game} = GameAgent.start_link
    GameAgent.add_player(game, 1)
    GameAgent.move_player(game, 1, "up")
    assert GameAgent.get(game) == Game.new |> Game.add_player(1) |> Game.move_player(1, "up")
    GameAgent.move_player(game, 1, "down")
    assert GameAgent.get(game) == Game.new |> Game.add_player(1) |> Game.move_player(1, "down")
  end

  test "remove player removes player" do
    {:ok, game} = GameAgent.start_link
    GameAgent.add_player(game, 1)
    GameAgent.remove_player(game, 1)
    assert GameAgent.get(game) == Game.new |> Game.add_player(1) |> Game.remove_player(1)
  end
end
