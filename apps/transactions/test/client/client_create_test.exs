defmodule Transactions.Clients.Client.CreateTest do
  @moduledoc """
    Tests create client
  """
  use Transactions.DataCase
  alias Transactions.Clients.Client.Create
  alias Transactions.Clients.Inputs.ClientsCreate

  @new_client %ClientsCreate{
    name: "account origin",
    email: "account@email.com",
    email_confirmation: "account@email.com",
    password: "123456",
    password_confirmation: "123456"
  }

  describe "create_client/1" do
    test "if valid parameters resets the insertion data in the database" do
      result_function = Create.create_client(@new_client)

      assert {
               :ok,
               %{
                 account: _account,
                 balance: 100_000,
                 email: "account@email.com",
                 id: _id,
                 name: "account origin"
               }
             } =
               result_function
    end

    test "fails when email is already in use" do
      Create.create_client(@new_client)

      result_function = Create.create_client(@new_client)

      assert {:error, "Email already registered"} = result_function
    end

    test "fails when no match for struct" do
      parans = %{
        name: "account origin",
        email: "account@email.com",
        email_confirmation: "account@email.com",
        password: "123456",
        password_confirmation: "123456"
      }

      result_function = Create.create_client(parans)

      assert right: {:error, "Struct not valid"} = result_function
    end
  end
end
