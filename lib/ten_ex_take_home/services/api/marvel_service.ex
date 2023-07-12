defmodule TenExTakeHome.Services.Api.MarvelService do
  @moduledoc """
  MarvelService wrapper for Marvel Api.
  """
  alias TenExTakeHome.HashGenerator
  @doc """
  Fetch characters name from Marvel API.
  """
  def fetch_characters(page \\ 1) do
    case cache_client().fetch_characters("marvel-characters:#{page}") do
      {:ok, characters} ->
        {:ok, characters}

      {:not_found, _} ->
        fetch_characters_from_api(page)
    end
  end

  defp fetch_characters_from_api(page) do
    timestamp = Integer.to_string(System.system_time(:second))
    {public_key, private_key} = get_keys()

    url = build_url(timestamp, public_key, private_key, page)
    response = http_client().get(url)
    case response do
      {:ok, %{body: body, status_code: status_code}}
        when status_code >= 200 and status_code <= 299 ->
          characters_parsed = parse_characters(body)
          cache_client().save("marvel-characters:#{page}", characters_parsed)
          {:ok, characters_parsed}

      {:ok, %HTTPoison.Response{body: body, status_code: _status_code}} ->
        {:error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp get_keys do
    {System.fetch_env!("MARVEL_PUBLIC_KEY"), System.fetch_env!("MARVEL_PRIVATE_KEY")}
  end

  defp build_url(timestamp, public_key, private_key, page) do
    hash = HashGenerator.generate_md5(timestamp, private_key, public_key)

    "#{System.fetch_env!("MARVEL_CHARACTERS_URL")}?ts=#{timestamp}&apikey=#{public_key}&hash=#{hash}&limit=10&offset=#{page}"
  end

  defp parse_characters(body) do
    body = Jason.decode!(body)
    %{names: Enum.map(body["data"]["results"], &(&1["name"])), total: body["data"]["total"]}
  end

  defp http_client do
    Application.get_env(:ten_ex_take_home, :http_client)
  end

  defp cache_client do
    Application.get_env(:ten_ex_take_home, :cache_client)
  end
end
