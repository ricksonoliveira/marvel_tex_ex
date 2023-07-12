# Define dynamic mocks
Mox.defmock(HTTPoison.BaseMock, for: HTTPoison.Base)
Mox.defmock(MarvelCharactersCacheMock, for: TenExTakeHome.Behaviours.MarvelCharactersCacheBehaviour)

# Override the config settings
Application.put_env(:ten_ex_take_home, :http_client, HTTPoison.BaseMock)
Application.put_env(:ten_ex_take_home, :cache_client, MarvelCharactersCacheMock)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(TenExTakeHome.Repo, :manual)
