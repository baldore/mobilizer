defmodule Mobilizer.CLI do
  use Application

  def start(_type, _args) do
    Mobilizer.putSomething "hola mundo genial"

    # A Supervisor is returned in order to prevent an error...
    # TODO: investigate why do I need this!
    Supervisor.start_link [], strategy: :one_for_one
  end
end
