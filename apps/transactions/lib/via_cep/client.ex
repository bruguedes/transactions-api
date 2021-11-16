defmodule Transactions.ViaCep.Client do
  @moduledoc """
  Modulo returns the user address based on zip code.
  zip code and sent to viacep API and returns full address.
  """
  use Tesla

  alias Tesla.Env
  alias Transactions.BuildError
  alias Transactions.ViaCep.Behaviour

  @base_url "https://viacep.com.br/ws/"
  plug(Tesla.Middleware.JSON)

  @behaviour Behaviour
  def get_cep_info(url \\ @base_url, cep) do
    "#{url}#{cep}/json/"
    |> get()
    |> handle_get()
  end

  defp handle_get({:ok, %Env{status: 200, body: %{"erro" => true}}}) do
    {:error, BuildError.build(:not_found, "CEP not found!")}
  end

  defp handle_get({:ok, %Env{status: 400, body: _body}}) do
    {:error, BuildError.build(:bad_request, "invalid CEP")}
  end

  defp handle_get({:error, reason}) do
    {:error, BuildError.build(:bad_request, reason)}
  end

  defp handle_get({:ok, %Env{status: 200, body: body}}) do
    address = "#{body["logradouro"]}, #{body["bairro"]}, #{body["localidade"]}/#{body["uf"]}"

    {:ok, address}
  end
end
