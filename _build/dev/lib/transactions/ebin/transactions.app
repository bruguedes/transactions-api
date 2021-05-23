{application,transactions,
             [{applications,[kernel,stdlib,elixir,logger,runtime_tools,
                             phoenix_pubsub,ecto_sql,postgrex,jason]},
              {description,"transactions"},
              {modules,['Elixir.Jason.Encoder.Transactions.Accounts.Schemas.Account',
                        'Elixir.Jason.Encoder.Transactions.Clients.Schemas.Client',
                        'Elixir.Transactions',
                        'Elixir.Transactions.Accounts.Account.GetAccount',
                        'Elixir.Transactions.Accounts.Account.Transference',
                        'Elixir.Transactions.Accounts.Account.ValidationInputsForTransection',
                        'Elixir.Transactions.Accounts.Account.Withdraw',
                        'Elixir.Transactions.Accounts.Schemas.Account',
                        'Elixir.Transactions.Application',
                        'Elixir.Transactions.Clients.Client.Changeset',
                        'Elixir.Transactions.Clients.Client.Create',
                        'Elixir.Transactions.Clients.Schemas.Client',
                        'Elixir.Transactions.Repo']},
              {registered,[]},
              {vsn,"0.1.0"},
              {mod,{'Elixir.Transactions.Application',[]}}]}.