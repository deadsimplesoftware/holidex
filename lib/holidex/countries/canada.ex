defmodule Holidex.Countries.Canada do
  @moduledoc """
  Provides public holiday observances for Canadian holidays. Each province and territory in Canada has the authority to establish its own holiday schedule and observance rules.
  """

  import Holidex.YearGuard

  alias Holidex.DateCalculators.Easter
  alias Holidex.DateHelpers
  alias Holidex.NationalHoliday
  alias Holidex.RegionalHoliday

  @typedoc """
  An atom representing a supported holiday name.
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
          | :national_indigenous_peoples_day
          | :saint_jean_baptiste_day
          | :canada_day
          | :orangemans_day
          | :nunavut_day
          | :civic_holiday
          | :discovery_day
          | :labour_day
          | :national_day_for_truth_and_reconciliation
          | :thanksgiving_day
          | :remembrance_day
          | :christmas_day
          | :boxing_day

  @typedoc """
  An atom representing a Province or Territory short code.
  """
  @type region_code ::
          :ab
          | :bc
          | :mb
          | :nb
          | :nl
          | :nt
          | :nv
          | :nt
          | :on
          | :pe
          | :qc
          | :sk
          | :yt

  @type year :: 1900..2200

  @region_codes [:ab, :bc, :mb, :nb, :nl, :ns, :nt, :nu, :on, :pe, :qc, :sk, :yt]
  @country_code :ca
  @invalid_parameters :invalid_parameters

  @doc """
  Retrieves a list of national public holidays for the specified year.

  ## Parameters

    * `year` - An integer representing the year for which to fetch holidays.

  ## Returns

    * `{:ok, list(Holidex.NationalHoliday.t())}` - A tuple containing `:ok` and a list of
      `Holidex.NationalHoliday` structs representing the public holidays for the given year.
    * `{:error, atom(), String.t()}` - A tuple containing `:error`, the method called as a tuple,
        and an error message string if the operation fails (e.g., invalid year, API failure, etc.).
    * `{:error, String.t()}` - A tuple containing `:error` and an error message string if
      the operation fails (e.g., invalid year, API failure, etc.).

  ## Examples

      iex> Holidex.Countries.Canada.holidays(2024)
      {:ok, [%Holidex.NationalHoliday{name: "New Year's Day", date: ~D[2024-01-01]}, ...]}

      iex> Holidex.Countries.Canada.holidays(1800)
      {:error, :holidays, "Year was out of range..."}
  """
  @spec holidays(year()) ::
          {:ok, list(Holidex.NationalHoliday.t())}
          | {:error, atom(), String.t()}
          | {:error, String.t()}
  def holidays(year) when is_valid_year(year) do
    with {:new_years_day, %NationalHoliday{} = new_years_day} <-
           {:new_years_day, holiday(:new_years_day, year)},
         {:family_day, %NationalHoliday{} = family_day} <-
           {:family_day, holiday(:family_day, year)},
         {:st_patricks_day, %NationalHoliday{} = st_patricks_day} <-
           {:st_patricks_day, holiday(:st_patricks_day, year)},
         {:good_friday, %NationalHoliday{} = good_friday} <-
           {:good_friday, holiday(:good_friday, year)},
         {:easter_sunday, %NationalHoliday{} = easter_sunday} <-
           {:easter_sunday, holiday(:easter_sunday, year)},
         {:easter_monday, %NationalHoliday{} = easter_monday} <-
           {:easter_monday, holiday(:easter_monday, year)},
         {:st_georges_day, %NationalHoliday{} = st_georges_day} <-
           {:st_georges_day, holiday(:st_georges_day, year)},
         {:victoria_day, %NationalHoliday{} = victoria_day} <-
           {:victoria_day, holiday(:victoria_day, year)},
         {:national_indigenous_peoples_day, %NationalHoliday{} = national_indigenous_peoples_day} <-
           {:national_indigenous_peoples_day, holiday(:national_indigenous_peoples_day, year)},
         {:saint_jean_baptiste_day, %NationalHoliday{} = saint_jean_baptiste_day} <-
           {:saint_jean_baptiste_day, holiday(:saint_jean_baptiste_day, year)},
         {:canada_day, %NationalHoliday{} = canada_day} <-
           {:canada_day, holiday(:canada_day, year)},
         {:orangemans_day, %NationalHoliday{} = orangemans_day} <-
           {:orangemans_day, holiday(:orangemans_day, year)},
         {:nunavut_day, %NationalHoliday{} = nunavut_day} <-
           {:nunavut_day, holiday(:nunavut_day, year)},
         {:civic_holiday, %NationalHoliday{} = civic_holiday} <-
           {:civic_holiday, holiday(:civic_holiday, year)},
         {:discovery_day, %NationalHoliday{} = discovery_day} <-
           {:discovery_day, holiday(:discovery_day, year)},
         {:labour_day, %NationalHoliday{} = labour_day} <-
           {:labour_day, holiday(:labour_day, year)},
         {:national_day_for_truth_and_reconciliation, %NationalHoliday{} = national_day_for_truth_and_reconciliation} <-
           {:national_day_for_truth_and_reconciliation, holiday(:national_day_for_truth_and_reconciliation, year)},
         {:thanksgiving_day, %NationalHoliday{} = thanksgiving_day} <-
           {:thanksgiving_day, holiday(:thanksgiving_day, year)},
         {:remembrance_day, %NationalHoliday{} = remembrance_day} <-
           {:remembrance_day, holiday(:remembrance_day, year)},
         {:christmas_day, %NationalHoliday{} = christmas_day} <-
           {:christmas_day, holiday(:christmas_day, year)},
         {:boxing_day, %NationalHoliday{} = boxing_day} <-
           {:boxing_day, holiday(:boxing_day, year)} do
      {:ok,
       [
         new_years_day,
         family_day,
         st_patricks_day,
         good_friday,
         easter_sunday,
         easter_monday,
         st_georges_day,
         victoria_day,
         national_indigenous_peoples_day,
         saint_jean_baptiste_day,
         canada_day,
         orangemans_day,
         nunavut_day,
         civic_holiday,
         discovery_day,
         labour_day,
         national_day_for_truth_and_reconciliation,
         thanksgiving_day,
         remembrance_day,
         christmas_day,
         boxing_day
       ]}
    else
      {step, {:error, message}} -> {:error, "Unexpected return from: #{step}, got: #{message}"}
      error -> {:error, error}
    end
  end

  def holidays(_year) do
    {:error, :holidays, "Invalid argument for: year. Expected an integer between 1900 and 2200."}
  end

  @doc """
  Retrieves a list of available region codes.

  This function returns a list of region codes that can be used with other functions
  in the module to specify geographic regions for holiday data.

  ## Returns

    * `list(region_code())` - A list of strings representing region codes.

  ## Examples

      iex> Holidex.Countries.Canada.region_codes()
      [:ab, :bc, :mb, :nb, :nl, :nt, :ns, :nu, :on, :pe, :qc, :sk, :yt]
  """
  @spec region_codes() :: list(region_code())
  def region_codes do
    Enum.map(regions(), & &1.region_code)
  end

  @doc """
  Retrieves detailed information about all available regions.

  This function returns a list of maps, each containing detailed information
  about a specific region, including its name, type, and region code.

  ## Returns

    * `list(map())` - A list of maps, each representing a region with the following keys:
      - `:name` - The name of the region (string)
      - `:region_type` - The type of the region (atom, e.g., :province, :state)
      - `:region_code` - The code for the region (atom)

  ## Examples

      iex> Holidex.Countries.Canada.regions()
      [
        %{name: "Alberta", region_type: :province, region_code: :ab},
        %{name: "British Columbia", region_type: :province, region_code: :bc},
        ...
      ]
  """
  @spec regions() :: list(map())
  def regions do
    [
      %{
        name: "Alberta",
        region_type: :province,
        region_code: :ab
      },
      %{
        name: "British Columbia",
        region_type: :province,
        region_code: :bc
      },
      %{
        name: "Manitoba",
        region_type: :province,
        region_code: :mb
      },
      %{
        name: "New Brunswick",
        region_type: :province,
        region_code: :nb
      },
      %{
        name: "Newfoundland and Labrador",
        region_type: :province,
        region_code: :nl
      },
      %{
        name: "Northwest Territories",
        region_type: :territory,
        region_code: :nt
      },
      %{
        name: "Nova Scotia",
        region_type: :province,
        region_code: :ns
      },
      %{
        name: "Nunavut",
        region_type: :territory,
        region_code: :nu
      },
      %{
        name: "Ontario",
        region_type: :province,
        region_code: :on
      },
      %{
        name: "Prince Edward Island",
        region_type: :province,
        region_code: :pe
      },
      %{
        name: "Québec",
        region_type: :province,
        region_code: :qc
      },
      %{
        name: "Saskatchewan",
        region_type: :province,
        region_code: :sk
      },
      %{
        name: "Yukon",
        region_type: :territory,
        region_code: :yt
      }
    ]
  end

  @doc """
  Generates a NationalHoliday struct for the specified holiday and year.

  This function creates a NationalHoliday struct for the given holiday and year.
  It also calculates the observance date, which may differ from the actual date
  if the holiday falls on a weekend or has special observance rules.

  ## Parameters
    - holiday_name: Atom representing the holiday (e.g., :new_years_day, :labour_day)
    - year: Integer representing the year for which to generate the holiday

  ## Returns
    * `Holidex.NationalHoliday.t()`: A struct containing details about the holiday
    * `{:error, :holiday, atom()}`: An error tuple if the input is invalid

  ## Examples
      iex> Holidex.Countries.Canada.holiday(:new_years_day, 2024)
      %Holidex.NationalHoliday{
        name: "New Years Day",
        categories: [:national],
        date: ~D[2024-01-01],
        observance_date: ~D[2024-01-01],
        regional_names: %{},
        regions: [:ab, :bc, :mb, :nb, :nl, :nt, :ns, :nu, :on, :pe, :qc, :sk, :yt],
        description: "",
        country: :ca
      }
  """
  @spec holiday(holiday_name(), year()) ::
          Holidex.NationalHoliday.t() | {:error, :holiday, atom()}
  def holiday(:new_years_day, year) when is_valid_year(year) do
    {:ok, date} = Date.new(year, 1, 1)

    %NationalHoliday{
      name: "New Years Day",
      categories: [:national],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regions: region_codes()
    }
  end

  def holiday(:family_day, year) when is_valid_year(year) do
    date = DateHelpers.nth_weekday_in_month(year, 2, 1, 3)

    regional_names = %{
      mb: "Louis Riel Day",
      ns: "Heritage Day",
      pe: "Islander Day"
    }

    %NationalHoliday{
      name: "Family Day",
      categories: [:regional],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regional_names: regional_names,
      regions: [:ab, :bc, :nb, :on, :sk, :mb, :ns, :pe]
    }
  end

  def holiday(:st_patricks_day, year) when is_valid_year(year) do
    {:ok, date} = Date.new(year, 3, 17)

    %NationalHoliday{
      name: "St. Patrick's Day",
      categories: [:regional, :religious],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regions: [:nl]
    }
  end

  def holiday(:good_friday, year) when is_valid_year(year) do
    %{good_friday: date} = Easter.new(year)

    %NationalHoliday{
      name: "Good Friday",
      description: "In Quebec, employers must choose between Good Friday and Easter Monday for their public holiday",
      categories: [:national, :religious],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regions: region_codes()
    }
  end

  def holiday(:easter_sunday, year) when is_valid_year(year) do
    %{easter_sunday: date} = Easter.new(year)

    %NationalHoliday{
      name: "Easter Sunday",
      categories: [:religious],
      date: date,
      observance_date: date,
      country: @country_code
    }
  end

  def holiday(:easter_monday, year) when is_valid_year(year) do
    %{easter_monday: date} = Easter.new(year)

    %NationalHoliday{
      name: "Easter Monday",
      description: "In Quebec, employers must choose between Good Friday and Easter Monday for their public holiday",
      categories: [:national, :religious],
      country: @country_code,
      date: date,
      observance_date: date
    }
  end

  def holiday(:st_georges_day, year) when is_valid_year(year) do
    {:ok, date} = Date.new(year, 4, 23)

    %NationalHoliday{
      name: "St. George's Day",
      categories: [:regional],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regions: [:nl]
    }
  end

  def holiday(:victoria_day, year) when is_valid_year(year) do
    date = calculate(:victoria_day, year)
    # regions_except: [:nb, :ns, :pe],
    regions = Enum.reject(region_codes(), &(&1 in [:pe]))

    %NationalHoliday{
      name: "Victoria Day",
      categories: [:national, :regional],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regional_names: %{qc: "National Patriots' Day"},
      regions: regions
    }
  end

  def holiday(:national_indigenous_peoples_day, year) when is_valid_year(year) do
    {:ok, date} = Date.new(year, 6, 21)

    %NationalHoliday{
      name: "National Indigenous Peoples Day",
      categories: [:regional],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regions: [:nt, :yt]
    }
  end

  def holiday(:saint_jean_baptiste_day, year) when is_valid_year(year) do
    {:ok, date} = Date.new(year, 6, 24)

    %NationalHoliday{
      name: "Saint-Jean-Baptiste Day",
      categories: [:regional],
      country: @country_code,
      date: date,
      description:
        "Quebec’s National Holiday - You may be entitled to paid leave. This depends on your collective agreement or employment contract.",
      observance_date: DateHelpers.post_weekend_observance(date),
      regional_names: %{qc: "Fête Nationale"},
      regions: [:qc]
    }
  end

  def holiday(:canada_day, year) when is_valid_year(year) do
    {:ok, date} = Date.new(year, 7, 1)

    %NationalHoliday{
      name: "Canada Day",
      categories: [:national],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regional_names: %{nl: "Memorial Day"},
      regions: region_codes()
    }
  end

  def holiday(:nunavut_day, year) when is_valid_year(year) do
    {:ok, date} = Date.new(year, 7, 9)

    %NationalHoliday{
      name: "Nunavut Day",
      categories: [:regional],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regions: [:nu]
    }
  end

  def holiday(:orangemans_day, year) when is_valid_year(year) do
    {:ok, date} = Date.new(year, 7, 15)

    %NationalHoliday{
      name: "Orangeman’s Day",
      categories: [:regional],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regions: [:nl]
    }
  end

  def holiday(:civic_holiday, year) when is_valid_year(year) do
    date = DateHelpers.nth_weekday_in_month(year, 8, 1, 1)

    %NationalHoliday{
      name: "Civic Holiday",
      categories: [:national, :regional],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regional_names: %{
        ab: "Heritage Day",
        mb: "Terry Fox Day",
        bc: "British Columbia Day",
        nb: "New Brunswick Day",
        ns: "Natal Day",
        sk: "Saskatchewan Day"
      },
      regions: [
        :bc,
        :nb,
        :nt,
        :nu,
        :sk
      ]
    }
  end

  def holiday(:discovery_day, year) when is_valid_year(year) do
    {:ok, date} = Date.new(year, 8, 19)

    %NationalHoliday{
      name: "Discovery Day",
      categories: [:regional],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regions: [:yt]
    }
  end

  def holiday(:labour_day, year) when is_valid_year(year) do
    date = DateHelpers.nth_weekday_in_month(year, 9, 1, 1)

    %NationalHoliday{
      name: "Labour Day",
      categories: [:national],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regions: region_codes()
    }
  end

  def holiday(:national_day_for_truth_and_reconciliation, year) when is_valid_year(year) do
    {:ok, date} = Date.new(year, 9, 30)

    %NationalHoliday{
      name: "National Day for Truth and Reconciliation",
      categories: [:national, :regional],
      country: @country_code,
      date: date,
      description:
        "The day is meant for reflection and education about the history and legacy of residential schools in Canada",
      observance_date: DateHelpers.post_weekend_observance(date),
      regional_names: %{mb: "Orange Shirt Day"},
      regions: [:bc, :nt, :pe, :mb, :yt]
    }
  end

  def holiday(:thanksgiving_day, year) when is_valid_year(year) do
    date = DateHelpers.nth_weekday_in_month(year, 10, 1, 2)
    regions = Enum.reject(region_codes(), &(&1 in [:nb, :ns, :pe]))

    %NationalHoliday{
      name: "Thanksgiving Day",
      categories: [:national],
      date: date,
      observance_date: date,
      regions: regions,
      country: @country_code
    }
  end

  def holiday(:remembrance_day, year) when is_valid_year(year) do
    {:ok, date} = Date.new(year, 11, 11)
    regions = Enum.reject(region_codes(), &(&1 in [:ns, :on, :qc, :mb]))

    %NationalHoliday{
      name: "Remembrance Day",
      categories: [:national],
      country: @country_code,
      date: date,
      description:
        "Some employers in provinces where it's a public holiday might choose to give the following Monday off, but this isn't a universal practice. Ceremonies and moments of silence are typically observed at 11:00 AM local time on November 11, regardless of whether it's a work day or not",
      observance_date: DateHelpers.post_weekend_observance(date),
      regional_names: %{
        nl: "Armistice Day"
      },
      regions: regions
    }
  end

  def holiday(:christmas_day, year) when is_valid_year(year) do
    {:ok, date} = Date.new(year, 12, 25)

    %NationalHoliday{
      name: "Christmas Day",
      categories: [:national, :religious],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regions: region_codes()
    }
  end

  def holiday(:boxing_day, year) when is_valid_year(year) do
    {:ok, date} = Date.new(year, 12, 26)
    observance_date = boxing_day_observance(year)

    %NationalHoliday{
      name: "Boxing Day",
      categories: [:national, :regional],
      country: @country_code,
      date: date,
      description: "Retail stores are closed in Nova Scotia (ns)",
      observance_date: observance_date,
      regions: [:on, :nl]
    }
  end

  def holiday(_unknown_holiday, _year) do
    {:error, :holiday, @invalid_parameters}
  end

  @spec boxing_day_observance(year()) :: Date.t()
  defp boxing_day_observance(year) do
    %NationalHoliday{observance_date: observance_date} =
      holiday(:christmas_day, year)

    case Date.day_of_week(observance_date) do
      5 -> Date.add(observance_date, 3)
      _ -> Date.add(observance_date, 1)
    end
  end

  @doc """
  Retrieves a list of national and regional holidays for a specific region and year.

  This function fetches all observed national and regional holidays and will use localized
  holiday names if they're available. The nationally recognized name will appear beside
  it's regional counterpart in parenthesis.

  ## Parameters
    - region_code: String or atom representing the region code (e.g., :on, :bc)
    - year: Integer representing the year for which to retrieve holidays

  ## Returns
    * `{:ok, [RegionalHoliday.t()]}`: A tuple containing a list of RegionalHoliday structs
    * `{:error, atom()}`: An error tuple if the input is invalid or an error occurs during processing

  ## Examples
      iex> Holidex.Countries.Canada.holidays_by_region(:mb, 2024)
      {:ok,
       [
         %Holidex.RegionalHoliday{
           name: "New Years Day",
           categories: [:national],
           date: ~D[2024-01-01],
           observance_date: ~D[2024-01-01],
           region: :mb,
           description: "",
           country: :ca
         },
         %Holidex.RegionalHoliday{
           name: "Louis Riel Day (Family Day)",
           categories: [:regional],
           date: ~D[2024-02-19],
           observance_date: ~D[2024-02-19],
           region: :mb,
           description: "",
           country: :ca
         },
         ...
        ]

      iex> Holidex.holidays_by_region(:invalid_region, 2024)
      {:error, :holidays_by_region, :invalid_parameters}
  """
  @spec holidays_by_region(region_code(), integer()) ::
          {:ok, [RegionalHoliday.t()]} | {:error, atom()}
  def holidays_by_region(region_code, year) when is_valid_year(year) and region_code in @region_codes do
    {:ok, holidays} = __MODULE__.holidays(year)

    {:ok,
     holidays
     |> filter_by_region_code(region_code)
     |> map_national_to_regional(region_code)}
  end

  def holidays_by_region(_region_code, _year) do
    {:error, :holidays_by_region, @invalid_parameters}
  end

  defp filter_by_region_code(holidays, region_code) do
    Enum.filter(holidays, &(region_code in &1.regions))
  end

  defp map_national_to_regional(holidays, region_code) do
    Enum.map(holidays, &national_to_regional(&1, region_code))
  end

  defp national_to_regional(%NationalHoliday{regional_names: regional_names} = national, region_code) do
    name =
      case Map.get(regional_names, region_code) do
        nil -> "#{national.name}"
        regional_name -> "#{regional_name} (#{national.name})"
      end

    struct!(RegionalHoliday, %{
      name: name,
      categories: national.categories,
      date: national.date,
      observance_date: national.observance_date,
      region: region_code,
      country: national.country
    })
  end

  defp calculate(:victoria_day, year) when is_valid_year(year) do
    {:ok, start_date} = Date.new(year, 5, 25)

    start_date
    |> Date.add(-1)
    |> Date.range(Date.add(start_date, -7), -1)
    |> Enum.filter(fn day -> Date.day_of_week(day) == 1 end)
    |> Enum.at(0)
  end
end
