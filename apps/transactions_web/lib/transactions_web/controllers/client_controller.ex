defmodule TransactionsWeb.ClientController do
  use TransactionsWeb, :controller

  action_fallback TransactionsWeb.FallbackController

  def create(conn, params) do
    params
    |> Transactions.create_client()
    |> handle_response_create(conn, 201, "new client successfully created")
  end

  # def delete(conn, params) do
  #   %{"id" => id} = params

  #   id
  #   |> Transactions.delete_client()
  #   |> handle_response_delete(conn)
  # end

  # def show(conn, params) do
  #   %{"id" => id} = params

  #   id
  #   |> Transactions.fetch_client()
  #   |> handle_response_create(conn, 200, "Date Client")
  # end

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

  # defp handle_response_delete({:ok, client}, conn) do
  #   for_encoder = %{
  #     status: 202,
  #     client: %{
  #       id: client.id,
  #       name: client.name,
  #       email: client.email
  #     },
  #     message: "client successfully deleted"
  #   }

  #     conn
  #     |> put_resp_header("content-type", "application/json")
  #     |> send_resp(202, Jason.encode!(for_encoder))
  #   end

  #   defp handle_response_delete({:error, _reason} = error, _conn), do: error
end
