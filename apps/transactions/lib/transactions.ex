defmodule Transactions do
  @moduledoc """
  Transactions keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Transactions.Clients.Client
  alias Transactions.Accounts.Account

  defdelegate create_client(params), to: Client.Create, as: :call

  defdelegate req_withdraw(params), to: Account.Withdraw, as: :call
  defdelegate req_transference(params), to: Account.Transference, as: :call

  # defdelegate delete_client(params), to: Client.Delete, as: :call
  # defdelegate fetch_client(params), to: Client.Get, as: :call
end
