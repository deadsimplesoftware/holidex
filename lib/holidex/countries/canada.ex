defmodule Holidex.Countries.Canada do
  # TODO: consider the introduction of holidays i.e. what year was it introduced or retired
  @moduledoc """
  Provides public holiday dates and observances for Canadian holidays.
  Each province and territory in Canada has the authority to establish its
  own holiday schedule and observance rules.
  """

  import Holidex.YearGuard

  @type year :: 1900..2200

  defstruct name: "Canada",
            country_code: :ca,
            national_holidays: [],
            regional_holidays: []

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

  @spec holidays(year()) :: {:ok, list(map())} | {:error, String.t()}
  def holidays(year) when is_valid_year(year) do
    holidays =
      transform_holidays(holiday_definitions(), year)

    {:ok, holidays}
  end

  def holidays(year) do
    {:error, "Invalid year: #{year}. Expected an integer value between 1900 and 2200."}
  end

  @spec holiday(String.t(), year()) :: {:ok, map()} | {:error, String.t()}
  def holiday(name, year) when is_binary(name) do
    case holidays(year) do
      {:ok, holidays} ->
        case Enum.find(holidays, &(&1.name == name)) do
          nil -> {:error, "No holiday found with name: #{name}"}
          holiday -> {:ok, holiday}
        end

      {:error, _} ->
        {:error, "No holidays found for #{year}"}
    end
  end

  def holiday(name, _year) do
    {:error, "Expected name to be a string, got: #{inspect(name)}."}
  end

  def holidays_by_region(region_code, year) do
    {:ok, holidays} = holidays(year)

    {:ok,
     holidays
     |> Enum.filter(&(&1.regions_observed == :all or region_code in &1.regions_observed))
     |> Enum.reduce([], fn
       %{name: name, regional_names: %{} = regional_names} = holiday, acc ->
         case Map.get(regional_names, region_code) do
           nil -> [%{holiday | name: "#{name}"} | acc]
           regional_name -> [%{holiday | name: "#{regional_name} (#{name})"} | acc]
         end

       %{} = holiday, acc ->
         [holiday | acc]
     end)}
  end

  defp transform_holidays(holiday_definitions, year) do
    computed_holidays =
      holiday_definitions
      |> compute_dates(year)
      |> compute_observance_dates()

    compute_relative_dates(computed_holidays)
  end

  defp compute_dates(holiday_definitions, year) do
    Enum.reduce(holiday_definitions, [], fn
      %{date: {:static, {:year, month, day}}} = holiday, acc ->
        [%{holiday | date: Date.new!(year, month, day)} | acc]

      %{date: {:occurrence, {:year, month}, {nth, dow}}} = holiday, acc ->
        [%{holiday | date: Holidex.DateHelpers.nth_weekday_in_month(year, month, nth, dow)} | acc]

      %{date: {:calculated, {m, f, [:year]}}} = holiday, acc ->
        [%{holiday | date: apply(m, f, [year])} | acc]

      %{date: {:calculated, {m, f, [month: month, day: day]}}} = holiday, acc ->
        [%{holiday | date: apply(m, f, [Date.new!(year, month, day)])} | acc]
    end)
  end

  defp compute_observance_dates(holiday_definitions) do
    Enum.reduce(holiday_definitions, [], fn
      %{observance_date: :date} = holiday, acc ->
        [%{holiday | observance_date: holiday.date} | acc]

      %{observance_date: :post_weekend} = holiday, acc ->
        [
          %{holiday | observance_date: Holidex.DateHelpers.post_weekend_observance(holiday.date)}
          | acc
        ]

      %{observance_date: {:relative, _}} = holiday, acc ->
        [holiday | acc]
    end)
  end

  defp compute_relative_dates(computed_holidays) do
    Enum.reduce(computed_holidays, [], fn
      %{observance_date: {:relative, [to: relative_holiday_name, fn: func]}} = holiday, acc ->
        relative_holiday = Enum.find(computed_holidays, &(&1.name == relative_holiday_name))

        [%{holiday | observance_date: func.(relative_holiday.observance_date)} | acc]

      computed_holiday, acc ->
        [computed_holiday | acc]
    end)
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

  defp holiday_definitions do
    [
      %{
        name: "New Years Day",
        date: {:static, {:year, 1, 1}},
        observance_date: :post_weekend,
        regions_observed: :all,
        national: true
      },
      %{
        name: "Family Day",
        date: {:occurrence, {:year, 2}, {3, :monday}},
        observance_date: :post_weekend,
        regions_observed: [:ab, :bc, :nb, :on, :sk, :mb, :ns, :pe],
        regional_names: %{
          mb: "Louis Riel Day",
          ns: "Heritage Day",
          pe: "Islander Day"
        }
      },
      %{
        name: "St. Patrick's Day",
        date: {:static, {:year, 3, 17}},
        observance_date: :post_weekend,
        regions_observed: [:nl]
      },
      %{
        name: "Good Friday",
        national: true,
        date: {:calculated, {Holidex.Calculators.Easter, :good_friday, [:year]}},
        observance_date: :date,
        regions_observed: :all,
        description: "In Quebec, employers must choose between Good Friday and Easter Monday for their public holiday"
      },
      %{
        name: "Easter Sunday",
        national: true,
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
        date: {:occurrence, {:year, 4}, {4, :monday}},
        observance_date: :post_weekend,
        regions_observed: [:nl]
      },
      %{
        name: "Victoria Day",
        national: true,
        date: {:calculated, {__MODULE__, :victoria_day, [:year]}},
        regional_names: %{qc: "National Patriots' Day"},
        observance_date: :post_weekend,
        regions_observed: [:ab, :bc, :mb, :nb, :nl, :nt, :ns, :nu, :on, :qc, :sk, :yt]
      },
      %{
        name: "National Indigenous Peoples Day",
        date: {:static, {:year, 6, 21}},
        observance_date: :post_weekend,
        regions_observed: [:nt, :yt]
      },
      %{
        name: "Saint-Jean-Baptiste Day",
        date: {:static, {:year, 6, 24}},
        observance_date: :post_weekend,
        description:
          "Quebec’s National Holiday - You may be entitled to paid leave. This depends on your collective agreement or employment contract.",
        regional_names: %{qc: "Fête Nationale"},
        regions_observed: [:qc]
      },
      %{
        name: "Canada Day",
        national: true,
        date: {:static, {:year, 7, 1}},
        observance_date: :post_weekend,
        regional_names: %{nl: "Memorial Day"},
        regions_observed: :all
      },
      %{
        name: "Nunavut Day",
        date: {:static, {:year, 7, 9}},
        observance_date: :post_weekend,
        regions_observed: [:nu]
      },
      %{
        name: "Orangeman's Day",
        date: {:calculated, {Holidex.DateHelpers, :closest_monday, [month: 7, day: 12]}},
        observance_date: :date,
        regions_observed: [:nl]
      },
      %{
        name: "Civic Holiday",
        national: true,
        date: {:occurrence, {:year, 8}, {1, :monday}},
        observance_date: :post_weekend,
        regional_names: %{
          ab: "Heritage Day",
          mb: "Terry Fox Day",
          bc: "British Columbia Day",
          nb: "New Brunswick Day",
          ns: "Natal Day",
          sk: "Saskatchewan Day"
        },
        regions_observed: [
          :bc,
          :nb,
          :nt,
          :nu,
          :sk
        ]
      },
      %{
        name: "Discovery Day",
        date: {:static, {:year, 8, 19}},
        observance_date: :post_weekend,
        regions_observed: [:yt]
      },
      %{
        name: "Labour Day",
        national: true,
        date: {:occurrence, {:year, 9}, {1, :monday}},
        observance_date: :post_weekend,
        regions_observed: :all
      },
      %{
        name: "National Day for Truth and Reconciliation",
        national: true,
        date: {:static, {:year, 9, 30}},
        description:
          "The day is meant for reflection and education about the history and legacy of residential schools in Canada",
        observance_date: :post_weekend,
        regional_names: %{mb: "Orange Shirt Day"},
        regions_observed: [:bc, :nt, :pe, :mb, :yt]
      },
      %{
        name: "Thanksgiving Day",
        national: true,
        date: {:occurrence, {:year, 10}, {2, :monday}},
        observance_date: :date,
        regions_observed: [:ab, :bc, :mb, :nl, :nt, :nu, :on, :qc, :sk, :yt]
      },
      %{
        name: "Remembrance Day",
        national: true,
        date: {:static, {:year, 11, 11}},
        observance_date: :post_weekend,
        regional_names: %{
          nl: "Armistice Day"
        },
        regions_observed: [:ab, :bc, :nb, :nl, :nt, :nu, :pe, :sk, :yt]
      },
      %{
        name: "Christmas Day",
        national: true,
        date: {:static, {:year, 12, 25}},
        observance_date: :post_weekend,
        regions_observed: :all
      },
      %{
        name: "Boxing Day",
        national: true,
        date: {:static, {:year, 12, 26}},
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
        regions_observed: [:on, :nl]
      }
    ]
  end
end
