defmodule TenExTakeHome.Timestamps.Repositories.SuccessfullTimestampRepository do
  @moduledoc """
  SuccessfullTimestamp to handle context.
  """
  alias TenExTakeHome.{Repo, Timestamps.Entities.SuccessfullTimestamp}

  import Ecto.Query, warn: false

  @doc """
  Creates a Successfull Timestamp for an api call
  """
  def create_successfull_timestamp(attrs \\ %{}) do
    %SuccessfullTimestamp{}
    |> SuccessfullTimestamp.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets latest successfull timestamp for api call
  """
  def get_latest_successfull_timestamps do
    query =
      from st in SuccessfullTimestamp,
      order_by: [desc: st.inserted_at],
      select: %{id: st.id, success: st.success},
      limit: 1

    case Repo.one(query) do
      st when not is_nil(st) -> st
      _ -> nil
    end
  end
end
