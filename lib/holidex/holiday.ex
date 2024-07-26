defmodule Holidex.Holiday do
  @moduledoc """
  Defines the structure of a holiday.
  """

  @type region :: atom()
  @type country_code :: :ca

  @type t :: %__MODULE__{
          name: String.t(),
          category: :national | :federal | :regional | :religious | :other,
          date: Date.t(),
          observance_date: Date.t(),
          statutory: boolean(),
          regional_names: %{region() => String.t()} | nil,
          regions: [region()] | :all,
          regions_except: [region()] | nil,
          description: String.t() | nil,
          country: country_code()
        }

  defstruct [
    :name,
    :category,
    :date,
    :observance_date,
    :statutory,
    :regional_names,
    :regions,
    :regions_except,
    :description,
    :country
  ]
end
