# API in elixir and Phoenix

API in elixir and Phoenix, with a focus on study and practice of the elixir language using a phoenix framework with umbrella structure, api has three requirements, create client, withdrawal of values and transfer between accounts.

note: When registering a new client and automatically generating a 5 digit account number, with a starting balance of R $ 1,000 represented in cents, then in the BD balance it will be: 100000.

To run the project, you must first have a Postgres container running on port 5432. At the root of the project is this docker-compose that will start the download and raise the BD service.

Being in the root folder by the terminal follow the steps below to start the BD postgres using docker, create the bank and its tables:

initializing containet: `docker-compose up -d`
Creating database: `mix ecto.create`
Generating tables: `mix ecto.migrate`

Downloading project dependencies: `mix deps.get`
To run tests: mix test
Booting the server: `mix phx.server`


Making requests:
if you prefer, you can use the postman or insomnia, to make the post type requests.

``` sh
Cadastrando um  usuario:
POST http://localhost:4000/api/clients {
	"name": "client",
	"email": "client@email.com",
	"email_confirmation": "client@email.com"
}

>restono da chamada:
{
  "client": {
    "account": "27234",
    "balance": 100000,
    "email": "client@email.com",
    "id": "757edbd6-25a3-4594-af16-5a544838e221",
    "name": "client"
  },
  "message": "new client successfully created",
  "status": 201
}
```
``` sh

Solicitando um saque:
Para teste deve criar primeiro um novo usuario

POST http://localhost:4000/api/operation/withdraw {
	"source_account": "27234",
	"requested_amount": 1000	
}
>restono da chamada:
{
  "message": "Withdrawal successful!",
  "status": 200,
  "transaction_data": {
    "account": "27234",
    "current_balance": 99000,
    "id": "757edbd6-25a3-4594-af16-5a544838e221",
    "name": "client",
    "withdrawn_amount": 1000
  }
}
```

``` sh
Solicitando um saque:
Para  este teste deve ter pelo menos dois cadastro de usuario.

POST http://localhost:4000/api//operation/transference{
	"source_account": "27234",
	"target_account": "48654",
	"requested_amount": 20000	
}
>restono da chamada:
{
  "message": "Transfer successfully completed!",
  "status": 200,
  "transaction_data": {
    "beneficiary_name": "Luiz Push",
    "current_balance": 79000,
    "name": "client",
    "source_account": "27234",
    "target_account": "48654",
    "transferred_value": 20000
  }
}
```
