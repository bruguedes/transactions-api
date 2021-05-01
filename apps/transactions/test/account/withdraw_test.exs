defmodule Transactions.Accounts.Account.WithdrawTest do
  @moduledoc """
  Tests withdraw operation
  """
  use Transactions.DataCase
  alias Transactions.Accounts.Account.Withdraw
  alias Transactions.Clients.Client.Create

  @account %{
    name: "account Withdraw",
    email: "account@email.com",
    email_confirmation: "account@email.com"
  }

  describe "call/1" do
    test "if all parameters are correct" do
      {:ok, %{account: account_number}} = Create.call(@account)

      params = %{
        "source_account" => account_number,
        "requested_amount" => 25_000
      }

      assert {:ok,
              %{
                account: _account_number,
                current_balance: 75_000,
                id: _id,
                name: _name_client,
                withdrawn_amount: 25_000
              }} = Withdraw.call(params)
    end

    test "if the account number is invalid" do
      params = %{
        "source_account" => "00000",
        "requested_amount" => 25_000
      }

      assert {:error, "Account  not found!"} = Withdraw.call(params)
    end

    test "if the requested amount is greater than in account" do
      {:ok, %{account: account_number}} = Create.call(@account)

      params = %{
        "source_account" => account_number,
        "requested_amount" => 215_000
      }

      assert {:error, "Insufficient funds"} = Withdraw.call(params)
    end

    test "If the requested amount is in invalid format" do
      {:ok, %{account: account_number}} = Create.call(@account)

      params = %{
        "source_account" => account_number,
        "requested_amount" => "45dss"
      }

      assert {:error,
              %Ecto.Changeset{
                action: :insert,
                errors: [requested_amount: {"is invalid", [type: :integer, validation: :cast]}],
                valid?: false
              }} = Withdraw.call(params)
    end
  end
end
