# Findchips
[![CircleCI](https://circleci.com/gh/dragon-innovation/findchips.svg?style=svg)](https://circleci.com/gh/dragon-innovation/findchips)

This is a research spike on gemifying our interaction with the
[Findchips API](https://dev.supplyframe.com/doc/fcapi) and very early build, at
that. So, please pardon our mess during construction.

## Installation

Clone to your local development environment and include into your project.

```ruby
gem 'findchips', '0.1.0', path: '/full/path/to/findchips'
```

And then execute:

    $ bundle

## Usage
This is designed to be a drop in replacement for some existing `Findchips` code
on some internal products. However, the stucture allows for future improvments,
outside of the `Legacy` functionality.

```ruby
Findchips.configure do |config|
  config.auth_token = 'SECRET TOKEN'
end

client = Findchips::Legacy::Client.new
client.search('LM741')
```

Soon to come... `Findchips::REST`?

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a Pull Request!

## CWCID

Much of basic the structure of this this gem is inspired by the very excellent
[Twilio-Ruby](https://github.com/twilio/twilio-ruby) gem. Their work inspired us!
