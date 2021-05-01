# API in elixir and Phoenix

API  em elixir e Phoenix, com foco estudo e pratica da liguagem elixir utilizando framework phoenix com estrutura umbrella, a api tem tres requisiços, create cliente, saque de valores e trasferencia entre contas.

Para executar o projeto, você precisa primeiro ter um contêiner Postgres em execução na porta 5432. Na raiz do projeto esta docker-compose que iniciara o dowload e levantara o servico de BD.

# Estando na pasta raiz pelo terminal siga os passos a seguir para iniciar o BD postgres utilizando docker,  criar o banco e suas tabelas:

inicializando containet :`docker-compose up -d`
Criando base de dados: `mix ecto.create`
Gerando tabelas: `mix ecto.migrate` 

Baixando dependencias do projeto: `mix deps.get`
To run tests: `mix test` 
Inicializando o servidor: `mix phx.server`

Fazendo requisições:
caso prefira pode utilizar o postman ou insomnia, para execurtar fazer as requisições tipo Post.

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
