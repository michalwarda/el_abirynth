defmodule ElAbirynth.GameChannel do
  use ElAbirynth.Web, :channel
  alias ElAbirynth.GameAgent

  def join("games:lobby", _, socket) do
    GameAgent.add_player(GameState, socket.assigns.id)
    send(self, :after_join)
    {:ok, %{id: socket.assigns.id}, socket}
  end

  def handle_info(:after_join, socket) do
    socket |> broadcast("game", GameAgent.get(GameState))
    {:noreply, socket}
  end

  def handle_in("move_player", %{"direction" => direction}, socket) do
    GameAgent.move_player(GameState, socket.assigns.id, direction)
    socket |> broadcast("game", GameAgent.get(GameState))
  end

  def terminate(_message, socket) do
    GameAgent.remove_player(GameState, socket.assigns.id)
    socket |> broadcast("game", GameAgent.get(GameState))
  end
end
