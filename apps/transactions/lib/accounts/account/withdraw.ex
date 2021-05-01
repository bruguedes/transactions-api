defmodule Transactions.Accounts.Account.Withdraw do
  alias Transactions.Accounts.Account.ValidationInputs_for_Transection
  alias Transactions.Accounts.Schemas.Account
  alias Transactions.Accounts.Account.GetAccount
  alias Transactions.Repo
  import Ecto.Query

  require Logger

  @doc """
  functions:
    call(): makes the necessary calls to execute the withdrawal action.

    inputs_checked():checks if the return of the input validations are
    valid, in case of {: ok, map}, matches the patterns, and calls the
    private functions responsible for the execution of the task.

    GetAccount.get(): searches for the account passed as a parameter to make the withdrawal.

    check_balance(): Checks whether the balance in the account is greater than or equal to that requested.

    withdraw(): Withdraws and updates the new account balance.

    response_withdraw(): Assemble the tuple that will be the return of the call () function that is being called by the withdraw function of
     of the transaction_controller module.
  """
  def call(params) do
    Logger.info("withdrawal request")

    params
    |> ValidationInputs_for_Transection.build()
    |> inputs_checked()
  end

  defp inputs_checked({:ok, imputs}) do
    %{source_account: account, requested_amount: value} = imputs

    account
    |> GetAccount.get()
    |> check_balance(value)
  end

  defp inputs_checked({:error, imputs}), do: {:error, imputs}

  defp check_balance({:ok, account}, value) do
    %{balance: balance} = account

    case balance >= value do
      false ->
        Logger.warning("Insufficient funds")
        {:error, "Insufficient funds"}

      true ->
        withdraw(account, value)
    end
  end

  defp check_balance({:error, msg}, _value), do: {:error, msg}

  defp withdraw(account, value) do
    Logger.info("withdrawal request made")

    %{id: id, balance: balance} = account
    new_balance = balance - value

    from(acc in Account, where: acc.id == ^id)
    |> Repo.update_all(set: [balance: new_balance])

    response_withdraw(account, value)
  end

  defp response_withdraw(struct_account, value) do
    %{client: client, account: account, balance: balance} = Repo.preload(struct_account, :client)

    current_balance = balance - value

    {:ok,
     %{
       id: client.id,
       name: client.name,
       account: account,
       current_balance: current_balance,
       withdrawn_amount: value
     }}
  end
end
