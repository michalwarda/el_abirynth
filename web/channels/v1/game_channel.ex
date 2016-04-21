defmodule ElAbirynth.V1.GameChannel do
  use ElAbirynth.Web, :channel
  alias ElAbirynth.V1.GameAgent

  def join("games:lobby", _, socket) do
    GameAgent.add_player(GameStateV1, socket.assigns.id)
    send(self, :after_join)
    {:ok, %{id: socket.assigns.id}, socket}
  end

  def handle_info(:after_join, socket) do
    socket |> broadcast("game", GameAgent.get(GameStateV1))
    {:noreply, socket}
  end

  def handle_in("move_player", %{"direction" => direction}, socket) do
    GameAgent.move_player(GameStateV1, socket.assigns.id, direction)
    socket |> broadcast("game", GameAgent.get(GameStateV1))
    {:noreply, socket}
  end

  def terminate(_message, socket) do
    GameAgent.remove_player(GameStateV1, socket.assigns.id)
    socket |> broadcast("game", GameAgent.get(GameStateV1))
  end
end
