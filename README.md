# Macaron
Macaron is a simple web scraper implemented in ruby. It's used for service alive testing.

## Support
Ruby 1.9.x

## Install
    gem install macaron

## Example
```ruby
require 'macaron'
Macaron::Spawner.new("http://www.google.com")
```

## CLI (Command Line Interface)
```
Usage: macaron [options] URL
    -d, --debug                      Show debug output
    -n, --depth N                    Set the digging depth N
    -j, --javascript                 Open javascript support mode
    -h, --help                       Show this message
```

## License
MIT LICENSE, please refer to the LICENSE file.
