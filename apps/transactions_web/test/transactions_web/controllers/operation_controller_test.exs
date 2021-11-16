defmodule TransactionsWeb.OperationControllerTest do
  use TransactionsWeb.ConnCase

  import Transactions.Factory

  alias Transactions.Users.User.Create

  setup %{conn: conn} do
    {:ok, %{account: account_origin}} =
      Create.call(
        build(:user_input, name: "account origin", email: "origin@email.com", cpf: "11122233311")
      )

    {:ok, %{account: account_destiny}} =
      Create.call(
        build(:user_input, name: "account destiny", email: "destiny@email.com", cpf: "11122233322")
      )

    {:ok, conn: conn, account_origin: account_origin, account_destiny: account_destiny}
  end

  describe "withdraw/2" do
    test "sucess when all parameters are valid, execute the withdrawal", ctx do
      params = %{
        "source_account" => ctx.account_origin.code,
        "requested_amount" => "25000"
      }

      assert %{
               "message" => "Withdrawal successful!",
               "transaction_data" => %{
                 "account" => _account,
                 "current_balance" => 75_000,
                 "id" => _id,
                 "name" => "account origin",
                 "withdrawn_amount" => 25_000
               }
             } =
               ctx.conn
               |> post("/api/operation/withdraw", params)
               |> json_response(:ok)
    end

    test "fail when account number not exist", ctx do
      params = %{
        "source_account" => "12345",
        "requested_amount" => "25000"
      }

      assert %{"message" => "source_account account  not found!"} =
               ctx.conn
               |> post("/api/operation/withdraw", params)
               |> json_response(:bad_request)
    end

    test "fail when the requested amount is greater than available.", ctx do
      params = %{
        "source_account" => ctx.account_origin.code,
        "requested_amount" => "125000"
      }

      assert %{"message" => "Insufficient funds"} ==
               ctx.conn
               |> post("/api/operation/withdraw", params)
               |> json_response(:bad_request)
    end

    test "fail when the account  not valid .", ctx do
      params = %{
        "source_account" => "123ab",
        "requested_amount" => "5000"
      }

      assert %{"message" => %{"source_account" => ["invalid account number"]}} ==
               ctx.conn
               |> post("/api/operation/withdraw", params)
               |> json_response(:bad_request)
    end

    test "fail when the requested_amount  not valid", ctx do
      params = %{
        "source_account" => ctx.account_origin.code,
        "requested_amount" => "invalid"
      }

      assert %{"message" => %{"requested_amount" => ["is invalid"]}} ==
               ctx.conn
               |> post("/api/operation/withdraw", params)
               |> json_response(:bad_request)
    end
  end

  describe "transference/2" do
    test "sucess when all parameters are valid, execute the trasference", ctx do
      params = %{
        "source_account" => ctx.account_origin.code,
        "target_account" => ctx.account_destiny.code,
        "requested_amount" => 25_000
      }

      assert %{
               "message" => "Transfer successfully completed!",
               "transaction_data" => %{
                 "current_balance" => 75_000,
                 "source_account" => _,
                 "target_account" => _,
                 "transferred_value" => 25_000,
                 "user_destiny_name" => "account destiny",
                 "user_origin_name" => "account origin"
               }
             } =
               ctx.conn
               |> post("/api/operation/transference", params)
               |> json_response(:ok)
    end

    test "fail when the original account number is invalid.", ctx do
      params = %{
        "source_account" => "00000",
        "target_account" => ctx.account_destiny.code,
        "requested_amount" => 25_000
      }

      assert %{"message" => "source_account account  not found!"} =
               ctx.conn
               |> post("/api/operation/transference", params)
               |> json_response(:bad_request)
    end

    test "fail when the destination account number is invalid.", ctx do
      params = %{
        "source_account" => ctx.account_origin.code,
        "target_account" => "00000",
        "requested_amount" => 25_000
      }

      assert %{"message" => "target_account account  not found!"} =
               ctx.conn
               |> post("/api/operation/transference", params)
               |> json_response(:bad_request)
    end

    test "fail when requested amount is greater than the account balance", ctx do
      params = %{
        "source_account" => ctx.account_origin.code,
        "target_account" => ctx.account_destiny.code,
        "requested_amount" => 125_000
      }

      assert %{"message" => "Insufficient funds"} =
               ctx.conn
               |> post("/api/operation/transference", params)
               |> json_response(:bad_request)
    end

    test "fail when the destination account number not numeric", ctx do
      params = %{
        "source_account" => ctx.account_origin.code,
        "target_account" => "1212a",
        "requested_amount" => 25_000
      }

      assert %{"message" => %{"target_account" => ["invalid account number"]}} =
               ctx.conn
               |> post("/api/operation/transference", params)
               |> json_response(:bad_request)
    end

    test "fail when the origin account number not numeric", ctx do
      params = %{
        "source_account" => "1212a",
        "target_account" => ctx.account_destiny.code,
        "requested_amount" => 25_000
      }

      assert %{"message" => %{"source_account" => ["invalid account number"]}} =
               ctx.conn
               |> post("/api/operation/transference", params)
               |> json_response(:bad_request)
    end
  end
end
