defmodule Transactions.Accounts.Account.Withdraw do
  alias Transactions.Accounts.Account.GetAccount
  alias Transactions.Accounts.Inputs.Withdraw
  alias Transactions.Accounts.Schemas.Account
  alias Transactions.Repo
  import Ecto.Query

  require Logger

  @moduledoc """
    Executes the withdrawal transaction
  """
  @doc """
  functions:
    call(): makes the necessary calls to execute the withdrawal action.

    GetAccount.get(): searches for the account passed as a parameter to make the withdrawal.

    check_balance(): Checks whether the balance in the account is greater than or equal to that requested.

    withdraw(): Withdraws and updates the new account balance.

    response_withdraw(): Assemble the tuple that will be the return of the call () function that is being called by the withdraw function of
     of the transaction_controller module.
  """
  def call(%Withdraw{source_account: account, requested_amount: value} = _params) do
    Logger.info("withdrawal request")

    account
    |> GetAccount.get(:source_account)
    |> check_balance(value)
    |> withdraw
    |> response_withdraw
  end

  defp check_balance({:ok, account}, value) do
    %{balance: balance} = account

    case balance >= value do
      false ->
        Logger.warning("Insufficient funds")
        {:error, "Insufficient funds"}

      true ->
        {:ok, account, value}
    end
  end

  defp check_balance({:error, msg}, _value), do: {:error, msg}

  defp withdraw({:ok, account, value}) do
    Logger.info("withdrawal request made")

    %{id: id, balance: balance} = account
    new_balance = balance - value

    from(acc in Account, where: acc.id == ^id)
    |> Repo.update_all(set: [balance: new_balance])

    {:ok, account, value}
  end

  defp withdraw({:error, msg}), do: {:error, msg}

  defp response_withdraw({:ok, account, value}) do
    %{client: client, account: account, balance: balance} = Repo.preload(account, :client)

    current_balance = balance - value

    {:ok,
     %{
       message: "Withdrawal successful!",
       transaction_data: %{
         id: client.id,
         name: client.name,
         account: account,
         current_balance: current_balance,
         withdrawn_amount: value
       }
     }}
  end

  defp response_withdraw({:error, msg}), do: {:error, msg}
end
