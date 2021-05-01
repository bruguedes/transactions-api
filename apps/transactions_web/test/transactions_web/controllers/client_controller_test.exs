defmodule TransactionsWeb.ClientControllerTest do
  use TransactionsWeb.ConnCase

  describe "create/2" do
    test "When all params are valide, creates the client", %{conn: conn} do
      params = %{
        name: "Test Created",
        email: "test@email.com",
        email_confirmation: "test@email.com"
      }

      assert %{
               "client" => %{
                 "account" => _account,
                 "balance" => 100_000,
                 "email" => "test@email.com",
                 "id" => _id,
                 "name" => "Test Created"
               },
               "message" => "new client successfully created",
               "status" => 201
             } =
               conn
               |> post("/api/clients", params)
               |> json_response(:created)
    end

    test "When the parameter confirms emails and invalid, creates the client", %{conn: conn} do
      params = %{
        name: "Test Created",
        email: "test@email.com",
        email_confirmation: "test1@email.com"
      }

      response =
        conn
        |> post(Routes.client_path(conn, :create, params))
        |> json_response(:bad_request)

      assert %{
               "message" => %{"email_confirmation" => ["Email and confirmation must be the same"]},
               "status" => 400
             } = response
    end

    test "When the email and email confirmation parameters are invalid, create the client", %{
      conn: conn
    } do
      params = %{
        name: "Teste",
        email: "testmail",
        email_confirmation: ""
      }

      response =
        conn
        |> post(Routes.client_path(conn, :create, params))
        |> json_response(:bad_request)

      assert %{
               "message" => %{
                 "email" => ["has invalid format"],
                 "email_confirmation" => [
                   "Email and confirmation must be the same",
                   "can't be blank"
                 ]
               },
               "status" => 400
             } = response
    end
  end
end
