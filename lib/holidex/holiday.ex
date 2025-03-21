defmodule Holidex.Holiday do
  @moduledoc """
  Defines the structure of a holiday.
  """

  @enforce_keys [:name, :country, :date]

  @type country_code :: atom()
  @type region :: atom()
  @type category :: :national | :federal | :regional | :religious | :other

  @type t :: %__MODULE__{
          name: String.t(),
          categories: list(category()),
          date: Date.t(),
          observance_date: Date.t(),
          regional_names: %{region() => String.t()},
          regions: [region()] | :all,
          description: String.t() | nil,
          country: country_code()
        }

  defstruct name: nil,
            categories: [],
            date: nil,
            observance_date: nil,
            regional_names: %{},
            regions: [],
            description: "",
            country: nil
end
