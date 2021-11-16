defmodule Transactions do
  @moduledoc """
  Transactions keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Transactions.Accounts.Account
  alias Transactions.Users.Inputs.UserInput
  alias Transactions.Users.User

  @spec create_user(%UserInput{}) :: {:error} | {:ok, map()}
  defdelegate create_user(params), to: User.Create, as: :call

  defdelegate req_withdraw(params), to: Account.Withdraw, as: :call
  defdelegate req_transference(params), to: Account.Transference, as: :call
end
