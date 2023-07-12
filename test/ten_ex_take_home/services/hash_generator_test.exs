defmodule TenExTakeHome.HashGeneratorTest do
  @moduledoc """
  HashGeneratorTest
  """
  use ExUnit.Case, async: true

  alias TenExTakeHome.HashGenerator

  test "hash_generator/3 will return the md5 digested hash based on given args" do
    timestamp = 1_625_827_200 |> Integer.to_string()
    private_key = "123"
    apikey = "abcd"
    assert "4ea2ac548dbb2b95d708dd0dc20b46bb" == HashGenerator.generate_md5(timestamp, private_key, apikey)
  end

  test "hash_generator/3 will return the md5 digested hash based on given args even when timestamp given as integer" do
    timestamp = 1_625_827_200
    private_key = "123"
    apikey = "abcd"
    assert "4ea2ac548dbb2b95d708dd0dc20b46bb" == HashGenerator.generate_md5(timestamp, private_key, apikey)
  end
end
