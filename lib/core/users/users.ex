defmodule Users.Users do
  alias Services.Github
  alias Users.User

  @spec init(atom(), list()) :: atom()
  def init(table, options \\ [:named_table]) do
    :ets.new(table, options)
  end

  @spec insert_user(atom(), tuple()) :: true | false | {:error, :this_table_not_exist}
  def insert_user(table, username) do
    %User{user_github_id: user_id} = user = get_user_by_github_username(username)

    table
    |> table_exists?()
    |> handle_insert(table, {user_id, user})

    %{"user_id" => user_id}
  end

  def get_user_by_github_username(username) do
    Github.get_github_user_by_username(username)
  end

  @spec delete_user(atom(), integer()) :: {:user_not_found} | map()
  def delete_user(table, user_id) do
    table
    |> search_user_by_key(user_id)
    |> handle_delete(table, user_id)
  end

  @spec search_user_by_key(atom(), any()) :: map() | {:error, map()}
  def search_user_by_key(table, key) do
    table
    |> :ets.lookup(key)
    |> handle_search_user_by_key()
  end

  @spec get_all_users(atom()) :: list() | {:error, :this_table_not_exist}
  def get_all_users(table) do
    table
    |> table_exists?()
    |> handle_get_all_users(table)
  end

  defp handle_insert(true, table, user), do: :ets.insert_new(table, user)
  defp handle_insert(false, _table, _user), do: {:error, :this_table_not_exist}

  defp handle_delete(
         {:error, %{message: "User not found in erlang team storage"}},
         _table,
         _user
       ),
       do: {:user_not_found}

  defp handle_delete(_, table, user_id) do
    :ets.delete(table, user_id)

    {:ok, "User deleted"}
  end

  defp handle_search_user_by_key([user]) do
    {user_id, user_data} = user

    %{"user_id" => user_id, "user_data" => user_data}
  end

  defp handle_search_user_by_key([]),
    do: {:error, %{message: "User not found in erlang team storage"}}

  defp handle_get_all_users(true, table), do: :ets.tab2list(table)
  defp handle_get_all_users(false, _table), do: {:error, :this_table_not_exist}

  defp table_exists?(table) do
    case :ets.whereis(table) do
      :undefined -> false
      _table -> true
    end
  end
end
