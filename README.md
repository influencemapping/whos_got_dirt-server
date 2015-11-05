# Who's got dirt? A federated search API for people and organizations

[![Build Status](https://secure.travis-ci.org/influencemapping/whos_got_dirt-server.png)](https://travis-ci.org/influencemapping/whos_got_dirt-server)
[![Dependency Status](https://gemnasium.com/influencemapping/whos_got_dirt-server.png)](https://gemnasium.com/influencemapping/whos_got_dirt-server)
[![Coverage Status](https://coveralls.io/repos/influencemapping/whos_got_dirt-server/badge.svg)](https://coveralls.io/r/influencemapping/whos_got_dirt-server)
[![Code Climate](https://codeclimate.com/github/influencemapping/whos_got_dirt-server.png)](https://codeclimate.com/github/influencemapping/whos_got_dirt-server)

This server provides a single access point to some public data on the web. See the [Ruby gem](https://github.com/influencemapping/whos_got_dirt-gem) for details.

## Development

```
bundle
bundle exec rackup
```

## Deployment

If you are concerned about the privacy or security of this API, deploy your own.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

```
heroku apps:create
heroku addons:create memcachier:dev
git push heroku master
```

## Acknowledgements

Most terms are from [Popolo](http://www.popoloproject.com/). The request and response formats are inspired from the [Metaweb Query Language (MQL)](http://mql.freebaseapps.com/index.html) and the [OpenRefine Reconciliation Service API](https://github.com/OpenRefine/OpenRefine/wiki/Reconciliation-Service-API). Differences from MQL are [documented](/docs/differences-from-freebase.md).

Copyright (c) 2015 James McKinney, released under the MIT license
