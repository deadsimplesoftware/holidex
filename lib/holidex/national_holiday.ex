defmodule Holidex.NationalHoliday do
  defstruct name: nil,
            date: nil,
            observance_date: nil,
            description: nil,
            regions_observed: [],
            regional_names: %{},
            national_public_holiday: false

  def new!(holiday) do
    struct!(__MODULE__, holiday)
  end
end
