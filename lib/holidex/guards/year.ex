defmodule Holidex.YearGuard do
  @moduledoc """
    Guard to check if a year is valid.
    Valid years are an integer between 1900 and 2200, inclusive.
  """
  @min_year 1900
  @max_year 2200

  defguard is_valid_year(year)
           when is_integer(year) and year >= @min_year and year <= @max_year and year != 0
end
