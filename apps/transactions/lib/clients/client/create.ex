defmodule Transactions.Clients.Client.Create do
  alias Transactions.Accounts.Schemas.Account
  alias Transactions.Clients.Client.Changeset
  alias Transactions.Repo
  require Logger

  @moduledoc """
  This module's function is to create a new customer, assigning him an account with an opening balance.
  """

  @doc """
    call(): calls the input validations and if successful, passes the struc to the create function.
    create_client(): inserts the client into the database, in the clint table, calls the create_account function that generates the
                          account number, balance.
    create_account(): generates a random number, this is assigned as an account number, uses the return data
    inserting the user to use Ecto's build_assoc function to add the data to the account table
    along with the user reference of the customers table.
    response_create(): Assemble the tuple that will be the return of the call () function that is being called by the create function of
    of the cliente_controller module
  """
  @spec call(map()) :: tuple()
  def call(params) do
    Logger.info("client successfully registered")

    params
    |> Changeset.build()
    |> create_client()
  rescue
    Ecto.ConstraintError ->
      Logger.info("Email already registered")
      {:error, "Email already registered"}
  end

  defp create_client({:ok, struct_client}) do
    Repo.insert!(struct_client)
    |> create_account()
    |> response_create()
  end

  defp create_client({:error, _changeset} = error), do: error

  defp create_account(%{} = struct_client) do
    number_account =
      Enum.random(10000..90000)
      |> to_string

    Ecto.build_assoc(struct_client, :account, %Account{account: number_account, balance: 100_000})
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
