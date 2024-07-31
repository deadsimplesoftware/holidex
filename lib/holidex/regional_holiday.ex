defmodule Holidex.RegionalHoliday do
  @moduledoc """
  Defines the structure of a regional holiday.
  """

  @type region :: atom()
  @type country_code :: atom()
  @type category :: :national | :federal | :regional | :religious | :other

  @type t :: %__MODULE__{
          name: String.t(),
          categories: list(category()),
          date: Date.t(),
          observance_date: Date.t(),
          region: region(),
          description: String.t() | nil,
          country: country_code()
        }

  defstruct name: nil,
            categories: [],
            date: nil,
            observance_date: nil,
            region: nil,
            description: "",
            country: nil
end
