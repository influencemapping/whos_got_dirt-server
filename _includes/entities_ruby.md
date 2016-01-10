```ruby
require 'cgi'
require 'open-uri'
require 'json'

queries = <<-EOL
{
  "q0": {
    "query": {
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
#=> {"q0":{"query":{"name~=":"John Smith","jurisdiction_code|=":["gb","ie"],"memberships":
#  [{"role":"director","inactive":false}]}}}

url = "https://whosgotdirt.herokuapp.com/entities?queries=#{CGI.escape(value)}"
#=> https://whosgotdirt.herokuapp.com/entities?queries=%7B%22q0%22%3A%7B%22query%22%3A%7B%22name%7E%3D%22%3A%22John+Smith%22%2C...

results = JSON.load(open(url).read)
#=> {"q0"=>
#  {"count"=>3915,
#   "result"=>
#    [{"name"=>"JOHN SMITH",
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
#       [{"url"=>"https://api.opencorporates.com/officers/search?inactive=false&jurisdiction_code=gb%7Cie&order=score&position=director&q=John+Smith",
#         "note"=>"OpenCorporates"}]},
#    ...]
```
