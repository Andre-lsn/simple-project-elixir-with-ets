defmodule UsersTest do
  use ExUnit.Case

  describe "init/1" do
    test "when create new table" do
      assert :users == Users.init(:users, [:named_table])
    end
  end

  describe "insert_user/2" do
    test "when found table, insert the user" do
      Users.init(:users, [:named_table])

      Users.insert_user(:users, {1, %{"name" => "Andre", "age" => 21}})

      assert Users.search_user_by_key(:users, 1) == %{
               "user_data" => %{"age" => 21, "name" => "Andre"},
               "user_id" => 1
             }
    end

    test "when not found table, returns error" do
      Users.init(:users, [:named_table])

      assert Users.insert_user(:not_exist_table, {1, %{"name" => "Andre", "age" => 21}}) ==
               {:error, :this_table_not_exist}
    end
  end

  describe "delete_user/2" do
    test "when found user, delete user" do
      Users.init(:users, [:named_table])
      Users.insert_user(:users, {1, %{"name" => "Andre", "age" => 21}})

      assert Users.delete_user(:users, 1) == {:ok, "User deleted"}
    end

    test "when not found user, returns user not found" do
      Users.init(:users, [:named_table])
      not_exist_id = 999

      assert Users.delete_user(:users, not_exist_id) == {:user_not_found}
    end
  end

  describe "search_user_by_key/2" do
    test "when found user, return user" do
      Users.init(:users, [:named_table])
      Users.insert_user(:users, {1, %{"name" => "Andre", "age" => 21}})

      assert Users.search_user_by_key(:users, 1) == %{
               "user_data" => %{"age" => 21, "name" => "Andre"},
               "user_id" => 1
             }
    end

    test "when not found user, returns user not found" do
      Users.init(:users, [:named_table])
      not_exist_id = 999

      assert Users.search_user_by_key(:users, not_exist_id) ==
               {:error, %{message: "User not found in erlang team storage"}}
    end
  end

  describe "get_all_users/0" do
    test "when found user, return user" do
      Users.init(:users, [:named_table])
      users_id = [1, 2]

      users = Enum.map(users_id, fn user_id ->
        Users.insert_user(:users, {user_id, %{}})
      end)

      assert length(users) == 2
      assert is_list(users) == true
    end

    test "when not found users, return empty list" do
      Users.init(:users, [:named_table])

      assert Users.get_all_users(:users) == []
    end

    test "when not found table, returns error table not exist" do
     not_exist_table = :not_exist

     assert Users.get_all_users(not_exist_table) == {:error, :this_table_not_exist}
    end
  end
end
