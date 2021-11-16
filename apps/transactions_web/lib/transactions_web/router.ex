defmodule TransactionsWeb.Router do
  use TransactionsWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api" do
    pipe_through(:api)
    post("/user", TransactionsWeb.UserController, :create)
    post("/operation/withdraw", TransactionsWeb.OperationController, :withdraw)
    post("/operation/transference", TransactionsWeb.OperationController, :transference)
  end
end
