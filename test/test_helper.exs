ExUnit.start

Mix.Task.run "ecto.create", ~w(-r ElAbirynth.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r ElAbirynth.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(ElAbirynth.Repo)

