defmodule Transactions.Clients.Inputs.ClientsCreate do
  @moduledoc """
  embedded_schema table clients
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:name, :email, :password, :password_confirmation, :email_confirmation]

  embedded_schema do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string)
    field(:password_confirmation, :string, virtual: true)
    field(:email_confirmation, :string, virtual: true)
  end

  @email_regex ~r/^[A-Za-z0-9\._%+\-+']+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,4}$/

  @doc false
  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_format(:email, @email_regex)
    |> validate_format(:email_confirmation, @email_regex)
    |> validate_confirmation(:email, message: "Email and confirmation must be the same")
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, message: "Does not match password")
    |> apply_action(:insert)
  end
end
