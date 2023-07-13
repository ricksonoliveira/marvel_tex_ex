defmodule TenExTakeHome.Shared.Cache.MarvelCharactersCacheTest do
  alias TenExTakeHome.Shared.Cache.MarvelCharactersCache
  use TenExTakeHome.DataCase, async: true

  @cache_key "characters:1"
  @characters [
    "Captain America",
    "Spider Man",
    "Wolverine"
  ]

  setup do
    on_exit(fn ->
      :ets.delete(:marvel, @cache_key) # Deletes data after test
    end)
    :ok
  end

  test "fetch_characters/1 should fetch characters from cache" do
    assert :ok == MarvelCharactersCache.save(@cache_key, @characters)
    assert {:ok, characters_from_cache} = MarvelCharactersCache.fetch_characters(@cache_key)
    assert characters_from_cache == @characters
  end

  test "fetch_characters/1 should save characters in cache" do
    assert {:not_found, []} == MarvelCharactersCache.fetch_characters(@cache_key)
    assert :ok == MarvelCharactersCache.save(@cache_key, @characters)
    assert {:ok, characters_from_cache} = MarvelCharactersCache.fetch_characters(@cache_key)
    assert characters_from_cache |> Enum.count() > 1
  end
end
