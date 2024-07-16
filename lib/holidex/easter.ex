defmodule Holidex.Easter do
  @moduledoc """
  Returns the Date that Easter falls on for a given year.
  """

  # Easter in North America typically follows the Western Christian
  # tradition, which uses the Gregorian calendar. The formula commonly used
  # to calculate Easter Sunday is known as the "Meeus/Jones/Butcher algorithm,"
  # named after the astronomers who developed it.
  @spec new(integer()) :: Date.t()
  def new(year) do
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
