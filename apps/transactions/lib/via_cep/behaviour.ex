defmodule Transactions.ViaCep.Behaviour do
  alias Transactions.BuildError

  @callback get_cep_info(String.t()) :: {:ok, String.t()} | {:error, BuildError.t()}
end
