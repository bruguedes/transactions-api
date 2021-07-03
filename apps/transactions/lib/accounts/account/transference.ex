defmodule Transactions.Accounts.Account.Transference do
  @moduledoc """
  Executa as ações necessarias para executar a trasferencia entre contas.
  """
  import Ecto.Query
  alias Transactions.Accounts.Account.GetAccount
  alias Transactions.Accounts.Inputs.Transference
  alias Transactions.Accounts.Schemas.Account
  alias Transactions.Repo

  require Logger

  @doc """
  functions:
     call(): queries the source account and checks for available balance
                         for transfer and validates the existence of the destination account.
     perform_transfer():performs the withdrawal of value or credits the amount, type of action and determined
                         through: to_remove or: credit, passed as a parameter together with account and value.
     response_trasference():Assemble the tuple that will be the return of the call () function that is being called by the trasference function of the
     of the transaction_controller module.
  """
  def call(
        %Transference{
          source_account: account_origin,
          target_account: account_destiny,
          requested_amount: value
        } = _params
      ) do
    Logger.info("Trasference request")

    with {:ok, origin} <- GetAccount.get(account_origin),
         {:ok, destiny} <- GetAccount.get(account_destiny),
         true <- origin.balance >= value do
      updated_source_balance = perform_transfer(origin, value, :to_remove)

      updated_destination_balance = perform_transfer(destiny, value, :credit)

      response_trasference(updated_source_balance, updated_destination_balance, value)
    else
      {:error, origin} -> {:error, origin}
      {:error, destiny} -> {:error, destiny}
      false -> {:error, "Insufficient funds"}
    end
  end

  def perform_transfer(account, value, operation) do
    case operation do
      :to_remove ->
        current_balance = Map.get(account, :balance)
        Map.put(account, :balance, current_balance - value)

      :credit ->
        current_balance = Map.get(account, :balance)
        Map.put(account, :balance, current_balance + value)
    end
  end

  defp response_trasference(account_origin, account_destiny, value) do
    %{id: id_o, client: client_o, account: account_o, balance: balance_o} =
      Repo.preload(account_origin, :client)

    from(acc in Account, where: acc.id == ^id_o)
    |> Repo.update_all(set: [balance: balance_o])

    %{id: id_d, client: client_d, account: account_d, balance: balance_d} =
      Repo.preload(account_destiny, :client)

    from(acc in Account, where: acc.id == ^id_d)
    |> Repo.update_all(set: [balance: balance_d])

    {:ok,
     %{
       client_origin_name: client_o.name,
       source_account: account_o,
       current_balance: balance_o,
       transferred_value: value,
       client_destiny_name: client_d.name,
       target_account: account_d
     }}
  end
end
