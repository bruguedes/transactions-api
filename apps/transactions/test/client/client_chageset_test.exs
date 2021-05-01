defmodule Transactions.Clients.Client.ChangesetTest do
  use Transactions.DataCase

  alias Ecto.Changeset
  alias Transactions.Clients.Client.Changeset

  describe "changeset/1" do
    test "Whe all params are valid, retuns a valid changeset" do
      params = %{
        name: "Bruno Guedes",
        email: "bruno@email.com",
        email_confirmation: "bruno@email.com"
      }

      result_function = Changeset.changeset(params)

      assert %Ecto.Changeset{
               changes: %{
                 email: "bruno@email.com",
                 email_confirmation: "bruno@email.com",
                 name: "Bruno Guedes"
               },
               valid?: true
             } = result_function
    end

    test "Whe there params are invalid, retuns an invalid changeset" do
      params = %{
        name: "Bruno Guedes",
        email: "bruno@email.com",
        email_confirmation: "error@email.com"
      }

      result_function = Changeset.changeset(params)

      assert %Ecto.Changeset{valid?: false} = result_function

      assert errors_on(result_function) == %{
               email_confirmation: ["Email and confirmation must be the same"]
             }
    end
  end
end
