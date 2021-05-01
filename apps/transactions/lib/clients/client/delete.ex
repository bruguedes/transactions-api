defmodule Transactions.Clients.Client.Delete do
  alias Ecto.UUID
  alias Transactions.Repo
  alias Transactions.Clients.Schemas.Client

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid ID format!"}
      {:ok, uuid} -> delete(uuid)
    end
  end

  defp delete(uuid) do
    case fetch_client(uuid) do
      nil -> {:error, "Client not found!"}
      client -> Repo.delete(client)
    end
  end

  defp fetch_client(uuid), do: Repo.get(Client, uuid)
end
