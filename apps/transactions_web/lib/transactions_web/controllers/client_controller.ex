defmodule TransactionsWeb.ClientController do
  use TransactionsWeb, :controller

  alias Transactions.Clients.Inputs.ClientsCreate

  action_fallback(TransactionsWeb.FallbackController)

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, inputs} <- ClientsCreate.changeset(%ClientsCreate{}, params),
         {:ok, client} <- Transactions.create(inputs) do
      conn
      |> put_status(201)
      |> put_resp_header("content-type", "application/json")
      |> send_resp(201, Jason.encode!(client))
    else
      {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset}
      {:error, _changeset} = error -> error
    end
  end
end
