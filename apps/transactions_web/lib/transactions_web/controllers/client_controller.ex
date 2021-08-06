defmodule TransactionsWeb.ClientController do
  use TransactionsWeb, :controller

  alias Transactions.Clients.Inputs.ClientsCreate

  action_fallback(TransactionsWeb.FallbackController)

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, inputs} <- ClientsCreate.changeset(%ClientsCreate{}, params),
         {:ok, client} <- Transactions.create_client(inputs) do
      handle_response(conn, client, "new client successfully created!")
    else
      {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset}
      {:error, _changeset} = error -> error
    end
  end

  defp handle_response(conn, data, msg) do
    for_encoder = %{
      client_data: data,
      message: msg
    }

    conn
    |> put_status(201)
    |> put_resp_header("content-type", "application/json")
    |> send_resp(201, Jason.encode!(for_encoder))
  end
end
