defmodule TransactionsWeb.ClientControllerTest do
  use TransactionsWeb.ConnCase

  describe "create/2" do
    test "sucess when all params are valide, creates the client", %{conn: conn} do
      params = %{
        name: "Test Created",
        email: "test@email.com",
        email_confirmation: "test@email.com",
        password: "123456",
        password_confirmation: "123456"
      }

      assert %{
               "message" => "new client successfully created!",
               "client_data" => %{
                 "account" => _,
                 "balance" => 100_000,
                 "email" => "test@email.com",
                 "id" => _,
                 "name" => "Test Created"
               }
             } =
               conn
               |> post("/api/clients", params)
               |> json_response(:created)
    end

    test "fail when the parameter confirms emails and invalid, creates the client", %{conn: conn} do
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
               "message" => %{"email_confirmation" => ["Email and confirmation must be the same"]}
             } = response
    end

    test "fail when the email and email confirmation parameters are invalid, create the client",
         %{
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
               }
             } = response
    end

    test "fail when the password and password confirmation parameters are invalid, create the client",
         %{
           conn: conn
         } do
      params = %{
        name: "Test Created",
        email: "test@email.com",
        email_confirmation: "test@email.com",
        password: "123",
        password_confirmation: "1234"
      }

      response =
        conn
        |> post(Routes.client_path(conn, :create, params))
        |> json_response(:bad_request)

      assert %{
               "message" => %{
                 "password" => ["should be at least 6 character(s)"],
                 "password_confirmation" => ["Does not match password"]
               }
             } = response
    end
  end
end
