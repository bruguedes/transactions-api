defmodule Transactions.Clients.Client.Changeset do
  @moduledoc """
  validates the input data according to the rules required by the changeset
  """
  @doc """
  Validates that the data passed as a parameter of the conn,
  is in accordance with the requested.
  """
  import Ecto.Changeset
  alias Transactions.Clients.Schemas.Client

  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  @required_params [:name, :email, :email_confirmation]
  @email_regex ~r/^[A-Za-z0-9\._%+\-+']+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,4}$/
  def changeset(params) do
    %Client{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_format(:email, @email_regex)
    |> validate_format(:email_confirmation, @email_regex)
    |> validate_confirmation(:email, message: "Email and confirmation must be the same")
  end
end
