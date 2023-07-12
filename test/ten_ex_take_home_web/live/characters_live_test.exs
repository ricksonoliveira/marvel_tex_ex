defmodule TenExTakeHomeWeb.CharactersLiveTest do
  use TenExTakeHomeWeb.ConnCase
  import Phoenix.LiveViewTest
  import Mox

  describe "Succesfully" do
    setup [:mock_successfull_service_calls]
    test "fetches and assigns characters from API on mount", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/")

      assert has_element?(view, "#characters") # Assert table id exists

      # Simulate next_page event by rendering the button click
      assert _view = render_click(view, "next_page", %{})
      assert _view = render_click(view, "previous_page", %{})

      assert html =~ "Captain America" # Assert rendered characters
      assert html =~ "Spider-Man" # Assert rendered characters
    end

    defp mock_successfull_service_calls(_conn) do
      expected_characters = ["Captain America", "Spider-Man"]

      expect(MarvelCharactersCacheMock, :fetch_characters, 4, fn _ -> {:not_found, "not found"} end)
      expect(HTTPoison.BaseMock, :get, 4, fn _url ->
        {:ok,
          %HTTPoison.Response{
            status_code: 200,
            body: build_response_body(expected_characters)
          }}
      end)
      expect(MarvelCharactersCacheMock, :save, 4, fn _, _ -> {:ok, []} end)
      :ok
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

  describe "Fails when" do
    setup [:mock_fail_service_calls]
    test "renders error placeholder component", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/")
      # Render the error placeholder component
      assert html =~ "Something seriously bad happened."
    end

    defp mock_fail_service_calls(_conn) do
      expect(MarvelCharactersCacheMock, :fetch_characters, 2, fn _ -> {:not_found, "not found"} end)
      expect(HTTPoison.BaseMock, :get, 2, fn _url ->
        {:ok,
          %HTTPoison.Response{
            status_code: 500,
            body: "Internal server error"
          }}
      end)
      :ok
    end
  end
end
