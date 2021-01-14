defmodule TeacherWeb.SessionController do
  use TeacherWeb, :controller

  alias Teacher.Auth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def notify_sign_in(user) do
    Phoenix.PubSub.broadcast(Teacher.PubSub, "current_users", {:sign_in, user.id})
  end

  def notify_sign_in(user_id) do
    Phoenix.PubSub.broadcast(Teacher.PubSub, "current_users", {:sign_out, user_id})
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Auth.sign_in(email, password) do
      {:ok, user} ->
        notify_sign_in(user)

        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "You have signed in successfully")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid Email or Password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> get_session(:current_user_id)
    |> notify_sign_out()

    conn
    |> delete_session(:current_user_id)
    |> put_flash(:error, "You have signed out")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
