defmodule Transactions.Users.User.Create do
  alias Transactions.Accounts.Schemas.Account
  alias Transactions.Helper.Parse
  alias Transactions.Repo
  alias Transactions.Users.Inputs.UserInput
  alias Transactions.Users.Schemas.User
  require Logger

  @moduledoc """
  This module's function is to create a new customer, assigning him an account with an opening balance.
  """

  @spec call(UserInput.t() | map()) :: {:ok, map()} | {:error, Ecto.Changeset.t() | String}
  def call(%UserInput{} = inputs) do
    input = Parse.build_user(inputs)

    Repo.transaction(fn ->
      with %Ecto.Changeset{valid?: true} = input <- User.changeset(input),
           {:ok, user} <- User.insert(input),
           {:ok, account} <- Account.insert(user) do
        build_response(account)
      else
        %Ecto.Changeset{valid?: false} = err -> Repo.rollback(err)
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
    |> case do
      {:ok, _} = user -> user
      {:error, err} -> {:error, err}
    end
  end

  def call(_input), do: {:error, "Struct not valid"}

  defp build_response(params) do
    %{id: account_id, account: account, balance: balance, user: user} =
      Repo.preload(params, :user)

    %{
      user: %{
        id: user.id,
        name: user.name,
        email: user.email
      },
      account: %{
        id: account_id,
        code: account,
        balance: balance
      }
    }
  end
end
