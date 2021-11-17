ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Transactions.Repo, :manual)

Mox.defmock(Transactions.ViaCep.ClientMock, for: Transactions.ViaCep.Behaviour)
