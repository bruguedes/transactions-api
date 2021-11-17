defmodule Transactions.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Transactions.Repo

  alias Ecto.UUID
  alias Transactions.Accounts.Schemas.Account
  alias Transactions.Users.Inputs.UserInput
  alias Transactions.Users.Schemas.User
  # alias Rockelivery.ViaCep.ClientMock

  def user_params_factory do
    %{
      "age" => 36,
      "cep" => "69905080",
      "cpf" => "11122233344",
      "email" => "user@email.com",
      "password" => "123123",
      "name" => "Bruno Guedes"
    }
  end

  def user_input_factory do
    %UserInput{
      address: "Avenida Epaminondas Jácome, Habitasa, Rio Branco/AC",
      cep: "69905080",
      cpf: "17362232313",
      email: "user@email.com",
      id: nil,
      name: "User Name",
      password: "123456",
      password_hash:
        "$argon2id$v=19$m=131072,t=8,p=4$Y7J+ViuiNJLrF6QTb/mqaw$OCdJ/toh4JzYB8bsGxHFJXHTpgy7zA8xtAhtaYgx/lU"
    }
  end

  def user_factory do
    %User{
      address: "Avenida Epaminondas Jácome, Habitasa, Rio Branco/AC",
      cep: "69905080",
      cpf: "11122233344",
      email: "user@email.com",
      id: UUID.generate(),
      name: "User Name",
      password_hash:
        "$argon2id$v=19$m=131072,t=8,p=4$Y7J+ViuiNJLrF6QTb/mqaw$OCdJ/toh4JzYB8bsGxHFJXHTpgy7zA8xtAhtaYgx/lU"
    }
  end

  # def create_user_factory do
  #   expect(ClientMock, :get_cep_info, fn _cep ->
  #     {:ok, "Avenida Epaminonda Jácome, Habitasa, Rio Branco/AC"}
  #   end)

  #   params = build(:user_params)
  #   {:ok, user} = UserCreate.call(params)
  #   user
  # enduser
  def account_factory do
    %Account{
      account: "00000",
      balance: 100_000,
      id: UUID.generate(),
      user_id: UUID.generate()
    }
  end

  def create_user_and_account_factory do
    user = insert(:user)
    insert(:account, user_id: user.id)
  end
end
