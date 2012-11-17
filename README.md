# Macaron
Macaron is a simple web scraper implemented in ruby. It's used for service alive testing.

## Install
    gem install macaron

## Example
```ruby
require 'macaron'
spawner = Spawner.new()

# 1st argument is for start url, 2nd is for the depth to dig (optional)
spawner.dig("http://www.google.com/", 2)
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
