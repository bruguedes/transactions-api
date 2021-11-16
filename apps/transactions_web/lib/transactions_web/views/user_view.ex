defmodule TransactionsWeb.UserView do
  use TransactionsWeb, :view

  def render("create.json", %{user: user}) do
    %{
      user: user.user,
      account: user.account
    }
  end
end
