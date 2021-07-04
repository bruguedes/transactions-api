defmodule Transactions.Accounts.Account.GetAccountTest do
  @moduledoc """
  Test get accounts
  """
  use Transactions.DataCase
  alias Transactions.Accounts.Account.GetAccount
  alias Transactions.Clients.Client.Create
  alias Transactions.Clients.Inputs.ClientsCreate

  describe "get/1" do
    test "fetches account data when parameters are valid" do
      {:ok, %{account: account}} =
        Create.create_client(%ClientsCreate{
          name: "Test Created",
          email: "test@email.com",
          email_confirmation: "test@email.com",
          password: "123456",
          password_confirmation: "123456"
        })

      assert {
               :ok,
               %Transactions.Accounts.Schemas.Account{
                 balance: 100_000,
                 account: _account,
                 client_id: _client_id,
                 id: _id,
                 inserted_at: _inserted_at,
                 updated_at: _updated_at
               }
             } = GetAccount.get(account, :source_account)
    end
  end

  test "when search parameter is invalid" do
    result_function = GetAccount.get("12345", :source_account)

    assert right: {:error, "source_account account  not found!"} = result_function
  end
end
