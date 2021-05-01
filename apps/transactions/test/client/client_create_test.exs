defmodule Transactions.Clients.Client.CreateTest do
  @moduledoc """
    Tests create client
  """
  use Transactions.DataCase
  alias Transactions.Clients.Client.Create

  describe "call/1" do
    test "if valid parameters resets the insertion data in the database" do
      params = %{
        name: "Test Created",
        email: "test@email.com",
        email_confirmation: "test@email.com"
      }

      result_function = Create.call(params)

      assert {:ok,
              %{
                account: _account_number,
                balance: 100_000,
                email: "test@email.com",
                id: _id,
                name: "Test Created"
              }} = result_function
    end

    test "when a invalid file, returns mensege of error" do
      params = %{
        name: "Test Created",
        email: "test@email.com",
        email_confirmation: ""
      }

      result_function = Create.call(params)

      assert {:error,
              %Ecto.Changeset{
                action: :insert,
                changes: %{email: "test@email.com", name: "Test Created"},
                errors: [
                  email_confirmation:
                    {"Email and confirmation must be the same", [validation: :confirmation]},
                  email_confirmation: {"can't be blank", [validation: :required]}
                ],
                data: %Transactions.Clients.Schemas.Client{},
                valid?: false
              }} = result_function
    end
  end
end
