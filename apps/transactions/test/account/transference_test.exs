defmodule Transactions.Accounts.Account.TransferenceTest do
  @moduledoc """
  Tests trasference
  """
  use Transactions.DataCase

  alias Transactions.Accounts.Account.Transference
  alias Transactions.Clients.Client.Create

  @account_origin %{
    name: "account origin",
    email: "origin@email.com",
    email_confirmation: "origin@email.com"
  }

  @account_destiny %{
    name: "account destiny",
    email: "destiny@email.com",
    email_confirmation: "destiny@email.com"
  }

  describe "call/1" do
    test "if valid parameters, make the transaction between accounts" do
      {:ok, %{account: account_origin}} = Create.call(@account_origin)
      {:ok, %{account: account_destiny}} = Create.call(@account_destiny)

      params = %{
        "source_account" => account_origin,
        "target_account" => account_destiny,
        "requested_amount" => 25_000
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

    test "If balance does not meet the condition" do
      {:ok, %{account: account_origin}} = Create.call(@account_origin)
      {:ok, %{account: account_destiny}} = Create.call(@account_destiny)

      params = %{
        "source_account" => account_origin,
        "target_account" => account_destiny,
        "requested_amount" => 150_000
      }

      assert {:error, "Insufficient funds"} == Transference.call(params)
    end

    test "If account origin does not meet the condition" do
      # {:ok, %{account: account_origin}} = Create.call(@account_origin)
      {:ok, %{account: account_destiny}} = Create.call(@account_destiny)

      params = %{
        "source_account" => "",
        "target_account" => account_destiny,
        "requested_amount" => 150_000
      }

      assert {:error,
              %Ecto.Changeset{
                action: :insert,
                errors: [source_account: {"can't be blank", [validation: :required]}],
                valid?: false
              }} = Transference.call(params)
    end

    test "If account destiny does not meet the condition" do
      {:ok, %{account: account_origin}} = Create.call(@account_origin)

      params = %{
        "source_account" => account_origin,
        "target_account" => "12312",
        "requested_amount" => 150_000
      }

      assert {:error, "Account  not found!"} = Transference.call(params)
    end

    test "If value does not meet the condition" do
      {:ok, %{account: account_origin}} = Create.call(@account_origin)
      {:ok, %{account: account_destiny}} = Create.call(@account_destiny)

      params = %{
        "source_account" => account_origin,
        "target_account" => account_destiny,
        "requested_amount" => "123er"
      }

      assert {:error,
              %Ecto.Changeset{
                action: :insert,
                errors: [requested_amount: {"is invalid", [type: :integer, validation: :cast]}],
                valid?: false
              }} = Transference.call(params)
    end
  end
end
