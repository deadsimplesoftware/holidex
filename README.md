# Holidex

Holidex provides a purely functional API to retrieve public holidays by country. Effortlessly integrate holiday information into your applications.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `holidex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:holidex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/holidex](https://hexdocs.pm/holidex).

## Features
* Provides Canadian holiday names and dates with a distinction between the official `date` of the holiday and the `observance_date`, which are usually different when the holiday falls on a weekend. The named property `observance_date` is subject to change since I don't believe it's the proper way to express this distinction.
* Each holiday will have a `regions_observed` key that lists which provinces consider the holiday statutory. When the holiday is observed nationally, the `regions_observed` key will be set to `all` and `national_public_holiday` will be `true`.
* `regional_names` provides localized names for holidays in different regions. As an example, `Civic Holiday` in Ontario is referred to as `British Columbia Day` in British Columbia.

## Getting Started

The quickest way to get started is exploring the API in `iex`:
```
$ iex -S mix
```
```
iex(1)> Holidex.Countries.Canada.holidays(2025)
```
```
iex(2)> Holidex.Countries.Canada.holidays_by_region(2025)
```

## Disclaimer

This project is in active development. Breaking changes are expected until the 1.0 release. We appreciate your understanding and encourage you to contribute to the project during this phase.

## Contributing

We welcome contributions from the community! Whether it's a bug fix, new feature, or improvement, your input is valuable.

## How to Contribute

Open an Issue: Before you start working on your contribution, please open an issue to describe your suggestion or bug report. This helps us discuss the changes and guide you through the process.

## License

MIT
