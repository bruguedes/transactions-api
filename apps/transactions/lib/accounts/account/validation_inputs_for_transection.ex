defmodule Transactions.Accounts.Account.ValidationInputsForTransection do
  @moduledoc """
  Input data for calling insert_new_author/1.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @required [:source_account, :requested_amount]
  @optional [:target_account]

  @primary_key false
  embedded_schema do
    field(:source_account, :string)
    field(:target_account, :string)
    field(:requested_amount, :integer)
  end

  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:source_account, min: 5, max: 5)
    |> validate_length(:target_account, min: 5, max: 5)
  end
end
