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

## Getting Started

You can start an interactive Elixir shell session (IEx) and explore the available functions. Start IEx:

```
iex -S mix
```

## Retrieving Holidays

To see the list of holidays in Canada for 2024
```
iex> Holidex.Countries.Canada.holidays(2024)
```

## Disclaimer

This project is in early and active development. Breaking changes are expected until a stable release is achieved. We appreciate your understanding and encourage you to contribute to the project during this phase.

## Contributing

We welcome contributions from the community! Whether it's a bug fix, new feature, or improvement, your input is valuable.

## How to Contribute

Open an Issue: Before you start working on your contribution, please open an issue to describe your suggestion or bug report. This helps us discuss the changes and guide you through the process.

## Roadmap

### Version 0.1.x - Canadian Holidays

The current version supports major Canadian holidays, but is still not considered stable.

#### Features

- [x] Accurate date vs observed dates
- [x] Accurate regional observances
- [x] Consistent/stable functions API
- [x] Public functions are well documented

### Version 0.2.x - United States Holidays

- [ ] Implement major US federal holidays
- [ ] Add state-specific holidays
- [ ] Ensure accurate handling of US-specific holiday rules

### Future Versions

- [ ] Support for other countries
- [ ] Localization support for holiday names and descriptions

## License

MIT
