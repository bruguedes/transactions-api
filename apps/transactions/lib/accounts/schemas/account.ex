defmodule Transactions.Accounts.Schemas.Account do
  @moduledoc """
    schema table accounts
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Transactions.Clients.Schemas.Client

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_params [:account, :balance, :client_id]
  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  schema "accounts" do
    field :account, :string
    field :balance, :integer
    belongs_to :client, Client
    timestamps()
  end

  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
