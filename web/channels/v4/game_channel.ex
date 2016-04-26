defmodule ElAbirynth.V4.GameChannel do
  use ElAbirynth.Web, :channel
  alias ElAbirynth.V3.GameAgent
  alias ElAbirynth.V4.GameCommandQueue

  def join("games:lobby", _, socket) do
    GameAgent.add_player(GameStateV3, socket.assigns.id)
    {:ok, %{id: socket.assigns.id}, socket}
  end

  def handle_in("move_player", %{"direction" => "swipe_" <> direction}, socket) do
    GameCommandQueue.add_move(GameCommandState, {socket.assigns.id, {"swipe", direction}})
    {:noreply, socket}
  end

  def handle_in("move_player", %{"direction" => direction}, socket) do
    GameCommandQueue.add_move(GameCommandState, {socket.assigns.id, {"move", direction}})
    {:noreply, socket}
  end

  def terminate(_message, socket) do
    GameCommandQueue.remove_player(GameCommandState, socket.assigns.id)
    GameAgent.remove_player(GameStateV3, socket.assigns.id)
  end
end
