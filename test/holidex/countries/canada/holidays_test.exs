defmodule Holidex.Countries.CanadaTest do
  use ExUnit.Case, async: true

  alias Holidex.Countries.Canada, as: Canada

  describe "public api" do
    setup do
      year = Date.utc_today().year()
      {:ok, year: year}
    end

    test "get_holidays/1", context do
      assert length(Canada.get_holidays(context.year).holidays) == 16
    end

    test "get_holiday_names/0", context do
      assert length(Canada.get_holidays(context.year).holidays) ==
               length(Canada.get_holiday_names())
    end

    test "get_regions/0" do
      assert length(Canada.get_regions()) == 13
    end

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
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == true
        assert Canada.get_holiday_by_name(holiday_name, year).type == :national
      end
    end

    test "family day returns the correct values" do
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
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == true
        assert Canada.get_holiday_by_name(holiday_name, year).type == :provincial

        assert Canada.get_holiday_by_name(holiday_name, year).provinces == [
                 :ab,
                 :bc,
                 :nb,
                 :on,
                 :sk
               ]
      end
    end

    test "easter returns the correct values" do
      holiday_name = :easter

      known_easter_dates = %{
        2022 => ~D[2022-04-17],
        2023 => ~D[2023-04-09],
        2024 => ~D[2024-03-31],
        2025 => ~D[2025-04-20],
        2026 => ~D[2026-04-05],
        2027 => ~D[2027-03-28],
        2028 => ~D[2028-04-16],
        2029 => ~D[2029-04-01],
        2030 => ~D[2030-04-21],
        2031 => ~D[2031-04-13],
        2032 => ~D[2032-03-28]
      }

      for {year, expected_date} <- known_easter_dates do
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == true
        assert Canada.get_holiday_by_name(holiday_name, year).type == :provincial
        assert Canada.get_holiday_by_name(holiday_name, year).provinces == [:qc, :nt]
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
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == true
        assert Canada.get_holiday_by_name(holiday_name, year).type == :national
        assert Canada.get_holiday_by_name(holiday_name, year).provinces_except == [:qc]
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
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == true
        assert Canada.get_holiday_by_name(holiday_name, year).type == :provincial

        assert Canada.get_holiday_by_name(holiday_name, year).provinces == [
                 :ab,
                 :bc,
                 :mb,
                 :nt,
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
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == false
        assert Canada.get_holiday_by_name(holiday_name, year).type == :provincial
        assert Canada.get_holiday_by_name(holiday_name, year).provinces == [:nt, :yt]
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
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == true
        assert Canada.get_holiday_by_name(holiday_name, year).type == :provincial

        assert Canada.get_holiday_by_name(holiday_name, year).provinces == [
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
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == true
        assert Canada.get_holiday_by_name(holiday_name, year).type == :national
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
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == true
        assert Canada.get_holiday_by_name(holiday_name, year).type == :provincial

        assert Canada.get_holiday_by_name(holiday_name, year).provinces == [
                 :ab,
                 :bc,
                 :sk,
                 :on,
                 :nb,
                 :nu
               ]
      end
    end

    test "gold cup parade day returns the correct values" do
      holiday_name = :gold_cup_parade_day

      known_gold_cup_parade_days = %{
        2022 => ~D[2022-08-19],
        2023 => ~D[2023-08-18],
        2024 => ~D[2024-08-16],
        2025 => ~D[2025-08-15],
        2026 => ~D[2026-08-21],
        2027 => ~D[2027-08-20],
        2028 => ~D[2028-08-18],
        2029 => ~D[2029-08-17],
        2030 => ~D[2030-08-16],
        2031 => ~D[2031-08-15],
        2032 => ~D[2032-08-20]
      }

      for {year, expected_date} <- known_gold_cup_parade_days do
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == false
        assert Canada.get_holiday_by_name(holiday_name, year).type == :provincial

        assert Canada.get_holiday_by_name(holiday_name, year).provinces == [
                 :pe
               ]
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
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == true
        assert Canada.get_holiday_by_name(holiday_name, year).type == :national
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
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == true
        assert Canada.get_holiday_by_name(holiday_name, year).type == :provincial

        assert Canada.get_holiday_by_name(holiday_name, year).provinces == [
                 :bc,
                 :nt,
                 :nu,
                 :pe,
                 :yt
               ]
      end
    end

    test "thanksgiving returns the correct values" do
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
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == true
        assert Canada.get_holiday_by_name(holiday_name, year).type == :provincial

        assert Canada.get_holiday_by_name(holiday_name, year).provinces == [
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
      end
    end

    test "remembrance day returns the correct values" do
      holiday_name = :remembrance_day

      known_remembrance_days = %{
        2022 => ~D[2022-11-11],
        2023 => ~D[2023-11-11],
        2024 => ~D[2024-11-11],
        2025 => ~D[2025-11-11],
        2026 => ~D[2026-11-11],
        2027 => ~D[2027-11-11],
        2028 => ~D[2028-11-11],
        2029 => ~D[2029-11-11],
        2030 => ~D[2030-11-11],
        2031 => ~D[2031-11-11],
        2032 => ~D[2032-11-11]
      }

      for {year, expected_date} <- known_remembrance_days do
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == true
        assert Canada.get_holiday_by_name(holiday_name, year).type == :provincial

        assert Canada.get_holiday_by_name(holiday_name, year).provinces == [
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
        2022 => ~D[2022-12-25],
        2023 => ~D[2023-12-25],
        2024 => ~D[2024-12-25],
        2025 => ~D[2025-12-25],
        2026 => ~D[2026-12-25],
        2027 => ~D[2027-12-25],
        2028 => ~D[2028-12-25],
        2029 => ~D[2029-12-25],
        2030 => ~D[2030-12-25],
        2031 => ~D[2031-12-25],
        2032 => ~D[2032-12-25]
      }

      for {year, expected_date} <- known_christmas_days do
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == true
        assert Canada.get_holiday_by_name(holiday_name, year).type == :national
      end
    end

    test "boxing day returns the correct values" do
      holiday_name = :boxing_day

      known_boxing_days = %{
        2022 => ~D[2022-12-26],
        2023 => ~D[2023-12-26],
        2024 => ~D[2024-12-26],
        2025 => ~D[2025-12-26],
        2026 => ~D[2026-12-28],
        2027 => ~D[2027-12-27],
        2028 => ~D[2028-12-26],
        2029 => ~D[2029-12-26],
        2030 => ~D[2030-12-26],
        2031 => ~D[2031-12-26],
        2032 => ~D[2032-12-27]
      }

      for {year, expected_date} <- known_boxing_days do
        assert Canada.get_holiday_by_name(holiday_name, year).name == holiday_name
        assert Canada.get_holiday_by_name(holiday_name, year).observance == expected_date
        assert Canada.get_holiday_by_name(holiday_name, year).statutory == true
        assert Canada.get_holiday_by_name(holiday_name, year).type == :provincial

        assert Canada.get_holiday_by_name(holiday_name, year).provinces == [
                 :on,
                 :nt
               ]
      end
    end
  end
end
