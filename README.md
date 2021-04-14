# locale.cr

Bindings to **locale.h** C library.

[![GitHub release](https://img.shields.io/github/release/light-side-software/locale.cr.svg)](https://github.com/light-side-software/locale.cr/releases)

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  locale:
    github: light-side-software/locale.cr
```
2. Run `shards install`

## Usage

```crystal
require "locale"

LibC.setlocale(LibC::LC_ALL, "")
```

## Contributing

1. Fork it (<https://github.com/light-side-software/locale.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Tamás Szekeres](https://github.com/TamasSzekeres) - creator and maintainer
