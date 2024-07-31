defmodule Holidex.DateHelpers do
  @moduledoc false

  @doc """
  Calculates the date of a holiday based on the nth occurrence of a specific weekday in a given month.

  ## Parameters

    * `year` - The year as an integer.
    * `month` - The month as an integer (1-12).
    * `weekday` - The day of the week as an integer (1-7, where 1 is Monday).
    * `occurrence` - The occurrence of the weekday in the month, either an integer (1-5) or an atom (:first, :second, :third, :fourth, :last).

  ## Returns

    A `Date` struct representing the calculated holiday date.

  ## Examples

      iex> nth_weekday_in_month(2023, 10, 1, :second)
      ~D[2023-10-09]

      # This calculates the date for Canadian Thanksgiving in 2023,
      # which falls on the second Monday of October.

  ## Specification Format

  The function can be used to calculate dates specified in the format:
  `{month, weekday, occurrence}`

  For example, Canadian Thanksgiving would be specified as:
  `{10, 1, :second}` (2nd Monday of October)

  """
  # TODO: do not currently support occurence as atom
  @spec nth_weekday_in_month(
          year :: integer(),
          month :: 1..12,
          weekday :: 1..7,
          occurrence :: 1..5 | :first | :second | :third | :fourth | :last
        ) :: Date.t()

  def nth_weekday_in_month(year, month, weekday, occurence) do
    days = Date.new!(year, month, 1) |> Date.days_in_month()

    1..days
    |> Enum.map(fn day -> Date.new!(year, month, day) end)
    |> Enum.filter(fn day -> Date.day_of_week(day) == weekday end)
    |> Enum.at(occurence - 1)
  end

  @doc """
  If a holiday is observed on the actual date, regardless of the day of the week, especially for ceremonies, it may be moved to Monday if it falls on a weekend.
  """
  @spec post_weekend_observance(Date.t()) :: Date.t()
  def post_weekend_observance(%Date{} = date) do
    date
    |> Date.day_of_week()
    |> case do
      6 -> Date.add(date, 2)
      7 -> Date.add(date, 1)
      _ -> date
    end
  end
end
