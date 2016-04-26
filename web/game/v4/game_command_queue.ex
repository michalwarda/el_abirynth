defmodule ElAbirynth.V4.GameCommandQueue do
  alias ElAbirynth.V3.GameAgent
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(state) do
    Process.send_after(self(), :manage_queue, 333)
    {:ok, state}
  end

  def get(server) do
    GenServer.call(server, :get)
  end

  def add_move(server, player_queue) do
    GenServer.call(server, {:add_move, player_queue})
  end

  def handle_call({:add_move, player_queue}, _from, players_queue) do
    players_queue = (players_queue |> Enum.reject(fn({id, _}) -> id == elem(player_queue, 0) end)) ++ [player_queue]
    {:reply, players_queue, players_queue}
  end

  def handle_call(:get, _from, players_queue) do
    {:reply, players_queue, players_queue}
  end

  def handle_info(:manage_queue, queue) do
    queue = queue |> Enum.map(fn(player_queue = {player_id, {move_type, direction}}) ->
      GameAgent.move_player(GameStateV3, player_id, direction)
      case move_type do
        "swipe" -> player_queue
        "move" -> nil
      end
    end) |> Enum.filter(&(&1))

    Process.send_after(self(), :manage_queue, 333)
    {:noreply, queue}
  end
end
