# Who's got dirt? A federated search API for people and organizations

[![Dependency Status](https://gemnasium.com/influencemapping/whos_got_dirt-server.png)](https://gemnasium.com/influencemapping/whos_got_dirt-server)
[![Code Climate](https://codeclimate.com/github/influencemapping/whos_got_dirt-server.png)](https://codeclimate.com/github/influencemapping/whos_got_dirt-server)

See the [Ruby gem](https://github.com/influencemapping/whos_got_dirt-gem) for details.

## Usage

### People

`GET /people?queries=<queries>` where `<queries>` looks like:

```json
{
  "q0": {
    "query": {
      "type": "Person",
      "name~=": "John Smith",
      "jurisdiction_code|=": ["gb", "ie"],
      "memberships": [{
        "role": "director",
        "inactive": false
      }]
    }
  }
}
```

You may use any query ID instead of `q0`. Not all APIs support every parameter and operator. **If a parameter or operator is unsupported, it is silently ignored.** See more in the [documentation](http://www.rubydoc.info/gems/whos_got_dirt/WhosGotDirt/Requests/Person).

**If an API returns an error, its response is silently ignored.** See more in the [documentation](http://www.rubydoc.info/gems/whos_got_dirt/WhosGotDirt/Responses/Person).

For example, run `bundle exec rackup` in a Unix shell, and run the following in a Ruby shell:

```ruby
require 'cgi'
require 'open-uri'
require 'json'

queries = <<-EOL
{
  "q0": {
    "query": {
      "type": "Person",
      "name~=": "John Smith",
      "jurisdiction_code|=": ["gb", "ie"],
      "memberships": [{
        "role": "director",
        "inactive": false
      }]
    }
  }
}
EOL

value = JSON.dump(JSON.load(queries))

body = open("http://localhost:9292/people?queries=#{CGI.escape(value)}").read

results = JSON.load(body)
#=> {"q0"=>
#  {"count"=>3915,
#   "result"=>
#    [{"@type"=>"Person",
#      "name"=>"JOHN SMITH",
#      "updated_at"=>"2014-10-25T00:34:16+00:00",
#      "identifiers"=>[{"identifier"=>"46065070", "scheme"=>"OpenCorporates"}],
#      "contact_details"=>[],
#      "links"=>[{"url"=>"https://opencorporates.com/officers/46065070", "note"=>"OpenCorporates URL"}],
#      "memberships"=>
#       [{"role"=>"director",
#         "start_date"=>"2006-11-24",
#         "organization"=>
#          {"name"=>"EVOLUTION (GB) LIMITED",
#           "identifiers"=>[{"identifier"=>"05997209", "scheme"=>"Company Register"}],
#           "links"=>[{"url"=>"https://opencorporates.com/companies/gb/05997209", "note"=>"OpenCorporates URL"}],
#           "jurisdiction_code"=>"gb"}}],
#      "current_status"=>"CURRENT",
#      "jurisdiction_code"=>"gb",
#      "occupation"=>"MANAGER",
#      "sources"=>
#       [{"url"=>"https://api.opencorporates.com/officers/search?inactive=false&jurisdiction_code=gb%7Cie&order=score&position=director&q=John+Smith", "note"=>"OpenCorporates"}]},
#    ...]
```

## Acknowledgements

Most terms are from [Popolo](http://www.popoloproject.com/). The request and response formats are inspired from the [Metaweb Query Language (MQL)](http://mql.freebaseapps.com/index.html) and the [OpenRefine Reconciliation Service API](https://github.com/OpenRefine/OpenRefine/wiki/Reconciliation-Service-API). Differences from MQL are [documented](/docs/differences-from-freebase.md).

Copyright (c) 2015 James McKinney, released under the MIT license
