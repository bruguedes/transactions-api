defmodule Transactions.Accounts.Account.WithdrawTest do
  @moduledoc """
  Tests withdraw operation
  """
  import Transactions.Factory
  use Transactions.DataCase
  alias Transactions.Accounts.Account.Withdraw
  alias Transactions.Accounts.Inputs.Withdraw, as: Inputs_Withdraw
  alias Transactions.Users.User.Create

  setup do
    {:ok, %{account: account_origin}} =
      Create.call(
        build(:user_input, name: "account origin", email: "origin@email.com", cpf: "11122233311")
      )

    {:ok, %{account: account_destiny}} =
      Create.call(
        build(:user_input, name: "account destiny", email: "destiny@email.com", cpf: "11122233322")
      )

    {:ok, account_origin: account_origin, account_destiny: account_destiny}
  end

  describe "call/1" do
    test "sucess if all parameters are correct", ctx do
      params = %Inputs_Withdraw{
        source_account: ctx.account_origin.code,
        requested_amount: 25_000
      }

      assert {
               :ok,
               %{
                 message: "Withdrawal successful!",
                 transaction_data: %{
                   account: _,
                   current_balance: 75_000,
                   id: _,
                   name: "account origin",
                   withdrawn_amount: 25_000
                 }
               }
             } = Withdraw.call(params)
    end

    test "fail if the account number is invalid" do
      params = %Inputs_Withdraw{
        source_account: "00000",
        requested_amount: 25_000
      }

      assert {:error, "source_account account  not found!"} = Withdraw.call(params)
    end

    test "fail if the requested amount is greater than in account", ctx do
      params = %Inputs_Withdraw{
        source_account: ctx.account_origin.code,
        requested_amount: 255_000
      }

      assert {:error, "Insufficient funds"} = Withdraw.call(params)
    end
  end
end
