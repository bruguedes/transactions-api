# API in elixir and Phoenix

API in elixir and Phoenix, with a focus on study and practice of the elixir language 
using a phoenix framework with umbrella structure, api has three requirements, create client,
withdrawal of values and transfer between accounts.

note: When registering a new client and automatically generating a 5 digit account number,
with a starting balance of R $ 1,000 represented in cents, then in the BD balance it will be: 100000.

To run the project, you must first have a Postgres container running on port 5432.
At the root of the project is this docker-compose that will start the download and raise the BD service.

Being in the root folder by the terminal follow the steps below to start the BD postgres using docker
, create the bank and its tables:

initializing containet: `docker-compose up -d`

Creating database: `mix ecto.create`

Generating tables: `mix ecto.migrate`

Downloading project dependencies: `mix deps.get`

To run tests: `mix test`

Booting the server: `mix phx.server`


Making requests:
if you prefer, you can use the postman or insomnia, to make the post type requests.

``` sh
Registering a user:
POST http://localhost:4000/api/clients {
	"name": "client",
	"email": "client@email.com",
	"email_confirmation": "client@email.com",
	"password": "123456",
	"password_confirmation": "123456"
}

> return:
{ 
  "client_data": {
    "account": "83327",
    "balance": 100000,
    "email": "client@email.com",
    "id": "9c4069b1-c235-4426-b315-8701e5fe2a99",
    "name": "client"
  },
  "message": "new client successfully created!"
}

```


``` sh

Requesting a withdrawal:

note: For testing you must first create a new user.

POST http://localhost:4000/api/operation/withdraw {
	"source_account": "83327",
	"requested_amount": "5000"	
}
>return:
{
  "message": "Withdrawal successful!",
  "transaction_data": {
    "account": "83327",
    "current_balance": 95000,
    "id": "9c4069b1-c235-4426-b315-8701e5fe2a99",
    "name": "client",
    "withdrawn_amount": 5000
  }
}
```

``` sh

Requesting transfer:

note: For this test, you must have at least two user registers.

POST http://localhost:4000/api//operation/transference{
	"source_account": "83327",
	"target_account": "70450",
	"requested_amount": 5000
}
>return:
{
  "message": "Transfer successfully completed!",
  "transaction_data": {
    "client_destiny_name": "clint beneficiary",
    "client_origin_name": "client",
    "current_balance": 90000,
    "source_account": "83327",
    "target_account": "70450",
    "transferred_value": 5000
  }
}
```
