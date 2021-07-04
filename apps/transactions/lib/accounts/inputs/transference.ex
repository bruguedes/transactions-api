defmodule Transactions.Accounts.Inputs.Transference do
  @moduledoc """
  Input data for new transference.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Transactions.Accounts.Inputs.CustomValidate, as: Validate

  @required [:source_account, :requested_amount, :target_account]

  @primary_key false
  embedded_schema do
    field(:source_account, :string)
    field(:target_account, :string)
    field(:requested_amount, :integer)
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_length(:source_account, min: 5, max: 5)
    |> validate_length(:target_account, min: 5, max: 5)
    |> Validate.account_is_integer(:source_account)
    |> Validate.account_is_integer(:target_account)
    |> apply_action(:trasference)
  end
end
