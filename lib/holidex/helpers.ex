defmodule Holidex.DateHelpers do
  @moduledoc false

  @days_of_the_week %{
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 7
  }

  @spec get_day_of_week_occurence(atom(), integer(), integer(), integer()) :: Date.t()
  def get_day_of_week_occurence(dow, year, month, nth_occurence) do
    dow = translate_day_to_number(dow)

    days =
      year
      |> Date.new!(10, 1)
      |> Date.days_in_month()

    1..days
    |> Stream.map(fn day -> Date.new!(year, month, day) end)
    |> Stream.filter(fn day -> Date.day_of_week(day) == dow end)
    |> Enum.at(nth_occurence - 1)
  end

  def get_observance(%Date{} = date) do
    date
    |> Date.day_of_week()
    |> case do
      6 -> Date.add(date, 2)
      7 -> Date.add(date, 1)
      _ -> date
    end
  end

  defp translate_day_to_number(dow) do
    Map.get(
      @days_of_the_week,
      dow
    )
  end
end
