defmodule Holidex.Transformers do
  @spec compute_holidays(map(), integer()) :: [Holidex.NationalHoliday.t()]
  def compute_holidays(holiday_definitions, year) do
    holiday_definitions
    |> compute_dates(year)
    |> compute_observance_dates()
    |> compute_relative_dates()
  end

  defp compute_dates(holiday_definitions, year) do
    Enum.reduce(holiday_definitions, [], fn
      %{date: {:static, [month: month, day: day]}} = holiday, acc ->
        [%{holiday | date: Date.new!(year, month, day)} | acc]

      %{date: {:occurrence, [month: month, occurrence: nth, weekday: dow]}} = holiday, acc ->
        [
          %{holiday | date: Holidex.Calculators.Date.nth_weekday_in_month(year, month, nth, dow)}
          | acc
        ]

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
          %{
            holiday
            | observance_date: Holidex.Calculators.Date.post_weekend_observance(holiday.date)
          }
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
end
