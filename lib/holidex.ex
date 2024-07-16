defmodule Holidex do
  @moduledoc """
  Documentation for `Holidex`.
  """

  alias Holidex.Countries.Canada, as: Canada

  @doc """
  Returns a list of country codes (ISO 3166) and names supported by the library.
  """
  def get_countries do
    [
      %{
        country_code: :ca,
        name: "Canada"
      }
    ]
  end

  @doc """
  Returns a list of holidays for the given country code and year.
  """
  def get_holidays(:ca, year) do
    Canada.holidays(year)
    # [x] New Year - Sunday, January 1, 2023
    # [x] Good Friday - Friday, April 7, 2023
    # [x] Easter Monday - Monday, April 10, 2023
    # [x] Easter Sunday
    # [x] Victoria Day - Monday, May 22, 2023
    # [x] Canada Day - Saturday, July 1, 2023
    # [x] Civic Holiday - Monday, August 7, 2023
    # [x] Labour Day - Monday, September 4, 2023
    # [x] National Day for Truth and Reconciliation - Saturday, September 30, 2023
    # [x] Thanksgiving Day - Monday, October 9, 2023
    # [x] Remembrance Day - Saturday, November 11, 2023
    # [x] Christmas Day - Monday, December 25, 2023
    # [x] Boxing Day - Tuesday, December 26, 2023
    # [x] Family Day
  end

  def get_holidays(_country_code, _year) do
    {:error, :unsupported_country_code}
  end
end
