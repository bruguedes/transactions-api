defmodule Transactions.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:name, :string)
      add(:email, :string)
      add(:cpf, :string)
      add(:address, :string)
      add(:cep, :string)
      add(:password_hash, :string)

      timestamps()
    end

    create(unique_index(:users, [:email]))
    create(unique_index(:users, [:cpf]))
  end
end
