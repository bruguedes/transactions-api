defmodule Transactions.Helper.Parse do
  @moduledoc """
  adds the address field and its value to the parameters
  """
  alias Transactions.Users.Inputs.UserInput

  @spec build_address(map) :: {:ok, map} | {:error, Transactions.BuildError.t()}
  def build_address(%{"cep" => cep} = params) do
    cep
    |> client().get_cep_info()
    |> parse(params)
  end

  # @spec build_user(UserInput.t()) :: map()
  def build_user(%UserInput{} = params) do
    %{
      address: params.address,
      cep: params.cep,
      cpf: params.cpf,
      email: params.email,
      name: params.name,
      password_hash: params.password_hash
    }
  end

  defp parse({:ok, address}, params) do
    params = Map.put(params, "address", address)

    {:ok, params}
  end

  defp parse(err, _params), do: err

  defp client do
    Application.fetch_env!(:transactions, __MODULE__)[:via_cep_adapter]
  end
end
