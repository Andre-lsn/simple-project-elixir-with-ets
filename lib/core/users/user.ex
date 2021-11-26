defmodule Users.User do
  @enforce_keys ~w(name_github bio_github url_github)a
  defstruct [:name_github, :bio_github, :url_github, :user_github_id]

  def build_user(%{"id" => id, "name" =>  name, "bio" => bio, "url" => url}) do
    %__MODULE__{
      name_github: name,
      bio_github: bio,
      url_github: url,
      user_github_id: id
    }
  end
end
