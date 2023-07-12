defmodule TenExTakeHome.Timestamps.Repositories.SuccessfullTimestampRepositoryTest do
  alias TenExTakeHome.Timestamps.Entities.SuccessfullTimestamp
  alias TenExTakeHome.Timestamps.Repositories.SuccessfullTimestampRepository
  use TenExTakeHome.DataCase, async: true

  import TenExTakeHome.SuccessfullTimestampFixture

  @invalid_attrs %{success: nil}

  test "create_successfull_timestamp/1 with valid data creates a sucessfull timestamp" do
    valid_attrs = %{success: DateTime.utc_now()}

    assert {:ok, %SuccessfullTimestamp{} = st} =
             SuccessfullTimestampRepository.create_successfull_timestamp(valid_attrs)

    assert st.success == valid_attrs.success |> DateTime.truncate(:second)
  end

  test "create_successfull_timestamp/1 with invalid data returns error changeset" do
    assert response = SuccessfullTimestampRepository.create_successfull_timestamp(@invalid_attrs)
    assert {:error, %Ecto.Changeset{}} = response
    {:error, changeset} = response
    assert  "can't be blank" in errors_on(changeset).success
    assert %{success: ["can't be blank"]} = errors_on(changeset)
  end

  test "get_latest_successfull_timestamps/0 returns latest success timestamp" do
    st_fixture = create_succesfull_timestamp()
    assert st = SuccessfullTimestampRepository.get_latest_successfull_timestamps()
    assert st.id == st_fixture.id
    assert st.success == st_fixture.success
  end

  test "get_latest_successfull_timestamps/0 returns nil when no success timestamp" do
    assert nil == SuccessfullTimestampRepository.get_latest_successfull_timestamps()
  end
end
