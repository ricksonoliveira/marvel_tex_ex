defmodule TenExTakeHome.Shared.Cache.MarvelCharactersCache do
  @db :marvel

  def fetch_characters(key), do: GenServer.call(@db, {:get, key})
  def save(key, value), do:  GenServer.cast(@db, {:put, key, value})
end
