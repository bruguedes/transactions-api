defmodule TransactionsWeb.ClientController do
  use TransactionsWeb, :controller

  action_fallback(TransactionsWeb.FallbackController)

  def create(conn, params) do
    params
    |> Transactions.create_client()
    |> handle_response_create(conn, 201, "new client successfully created")
  end

  defp handle_response_create({:ok, client}, conn, status, msg) do
    %{id: id, name: name, email: email, account: account, balance: balance} = client

    for_encoder = %{
      status: status,
      client: %{
        id: id,
        name: name,
        email: email,
        account: account,
        balance: balance
      },
      message: msg
    }

    conn
    |> put_status(201)
    |> put_resp_header("content-type", "application/json")
    |> send_resp(201, Jason.encode!(for_encoder))
  end

  defp handle_response_create({:error, _changerset} = error, _conn, _status, _msg), do: error
end
