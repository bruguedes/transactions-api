defmodule Transactions.Accounts.Inputs.Withdraw do
  @moduledoc """
  embedded_schema withdraw
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Transactions.Accounts.Inputs.CustomValidate, as: Validate

  @required [:source_account, :requested_amount]

  @primary_key false
  embedded_schema do
    field(:source_account, :string)
    field(:requested_amount, :integer)
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_length(:source_account, min: 5, max: 5)
    |> Validate.account_is_integer(:source_account)
    |> apply_action(:withdraw)
  end
end
