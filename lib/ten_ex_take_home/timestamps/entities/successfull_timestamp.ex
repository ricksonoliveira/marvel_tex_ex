defmodule TenExTakeHome.Timestamps.Entities.SuccessfullTimestamp do
  use Ecto.Schema
  import Ecto.Changeset

  schema "successfull_timestamps" do
    field :success, :utc_datetime

    timestamps()
  end

  def changeset(success_timestamp, attrs \\ %{}) do
    success_timestamp
    |> cast(attrs, [:success])
    |> validate_required([:success])
  end
end
