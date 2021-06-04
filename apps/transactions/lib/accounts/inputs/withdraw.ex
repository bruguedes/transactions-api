defmodule Transactions.Accounts.Inputs.Withdraw do
  @moduledoc """
  embedded_schema withdraw
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required [:source_account, :requested_amount]

  @primary_key false
  embedded_schema do
    field(:source_account, :string)
    field(:requested_amount, :integer)
  end

  @doc false
  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_length(:source_account, min: 5, max: 5)
    |> apply_action(:insert)
  end
end
