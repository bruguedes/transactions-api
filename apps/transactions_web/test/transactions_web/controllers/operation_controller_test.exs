defmodule TransactionsWeb.OperationControllerTest do
  use TransactionsWeb.ConnCase

  alias Transactions.Clients.Client.Create

  @account %{
    name: "account origin",
    email: "account@email.com",
    email_confirmation: "account@email.com"
  }
  @account_for_transference %{
    name: "account destiny",
    email: "destiny@email.com",
    email_confirmation: "destiny@email.com"
  }

  describe "withdraw/2" do
    test "When all parameters are valid, execute the withdrawal", %{conn: conn} do
      {:ok, %{account: account_number}} = Create.call(@account)

      params = %{
        "source_account" => account_number,
        "requested_amount" => "25000"
      }

      assert %{
               "message" => "Withdrawal successful!",
               "status" => 200,
               "transaction_data" => %{
                 "account" => _account,
                 "current_balance" => 75000,
                 "id" => _id,
                 "name" => "account origin",
                 "withdrawn_amount" => 25000
               }
             } =
               conn
               |> post("/api/operation/withdraw", params)
               |> json_response(:ok)
    end

    test "When account number is invalid", %{conn: conn} do
      params = %{
        "source_account" => "invlid",
        "requested_amount" => "25000"
      }

      assert %{
               "message" => %{"source_account" => ["should be at most 5 character(s)"]},
               "status" => 400
             } =
               conn
               |> post("/api/operation/withdraw", params)
               |> json_response(:bad_request)
    end

    test "When the requested amount is greater than available..", %{conn: conn} do
      {:ok, %{account: account_number}} = Create.call(@account)

      params = %{
        "source_account" => account_number,
        "requested_amount" => "125000"
      }

      assert %{"message" => "Insufficient funds"} ==
               conn
               |> post("/api/operation/withdraw", params)
               |> json_response(:bad_request)
    end

    test "When the requested amount is greater than ..", %{conn: conn} do
      {:ok, %{account: account_number}} = Create.call(@account)

      params = %{
        "source_account" => account_number,
        "requested_amount" => "invalid"
      }

      assert %{"message" => %{"requested_amount" => ["is invalid"]}, "status" => 400} ==
               conn
               |> post("/api/operation/withdraw", params)
               |> json_response(:bad_request)
    end
  end

  describe "transference/2" do
    test "When all parameters are valid, execute the trasference", %{conn: conn} do
      {:ok, %{account: account_origin}} = Create.call(@account)
      {:ok, %{account: account_destiny}} = Create.call(@account_for_transference)

      params = %{
        "source_account" => account_origin,
        "target_account" => account_destiny,
        "requested_amount" => 25000
      }

      assert %{
               "message" => "Transfer successfully completed!",
               "status" => 200,
               "transaction_data" => %{
                 "current_balance" => 75000,
                 "name" => "account origin",
                 "beneficiary_name" => "account destiny",
                 "source_account" => _source_account,
                 "target_account" => _target_account,
                 "transferred_value" => 25000
               }
             } =
               conn
               |> post("/api/operation/transference", params)
               |> json_response(:ok)
    end

    test "When the original account number is invalid.", %{conn: conn} do
      {:ok, %{account: account_destiny}} = Create.call(@account_for_transference)

      params = %{
        "source_account" => "00000",
        "target_account" => account_destiny,
        "requested_amount" => 25000
      }

      assert %{"message" => "Account  not found!"} =
               conn
               |> post("/api/operation/transference", params)
               |> json_response(:bad_request)
    end

    test "When the destination account number is invalid.", %{conn: conn} do
      {:ok, %{account: account_origin}} = Create.call(@account_for_transference)

      params = %{
        "source_account" => account_origin,
        "target_account" => "00000",
        "requested_amount" => 25000
      }

      assert %{"message" => "Account  not found!"} =
               conn
               |> post("/api/operation/transference", params)
               |> json_response(:bad_request)
    end

    test "When requested amount is greater than the account balance", %{conn: conn} do
      {:ok, %{account: account_origin}} = Create.call(@account)
      {:ok, %{account: account_destiny}} = Create.call(@account_for_transference)

      params = %{
        "source_account" => account_origin,
        "target_account" => account_destiny,
        "requested_amount" => 125_000
      }

      assert %{"message" => "Insufficient funds"} =
               conn
               |> post("/api/operation/transference", params)
               |> json_response(:bad_request)
    end
  end
end
