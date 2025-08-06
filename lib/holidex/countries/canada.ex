defmodule Holidex.Countries.Canada do
  # TODO: consider the introduction of holidays i.e. what year was it introduced or retired
  @moduledoc """
  Provides public holiday dates and observances for Canadian holidays.
  Each province and territory in Canada has the authority to establish its
  own holiday schedule and observance rules.
  """

  import Holidex.YearGuard

  @type year :: 1900..2200

  @derive JSON.Encoder
  defstruct name: "Canada",
            country_code: :ca,
            regions: [],
            national_holidays: [],
            regional_holidays: %{}

  def new(year) do
    %__MODULE__{
      national_holidays: year |> holidays() |> Enum.sort_by(& &1.observance_date, {:asc, Date}),
      regional_holidays: holidays_by_region(year),
      regions: regions()
    }
  end

  @doc """
  Retrieves detailed information about all available regions.

  This function returns a list of maps, each containing detailed information
  about a specific region, including its name, region type, and region code.

  ## Returns

    * `list(map())` - A list of maps, each representing a region with the following keys:
      - `:name` - The name of the region (string)
      - `:region_type` - The type of the region (atom, e.g., :province, :state)
      - `:region_code` - The code for the region (atom)

  ## Examples

      iex> Holidex.Countries.Canada.regions()
      [
        %{name: "Alberta", region_type: :province, region_code: "ab"},
        %{name: "British Columbia", region_type: :province, region_code: "bc"},
        ...
      ]
  """
  @spec regions() :: list(map())
  def regions do
    [
      %{
        name: "Alberta",
        region_type: "province",
        region_code: "ab"
      },
      %{
        name: "British Columbia",
        region_type: "province",
        region_code: "bc"
      },
      %{
        name: "Manitoba",
        region_type: "province",
        region_code: "mb"
      },
      %{
        name: "New Brunswick",
        region_type: "province",
        region_code: "nb"
      },
      %{
        name: "Newfoundland and Labrador",
        region_type: "province",
        region_code: "nl"
      },
      %{
        name: "Northwest Territories",
        region_type: "territory",
        region_code: "nt"
      },
      %{
        name: "Nova Scotia",
        region_type: "province",
        region_code: "ns"
      },
      %{
        name: "Nunavut",
        region_type: "territory",
        region_code: "nu"
      },
      %{
        name: "Ontario",
        region_type: "province",
        region_code: "on"
      },
      %{
        name: "Prince Edward Island",
        region_type: "province",
        region_code: "pe"
      },
      %{
        name: "Quebec",
        region_type: "province",
        region_code: "qc"
      },
      %{
        name: "Saskatchewan",
        region_type: "province",
        region_code: "sk"
      },
      %{
        name: "Yukon",
        region_type: "territory",
        region_code: "yt"
      }
    ]
  end

  @spec region_codes() :: list(atom())
  def region_codes do
    Enum.map(regions(), & &1.region_code)
  end

  @spec holidays(year()) :: list(Holidex.NationalHoliday.t())
  def holidays(year) when is_valid_year(year) do
    Holidex.Transformers.compute_holidays(holiday_definitions(), year)
  end

  @spec holiday(String.t(), year()) :: {:ok, Holidex.NationalHoliday.t()} | {:error, String.t()}
  def holiday(name, year) when is_binary(name) do
    Enum.find(holidays(year), &(&1.name == name))
  end

  # options: all regions or specific region
  def holidays_by_region(year) do
    country = %__MODULE__{}
    Holidex.RegionalHoliday.holidays(country.name, year)
  end

  # TODO: refactor this
  def victoria_day(year) do
    {:ok, start_date} = Date.new(year, 5, 25)

    start_date
    |> Date.add(-1)
    |> Date.range(Date.add(start_date, -7), -1)
    |> Enum.filter(fn day -> Date.day_of_week(day) == 1 end)
    |> Enum.at(0)
  end

  def holiday_definitions do
    [
      %{
        name: "New Years Day",
        date: {:static, [month: 1, day: 1]},
        observance_date: :post_weekend,
        regions_observed: "all",
        national_public_holiday: true
      },
      %{
        name: "Family Day",
        date: {:occurrence, [month: 2, occurrence: 3, weekday: :monday]},
        observance_date: :post_weekend,
        regions_observed: ["ab", "bc", "nb", "on", "sk", "mb", "ns", "pe"],
        regional_names: %{
          "mb" => "Louis Riel Day",
          "ns" => "Heritage Day",
          "pe" => "Islander Day"
        }
      },
      %{
        name: "St. Patrick's Day",
        date: {:static, [month: 3, day: 17]},
        observance_date: :post_weekend,
        regions_observed: ["nl"]
      },
      %{
        name: "Good Friday",
        national_public_holiday: true,
        date: {:calculated, {Holidex.Calculators.Easter, :good_friday, [:year]}},
        observance_date: :date,
        regions_observed: "all",
        description: "In Quebec, employers must choose between Good Friday and Easter Monday for their public holiday"
      },
      %{
        name: "Easter Sunday",
        national_public_holiday: true,
        date: {:calculated, {Holidex.Calculators.Easter, :easter_sunday, [:year]}},
        observance_date: :date,
        regions_observed: []
      },
      %{
        name: "Easter Monday",
        date: {:calculated, {Holidex.Calculators.Easter, :easter_monday, [:year]}},
        observance_date: :date,
        regions_observed: []
      },
      %{
        name: "St. George's Day",
        date: {:occurrence, [month: 4, occurrence: 4, weekday: :monday]},
        observance_date: :post_weekend,
        regions_observed: ["nl"]
      },
      %{
        name: "Victoria Day",
        national_public_holiday: true,
        date: {:calculated, {__MODULE__, :victoria_day, [:year]}},
        regional_names: %{"qc" => "National Patriots' Day"},
        observance_date: :post_weekend,
        regions_observed: ["ab", "bc", "mb", "nb", "nl", "nt", "ns", "nu", "on", "qc", "sk", "yt"]
      },
      %{
        name: "National Indigenous Peoples Day",
        date: {:static, [month: 6, day: 21]},
        observance_date: :post_weekend,
        regions_observed: ["nt", "yt"]
      },
      %{
        name: "Saint-Jean-Baptiste Day",
        date: {:static, [month: 6, day: 24]},
        observance_date: :post_weekend,
        description:
          "Quebec’s National Holiday - You may be entitled to paid leave. This depends on your collective agreement or employment contract.",
        regional_names: %{"qc" => "Fête Nationale"},
        regions_observed: ["qc"]
      },
      %{
        name: "Canada Day",
        national_public_holiday: true,
        date: {:static, [month: 7, day: 1]},
        observance_date: :post_weekend,
        regional_names: %{"nl" => "Memorial Day"},
        regions_observed: "all"
      },
      %{
        name: "Nunavut Day",
        date: {:static, [month: 7, day: 9]},
        observance_date: :post_weekend,
        regions_observed: ["nu"]
      },
      %{
        name: "Orangeman's Day",
        date: {:calculated, {Holidex.Calculators.Date, :closest_monday, [month: 7, day: 12]}},
        observance_date: :date,
        regions_observed: ["nl"]
      },
      %{
        name: "Civic Holiday",
        national_public_holiday: true,
        date: {:occurrence, [month: 8, occurrence: 1, weekday: :monday]},
        observance_date: :post_weekend,
        regional_names: %{
          "ab" => "Heritage Day",
          "mb" => "Terry Fox Day",
          "bc" => "British Columbia Day",
          "nb" => "New Brunswick Day",
          "ns" => "Natal Day",
          "sk" => "Saskatchewan Day"
        },
        regions_observed: [
          "bc",
          "nb",
          "nt",
          "nu",
          "sk"
        ]
      },
      %{
        name: "Discovery Day",
        date: {:static, [month: 8, day: 19]},
        observance_date: :post_weekend,
        regions_observed: ["yt"]
      },
      %{
        name: "Labour Day",
        national_public_holiday: true,
        date: {:occurrence, [month: 9, occurrence: 1, weekday: :monday]},
        observance_date: :post_weekend,
        regions_observed: "all"
      },
      %{
        name: "National Day for Truth and Reconciliation",
        national_public_holiday: true,
        date: {:static, [month: 9, day: 30]},
        description:
          "The day is meant for reflection and education about the history and legacy of residential schools in Canada",
        observance_date: :post_weekend,
        regional_names: %{"mb" => "Orange Shirt Day"},
        regions_observed: ["bc", "nt", "pe", "mb", "yt"]
      },
      %{
        name: "Thanksgiving Day",
        national_public_holiday: true,
        date: {:occurrence, [month: 10, occurrence: 2, weekday: :monday]},
        observance_date: :date,
        regions_observed: ["ab", "bc", "mb", "nl", "nt", "nu", "on", "qc", "sk", "yt"]
      },
      %{
        name: "Remembrance Day",
        national_public_holiday: true,
        date: {:static, [month: 11, day: 11]},
        observance_date: :post_weekend,
        regional_names: %{
          "nl" => "Armistice Day"
        },
        regions_observed: ["ab", "bc", "nb", "nl", "nt", "nu", "pe", "sk", "yt"]
      },
      %{
        name: "Christmas Day",
        national_public_holiday: true,
        date: {:static, [month: 12, day: 25]},
        observance_date: :post_weekend,
        regions_observed: "all"
      },
      %{
        name: "Boxing Day",
        national_public_holiday: true,
        date: {:static, [month: 12, day: 26]},
        observance_date:
          {:relative,
           [
             to: "Christmas Day",
             fn: fn date ->
               case Date.day_of_week(date) do
                 5 -> Date.add(date, 3)
                 _ -> Date.add(date, 1)
               end
             end
           ]},
        description: "Retail stores are closed in Nova Scotia (ns)",
        regions_observed: ["on", "nl"]
      }
    ]
  end
end
