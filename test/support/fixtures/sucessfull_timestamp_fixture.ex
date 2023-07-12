defmodule TenExTakeHome.SuccessfullTimestampFixture do
  alias TenExTakeHome.Timestamps.Repositories.SuccessfullTimestampRepository

  def create_succesfull_timestamp do
    {:ok, successfull_timestamp} =
    SuccessfullTimestampRepository.create_successfull_timestamp(%{success: DateTime.utc_now()})

    successfull_timestamp
  end
end
