defmodule ElAbirynth.V3.GameGenServer do
  alias ElAbirynth.V3.GameAgent
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :tick, 16)
    {:ok, state}
  end

  def handle_info(:tick, _) do
    ElAbirynth.Endpoint.broadcast!("games:lobby", "game", GameAgent.get(GameStateV3))
    Process.send_after(self(), :tick, 16)
    {:noreply, %{}}
  end
end
