defmodule ElAbirynth.V2.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "games:*", ElAbirynth.V2.GameChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket, timeout: 45_000
  transport :longpoll, Phoenix.Transports.LongPoll

  def connect(_params, socket) do
    {:ok, assign(socket, :id, SecureRandom.base64(8))}
  end

  def id(socket), do: "player:#{socket.assigns.id}"
end
