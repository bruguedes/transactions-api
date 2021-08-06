defmodule Transactions.Accounts.Account.GetAccount do
  @moduledoc """
  performs query in the database using account number as
  search parameter
  """
  alias Transactions.Accounts.Schemas.Account
  alias Transactions.Repo

  @doc """
  get () function on success returns the tuple with
   {:ok, account_data}
  """
  def get(account, account_type) when is_binary(account) and is_atom(account_type) do
    case Repo.get_by(Account, account: account) do
      nil -> {:error, "#{account_type} account  not found!"}
      account -> {:ok, account}
    end
  end
end
