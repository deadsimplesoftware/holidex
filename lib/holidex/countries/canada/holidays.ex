defmodule Holidex.Countries.Canada do
  @moduledoc """
  Provides information for all national and provincial Canadian holidays.
  """

  alias Holidex.DateHelpers, as: DateHelpers
  alias Holidex.Easter, as: Easter
  alias Holidex.Holiday, as: Holiday

  @country_code :ca

  defstruct holidays: []

  @spec holidays(integer()) :: [Holiday.t()] | {:error, :invalid_year}
  def holidays(year) when is_integer(year) do
    %__MODULE__{
      holidays: [
        holiday(:new_years_day, year),
        holiday(:family_day, year),
        holiday(:good_friday, year),
        holiday(:easter, year),
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

  @spec holidays(integer()) :: {:error, :invalid_year}
  def holidays(_), do: {:error, :invalid_year}

  @spec regions() :: list(map())
  def regions do
    [
      %{name: "Alberta", region: :province, code: :ab},
      %{name: "British Columbia", region: :province, code: :bc},
      %{name: "Manitoba", region: :province, code: :mb},
      %{name: "New Brunswick", region: :province, code: :nb},
      %{name: "Newfoundland and Labrador", region: :province, code: :nl},
      %{name: "Northwest Territories", region: :territory, code: :nt},
      %{name: "Nova Scotia", region: :province, code: :ns},
      %{name: "Nunavut", region: :territory, code: :nu},
      %{name: "Ontario", region: :province, code: :on},
      %{name: "Prince Edward Island", region: :province, code: :pe},
      %{name: "Québec", region: :province, code: :qc},
      %{name: "Saskatchewan", region: :province, code: :sk},
      %{name: "Yukon", region: :territory, code: :yt}
    ]
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:new_years_day, year) do
    date = Date.new!(year, 1, 1)

    %Holiday{
      name: "New Years Day",
      category: :federal,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regions: :all,
      country: @country_code
    }
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:family_day, year) do
    # 3rd Monday in February
    date = DateHelpers.nth_weekday_in_month(year, 2, 1, 3)

    %Holiday{
      name: "Family Day",
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      category: :local,
      regional_names: [
        %{name: "Louis Riel Day", region: :mb},
        %{name: "Heritage Day", region: :ns},
        %{name: "Islander Day", region: :pe}
      ],
      regions: [:ab, :bc, :nb, :on, :sk],
      country: @country_code
    }
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:good_friday, year) do
    date =
      :easter
      |> holiday(year)
      |> Map.get(:date)
      |> Date.add(-2)

    %Holiday{
      name: "Good Friday",
      category: :federal,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regions_except: [:qc],
      country: @country_code
    }
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:easter, year) do
    date = Easter.new(year)

    %Holiday{
      name: "Easter",
      category: :local,
      date: date,
      observance_date: date,
      statutory: true,
      description:
        "In Quebec, employers must choose between Good Friday and Easter Monday for their statutory holiday",
      regions: [
        :qc,
        :nt
      ],
      country: @country_code
    }
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:victoria_day, year) do
    start_date = Date.new!(year, 5, 25)

    date =
      start_date
      |> Date.add(-1)
      |> Date.range(Date.add(start_date, -7), -1)
      |> Enum.filter(fn day -> Date.day_of_week(day) == 1 end)
      |> Enum.at(0)

    %Holiday{
      name: "Victoria Day",
      category: :local,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regional_names: [
        %{name: "National Patriots Day", region: :qc}
      ],
      regions: [
        :ab,
        :bc,
        :mb,
        :nt,
        :qc,
        :sk,
        :yt
      ],
      country: @country_code
    }
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:national_indigenous_peoples_day, year) do
    date = Date.new!(year, 6, 21)

    %Holiday{
      name: "National Indigenous Peoples Day",
      category: :local,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: false,
      regions: [
        :nt,
        :yt
      ],
      country: @country_code
    }
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:saint_jean_baptiste_day, year) do
    date = Date.new!(year, 6, 24)

    %Holiday{
      name: "Saint-Jean-Baptiste Day",
      category: :local,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regions: [
        :qc
      ],
      country: @country_code
    }
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:canada_day, year) do
    date = Date.new!(year, 7, 1)

    %Holiday{
      name: "Canada Day",
      category: :federal,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regional_names: [
        %{name: "Memorial Day", province: :nl}
      ],
      regions: :all
    }
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:civic_holiday, year) do
    date = DateHelpers.nth_weekday_in_month(year, 8, 1, 1)

    %Holiday{
      name: "Civic Holiday",
      category: :local,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regional_names: [
        %{name: "British Columbia Day", region: :bc},
        %{name: "New Brunswick Day", region: :nb},
        %{name: "Civic Holiday", region: :nt},
        %{name: "Civic Holiday", region: :nu},
        %{name: "Saskatchewan Day", region: :sk},
        %{name: "Discovery Day", region: :yt}
      ],
      regions: [
        :ab,
        :bc,
        :sk,
        :on,
        :nb,
        :nu
      ],
      country: @country_code
    }
  end

  def holiday(:gold_cup_parade_day, year) do
    date = DateHelpers.nth_weekday_in_month(year, 8, 5, 3)

    %Holiday{
      name: "Gold Cup Parade Day",
      category: :local,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: false,
      regions: [:pe],
      country: @country_code
    }
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:labour_day, year) do
    # Labour Day is the first Monday of September.
    date = DateHelpers.nth_weekday_in_month(year, 9, 1, 1)

    %Holiday{
      name: "Labour Day",
      category: :federal,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regions: :all,
      country: @country_code
    }
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:national_day_for_truth_and_reconciliation, year) do
    date = Date.new!(year, 9, 30)

    %Holiday{
      name: "National Day for Truth and Reconciliation",
      category: :local,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      description:
        "The day is meant for reflection and education about the history and legacy of residential schools in Canada",
      regions: [
        :bc,
        :nt,
        :nu,
        :pe,
        :yt
      ],
      country: @country_code
    }
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:thanksgiving_day, year) do
    date = DateHelpers.nth_weekday_in_month(year, 10, 1, 2)

    %Holiday{
      name: "Thanksgiving Day",
      category: :local,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regions: [
        :ab,
        :bc,
        :mb,
        :nt,
        :nu,
        :on,
        :qc,
        :sk,
        :yt
      ],
      country: @country_code
    }
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:remembrance_day, year) do
    date = Date.new!(year, 11, 11)

    %Holiday{
      name: "Remembrance Day",
      category: :local,
      date: date,
      observance_date: date,
      statutory: true,
      description:
        "Some employers in provinces where it's a statutory holiday might choose to give the following Monday off, but this isn't a universal practice. Ceremonies and moments of silence are typically observed at 11:00 AM local time on November 11, regardless of whether it's a work day or not",
      regions: [
        :ab,
        :bc,
        :nb,
        :nl,
        :nt,
        :nu,
        :pe,
        :sk,
        :yt
      ]
    }
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:christmas_day, year) do
    date = Date.new!(year, 12, 25)

    %Holiday{
      name: "Christmas Day",
      category: :federal,
      date: date,
      observance_date: date,
      statutory: true,
      country: @country_code
    }
  end

  @spec holiday(atom, integer) :: Holiday.t()
  def holiday(:boxing_day, year) do
    date = Date.new!(year, 12, 26)

    %Holiday{
      name: "Boxing Day",
      category: :local,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regions: [
        :on,
        :nt
      ],
      country: @country_code
    }
  end

  @spec holiday(atom, integer) :: {:error, atom()}
  def holiday(_, _year) do
    {:error, :unknown_holiday}
  end
end
