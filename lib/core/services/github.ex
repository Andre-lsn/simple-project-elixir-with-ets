defmodule Services.Github do
  @base_url "https://api.github.com/users/"

  alias Users.User

  def get_github_user_by_username(username) do
    case HTTPoison.get("#{@base_url}#{username}") do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        body
        |> Poison.decode()
        |> handle_decode()

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, %{message: "Not found account github with username: #{username}"}}
    end
  end

  defp handle_decode({:ok, user}) do
    User.build_user(user)
  end
end
