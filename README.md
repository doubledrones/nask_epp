# EPP implementation for NASK domain management.

## Usage

Set NaskEpp::PROTOCOL_VERSION before loading gem. Example:
```ruby
  NaskEpp::PROTOCOL_VERSION = '3.0'
  require 'nask_epp'
```

You also need to obtain root certificate from NASK partner panel and put
it into `spec/ssl/root.pem`.

## Status

Note that this gem is not released on rubygems as it is not maintained.
If you are interested in further work on in and maintaining gem on
rubygems feel free to do that.
