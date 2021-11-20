defmodule Transactions.Users.Inputs.UserInputTest do
  use Transactions.DataCase, async: true

  import Transactions.Factory

  alias Transactions.Users.Inputs.UserInput

  setup do
    user = build(:user_params)
    {:ok, user: user}
  end

  describe "changeset/1" do
    test "sucess, when params are valid", ctx do
      params =
        ctx.user
        |> Map.put("address", "Av. Test changeset")

      response = UserInput.changeset(params)

      assert {:ok,
              %Transactions.Users.Inputs.UserInput{
                address: "Av. Test changeset",
                cep: "69905080",
                cpf: "11122233344",
                email: "user@email.com",
                id: nil,
                name: "Bruno Guedes",
                password: "123123",
                password_hash: _
              }} = response
    end

    test "fail, when params are invalid", ctx do
      params = %{ctx.user | "cep" => "123", "cpf" => "456", "email" => "not_valid"}
      response = UserInput.changeset(params)

      assert {:error,
              %Ecto.Changeset{
                action: :insert,
                changes: %{
                  cep: "123",
                  cpf: "456",
                  email: "not_valid",
                  name: "Bruno Guedes",
                  password: "123123"
                },
                errors: [
                  cpf:
                    {"should be %{count} character(s)",
                     [count: 11, validation: :length, kind: :is, type: :string]},
                  cep:
                    {"should be %{count} character(s)",
                     [count: 8, validation: :length, kind: :is, type: :string]},
                  email: {"has invalid format", [validation: :format]},
                  address: {"can't be blank", [validation: :required]}
                ],
                data: %Transactions.Users.Inputs.UserInput{},
                valid?: false
              }} = response
    end
  end
end
