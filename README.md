# Macaron
Macaron is a simple web scraper implemented in ruby. It's used for service alive testing.

## Install
    gem install macaron

## Example
```ruby
require 'macaron'
spawner = Spaner.new()

# 1st argument is for start url, 2nd is for the depth to dig (optional)
spawner.dig("http://www.google.com/", 2)
```

## License
MIT LICENSE, please refer to the LICENSE file.
