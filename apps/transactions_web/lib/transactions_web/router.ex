defmodule TransactionsWeb.Router do
  use TransactionsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api
    post "/clients", TransactionsWeb.ClientController, :create
    post "/operation/withdraw", TransactionsWeb.OperationController, :withdraw
    post "/operation/transference", TransactionsWeb.OperationController, :transference
  end

  # scope "/", Transactionsweb do
  #   pipe_through :api

  #   get "/", ClientController, :index

  #   # post "/create", ClientController, :create
  #   # post "/client", ClientController, :create
  # end
end
