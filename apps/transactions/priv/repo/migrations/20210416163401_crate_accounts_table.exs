defmodule Transactions.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add(:account, :string)
      add(:balance, :integer)
      add(:user_id, references(:users, type: :binary_id))
      timestamps()
    end

    create(unique_index(:accounts, [:user_id]))
  end
end
