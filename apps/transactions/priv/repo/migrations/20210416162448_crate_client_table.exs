defmodule Transactions.Repo.Migrations.CrateClientTable do
  use Ecto.Migration

  def change do
    create table(:clients, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)
      add(:email, :string)
      add(:password, :string)
      timestamps()
    end

    create(unique_index(:clients, [:email]))
  end
end
