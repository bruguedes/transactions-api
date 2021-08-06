defmodule Transactions.Clients.Client.Create do
  alias Transactions.Accounts.Schemas.Account
  alias Transactions.Clients.Inputs.ClientsCreate
  alias Transactions.Clients.Schemas.Client
  alias Transactions.Repo
  require Logger

  @moduledoc """
  This module's function is to create a new customer, assigning him an account with an opening balance.
  """

  @doc """
    create_client(): inserts the client into the database, in the clint table, calls the create_account function that generates the
                          account number, balance.
    create_account(): generates a random number, this is assigned as an account number, uses the return data
    inserting the user to use Ecto's build_assoc function to add the data to the account table
    along with the user reference of the customers table.
    response_create(): Assemble the tuple that will be the return of the create_client() function that is being called by the create function of
    of the cliente_controller module
  """

  @spec create_client(map()) :: {:ok, map()} | {:error, String}
  def create_client(%ClientsCreate{} = inputs) do
    new_cliente = %Client{name: inputs.name, email: inputs.email, password: inputs.password}

    Repo.insert!(new_cliente)
    |> create_account()
    |> response_create()
  rescue
    Ecto.ConstraintError ->
      Logger.info("Email already registered")
      {:error, "Email already registered"}
  end

  def create_client(_input), do: {:error, "Struct not valid"}

  defp create_account(%Client{} = inputs) do
    number_account =
      Enum.random(10_000..90_000)
      |> to_string

    Ecto.build_assoc(inputs, :account, %Account{account: number_account, balance: 100_000})
    |> Repo.insert!()
  end

  defp create_account({:error, _changeset} = error), do: error

  defp response_create(struct_account) do
    %{client: client, account: account, balance: balance} = Repo.preload(struct_account, :client)

    {:ok,
     %{
       id: client.id,
       name: client.name,
       email: client.email,
       account: account,
       balance: balance
     }}
  end
end
