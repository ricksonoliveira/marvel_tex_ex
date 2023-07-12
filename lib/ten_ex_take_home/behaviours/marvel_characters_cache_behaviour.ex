defmodule TenExTakeHome.Behaviours.MarvelCharactersCacheBehaviour do
  @callback fetch_characters(binary()) :: {:ok, map()} | {:not_found, binary()}
  @callback save(binary(), map()) :: {:ok, binary()} | {:error, binary()}
end
