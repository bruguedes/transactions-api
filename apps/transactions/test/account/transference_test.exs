defmodule Transactions.Accounts.Account.TransferenceTest do
  @moduledoc """
  Tests trasference
  """
  use Transactions.DataCase

  import Transactions.Factory
  alias Transactions.Accounts.Account.Transference
  alias Transactions.Accounts.Inputs.Transference, as: Input_Trasference
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
    test "sucess if valid parameters, make the transaction between accounts", ctx do
      params = %Input_Trasference{
        source_account: ctx.account_origin.code,
        target_account: ctx.account_destiny.code,
        requested_amount: 25_000
      }

      assert {:ok,
              %{
                user_destiny_name: "account destiny",
                user_origin_name: "account origin",
                current_balance: 75_000,
                source_account: _source_account,
                target_account: _target_account,
                transferred_value: 25_000
              }} = Transference.call(params)
    end

    test "fail if balance does not meet the condition", ctx do
      params = %Input_Trasference{
        source_account: ctx.account_origin.code,
        target_account: ctx.account_destiny.code,
        requested_amount: 125_000
      }

      assert {:error, "Insufficient funds"} == Transference.call(params)
    end

    test "fail account origin does not meet the condition", ctx do
      params = %Input_Trasference{
        source_account: "111111",
        target_account: ctx.account_destiny,
        requested_amount: 25_000
      }

      assert {:error, "source_account account  not found!"} = Transference.call(params)
    end

    test "fail account destiny does not meet the condition", ctx do
      params = %Input_Trasference{
        source_account: ctx.account_origin.code,
        target_account: "121212",
        requested_amount: 25_000
      }

      assert {:error, "target_account account  not found!"} = Transference.call(params)
    end

    test "fail if equal destination and origin account", ctx do
      params = %Input_Trasference{
        source_account: ctx.account_origin.code,
        target_account: ctx.account_origin.code,
        requested_amount: 25_000
      }

      assert {:error, "Destination account must be different from origin"} =
               Transference.call(params)
    end
  end
end
