defmodule ElAbirynth.GameAgent do
  alias ElAbirynth.Game

  def start_link(opts) do
    Agent.start_link fn -> ElAbirynth.Game.new end, opts
  end

  def start_link() do
    Agent.start_link fn -> ElAbirynth.Game.new end
  end

  def get(game) do
    Agent.get(game, fn state -> state end)
  end

  def add_player(game, id) do
    Agent.update(game, fn state -> Game.add_player state, id end)
  end

  def move_player(game, id, direction) do
    Agent.update(game, fn state -> Game.move_player state, id, direction end)
  end

  def remove_player(game, id) do
    Agent.update(game, fn state -> Game.remove_player state, id end)
  end
end
