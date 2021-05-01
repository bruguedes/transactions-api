defmodule TransactionsWeb.OperationController do
  use TransactionsWeb, :controller

  action_fallback TransactionsWeb.FallbackController

  def withdraw(conn, params) do
    params
    |> Transactions.req_withdraw()
    |> handle_response_withdrawn(conn, 200, "Withdrawal successful!")
  end

  def transference(conn, params) do
    params
    |> Transactions.req_transference()
    |> handle_response_transference(conn, 200, "Transfer successfully completed!")
  end

  defp handle_response_withdrawn({:ok, account}, conn, status, msg) do
    %{
      id: id,
      name: name,
      account: account,
      current_balance: current_balance,
      withdrawn_amount: withdrawn_amount
    } = account

    for_encoder = %{
      status: status,
      transaction_data: %{
        id: id,
        name: name,
        account: account,
        current_balance: current_balance,
        withdrawn_amount: withdrawn_amount
      },
      message: msg
    }

    conn
    |> put_status(200)
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(for_encoder))
  end

  defp handle_response_withdrawn({:error, _changerset} = error, _conn, _status, _msg), do: error

  defp handle_response_transference({:ok, account}, conn, status, msg) do
    %{
      client_destiny_name: name_destiny,
      client_origin_name: name_origin,
      current_balance: c_balance,
      source_account: s_account,
      target_account: t_account,
      transferred_value: value
    } = account

    for_encoder = %{
      status: status,
      transaction_data: %{
        name: name_origin,
        source_account: s_account,
        current_balance: c_balance,
        beneficiary_name: name_destiny,
        target_account: t_account,
        transferred_value: value
      },
      message: msg
    }

    conn
    |> put_status(200)
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(for_encoder))
  end

  defp handle_response_transference({:error, _changerset} = error, _conn, _status, _msg),
    do: error
end
