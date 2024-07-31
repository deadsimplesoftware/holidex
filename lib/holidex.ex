defmodule Holidex do
  @moduledoc false

  alias Holidex.Countries.Canada
  alias Holidex.NationalHoliday

  @type country_code :: :ca

  @countries [
    %{country_code: :ca, name: "Canada"}
  ]

  @doc """
  Returns a list of supported countries.

  ## Example

      iex> Holidex.supported_countries()
      [%{country_code: :ca, name: "Canada"}, %{country_code: :us, name: "United States"}]
  """
  @spec supported_countries() :: [%{country_code: country_code(), name: String.t()}]
  def supported_countries, do: @countries

  @doc """
  Returns a list of holidays for the given country code and year.

  ## Parameters

    - `country_code`: The country code as an atom (e.g., `:ca` for Canada)
    - `year`: The year for which to retrieve holidays

  ## Example

      iex> Holidex.holidays(:ca, 2023)
      {:ok, [%Holidex.NationalHoliday{name: "New Year's Day", date: ~D[2023-01-01], ...}, ...]}
  """
  @spec holidays(country_code(), integer()) ::
          {:ok, list(NationalHoliday.t())} | {:error, atom()}
  def holidays(:ca, year), do: Canada.holidays(year)
end
