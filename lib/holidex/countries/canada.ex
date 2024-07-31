defmodule Holidex.Countries.Canada do
  import Holidex.YearGuard

  @moduledoc """
  Provides public holiday observances for Canadian holidays. Each province and territory in Canada has the authority to establish its own holiday schedule and observance rules.
  """

  alias Holidex.DateCalculators.Easter
  alias Holidex.DateHelpers
  alias Holidex.NationalHoliday
  alias Holidex.RegionalHoliday

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
          | :canada_day
          | :nunavut_day
          | :civic_holiday
          | :discovery_day
          | :labour_day
          | :thanksgiving
          | :christmas_day
          | :boxing_day

  @country_code :ca
  @region_codes [:ab, :bc, :mb, :nb, :nl, :nt, :nv, :nt, :on, :pe, :qc, :sk, :yt]

  @spec holidays(integer()) :: {:ok, list(%Holidex.NationalHoliday{})} | {:error, atom()}
  def holidays(year) when is_valid_year(year) do
    {:ok,
     [
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
     ]}
  end

  def holidays(_), do: {:error, :invalid_parameters}

  @spec region_codes() :: list(atom())
  def region_codes() do
    regions() |> Enum.map(& &1.region_code)
  end

  # Reference: https://excelnotes.com/category/holiday/canada/
  @spec regions() :: list(map())
  def regions do
    [
      %{
        name: "Alberta",
        region_type: :province,
        region_code: :ab,
        reference_url: "https://www.alberta.ca/alberta-general-holidays"
      },
      %{
        name: "British Columbia",
        region_type: :province,
        region_code: :bc,
        reference_url:
          "https://www.gov.bc.ca/gov/content/employment-business/employment-standards-advice/employment-standards/statutory-holidays"
      },
      %{
        name: "Manitoba",
        region_type: :province,
        region_code: :mb,
        reference_url:
          "https://www.gov.mb.ca/labour/standards/doc,gen-holidays-after-april-30-07,factsheet.html"
      },
      %{
        name: "New Brunswick",
        region_type: :province,
        region_code: :nb,
        reference_url:
          "https://www2.gnb.ca/content/gnb/en/corporate/promo/immigration/working-in-nb/employee-rights-and-obligations.html"
      },
      %{
        name: "Newfoundland and Labrador",
        region_type: :province,
        region_code: :nl,
        reference_url: "https://www.gov.nl.ca/exec/tbs/2024-paid-holidays-2/"
      },
      %{
        name: "Northwest Territories",
        region_type: :territory,
        region_code: :nt,
        reference_url: ""
      },
      %{
        name: "Nova Scotia",
        region_type: :province,
        region_code: :ns,
        reference_url: "https://novascotia.ca/lae/employmentrights/holidaychart.asp"
      },
      %{
        name: "Nunavut",
        region_type: :territory,
        region_code: :nu,
        reference_url: "https://nu-lsco.ca/faq-s?tmpl=component&faqid=11"
      },
      %{
        name: "Ontario",
        region_type: :province,
        region_code: :on,
        reference_url:
          "https://www.ontario.ca/document/your-guide-employment-standards-act-0/public-holidays"
      },
      %{
        name: "Prince Edward Island",
        region_type: :province,
        region_code: :pe,
        reference_url:
          "https://www.princeedwardisland.ca/en/information/workforce-advanced-learning-and-population/paid-holidays"
      },
      %{
        name: "Québec",
        region_type: :province,
        region_code: :qc,
        reference_url: "https://educaloi.qc.ca/en/capsules/public-holidays/"
      },
      %{
        name: "Saskatchewan",
        region_type: :province,
        region_code: :sk,
        reference_url:
          "https://www.saskatchewan.ca/business/employment-standards/public-statutory-holidays/list-of-saskatchewan-public-holidays"
      },
      %{
        name: "Yukon",
        region_type: :territory,
        region_code: :yt,
        reference_url:
          "https://yukon.ca/en/doing-business/employer-responsibilities/find-yukon-statutory-holiday",
        public_holiday_count: 10
      }
    ]
  end

  @spec holidays_by_region(region_code(), integer()) ::
          {:ok, [RegionalHoliday.t()]} | {:error, atom()}
  def holidays_by_region(region_filter, year)
      when is_valid_year(year) and region_filter in @region_codes do
    case __MODULE__.holidays(year) do
      {:ok, holidays} ->
        holidays =
          holidays
          |> Enum.filter(&(region_filter in &1.regions))
          |> Enum.map(fn holiday ->
            default_keys = NationalHoliday.__struct__() |> Map.keys()
            regional_names = Map.take(holiday, default_keys).regional_names

            regional_holiday =
              case Map.fetch(regional_names, region_filter) do
                {:ok, result} ->
                  Map.put(holiday, :name, "#{result} (#{holiday.name})")
                  |> Map.put(:region, region_filter)

                :error ->
                  # there is no regional specific holiday name, return the holiday as is
                  holiday
              end

            regional_holiday =
              Map.drop(regional_holiday, [:regions, :regional_names])
              |> Map.from_struct()

            struct!(RegionalHoliday, regional_holiday)
          end)

        {:ok, holidays}

      {:error, error} ->
        {:error, error}
    end
  end

  def holidays_by_region(_, _), do: {:error, :invalid_parameters}

  # def national_to_regional(%NationalHoliday{} = national, region) do
  #   %RegionalHoliday{
  #     name: Map.get(national.regional_names, region, national.name),
  #     categories: national.categories,
  #     date: national.date,
  #     observance_date: national.observance_date,
  #     region: region,
  #     country: national.country
  #   }
  # end

  @doc """
  Retrieves holiday information for a holiday in a given year.

  ## Parameters

    - `holiday_name`: The name of the holiday as an atom (e.g., `:new_years_day`)
    - `year`: The year for which to retrieve the holiday information

  ## Returns

  A `Holidex.NationalHoliday` struct containing the holiday information.

  ## Examples

      iex> Holidex.Countries.Canada.holiday(:canada_day, 2023)
      %Holidex.NationalHoliday{name: "Canada Day", date: ~D[2023-07-01], ...}

  """

  @spec holiday(holiday_name(), integer()) :: Holidex.NationalHoliday.t() | {:error, atom()}
  def holiday(:new_years_day, year) when is_valid_year(year) do
    date = Date.new!(year, 1, 1)

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
      regions: [:ab, :bc, :nb, :on, :sk] ++ [:mb, :ns, :pe]
    }
  end

  def holiday(:st_patricks_day, year) when is_valid_year(year) do
    date = Date.new!(year, 3, 17)

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
      description:
        "In Quebec, employers must choose between Good Friday and Easter Monday for their statutory holiday",
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
      description:
        "In Quebec, employers must choose between Good Friday and Easter Monday for their statutory holiday",
      categories: [:national, :religious],
      country: @country_code,
      date: date,
      observance_date: date
    }
  end

  def holiday(:st_georges_day, year) when is_valid_year(year) do
    date = Date.new!(year, 4, 23)

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

    %NationalHoliday{
      name: "Victoria Day",
      # regions_except: [:nb, :ns, :pe],
      categories: [:national, :regional],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regional_names: %{qc: "National Patriots' Day"},
      regions: region_codes()
    }
  end

  def holiday(:national_indigenous_peoples_day, year) when is_valid_year(year) do
    date = Date.new!(year, 6, 21)

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
    date = Date.new!(year, 6, 24)

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
    date = Date.new!(year, 7, 1)

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
    date = Date.new!(year, 7, 9)

    %NationalHoliday{
      name: "Nunavut Day",
      categories: [:regional],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regions: [:nu]
    }
  end

  def holiday(:civic_holiday, year) when is_valid_year(year) do
    date = DateHelpers.nth_weekday_in_month(year, 8, 1, 1)
    # :on, # not technically a public holiday
    %NationalHoliday{
      name: "Civic Holiday",
      categories: [:national, :regional],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regional_names: %{
        bc: "British Columbia Day",
        nb: "New Brunswick Day",
        sk: "Saskatchewan Day"
      },
      regions: [
        :ab,
        :bc,
        :sk,
        :nt,
        :nb,
        :nu
      ]
    }
  end

  def holiday(:discovery_day, year) when is_valid_year(year) do
    date = Date.new!(year, 8, 19)

    %NationalHoliday{
      name: "Discovery Day",
      categories: [:regional],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regions: [:yt]
    }
  end

  def holiday(:gold_cup_parade_day, year) when is_valid_year(year) do
    date = DateHelpers.nth_weekday_in_month(year, 8, 5, 3)

    %NationalHoliday{
      name: "Gold Cup Parade Day",
      categories: [:regional],
      country: @country_code,
      date: date,
      observance_date: DateHelpers.post_weekend_observance(date),
      regions: [:pe]
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
    date = Date.new!(year, 9, 30)

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

    %NationalHoliday{
      name: "Thanksgiving Day",
      categories: [:national],
      date: date,
      observance_date: date,
      regions: region_codes(),
      # regions_except: [
      #   :nb,
      #   :ns,
      #   :pe
      # ],
      description: "Retail stores are closed in Nova Scotia (ns)",
      country: @country_code
    }
  end

  def holiday(:remembrance_day, year) when is_valid_year(year) do
    date = Date.new!(year, 11, 11)

    %NationalHoliday{
      name: "Remembrance Day",
      categories: [:national],
      country: @country_code,
      date: date,
      description:
        "Some employers in provinces where it's a statutory holiday might choose to give the following Monday off, but this isn't a universal practice. Ceremonies and moments of silence are typically observed at 11:00 AM local time on November 11, regardless of whether it's a work day or not",
      observance_date: DateHelpers.post_weekend_observance(date),
      regional_names: %{
        nl: "Armistice Day"
      },
      regions: Enum.reject(region_codes(), fn region_code -> region_code in [:ns, :on, :qc] end)
    }
  end

  def holiday(:christmas_day, year) when is_valid_year(year) do
    date = Date.new!(year, 12, 25)

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

  def holiday(_unknown_holiday, _year), do: {:error, :invalid_parameters}

  @spec boxing_day_observance(integer()) :: Date.t() | {:error, atom()}
  defp boxing_day_observance(year) do
    case holiday(:christmas_day, year) do
      %NationalHoliday{observance_date: observance_date} ->
        case Date.day_of_week(observance_date) do
          5 -> Date.add(observance_date, 3)
          _ -> Date.add(observance_date, 1)
        end

      {:error, error} ->
        {:error, error}
    end
  end

  defp calculate(:victoria_day, year) when is_valid_year(year) do
    start_date = Date.new!(year, 5, 25)

    start_date
    |> Date.add(-1)
    |> Date.range(Date.add(start_date, -7), -1)
    |> Enum.filter(fn day -> Date.day_of_week(day) == 1 end)
    |> Enum.at(0)
  end
end
