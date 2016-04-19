use Mix.Config
config :el_abirynth, ElAbirynth.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "el-abirynth.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :logger, level: :info
