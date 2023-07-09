defmodule TenExTakeHome.HashGenerator do
  @moduledoc """
  HashGenerator responsible to generate hash according to the auth rules.
  """

  @doc """
  Generate MD5 digested hash based of timestamp, private_key and api_key

  ## Examples
  HashGenerator.generate_md5(1688929621, "123", "abcd")
  91c3076570f650e6c46fbfa006221e70
  """
  def generate_md5(timestamp, private_key, api_key) when is_integer(timestamp) do
    generate_md5(timestamp |> Integer.to_string, private_key, api_key)
  end

  def generate_md5(timestamp, private_key, api_key) do
    string_to_hash = "#{timestamp}#{private_key}#{api_key}"

    :crypto.hash(:md5, string_to_hash)
    |> Base.encode16(case: :lower)
  end
end
