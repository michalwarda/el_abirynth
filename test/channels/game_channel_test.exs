defmodule ElAbirynth.GameChannelTest do
  use ElAbirynth.ChannelCase

  alias ElAbirynth.GameChannel

  setup do
    {:ok, socket} = connect(ElAbirynth.UserSocket, %{})
    {:ok, reply, socket} = subscribe_and_join(socket, GameChannel, "games:lobby")
    {:ok, reply: reply, socket: socket}
  end

  test "joining replies with random id and broadcasts game", %{reply: reply} do
    assert %{id: id} = reply
    players = %{id => %{x: 1, y: 1}}
    assert_broadcast "game", %{players: ^players}
  end

  test "move broadcasts game", %{socket: socket, reply: reply} do
    push socket, "move_player", %{"direction" => "down"}
    players = %{reply[:id] => %{x: 1, y: 2}}
    assert_broadcast "game", %{players: ^players}
  end

  test "leaving the channel removes player from game", %{socket: socket} do
    Process.unlink(socket.channel_pid)
    socket |> close
    players = %{}
    assert_broadcast "game", %{players: ^players}
  end
end
