defmodule ElAbirynth.Router do
  use ElAbirynth.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ElAbirynth do
    pipe_through :api
  end
end
