defmodule TransactionsWeb.FallbackController do
  use TransactionsWeb, :controller

  def call(conn, {:error, result}) do
    conn
    |> put_status(400)
    |> put_view(TransactionsWeb.ErrorView)
    |> render("error.json", result: result)
  end
end
