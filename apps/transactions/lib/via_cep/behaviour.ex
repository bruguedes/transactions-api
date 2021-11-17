defmodule Transactions.ViaCep.Behaviour do
  @moduledoc """
  client viacep API behaviour
  """
  alias Transactions.BuildError

  @callback get_cep_info(String.t()) :: {:ok, String.t()} | {:error, BuildError.t()}
end
