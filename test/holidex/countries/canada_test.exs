defmodule Holidex.Countries.CanadaTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Holidex.Countries.Canada

  describe "Public API" do
    setup do
      year = Date.utc_today().year()
      {:ok, year: year}
    end

    test "holidays/1", context do
      {:ok, holidays} = Canada.holidays(context.year)
      assert length(holidays) == 21
    end

    test "holidays_by_region/2", context do
      region_code = Enum.random(Canada.region_codes())

      refute Canada.holidays_by_region(region_code, context.year) == nil
    end

    test "holidays/1 with an invalid year" do
      assert Canada.holidays("2022") ==
               {:error, :holidays, "Invalid argument for: year. Expected an integer between 1900 and 2200."}
    end

    test "regions/0" do
      assert length(Canada.regions()) == 13
    end

    test "region_codes/0" do
      assert length(Canada.region_codes()) == 13
    end
  end

  describe "National Holidays" do
    setup do
      year = Date.utc_today().year()
      {:ok, year: year}
    end

    test "there are 12 public holidays per year nationwide", context do
      {:ok, holidays} = Canada.holidays(context.year)

      public_holidays =
        Enum.filter(holidays, fn %{categories: categories} -> :national in categories end)

      assert length(public_holidays) == 12
    end
  end

  describe "Regional (Provincial) Holidays" do
    setup do
      year = Date.utc_today().year()
      {:ok, year: year}
    end

    test "there are 9 public holidays in Alberta", context do
      {:ok, ab_public_holidays} =
        Canada.holidays_by_region(:ab, context.year)

      assert length(ab_public_holidays) == 9
    end

    test "there are 11 public holidays in British Columbia", context do
      {:ok, bc_public_holidays} =
        Canada.holidays_by_region(:bc, context.year)

      assert length(bc_public_holidays) == 11
    end

    test "there are 9 public holidays in Manitoba", context do
      {:ok, mb_public_holidays} =
        Canada.holidays_by_region(:mb, context.year)

      assert length(mb_public_holidays) == 9
    end

    test "there are 7 public holidays in New Brunswick", context do
      {:ok, nb_public_holidays} =
        Canada.holidays_by_region(:nb, context.year)

      assert length(nb_public_holidays) == 9
    end

    test "there are 12 public holidays in Newfoundland and Labrador", context do
      {:ok, nl_public_holidays} =
        Canada.holidays_by_region(:nl, context.year)

      assert length(nl_public_holidays) == 12
    end

    test "there are 11 public holidays in Northwest Territories", context do
      {:ok, nt_public_holidays} =
        Canada.holidays_by_region(:nt, context.year)

      assert length(nt_public_holidays) == 11
    end

    test "there are 10 public holidays in Nunavut", context do
      {:ok, nu_public_holidays} =
        Canada.holidays_by_region(:nu, context.year)

      assert length(nu_public_holidays) == 10
    end

    test "there are 9 public holidays in Ontario", context do
      {:ok, ontario_public_holidays} =
        Canada.holidays_by_region(:on, context.year)

      assert length(ontario_public_holidays) == 9
    end

    test "there are 8 public holidays in PEI", context do
      {:ok, pe_public_holidays} =
        Canada.holidays_by_region(:pe, context.year)

      assert length(pe_public_holidays) == 8
    end

    test "there are 8 public holidays in Québec", context do
      {:ok, qc_public_holidays} =
        Canada.holidays_by_region(:qc, context.year)

      assert length(qc_public_holidays) == 8
    end

    test "there are 10 public holidays in Saskatchewan", context do
      {:ok, sk_public_holidays} =
        Canada.holidays_by_region(:sk, context.year)

      assert length(sk_public_holidays) == 10
    end

    test "there are 11 public holidays in Yukon", context do
      {:ok, yukon_public_holidays} =
        Canada.holidays_by_region(:yt, context.year)

      assert length(yukon_public_holidays) == 11
    end
  end

  describe "Individual Holidays" do
    test "new years day returns the correct values" do
      holiday_name = :new_years_day

      known_new_years_day_days = %{
        2022 => ~D[2022-01-03],
        2023 => ~D[2023-01-02],
        2024 => ~D[2024-01-01],
        2025 => ~D[2025-01-01],
        2026 => ~D[2026-01-01],
        2027 => ~D[2027-01-01],
        2028 => ~D[2028-01-03],
        2029 => ~D[2029-01-01],
        2030 => ~D[2030-01-01],
        2031 => ~D[2031-01-01],
        2032 => ~D[2032-01-01]
      }

      for {year, expected_date} <- known_new_years_day_days do
        assert Canada.holiday(holiday_name, year).name == "New Years Day"
        assert Canada.holiday(holiday_name, year).observance_date == expected_date
        assert Canada.holiday(holiday_name, year).categories == [:national]
      end
    end

    test "Family Day returns the correct values" do
      holiday_name = :family_day

      known_family_days = %{
        2022 => ~D[2022-02-21],
        2023 => ~D[2023-02-20],
        2024 => ~D[2024-02-19],
        2025 => ~D[2025-02-17],
        2026 => ~D[2026-02-16],
        2027 => ~D[2027-02-15],
        2028 => ~D[2028-02-21],
        2029 => ~D[2029-02-19],
        2030 => ~D[2030-02-18],
        2031 => ~D[2031-02-17]
      }

      for {year, expected_date} <- known_family_days do
        assert Canada.holiday(holiday_name, year).name == "Family Day"
        assert Canada.holiday(holiday_name, year).observance_date == expected_date
        assert Canada.holiday(holiday_name, year).categories == [:regional]

        assert Canada.holiday(holiday_name, year).regions == [
                 :ab,
                 :bc,
                 :nb,
                 :on,
                 :sk,
                 :mb,
                 :ns,
                 :pe
               ]
      end
    end

    property "Family Day is always the third Monday in February" do
      check all(year <- StreamData.integer(1900..2100)) do
        family_day = Canada.holiday(:family_day, year)

        assert family_day.date.year == year
        assert family_day.date.month == 2

        # Monday
        assert Date.day_of_week(family_day.date) == 1
        # 3rd Monday always falls in this range
        assert family_day.date.day in 15..21

        # Check it's the 3rd Monday
        first_day_of_month = Date.new!(year, 2, 1)
        days_until_first_monday = rem(1 - Date.day_of_week(first_day_of_month) + 7, 7)
        third_monday = Date.add(first_day_of_month, days_until_first_monday + 14)

        assert family_day.date == third_monday
        assert family_day.observance_date == third_monday
      end
    end

    test "easter monday returns the correct values" do
      holiday_name = :easter_monday

      known_easter_monday_dates = %{
        2022 => ~D[2022-04-18],
        2023 => ~D[2023-04-10],
        2024 => ~D[2024-04-01],
        2025 => ~D[2025-04-21],
        2026 => ~D[2026-04-06],
        2027 => ~D[2027-03-29],
        2028 => ~D[2028-04-17],
        2029 => ~D[2029-04-02],
        2030 => ~D[2030-04-22],
        2031 => ~D[2031-04-14],
        2032 => ~D[2032-03-29]
      }

      for {year, expected_date} <- known_easter_monday_dates do
        assert Canada.holiday(holiday_name, year).name == "Easter Monday"
        assert Canada.holiday(holiday_name, year).date == expected_date
        assert Canada.holiday(holiday_name, year).observance_date == expected_date

        assert Canada.holiday(holiday_name, year).categories == [:national, :religious]
        assert Canada.holiday(holiday_name, year).regions == []
      end
    end

    test "good friday returns the correct values" do
      holiday_name = :good_friday

      known_good_fridays = %{
        2022 => ~D[2022-04-15],
        2023 => ~D[2023-04-07],
        2024 => ~D[2024-03-29],
        2025 => ~D[2025-04-18],
        2026 => ~D[2026-04-03],
        2027 => ~D[2027-03-26],
        2028 => ~D[2028-04-14],
        2029 => ~D[2029-03-30],
        2030 => ~D[2030-04-19],
        2031 => ~D[2031-04-11],
        2032 => ~D[2032-03-26]
      }

      for {year, expected_date} <- known_good_fridays do
        assert Canada.holiday(holiday_name, year).name == "Good Friday"
        assert Canada.holiday(holiday_name, year).observance_date == expected_date

        assert Canada.holiday(holiday_name, year).categories == [:national, :religious]
      end
    end

    test "victoria day returns the correct values" do
      holiday_name = :victoria_day

      known_victoria_days = %{
        2022 => ~D[2022-05-23],
        2023 => ~D[2023-05-22],
        2024 => ~D[2024-05-20],
        2025 => ~D[2025-05-19],
        2026 => ~D[2026-05-18],
        2027 => ~D[2027-05-24],
        2028 => ~D[2028-05-22],
        2029 => ~D[2029-05-21],
        2030 => ~D[2030-05-20],
        2031 => ~D[2031-05-19],
        2032 => ~D[2032-05-24]
      }

      for {year, expected_date} <- known_victoria_days do
        assert Canada.holiday(holiday_name, year).name == "Victoria Day"
        assert Canada.holiday(holiday_name, year).observance_date == expected_date

        assert Canada.holiday(holiday_name, year).categories == [:national, :regional]

        assert Canada.holiday(holiday_name, year).regions == [
                 :ab,
                 :bc,
                 :mb,
                 :nb,
                 :nl,
                 :nt,
                 :ns,
                 :nu,
                 :on,
                 :qc,
                 :sk,
                 :yt
               ]
      end
    end

    test "national indigenous peoples day returns the correct values" do
      holiday_name = :national_indigenous_peoples_day

      known_national_indigenous_peoples_days = %{
        2022 => ~D[2022-06-21],
        2023 => ~D[2023-06-21],
        2024 => ~D[2024-06-21],
        2025 => ~D[2025-06-23],
        2026 => ~D[2026-06-22],
        2027 => ~D[2027-06-21],
        2028 => ~D[2028-06-21],
        2029 => ~D[2029-06-21],
        2030 => ~D[2030-06-21],
        2031 => ~D[2031-06-23],
        2032 => ~D[2032-06-21]
      }

      for {year, expected_date} <- known_national_indigenous_peoples_days do
        assert Canada.holiday(holiday_name, year).name == "National Indigenous Peoples Day"
        assert Canada.holiday(holiday_name, year).observance_date == expected_date

        assert Canada.holiday(holiday_name, year).categories == [:regional]
        assert Canada.holiday(holiday_name, year).regions == [:nt, :yt]
      end
    end

    test "saint jean baptiste day returns the correct values" do
      holiday_name = :saint_jean_baptiste_day

      known_saint_jean_baptiste_days = %{
        2022 => ~D[2022-06-24],
        2023 => ~D[2023-06-26],
        2024 => ~D[2024-06-24],
        2025 => ~D[2025-06-24],
        2026 => ~D[2026-06-24],
        2027 => ~D[2027-06-24],
        2028 => ~D[2028-06-26],
        2029 => ~D[2029-06-25],
        2030 => ~D[2030-06-24],
        2031 => ~D[2031-06-24]
      }

      for {year, expected_date} <- known_saint_jean_baptiste_days do
        assert Canada.holiday(holiday_name, year).name == "Saint-Jean-Baptiste Day"
        assert Canada.holiday(holiday_name, year).observance_date == expected_date

        assert Canada.holiday(holiday_name, year).categories == [:regional]

        assert Canada.holiday(holiday_name, year).regions == [
                 :qc
               ]
      end
    end

    test "canada day returns the correct values" do
      holiday_name = :canada_day

      known_canada_days = %{
        2022 => ~D[2022-07-01],
        2023 => ~D[2023-07-03],
        2024 => ~D[2024-07-01],
        2025 => ~D[2025-07-01],
        2026 => ~D[2026-07-01],
        2027 => ~D[2027-07-01],
        2028 => ~D[2028-07-03],
        2029 => ~D[2029-07-02],
        2030 => ~D[2030-07-01],
        2031 => ~D[2031-07-01],
        2032 => ~D[2032-07-01]
      }

      for {year, expected_date} <- known_canada_days do
        assert Canada.holiday(holiday_name, year).name == "Canada Day"
        assert Canada.holiday(holiday_name, year).observance_date == expected_date

        assert Canada.holiday(holiday_name, year).categories == [:national]
      end
    end

    test "civic holiday returns the correct values" do
      holiday_name = :civic_holiday

      known_civic_holidays = %{
        2022 => ~D[2022-08-01],
        2023 => ~D[2023-08-07],
        2024 => ~D[2024-08-05],
        2025 => ~D[2025-08-04],
        2026 => ~D[2026-08-03],
        2027 => ~D[2027-08-02],
        2028 => ~D[2028-08-07],
        2029 => ~D[2029-08-06],
        2030 => ~D[2030-08-05],
        2031 => ~D[2031-08-04],
        2032 => ~D[2032-08-02]
      }

      for {year, expected_date} <- known_civic_holidays do
        assert Canada.holiday(holiday_name, year).name == "Civic Holiday"
        assert Canada.holiday(holiday_name, year).observance_date == expected_date

        assert Canada.holiday(holiday_name, year).categories == [:national, :regional]

        assert Canada.holiday(holiday_name, year).regions == [
                 :bc,
                 :nb,
                 :nt,
                 :nu,
                 :sk
               ]
      end
    end

    property "civic holiday is always the first Monday in August" do
      check all(year <- StreamData.integer(1900..2100)) do
        civic_holiday = Canada.holiday(:civic_holiday, year)

        assert civic_holiday.date.year == year
        assert civic_holiday.date.month == 8

        # Monday
        assert Date.day_of_week(civic_holiday.date) == 1
        # 1st Monday always falls in this range
        assert civic_holiday.date.day in 1..7

        # Check it's the 1st Monday
        first_day_of_month = Date.new!(year, 8, 1)
        days_until_first_monday = rem(1 - Date.day_of_week(first_day_of_month) + 7, 7)
        first_monday = Date.add(first_day_of_month, days_until_first_monday)

        assert civic_holiday.date == first_monday
        assert civic_holiday.observance_date == first_monday
      end
    end

    test "labour day returns the correct values" do
      holiday_name = :labour_day

      known_labour_days = %{
        2022 => ~D[2022-09-05],
        2023 => ~D[2023-09-04],
        2024 => ~D[2024-09-02],
        2025 => ~D[2025-09-01],
        2026 => ~D[2026-09-07],
        2027 => ~D[2027-09-06],
        2028 => ~D[2028-09-04],
        2029 => ~D[2029-09-03],
        2030 => ~D[2030-09-02],
        2031 => ~D[2031-09-01],
        2032 => ~D[2032-09-06]
      }

      for {year, expected_date} <- known_labour_days do
        assert Canada.holiday(holiday_name, year).name == "Labour Day"
        assert Canada.holiday(holiday_name, year).observance_date == expected_date

        assert Canada.holiday(holiday_name, year).categories == [:national]
      end
    end

    property "labour day is always the first Monday in September" do
      check all(year <- StreamData.integer(1900..2100)) do
        labour_day = Canada.holiday(:labour_day, year)

        assert labour_day.date.year == year
        assert labour_day.date.month == 9

        # Monday
        assert Date.day_of_week(labour_day.date) == 1
        # 1st Monday always falls in this range
        assert labour_day.date.day in 1..7

        # Check it's the 1st Monday
        first_day_of_month = Date.new!(year, 9, 1)
        days_until_first_monday = rem(1 - Date.day_of_week(first_day_of_month) + 7, 7)
        first_monday = Date.add(first_day_of_month, days_until_first_monday)

        assert labour_day.date == first_monday
        assert labour_day.observance_date == first_monday
      end
    end

    test "national day for truth and reconciliation returns the correct values" do
      holiday_name = :national_day_for_truth_and_reconciliation

      known_national_days_for_truth_and_reconciliation = %{
        2021 => ~D[2021-09-30],
        2022 => ~D[2022-09-30],
        2023 => ~D[2023-10-02],
        2024 => ~D[2024-09-30],
        2025 => ~D[2025-09-30],
        2026 => ~D[2026-09-30],
        2027 => ~D[2027-09-30],
        2028 => ~D[2028-10-02],
        2029 => ~D[2029-10-01],
        2030 => ~D[2030-09-30],
        2031 => ~D[2031-09-30],
        2032 => ~D[2032-09-30]
      }

      for {year, expected_date} <- known_national_days_for_truth_and_reconciliation do
        assert Canada.holiday(holiday_name, year).name ==
                 "National Day for Truth and Reconciliation"

        assert Canada.holiday(holiday_name, year).observance_date == expected_date
        assert Canada.holiday(holiday_name, year).categories == [:national, :regional]
        assert Canada.holiday(holiday_name, year).regions == [:bc, :nt, :pe, :mb, :yt]
      end
    end

    test "Thanksgiving returns the correct values" do
      holiday_name = :thanksgiving_day

      known_thanksgivings = %{
        2022 => ~D[2022-10-10],
        2023 => ~D[2023-10-09],
        2024 => ~D[2024-10-14],
        2025 => ~D[2025-10-13],
        2026 => ~D[2026-10-12],
        2027 => ~D[2027-10-11],
        2028 => ~D[2028-10-09],
        2029 => ~D[2029-10-08],
        2030 => ~D[2030-10-14],
        2031 => ~D[2031-10-13],
        2032 => ~D[2032-10-11]
      }

      for {year, expected_date} <- known_thanksgivings do
        assert Canada.holiday(holiday_name, year).name == "Thanksgiving Day"
        assert Canada.holiday(holiday_name, year).observance_date == expected_date

        assert Canada.holiday(holiday_name, year).categories == [:national]

        assert Canada.holiday(holiday_name, year).regions == [
                 :ab,
                 :bc,
                 :mb,
                 :nl,
                 :nt,
                 :nu,
                 :on,
                 :qc,
                 :sk,
                 :yt
               ]
      end
    end

    property "Thanksgiving is always the second Monday in October" do
      check all(year <- StreamData.integer(1900..2100)) do
        thanksgiving = Canada.holiday(:thanksgiving_day, year)

        assert thanksgiving.date.year == year
        assert thanksgiving.date.month == 10

        # Monday
        assert Date.day_of_week(thanksgiving.date) == 1
        # 2nd Monday always falls in this range
        assert thanksgiving.date.day in 8..14

        # Check it's the 2nd Monday
        first_day_of_month = Date.new!(year, 10, 1)
        days_until_first_monday = rem(1 - Date.day_of_week(first_day_of_month) + 7, 7)
        second_monday = Date.add(first_day_of_month, days_until_first_monday + 7)

        assert thanksgiving.date == second_monday
        assert thanksgiving.observance_date == second_monday
      end
    end

    test "remembrance day returns the correct values" do
      holiday_name = :remembrance_day

      known_remembrance_days = %{
        2022 => ~D[2022-11-11],
        2023 => ~D[2023-11-13],
        2024 => ~D[2024-11-11],
        2025 => ~D[2025-11-11],
        2026 => ~D[2026-11-11],
        2027 => ~D[2027-11-11],
        2028 => ~D[2028-11-13],
        2029 => ~D[2029-11-12],
        2030 => ~D[2030-11-11],
        2031 => ~D[2031-11-11],
        2032 => ~D[2032-11-11]
      }

      for {year, expected_date} <- known_remembrance_days do
        assert Canada.holiday(holiday_name, year).name == "Remembrance Day"
        assert Canada.holiday(holiday_name, year).observance_date == expected_date

        assert Canada.holiday(holiday_name, year).categories == [:national]

        assert Canada.holiday(holiday_name, year).regions == [
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
      end
    end

    test "christmas day returns the correct values" do
      holiday_name = :christmas_day

      known_christmas_days = %{
        2022 => ~D[2022-12-26],
        2023 => ~D[2023-12-25],
        2024 => ~D[2024-12-25],
        2025 => ~D[2025-12-25],
        2026 => ~D[2026-12-25],
        2027 => ~D[2027-12-27],
        2028 => ~D[2028-12-25],
        2029 => ~D[2029-12-25],
        2030 => ~D[2030-12-25],
        2031 => ~D[2031-12-25],
        2032 => ~D[2032-12-27]
      }

      for {year, expected_date} <- known_christmas_days do
        assert Canada.holiday(holiday_name, year).name == "Christmas Day"
        assert Canada.holiday(holiday_name, year).observance_date == expected_date

        assert Canada.holiday(holiday_name, year).categories == [:national, :religious]
      end
    end

    test "boxing day returns the correct values" do
      holiday_name = :boxing_day

      known_boxing_days = %{
        2020 => ~D[2020-12-28],
        2021 => ~D[2021-12-28],
        2022 => ~D[2022-12-27],
        2023 => ~D[2023-12-26],
        2024 => ~D[2024-12-26],
        2025 => ~D[2025-12-26],
        2026 => ~D[2026-12-28],
        2027 => ~D[2027-12-28],
        2028 => ~D[2028-12-26],
        2029 => ~D[2029-12-26],
        2030 => ~D[2030-12-26],
        2031 => ~D[2031-12-26],
        2032 => ~D[2032-12-28]
      }

      for {year, expected_date} <- known_boxing_days do
        assert Canada.holiday(holiday_name, year).name == "Boxing Day"
        assert Canada.holiday(holiday_name, year).observance_date == expected_date

        assert Canada.holiday(holiday_name, year).categories == [:national, :regional]

        assert Canada.holiday(holiday_name, year).regions == [
                 :on,
                 :nl
               ]
      end
    end
  end
end
