defmodule Transactions.Accounts.Account.TransferenceTest do
  @moduledoc """
  Tests trasference
  """
  use Transactions.DataCase

  alias Transactions.Accounts.Account.Transference
  alias Transactions.Accounts.Inputs.Transference, as: Input_Trasference
  alias Transactions.Clients.Client.Create
  alias Transactions.Clients.Inputs.ClientsCreate

  setup do
    {:ok, %{account: account_origin}} =
      Create.create_client(%ClientsCreate{
        name: "account origin",
        email: "origin@email.com",
        email_confirmation: "origin@email.com"
      })

    {:ok, %{account: account_destiny}} =
      Create.create_client(%ClientsCreate{
        name: "account destiny",
        email: "destiny@email.com",
        email_confirmation: "destiny@email.com"
      })

    {:ok, account_origin: account_origin, account_destiny: account_destiny}
  end

  describe "call/1" do
    test "if valid parameters, make the transaction between accounts", ctx do
      params = %Input_Trasference{
        source_account: ctx.account_origin,
        target_account: ctx.account_destiny,
        requested_amount: 25_000
      }

      assert {:ok,
              %{
                client_destiny_name: "account destiny",
                client_origin_name: "account origin",
                current_balance: 75_000,
                source_account: _source_account,
                target_account: _target_account,
                transferred_value: 25_000
              }} = Transference.call(params)
    end

    test "If balance does not meet the condition", ctx do
      params = %Input_Trasference{
        source_account: ctx.account_origin,
        target_account: ctx.account_destiny,
        requested_amount: 125_000
      }

      assert {:error, "Insufficient funds"} == Transference.call(params)
    end

    test "If account destiny does not meet the condition", ctx do
      params = %Input_Trasference{
        source_account: ctx.account_origin,
        target_account: "121212",
        requested_amount: 25_000
      }

      assert {:error, "Account  not found!"} = Transference.call(params)
    end

    test "fail if equal destination and origin account", ctx do
      params = %Input_Trasference{
        source_account: ctx.account_origin,
        target_account: ctx.account_origin,
        requested_amount: 25_000
      }

      assert {:error, "Destination account must be different from origin"} =
               Transference.call(params)
    end
  end
end
