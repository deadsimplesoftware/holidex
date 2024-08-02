defmodule Holidex.YearValidator do
  @moduledoc false
  @min_year 1900
  @max_year 2200

  @spec validate_year(integer()) :: {:ok, integer()} | {:error, String.t()}
  def validate_year(year) when is_integer(year) do
    cond do
      year < @min_year ->
        {:error, "Year must be #{@min_year} or later"}

      year > @max_year ->
        {:error, "Year must be #{@max_year} or earlier"}

      year == 0 ->
        {:error, "Year 0 does not exist in the Gregorian calendar"}

      true ->
        {:ok, year}
    end
  end

  def validate_year(year) when is_binary(year) do
    case Integer.parse(year) do
      {parsed_year, ""} -> validate_year(parsed_year)
      _ -> {:error, "Invalid year format"}
    end
  end

  def validate_year(_) do
    {:error, "Year must be an integer or a string representing an integer"}
  end
end
