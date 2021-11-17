defmodule Transactions.Users.Inputs.UserInput do
  @moduledoc """
  embedded_schema table users
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_params [:address, :cep, :cpf, :email, :name, :password]

  embedded_schema do
    field(:address, :string)
    field(:cep, :string)
    field(:cpf, :string)
    field(:email, :string)
    field(:name, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)
  end

  @email_regex ~r/^[A-Za-z0-9\._%+\-+']+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,4}$/

  @doc false
  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_format(:email, @email_regex)
    |> validate_length(:cep, is: 8)
    |> validate_length(:cpf, is: 11)
    |> validate_length(:password, min: 6)
    |> put_password_hash()
    |> apply_action(:insert)
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
