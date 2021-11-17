defmodule TransactionsWeb.UserController do
  use TransactionsWeb, :controller

  alias Transactions.Helper.Parse
  alias Transactions.Users.Inputs.UserInput

  alias TransactionsWeb.UserView

  action_fallback(TransactionsWeb.FallbackController)

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, input} <- Parse.build_address(params),
         {:ok, input} <- UserInput.changeset(input),
         {:ok, user} <- Transactions.create_user(input) do
      conn
      |> put_status(:created)
      |> put_resp_header("content-type", "application/json")
      |> put_view(UserView)
      |> render("create.json", %{user: user})
    end
  end
end
