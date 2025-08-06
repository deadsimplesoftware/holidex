defmodule Holidex.RegionalHoliday do
  defstruct [:name, :date, :observance_date, :relative_date]

  def new!(holiday) do
    struct!(__MODULE__, holiday)
  end

  def holidays(country, year) do
    module_name = Module.concat([Holidex, Countries, "#{country}"])
    holidays = apply(module_name, :holidays, [year])

    region_codes = apply(module_name, :region_codes, [])

    region_codes
    |> Enum.map(&regional_holiday(holidays, &1))
    |> Map.new()
  end

  defp regional_holiday(holidays, region_code) do
    regional_holidays =
      holidays
      |> Enum.filter(&(&1.regions_observed == "all" or region_code in &1.regions_observed))
      |> Enum.reduce([], fn
        %{name: name, regional_names: %{} = regional_names} = holiday, acc ->
          case Map.get(regional_names, region_code) do
            nil -> [%{holiday | name: "#{name}"} | acc]
            regional_name -> [%{holiday | name: "#{regional_name} (#{name})"} | acc]
          end

        %{} = holiday, acc ->
          [holiday | acc]
      end)

    {"#{region_code}", regional_holidays}
  end
end
