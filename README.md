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
      "name~=": "John Smith",
      "jurisdiction_code|=": ["gb", "ie"],
      "birth_date>=": "1950-01-01",
      "birth_date<=": "1959-12-31",
      "memberships": [{
        "role": "ceo",
        "status": "active"
      }],
      "contact_details": [{
        "type": "address",
        "value": "52 London"
      }],
      "open_corporates_api_key": "..."
    }
  },
  ...
}
```

You may use any query ID instead of `q0`. Not all APIs support every parameter and operator. **If a parameter or operator is unsupported, it is silently ignored.** See more in the [documentation](http://www.rubydoc.info/gems/whos_got_dirt/WhosGotDirt/Requests/Person).

The response looks like:

```json
{
  "q0": {
    "count": 123,
    "result": [
      {
        "id": "https://www.whosgotdirt.com/opencorporates/officers/72893270",
        "name": "0LGA SUSLOVA",
        "memberships": [{
          "role": "ceo",
          "organization": {
            "name": "LAW OFFICE OF OLGA SUSLOVA, P.C."
          }
        }]
      }
    ]
  },
  ...
}
```

**If an API returns an error, its response is silently ignored.** See more in the [documentation](http://www.rubydoc.info/gems/whos_got_dirt/WhosGotDirt/Responses/Person).

## Acknowledgements

Most terms are from [Popolo](http://www.popoloproject.com/). The request and response formats are inspired from the [Metaweb Query Language (MQL)](http://mql.freebaseapps.com/index.html) and the [OpenRefine Reconciliation Service API](https://github.com/OpenRefine/OpenRefine/wiki/Reconciliation-Service-API). Differences from MQL are [documented](/docs/differences-from-freebase.md).

Copyright (c) 2015 James McKinney, released under the MIT license
