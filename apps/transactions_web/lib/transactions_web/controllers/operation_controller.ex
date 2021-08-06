defmodule TransactionsWeb.OperationController do
  use TransactionsWeb, :controller
  alias Transactions.Accounts.Inputs.{Transference, Withdraw}

  action_fallback(TransactionsWeb.FallbackController)

  def withdraw(conn, params) do
    with {:ok, input} <- Withdraw.changeset(%Withdraw{}, params),
         {:ok, response} <- Transactions.req_withdraw(input) do
      conn
      |> put_status(200)
      |> put_resp_header("content-type", "application/json")
      |> send_resp(200, Jason.encode!(response))
    end
  end

  def transference(conn, params) do
    with {:ok, input} <- Transference.changeset(%Transference{}, params),
         {:ok, response} <- Transactions.req_transference(input) do
      handle_response_transference(conn, response, "Transfer successfully completed!")
    end
  end

  defp handle_response_transference(conn, data, msg) do
    for_encoder = %{
      transaction_data: data,
      message: msg
    }

    conn
    |> put_status(200)
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(for_encoder))
  end
end
