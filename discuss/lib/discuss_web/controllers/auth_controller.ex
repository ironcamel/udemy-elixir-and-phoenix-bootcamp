defmodule Discuss.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  alias Discuss.Repo
  alias Discuss.User

  def callback(conn, params) do
    %{assigns: %{ueberauth_auth: auth}} = conn
    user_params = %{
      email: auth.info.email,
      provider: "github",
      token: auth.credentials.token,
    }
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil -> Repo.insert(changeset)
      user -> {:ok, user }
    end
  end

end

#%{
#  ueberauth_auth: %Ueberauth.Auth{
#    credentials: %Ueberauth.Auth.Credentials{
#      expires: false,
#      expires_at: nil,
#      other: %{},
#      refresh_token: nil,
#      scopes: [""],
#      secret: nil,
#      token: "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",
#      token_type: "Bearer"
#    },
#    extra: %Ueberauth.Auth.Extra{
#      raw_info: %{
#        token: %OAuth2.AccessToken{
#          access_token: "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",
#          expires_at: nil,
#          other_params: %{"scope" => ""},
#          refresh_token: nil,
#          token_type: "Bearer"
#        },
#        user: %{
#          "avatar_url" => "https://avatars.githubusercontent.com/u/108419667?v=4",
#          "bio" => nil,
#          "blog" => "",
#          "company" => nil,
#          "created_at" => "2022-06-29T15:40:34Z",
#          "email" => "nmassjou@estee.com",
#          "events_url" => "https://api.github.com/users/nmassjou_elcomp/events{/privacy}",
#          "followers" => 0,
#          "followers_url" => "https://api.github.com/users/nmassjou_elcomp/followers",
#          "following" => 0,
#          "following_url" => "https://api.github.com/users/nmassjou_elcomp/following{/other_user}",
#          "gists_url" => "https://api.github.com/users/nmassjou_elcomp/gists{/gist_id}",
#          "gravatar_id" => "",
#          "hireable" => nil,
#          "html_url" => "https://github.com/nmassjou_elcomp",
#          "id" => 108419667,
#          "location" => nil,
#          "login" => "nmassjou_elcomp",
#          "name" => "Massjouni, Naveed",
#          "node_id" => "U_kgDOBnZaUw",
#          "organizations_url" => "https://api.github.com/users/nmassjou_elcomp/orgs",
#          "public_gists" => 0,
#          "public_repos" => 0,
#          "received_events_url" => "https://api.github.com/users/nmassjou_elcomp/received_events",
#          "repos_url" => "https://api.github.com/users/nmassjou_elcomp/repos",
#          "site_admin" => false,
#          "starred_url" => "https://api.github.com/users/nmassjou_elcomp/starred{/owner}{/repo}",
#          "subscriptions_url" => "https://api.github.com/users/nmassjou_elcomp/subscriptions",
#          "twitter_username" => nil,
#          "type" => "User",
#          "updated_at" => "2022-08-21T06:04:47Z",
#          "url" => "https://api.github.com/users/nmassjou_elcomp"
#        }
#      }
#    },
#    info: %Ueberauth.Auth.Info{
#      birthday: nil,
#      description: nil,
#      email: "nmassjou@estee.com",
#      first_name: nil,
#      image: "https://avatars.githubusercontent.com/u/108419667?v=4",
#      last_name: nil,
#      location: nil,
#      name: "Massjouni, Naveed",
#      nickname: "nmassjou_elcomp",
#      phone: nil,
#      urls: %{
#        api_url: "https://api.github.com/users/nmassjou_elcomp",
#        avatar_url: "https://avatars.githubusercontent.com/u/108419667?v=4",
#        blog: "",
#        events_url: "https://api.github.com/users/nmassjou_elcomp/events{/privacy}",
#        followers_url: "https://api.github.com/users/nmassjou_elcomp/followers",
#        following_url: "https://api.github.com/users/nmassjou_elcomp/following{/other_user}",
#        gists_url: "https://api.github.com/users/nmassjou_elcomp/gists{/gist_id}",
#        html_url: "https://github.com/nmassjou_elcomp",
#        organizations_url: "https://api.github.com/users/nmassjou_elcomp/orgs",
#        received_events_url: "https://api.github.com/users/nmassjou_elcomp/received_events",
#        repos_url: "https://api.github.com/users/nmassjou_elcomp/repos",
#        starred_url: "https://api.github.com/users/nmassjou_elcomp/starred{/owner}{/repo}",
#        subscriptions_url: "https://api.github.com/users/nmassjou_elcomp/subscriptions"
#      }
#    },
#    provider: :github,
#    strategy: Ueberauth.Strategy.Github,
#    uid: 108419667
#  }
#}
