defmodule TenExTakeHome.Services.Api.MarvelServiceTest do
  @moduledoc """
  MarvelServiceTest
  """
  use ExUnit.Case, async: true
  import Mox

  alias TenExTakeHome.Services.Api.MarvelService

  describe "fetch_characters/0" do
    setup do
      System.put_env("MARVEL_PUBLIC_KEY", "123")
      System.put_env("MARVEL_PRIVATE_KEY", "abcd")
      System.put_env("MARVEL_CHARACTERS_URL", "http://some-marvel-characters-url.com")
    end

    test "returns characters' names when API request is successful" do
      # Set up
      expected_characters = ["Captain America", "Spider-Man"]

      expect(HTTPoison.BaseMock, :get, fn _url ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: build_response_body(expected_characters)
         }}
      end)
      expect(MarvelCharactersCacheMock, :fetch_characters, fn _ -> {:not_found, "not found"} end)
      expect(MarvelCharactersCacheMock, :save, fn _, _ -> {:ok, []} end)
      # Act
      assert actual_result = MarvelService.fetch_characters()

      # Assert
      assert {:ok, %{names: actual_characters, total: total}} = actual_result
      assert expected_characters == actual_characters
      assert total == 100
    end

    test "returns error when API request fails" do
      # Set up
      expect(HTTPoison.BaseMock, :get, fn _url ->
        {:ok,
         %HTTPoison.Response{
           status_code: 500,
           body: "Internal server error"
         }}
      end)

      expect(MarvelCharactersCacheMock, :fetch_characters, fn _ -> {:not_found, "not found"} end)

      # Act
      actual_result = MarvelService.fetch_characters()

      # Assert
      assert {:error, actual_error} = actual_result
      assert "Internal server error" == actual_error
    end
  end

  defp build_response_body(characters) do
    Jason.encode!(%{
      "data" => %{
        "results" => Enum.map(characters, fn character -> %{"name" => character} end),
        "total" => 100
      }
    })
  end
end
