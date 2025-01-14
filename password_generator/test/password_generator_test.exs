defmodule PasswordGeneratorTest do
  use ExUnit.Case
  doctest PasswordGenerator

  test "greets the world" do
    options = %{
      "length" => 10,
      "number" => "false",
      "uppercase" => "false",
      "symbols" => "false"
    }

    options_type = %{
      lowercase: Enum.map(?a..?z, &<<&1>>),
      numbers: Enum.map(0..9, &Integer.to_string(&1)),
      uppercase: Enum.map(?A..?Z, &<<&1>>),
      symbols: String.split("~`!@#$%^&*()_-+={[}]|:;\"'<,>.?/", "", trim: true)
    }

    {:ok, result} = PasswordGenerator.generate(options)

    %{
      options_type: options_type,
      result: result
    }
  end

  test "returns a string", %{result: result} do
    assert is_bitstring(result)
  end

  test "returns error when no length is given" do
    options = %{"invalid" => "false"}
    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "returns error when length is not an integer" do
    options = %{"length" => "ab"}
    assert {:error, _error} = PasswordGenerator.generate(options)
  end

  test "returns error when length is no correct" do
    length_options = %{"length" => "5"}
    {:ok, result} = PasswordGenerator.generate(length_options)
    assert 5 = String.length(result)
  end

  test "returns a lowercase string just with the length", %{options_type: options_type} do
    length_options = %{"length" => "5"}
    {:ok, result} = PasswordGenerator.generate(length_options)
    assert String.contains?(result, options_type.lowercase)

    refute String.contains?(result, options_type.numbers)
    refute String.contains?(result, options_type.uppercase)
    refute String.contains?(result, options_type.symbols)
  end
end
