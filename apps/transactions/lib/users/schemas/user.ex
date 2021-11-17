defmodule Transactions.Users.Schemas.User do
  @moduledoc """
  schemas table clients
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Transactions.Accounts.Schemas.Account
  alias Transactions.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_params [:address, :cep, :cpf, :email, :name, :password_hash]
  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  schema "users" do
    field(:address, :string)
    field(:cep, :string)
    field(:cpf, :string)
    field(:email, :string)
    field(:name, :string)
    field(:password_hash, :string)

    has_one(:account, Account)

    timestamps()
  end

  @doc false
  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint([:email])
    |> unique_constraint([:cpf])
  end

  @spec insert(User.t()) :: {:ok, %__MODULE__{}} | {:error, %Ecto.Changeset{}}
  def insert(params) do
    params
    |> Repo.insert()
    |> case do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
