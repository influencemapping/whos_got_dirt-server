# Who's got dirt? A federated search API for people and organizations

[![Build Status](https://secure.travis-ci.org/influencemapping/whos_got_dirt-server.png)](https://travis-ci.org/influencemapping/whos_got_dirt-server)
[![Dependency Status](https://gemnasium.com/influencemapping/whos_got_dirt-server.png)](https://gemnasium.com/influencemapping/whos_got_dirt-server)
[![Coverage Status](https://coveralls.io/repos/influencemapping/whos_got_dirt-server/badge.svg)](https://coveralls.io/r/influencemapping/whos_got_dirt-server)
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
#=> {"q0":{"query":{"type":"Person","name~=":"John Smith","jurisdiction_code|=":["gb","ie"],"memberships":[{"role":"director","inactive":false}]}}}

url = "http://localhost:9292/people?queries=#{CGI.escape(value)}"
#=> http://localhost:9292/people?queries=%7B%22q0%22%3A%7B%22query%22%3A%7B%22type%22%3A%22Person%22%2C%22name%7E%3D%22%3A%22John+Smith%22%2C%22jurisdiction_code%7C%3D%22%3A%5B%22gb%22%2C%22ie%22%5D%2C%22memberships%22%3A%5B%7B%22role%22%3A%22director%22%2C%22inactive%22%3Afalse%7D%5D%7D%7D%7D

results = JSON.load(open(url).read)
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

## Deployment

```
heroku apps:create
git push heroku master
```

## Acknowledgements

Most terms are from [Popolo](http://www.popoloproject.com/). The request and response formats are inspired from the [Metaweb Query Language (MQL)](http://mql.freebaseapps.com/index.html) and the [OpenRefine Reconciliation Service API](https://github.com/OpenRefine/OpenRefine/wiki/Reconciliation-Service-API). Differences from MQL are [documented](/docs/differences-from-freebase.md).

Copyright (c) 2015 James McKinney, released under the MIT license
