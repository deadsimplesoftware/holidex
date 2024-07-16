defmodule Holidex.Holiday do
  @moduledoc """
  Defines the structure of a holiday.
  """

  # @type t :: %__MODULE__{
  #         name: String.t(),
  #         date: Date.t(),
  #         description: String.t(),
  #         type: :federal | :provincial | :informal,
  #         provinces: [atom()] | :all
  #       }

  # defstruct [
  #   :name,
  #   :type,
  #   :date,
  #   :observance_date,
  #   :statutory,
  #   :regional_names,
  #   :provinces,
  #   :provinces_except,
  #   :description
  # ]
  @type region :: atom()
  @type country :: :ca

  # {integer(), integer(), :last | :first | integer()}
  # date: {10, 1, :second} (2nd Monday of October)
  # date: {11, 4, :fourth} (4th Thursday of November)

  @type t :: %__MODULE__{
          name: String.t(),
          category: :federal | :local | :other,
          date: Date.t(),
          observance_date: Date.t(),
          statutory: boolean(),
          regional_names: %{region() => String.t()} | nil,
          regions: [region()] | :all,
          regions_except: [region()] | nil,
          description: String.t() | nil,
          country: country()
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

  @countries [:ca]

  @spec valid_country?(%__MODULE__{}) :: boolean()
  def valid_country?(%__MODULE__{country: country}) do
    country in @countries
  end
end
