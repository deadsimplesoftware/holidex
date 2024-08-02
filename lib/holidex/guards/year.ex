defmodule Holidex.YearGuard do
  @moduledoc false
  defguard is_valid_year(year)
           when is_integer(year) and year >= 1900 and year <= 2200 and year != 0
end
