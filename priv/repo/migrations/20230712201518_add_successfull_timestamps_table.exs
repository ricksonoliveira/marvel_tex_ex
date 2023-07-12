defmodule TenExTakeHome.Repo.Migrations.AddSuccessfullTimestampsTable do
  use Ecto.Migration

  def change do
    create table :successfull_timestamps do
      add :success, :utc_datetime_usec

      timestamps()
    end
  end
end
