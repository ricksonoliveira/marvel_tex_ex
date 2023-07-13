defmodule TenExTakeHomeWeb.CharactersLive do
  @moduledoc """
  LiveView for handling Characters page.
  """
  alias TenExTakeHome.Timestamps.Repositories.SuccessfullTimestampRepository
  use TenExTakeHomeWeb, :live_view

  alias TenExTakeHome.Services.Api.MarvelService

  def mount(_params, _session, socket) do
    {:ok, fetch_characters_from_api(socket, 1)}
  end

  def handle_event("previous_page", _, socket) do
    new_page = socket.assigns.page - 10
    {:noreply, fetch_characters_from_api(socket, new_page)}
  end

  def handle_event("next_page", _, socket) do
    new_page = socket.assigns.page + 10
    {:noreply, fetch_characters_from_api(socket, new_page)}
  end

  defp fetch_characters_from_api(socket, page) do
    case MarvelService.fetch_characters(page) do
      {:ok, %{names: characters, total: total}} ->
        assign(socket,
          characters: characters,
          page: page,
          per_page: 10,
          total: total,
          success_timestamp: get_successfull_timestamp(),
          error: nil
        )

      {:error, reason} ->
        assign(socket, characters: [], page: nil, per_page: nil, error: reason)
    end
  end

  defp get_successfull_timestamp do
    case SuccessfullTimestampRepository.get_latest_successfull_timestamps() do
      st when not is_nil(st) ->
        "#{format_digits(st.success.month)}/#{format_digits(st.success.day)}/#{st.success.year} #{st.success.hour}:#{st.success.minute}"

      nil ->
        ""
    end
  end

  defp format_digits(digits), do: digits |> Integer.to_string() |> String.pad_leading(2, "0")

  defp error_placeholder(assigns) do
    ~H"""
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
      <strong class="font-bold">Holy smokes!</strong>
      <span class="block sm:inline">Something seriously bad happened.</span>
      <span class="block">
        Looks like server returned an error, please check back a little later.
      </span>
      <span class="absolute top-0 bottom-0 right-0 px-4 py-3">
        <svg
          class="fill-current h-6 w-6 text-red-500"
          role="button"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 20 20"
        >
        </svg>
      </span>
    </div>
    """
  end
end
