defmodule Transactions.Accounts.Account.GetAccountTest do
  @moduledoc """
  Test get accounts
  """
  use Transactions.DataCase

  import Transactions.Factory
  alias Transactions.Accounts.Account.GetAccount
  alias Transactions.Users.User.Create

  describe "get/1" do
    test "fetches account data when parameters are valid" do
      {:ok, %{account: %{code: code, id: account_id}, user: %{id: user_id}}} =
        Create.call(build(:user_input))

      assert {
               :ok,
               %Transactions.Accounts.Schemas.Account{
                 balance: 100_000,
                 account: ^code,
                 user_id: ^user_id,
                 id: ^account_id,
                 inserted_at: _,
                 updated_at: _
               }
             } = GetAccount.get(code, :source_account)
    end
  end

  test "when search parameter is invalid" do
    result_function = GetAccount.get("12345", :source_account)

    assert right: {:error, "source_account account  not found!"} = result_function
  end
end
