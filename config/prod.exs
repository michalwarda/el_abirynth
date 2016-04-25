use Mix.Config
config :el_abirynth, ElAbirynth.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "http", host: "stark-refuge-21372.herokuapp.com"]

config :logger, level: :info
