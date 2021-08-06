defmodule Transactions.Accounts.Inputs.CustomValidate do
  @moduledoc """
   validations custom
  """
  import Ecto.Changeset

  def account_is_integer(
        %{changes: %{}, valid?: true} = changeset,
        account_field
      ) do
    {_, account} = fetch_field(changeset, account_field)

    is_true =
      account
      |> String.to_integer()
      |> is_integer()

    if is_true, do: changeset
  rescue
    _ -> add_error(changeset, account_field, "invalid account number")
  end

  def account_is_integer(params, _), do: params
end
