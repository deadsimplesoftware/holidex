defmodule Holidex.Countries.Canada do
  @moduledoc """
  Provides a map of all Canadian holidays.
  """

  alias Holidex.DateHelpers, as: DateHelpers
  alias Holidex.EasterSunday, as: EasterSunday

  defstruct holidays: nil

  def get_holidays(year) do
    %__MODULE__{
      holidays: [
        holiday(:new_years_day, year),
        holiday(:family_day, year),
        holiday(:good_friday, year),
        holiday(:easter_sunday, year),
        holiday(:easter_monday, year),
        holiday(:victoria_day, year),
        holiday(:national_indigenous_peoples_day, year),
        holiday(:saint_jean_baptiste_day, year),
        holiday(:canada_day, year),
        holiday(:civic_holiday, year),
        holiday(:gold_cup_parade_day, year),
        holiday(:labour_day, year),
        holiday(:national_day_for_truth_and_reconciliation, year),
        holiday(:thanksgiving_day, year),
        holiday(:remembrance_day, year),
        holiday(:christmas_day, year),
        holiday(:boxing_day, year)
      ]
    }
  end

  def get_holiday_names do
    [
      :new_years_day,
      :family_day,
      :good_friday,
      :easter_sunday,
      :easter_monday,
      :victoria_day,
      :national_indigenous_peoples_day,
      :saint_jean_baptiste_day,
      :canada_day,
      :civic_holiday,
      :gold_cup_parade_day,
      :labour_day,
      :national_day_for_truth_and_reconciliation,
      :thanksgiving_day,
      :remembrance_day,
      :christmas_day,
      :boxing_day
    ]
  end

  def get_holiday_by_name(name, year) do
    year
    |> get_holidays()
    |> Map.get(:holidays)
    |> Enum.find(fn holiday -> holiday[:name] == name end)
  end

  def get_regions do
    [
      %{name: "Alberta", region: :province, code: :ab},
      %{name: "British Columbia", region: :province, code: :bc},
      %{name: "Manitoba", region: :province, code: :mb},
      %{name: "New Brunswick", region: :province, code: :nb},
      %{name: "Newfoundland and Labrador", region: :province, code: :nl},
      %{name: "Northwest Territories", region: :province, code: :nt},
      %{name: "Nova Scotia", region: :province, code: :ns},
      %{name: "Nunavut", region: :province, code: :nu},
      %{name: "Ontario", region: :province, code: :on},
      %{name: "Prince Edward Island", region: :province, code: :pe},
      %{name: "Québec", region: :province, code: :qc},
      %{name: "Saskatchewan", region: :province, code: :sk},
      %{name: "Yukon", region: :province, code: :yt}
    ]
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:new_years_day, year) do
    date = Date.new!(year, 1, 1)

    %{
      name: :new_years_day,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: true,
      type: :national
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:family_day, year) do
    date = DateHelpers.get_day_of_week_occurence(:monday, year, 2, 3)

    %{
      name: :family_day,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: true,
      type: :provincial,
      aka: [
        %{name: "Louis Riel Day", region: :mb},
        %{name: "Heritage Day", region: :ns},
        %{name: "Islander Day", region: :pe}
      ],
      provinces: [:ab, :bc, :nb, :on, :sk]
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:good_friday, year) do
    date =
      :easter_sunday
      |> holiday(year)
      |> Map.get(:date)
      |> Date.add(-2)

    %{
      name: :good_friday,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: true,
      type: :national,
      provinces_except: [:qc]
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:easter_sunday, year) do
    date = EasterSunday.new(year)

    %{
      name: :easter_sunday,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: false,
      type: :national
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:easter_monday, year) do
    easter_sunday = :easter_sunday |> holiday(year) |> Map.get(:date)
    date = Date.add(easter_sunday, 1)

    %{
      name: :easter_monday,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: true,
      type: :provincial,
      notes:
        "In Quebec, employers must choose between Good Friday and Easter Monday for their statutory holiday",
      provinces: [
        :qc,
        :nt
      ]
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:victoria_day, year) do
    start_date = Date.new!(year, 5, 25)

    date =
      start_date
      |> Date.add(-1)
      |> Date.range(Date.add(start_date, -7))
      |> Enum.filter(fn day -> Date.day_of_week(day) == 1 end)
      |> Enum.at(0)

    %{
      name: :victoria_day,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: true,
      type: :provincial,
      aka: [
        %{name: "National Patriots Day", region: :qc}
      ],
      provinces: [
        :ab,
        :bc,
        :mb,
        :nt,
        :qc,
        :sk,
        :yt
      ]
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:national_indigenous_peoples_day, year) do
    date = Date.new!(year, 6, 21)

    %{
      name: :national_indigenous_peoples_day,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: false,
      type: :provincial,
      provincial: [
        :nt,
        :yt
      ]
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:saint_jean_baptiste_day, year) do
    date = Date.new!(year, 6, 24)

    %{
      name: :saint_jean_baptiste_day,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: true,
      type: :provincial,
      provinces: [
        :qc
      ]
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:canada_day, year) do
    date = Date.new!(year, 7, 1)

    %{
      name: :canada_day,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: true,
      type: :national,
      aka: [
        %{name: "Memorial Day", province: :nl}
      ],
      provinces: [
        :ab,
        :bc,
        :mb,
        :nb,
        :nl,
        :ns,
        :nt,
        :nu,
        :on,
        :pe,
        :qc,
        :sk,
        :yt
      ]
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:civic_holiday, year) do
    # Civic Holiday is the first Monday of August.
    date = DateHelpers.get_day_of_week_occurence(:monday, year, 8, 1)

    %{
      name: :civic_holiday,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: false,
      type: :provincial,
      aka: [
        %{name: "British Columbia Day", region: :bc},
        %{name: "New Brunswick Day", region: :nb},
        %{name: "Civic Holiday", region: :nt},
        %{name: "Civic Holiday", region: :nu},
        %{name: "Saskatchewan Day", region: :sk},
        %{name: "Discovery Day", region: :yt}
      ],
      provinces: [
        :bc,
        :nb,
        :nt,
        :nu,
        :sk,
        :yt
      ]
    }
  end

  defp holiday(:gold_cup_parade_day, year) do
    date = Date.new!(year, 8, 20)

    %{
      name: :gold_cup_parade_day,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: false,
      type: :provincial,
      provinces: [:pe]
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:labour_day, year) do
    # Labour Day is the first Monday of September.
    date = DateHelpers.get_day_of_week_occurence(:monday, year, 9, 1)

    %{
      name: :labour_day,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: true,
      type: :national
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:national_day_for_truth_and_reconciliation, year) do
    date = Date.new!(year, 9, 30)

    %{
      name: :national_day_for_truth_and_reconciliation,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: true,
      type: :provincial,
      provinces: [
        :bc,
        :nt,
        :nu,
        :pe,
        :yt
      ]
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:thanksgiving_day, year) do
    # Thanksgiving Day is the second Monday of October.
    date = DateHelpers.get_day_of_week_occurence(:monday, year, 10, 2)

    %{
      name: :thanksgiving_day,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: true,
      type: :provincial,
      provinces: [
        :ab,
        :bc,
        :mb,
        :nt,
        :nu,
        :on,
        :qc,
        :sk,
        :yt
      ]
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:remembrance_day, year) do
    date = Date.new!(year, 11, 11)

    %{
      name: :remembrance_day,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: true,
      type: :provincial,
      provinces: [
        :ab,
        :bc,
        :nb,
        :nl,
        :nt,
        :ns,
        :nu,
        :on,
        :pe,
        :sk,
        :yt
      ]
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:christmas_day, year) do
    date = Date.new!(year, 12, 25)

    %{
      name: :christmas_day,
      date: date,
      observance: DateHelpers.get_observance(date),
      statutory: true,
      type: :national
    }
  end

  @spec holiday(atom, integer) :: map()
  defp holiday(:boxing_day, year) do
    date = Date.new!(year, 12, 26)

    %{
      name: :boxing_day,
      date: date,
      observance: DateHelpers.get_observance(date),
      type: :provincial,
      statutory: true,
      provinces: [
        :on,
        :nt
      ]
    }
  end

  @spec holiday(atom, integer) :: {:error, atom()}
  defp holiday(_, _year) do
    {:error, :unknown_holiday}
  end
end
