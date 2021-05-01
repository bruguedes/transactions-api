defmodule Transactions.Repo.Migrations.CrateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :account, :string
      add :balance, :integer
      add :client_id, references(:clients, type: :binary_id)
      timestamps()
    end

    create unique_index(:accounts, [:client_id])
  end
end
