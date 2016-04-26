defmodule ElAbirynth.V3.GameChannel do
  use ElAbirynth.Web, :channel
  alias ElAbirynth.V3.GameAgent

  def join("games:lobby", _, socket) do
    GameAgent.add_player(GameStateV3, socket.assigns.id)
    {:ok, %{id: socket.assigns.id}, socket}
  end

  def handle_in("move_player", %{"direction" => direction}, socket) do
    GameAgent.move_player(GameStateV3, socket.assigns.id, direction)
    {:noreply, socket}
  end

  def terminate(_message, socket) do
    GameAgent.remove_player(GameStateV3, socket.assigns.id)
  end
end
