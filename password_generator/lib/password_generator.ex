defmodule PasswordGenerator do
  @moduledoc """
  Documentation for `PasswordGenerator`.

  options = %{
      "length" => 10,
      "number" => "false",
      "uppercase" => "false",
      "symbols" => "false"
    }
  """

  @allowed_options [:length, :number, :uppercase, :symbols]

  @doc """
  Hello world.

  ## Examples

      iex> PasswordGenerator.hello()
      :world

  """
  @spec generate(options :: map()) :: {:ok, bitstring()} | {:error, bitstring()}
  def generate(options) do
    length = Map.has_key?(options, "length")
    validate_length(length, options)
  end

  defp validate_length(false, _options), do: {:error, "Please provide a length"}

  defp validate_length(true, options) do
    numbers = Enum.map(0..9, &Integer.to_string(&1))
    length = options["length"]
    length = String.contains?(length, numbers)
    validate_length_is_integer(length, options)
  end

  defp validate_length_is_integer(false, _options),
    do: {:error, "Only integers allowed for length."}

  defp validate_length_is_integer(false, options) do
    length = options["length"] |> String.trim() |> String.to_integer()
    options_without_lenght = Map.delete(options, "length")
    options_values = Map.values(options_without_lenght)
    value =
      options_values
      |> Enum.all?(fn x -> String.to_atom(x) |> is_boolean())
    validate_options_values_are_boolean(value, length, options_without_length)
  end
end
