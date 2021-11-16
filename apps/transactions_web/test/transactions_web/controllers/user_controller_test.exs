defmodule TransactionsWeb.UserControllerTest do
  use TransactionsWeb.ConnCase

  import Mox
  import Transactions.Factory

  alias Transactions.ViaCep.ClientMock

  describe "create/2" do
    test "sucess when all params are valide, creates the client", %{conn: conn} do
      params = build(:user_params)

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, "Avenida Epaminonda Jácome, Habitasa, Rio Branco/AC"}
      end)

      assert %{
               "account" => %{
                 "balance" => 100_000,
                 "code" => _,
                 "id" => _
               },
               "user" => %{
                 "email" => "user@email.com",
                 "id" => _,
                 "name" => "Bruno Guedes"
               }
             } =
               conn
               |> post("/api/user", params)
               |> json_response(:created)
    end

    test "fails when CPF already registered", %{conn: conn} do
      build(:create_user_and_account)
      params = build(:user_params, %{"email" => "email@email.com"})

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, "Avenida Epaminonda Jácome, Habitasa, Rio Branco/AC"}
      end)

      assert %{"message" => %{"cpf" => ["has already been taken"]}} =
               conn
               |> post("/api/user", params)
               |> json_response(:bad_request)
    end

    test "fails when email already registered", %{conn: conn} do
      build(:create_user_and_account)
      params = build(:user_params, %{"cpf" => "99988877766"})

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, "Avenida Epaminonda Jácome, Habitasa, Rio Branco/AC"}
      end)

      assert %{"message" => %{"email" => ["has already been taken"]}} =
               conn
               |> post("/api/user", params)
               |> json_response(:bad_request)
    end

    test "fail when the parameter is invalid", %{conn: conn} do
      params =
        build(:user_params, %{
          "cpf" => "999888777",
          "email" => "user.com",
          "cep" => "000000",
          "password" => "123"
        })

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, "Avenida Epaminonda Jácome, Habitasa, Rio Branco/AC"}
      end)

      response =
        conn
        |> post(Routes.user_path(conn, :create, params))
        |> json_response(:bad_request)

      assert %{
               "message" => %{
                 "cep" => ["should be 8 character(s)"],
                 "cpf" => ["should be 11 character(s)"],
                 "email" => ["has invalid format"],
                 "password" => ["should be at least 6 character(s)"]
               }
             } = response
    end
  end
end
