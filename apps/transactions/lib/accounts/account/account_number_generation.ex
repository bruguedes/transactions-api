defmodule Transactions.Accounts.Account.AccountNumberGeneration do
  @moduledoc """
  Generates initial account data, such as number, and amount.
  """
  alias Transactions.Accounts.Schemas.Account

  @doc """
    Generates a 5 digit random number, representing the bank account number.
    ##Example
      iex> id_client = 00000
      iex> Transactions.Accounts.Account.AccountNumberGeneration.new_account(id_client)
          %Transactions.Accounts.Schemas.Account{
        __meta__: #Ecto.Schema.Metadata<:built, "accounts">,
        account: "57342",
        balance: 100000,
        client: #Ecto.Association.NotLoaded<association :client is not loaded>,
        client_id: 0,
        id: nil,
        inserted_at: nil,
        updated_at: nil
        }
  """
  def new_account(client_id) do
    number_account =
      Enum.random(10000..90000)
      |> to_string

    %Account{
      client_id: client_id,
      account: number_account,
      balance: 100_000
    }
  end
end
