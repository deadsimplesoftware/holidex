defmodule Holidex.Calculators.Easter do
  @moduledoc """
  Provides calculations for Easter-related dates.
  """

  defstruct [:year, :good_friday, :easter_sunday, :easter_monday]

  @type t :: %__MODULE__{
          year: integer(),
          good_friday: Date.t(),
          easter_sunday: Date.t(),
          easter_monday: Date.t()
        }

  @doc """
  Calculates Easter-related dates for a given year.

  Returns a struct containing the dates for Good Friday, Easter Sunday, and Easter Monday.

  ## Parameters

    - `year`: The year for which to calculate Easter dates

  ## Examples

      iex> Holidex.Calculators.Easter.new(2023)
      %Holidex.Calculators.Easter{
        year: 2023,
        good_friday: ~D[2023-04-07],
        easter_sunday: ~D[2023-04-09],
        easter_monday: ~D[2023-04-10]
      }
  """

  # Easter in North America typically follows the Western Christian tradition,
  # which uses the Gregorian calendar. The formula commonly used to calculate
  # Easter Sunday is known as the "Meeus/Jones/Butcher algorithm," named after
  # the astronomers who developed it.
  @spec new(integer()) :: Holidex.Calculators.Easter.t()
  def new(year) do
    %__MODULE__{
      year: year,
      good_friday: good_friday(year),
      easter_sunday: easter_sunday(year),
      easter_monday: easter_monday(year)
    }
  end

  def good_friday(year) do
    year
    |> easter_sunday()
    |> Date.add(-2)
  end

  def easter_monday(year) do
    year
    |> easter_sunday()
    |> Date.add(1)
  end

  def easter_sunday(year) do
    a = rem(year, 19)
    b = div(year, 100)
    c = rem(year, 100)
    d = div(b, 4)
    e = rem(b, 4)
    f = div(b + 8, 25)
    g = div(b - f + 1, 3)
    h = rem(19 * a + b - d - g + 15, 30)
    i = div(c, 4)
    k = rem(c, 4)
    l = rem(32 + 2 * e + 2 * i - h - k, 7)
    m = div(a + 11 * h + 22 * l, 451)
    n = div(h + l - 7 * m + 114, 31)
    p = rem(h + l - 7 * m + 114, 31)

    Date.new!(year, n, p + 1)
  end
end
