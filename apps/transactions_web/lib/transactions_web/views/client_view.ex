defmodule TransactionsWeb.ClientView do
  use TransactionsWeb, :view
  alias Transactions.Clients.Schemas.Client

  def render("create.json", %{
        client: %Client{id: id, name: name, email: email, inserted_at: inserted_at}
      }) do
    %{
      status: 200,
      client: %{
        id: id,
        name: name,
        email: email,
        inserted_at: inserted_at
      },
      message: "new client successfully created"
    }
  end
end
