defmodule Transactions.Users.User.CreateTest do
  @moduledoc """
    Tests create client
  """
  use Transactions.DataCase, async: true

  import Transactions.Factory

  alias Transactions.Users.User.Create

  describe "call/1" do
    test "if valid parameters resets the insertion data in the database" do
      user_input = build(:user_input)
      result_function = Create.call(user_input)

      assert {:ok,
              %{
                account: %{
                  balance: 100_000,
                  code: _,
                  id: _
                },
                user: %{
                  email: "user@email.com",
                  id: _,
                  name: "User Name"
                }
              }} = result_function
    end

    test "fails when email is already in use" do
      insert(:user)

      user_input = build(:user_input)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  email:
                    {"has already been taken",
                     [constraint: :unique, constraint_name: "users_email_index"]}
                ],
                valid?: false
              }} = Create.call(user_input)
    end

    test "fails when no match for struct" do
      parans = %{
        name: "account origin",
        email: "account@email.com",
        email_confirmation: "account@email.com",
        password: "123456",
        password_confirmation: "123456"
      }

      assert right: {:error, "Struct not valid"} = Create.call(parans)
    end
  end
end
