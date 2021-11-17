defmodule Transactions.Accounts.Schemas.Account do
  @moduledoc """
    schema table accounts
  """
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Transactions.Repo
  alias Transactions.Users.Schemas.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_params [:account, :balance, :user_id]
  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  schema "accounts" do
    field(:account, :string)
    field(:balance, :integer)
    belongs_to(:user, User)
    timestamps()
  end

  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end

  @spec insert(User.t()) :: {:ok, %__MODULE__{}} | {:error, %Ecto.Changeset{}}
  def insert(%User{} = inputs) do
    number_account = generate_number()

    Ecto.build_assoc(inputs, :account, %__MODULE__{account: number_account, balance: 100_000})
    |> Repo.insert()
  end

  defp generate_number do
    number_account =
      Enum.random(10_000..90_000)
      |> to_string

    case Repo.all(from(u0 in __MODULE__, where: u0.account == ^number_account)) do
      [_ | _] -> generate_number()
      [] -> number_account
    end
  end
end
