defmodule Holidex.Countries.Canada do
  @moduledoc """
  Provides information for all national and provincial Canadian holidays.
  """

  @typedoc """
  An atom representing a holiday name.
  """
  @type holiday_name ::
          :new_years_day
          | :family_day
          | :st_patricks_day
          | :good_friday
          | :easter_sunday
          | :easter_monday
          | :st_georges_day
          | :victoria_day
          | :canada_day
          | :nunavut_day
          | :civic_holiday
          | :discovery_day
          | :labour_day
          | :thanksgiving
          | :christmas_day
          | :boxing_day

  alias Holidex.DateHelpers, as: DateHelpers
  alias Holidex.DateCalculators.Easter, as: Easter
  alias Holidex.Holiday, as: Holiday

  @country_code :ca

  defstruct holidays: []

  @spec holidays(integer()) :: [Holidex.Holiday.t()] | {:error, :invalid_year}
  def holidays(year) when is_integer(year) do
    %__MODULE__{
      holidays: [
        holiday(:new_years_day, year),
        holiday(:family_day, year),
        holiday(:good_friday, year),
        holiday(:easter_sunday, year),
        holiday(:easter_monday, year),
        holiday(:st_georges_day, year),
        holiday(:victoria_day, year),
        holiday(:national_indigenous_peoples_day, year),
        holiday(:saint_jean_baptiste_day, year),
        holiday(:canada_day, year),
        holiday(:nunavut_day, year),
        holiday(:civic_holiday, year),
        holiday(:discovery_day, year),
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

  @doc """
  Retrieves holiday information for a specific holiday in a given year.

  ## Parameters

    - `holiday_name`: The name of the holiday as an atom (e.g., `:new_years_day`)
    - `year`: The year for which to retrieve the holiday information

  ## Returns

  A `Holidex.Holiday` struct containing the holiday information.

  ## Examples

      iex> Holidex.Countries.Canada.holiday(:canada_day, 2023)
      %Holidex.Holiday{name: "Canada Day", date: ~D[2023-07-01], ...}

  """
  @spec holiday(holiday_name(), integer()) :: Holidex.Holiday.t()
  def holiday(holiday_name, year)

  def holiday(:new_years_day, year) do
    date = Date.new!(year, 1, 1)

    %Holiday{
      name: "New Years Day",
      category: :national,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regions: :all,
      country: @country_code
    }
  end

  def holiday(:family_day, year) do
    date = DateHelpers.nth_weekday_in_month(year, 2, 1, 3)

    regional_names = [
      %{name: "Louis Riel Day", region: :mb},
      %{name: "Heritage Day", region: :ns},
      %{name: "Islander Day", region: :pe}
    ]

    %Holiday{
      name: "Family Day",
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      category: :regional,
      regional_names: regional_names,
      regions: [:ab, :bc, :nb, :on, :sk] ++ Enum.map(regional_names, & &1.region),
      country: @country_code
    }
  end

  def holiday(:st_patricks_day, year) do
    date = Date.new!(year, 3, 17)

    %Holiday{
      name: "St. Patrick's Day",
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      category: :religious,
      regions: [:nl],
      country: @country_code
    }
  end

  def holiday(:good_friday, year) do
    %{good_friday: date} = Easter.new(year)

    %Holiday{
      name: "Good Friday",
      category: :religious,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      description:
        "In Quebec, employers must choose between Good Friday and Easter Monday for their statutory holiday",
      country: @country_code
    }
  end

  def holiday(:easter_sunday, year) do
    %{easter_sunday: date} = Easter.new(year)

    %Holiday{
      name: "Easter Sunday",
      category: :religious,
      date: date,
      observance_date: date,
      statutory: false,
      country: @country_code
    }
  end

  def holiday(:easter_monday, year) do
    %{easter_monday: date} = Easter.new(year)

    %Holiday{
      name: "Easter Monday",
      category: :religious,
      date: date,
      observance_date: date,
      statutory: false,
      description:
        "In Quebec, employers must choose between Good Friday and Easter Monday for their statutory holiday",
      country: @country_code
    }
  end

  def holiday(:st_georges_day, year) do
    date = Date.new!(year, 4, 23)

    %Holiday{
      name: "St. George's Day",
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      category: :religious,
      regions: [:nl],
      country: @country_code
    }
  end

  def holiday(:victoria_day, year) do
    date = calculate(:victoria_day, year)

    %Holiday{
      name: "Victoria Day",
      category: :national,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regional_names: [
        %{name: "National Patriots' Day", region: :qc}
      ],
      regions: :all,
      regions_except: [:nb, :ns, :pe],
      country: @country_code
    }
  end

  def holiday(:national_indigenous_peoples_day, year) do
    date = Date.new!(year, 6, 21)

    %Holiday{
      name: "National Indigenous Peoples Day",
      category: :national,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regions: [
        :nt,
        :yt
      ],
      country: @country_code
    }
  end

  def holiday(:saint_jean_baptiste_day, year) do
    date = Date.new!(year, 6, 24)

    %Holiday{
      name: "Saint-Jean-Baptiste Day",
      category: :regional,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      description:
        "Quebec’s National Holiday - You may be entitled to paid leave. This depends on your collective agreement or employment contract.",
      regional_names: %{name: "Féte Nationale", region: :qc},
      regions: [
        :qc
      ],
      country: @country_code
    }
  end

  def holiday(:canada_day, year) do
    date = Date.new!(year, 7, 1)

    %Holiday{
      name: "Canada Day",
      category: :national,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regional_names: [
        %{name: "Memorial Day", province: :nl}
      ],
      regions: :all,
      country: @country_code
    }
  end

  def holiday(:nunavut_day, year) do
    date = Date.new!(year, 7, 9)

    %Holiday{
      name: "Nunavut Day",
      category: :regional,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regions: [:nu],
      country: @country_code
    }
  end

  def holiday(:civic_holiday, year) do
    date = DateHelpers.nth_weekday_in_month(year, 8, 1, 1)

    %Holiday{
      name: "Civic Holiday",
      category: :regional,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regional_names: [
        %{name: "British Columbia Day", region: :bc},
        %{name: "New Brunswick Day", region: :nb},
        %{name: "Saskatchewan Day", region: :sk}
      ],
      regions: [
        :ab,
        :bc,
        :sk,
        :on,
        :nt,
        :nb,
        :nu
      ],
      country: @country_code
    }
  end

  def holiday(:discovery_day, year) do
    date = Date.new!(year, 8, 19)

    %Holiday{
      name: "Discovery Day",
      category: :regional,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regions: [:yt],
      country: @country_code
    }
  end

  def holiday(:gold_cup_parade_day, year) do
    date = DateHelpers.nth_weekday_in_month(year, 8, 5, 3)

    %Holiday{
      name: "Gold Cup Parade Day",
      category: :regional,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: false,
      regions: [:pe],
      country: @country_code
    }
  end

  def holiday(:labour_day, year) do
    date = DateHelpers.nth_weekday_in_month(year, 9, 1, 1)

    %Holiday{
      name: "Labour Day",
      category: :national,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regions: :all,
      country: @country_code
    }
  end

  def holiday(:national_day_for_truth_and_reconciliation, year) do
    date = Date.new!(year, 9, 30)

    %Holiday{
      name: "National Day for Truth and Reconciliation",
      category: :national,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      description:
        "The day is meant for reflection and education about the history and legacy of residential schools in Canada",
      regions: [
        :bc,
        :nt,
        :pe,
        :yt
      ],
      country: @country_code
    }
  end

  def holiday(:thanksgiving_day, year) do
    date = DateHelpers.nth_weekday_in_month(year, 10, 1, 2)

    %Holiday{
      name: "Thanksgiving Day",
      category: :national,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      regions: :all,
      regions_except: [
        :nb,
        :ns,
        :pe
      ],
      description: "Retail stores are closed in Nova Scotia (ns)",
      country: @country_code
    }
  end

  def holiday(:remembrance_day, year) do
    date = Date.new!(year, 11, 11)

    %Holiday{
      name: "Remembrance Day",
      category: :national,
      date: date,
      observance_date: date,
      statutory: true,
      regional_names: [
        %{
          name: "Armistice Day",
          region: :nl
        }
      ],
      description:
        "Some employers in provinces where it's a statutory holiday might choose to give the following Monday off, but this isn't a universal practice. Ceremonies and moments of silence are typically observed at 11:00 AM local time on November 11, regardless of whether it's a work day or not",
      regions: :all,
      regions_except: [:ns, :on, :qc],
      country: @country_code
    }
  end

  def holiday(:christmas_day, year) do
    date = Date.new!(year, 12, 25)

    %Holiday{
      name: "Christmas Day",
      category: :national,
      date: date,
      observance_date: date,
      statutory: true,
      country: @country_code
    }
  end

  def holiday(:boxing_day, year) do
    date = Date.new!(year, 12, 26)

    %Holiday{
      name: "Boxing Day",
      category: :regional,
      date: date,
      observance_date: DateHelpers.get_observance(date),
      statutory: true,
      description: "Retail stores are closed in Nova Scotia (ns)",
      regions: [
        :on,
        :nl
      ],
      country: @country_code
    }
  end

  @spec holiday(holiday_name(), integer) :: {:error, atom()}
  def holiday(_, _year) do
    {:error, :unknown_holiday}
  end

  defp calculate(:victoria_day, year) do
    start_date = Date.new!(year, 5, 25)

    start_date
    |> Date.add(-1)
    |> Date.range(Date.add(start_date, -7), -1)
    |> Enum.filter(fn day -> Date.day_of_week(day) == 1 end)
    |> Enum.at(0)
  end
end
