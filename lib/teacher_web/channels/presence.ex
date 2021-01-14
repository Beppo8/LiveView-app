defmodule TeacherWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.
  """

  use Phoenix..Presence,
    otp_app: :teacher,
    pubsub_server: Teacher.PubSub
end
