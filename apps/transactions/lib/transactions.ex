defmodule Transactions do
  @moduledoc """
  Transactions keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Transactions.Accounts.Account
  alias Transactions.Clients.Client
  alias Transactions.Clients.Inputs.ClientsCreate

  @spec create(%ClientsCreate{}) :: {:error} | {:ok, map()}
  defdelegate create(params), to: Client.Create, as: :create_client

  defdelegate req_withdraw(params), to: Account.Withdraw, as: :call
  defdelegate req_transference(params), to: Account.Transference, as: :call
end
