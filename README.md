# NgiApi

This library is a convenient, easy way to access NGI's API for resellers - simple object methods vs. custom SOAP calls. There are multiple built-in checks for type corrections, and the entered values are automatically adjusted. Return values are parsed and presented as a hash.
This gem currently supports all API operations:
* list_bts
* list_comuni
* info_bts
* info_radio
* reboot_radio
* set_ethernet

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ngi_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ngi_api

## Usage

See documentation!

## Contributing

1. Fork it ( https://github.com/blacksd/ngi_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
