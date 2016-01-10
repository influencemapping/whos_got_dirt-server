# Who's got dirt? A federated search API for influence data

[![Build Status](https://secure.travis-ci.org/influencemapping/whos_got_dirt-server.png)](https://travis-ci.org/influencemapping/whos_got_dirt-server)
[![Dependency Status](https://gemnasium.com/influencemapping/whos_got_dirt-server.png)](https://gemnasium.com/influencemapping/whos_got_dirt-server)
[![Coverage Status](https://coveralls.io/repos/influencemapping/whos_got_dirt-server/badge.svg)](https://coveralls.io/r/influencemapping/whos_got_dirt-server)
[![Code Climate](https://codeclimate.com/github/influencemapping/whos_got_dirt-server.png)](https://codeclimate.com/github/influencemapping/whos_got_dirt-server)

This server provides a single access point to some public data on the web.

Read the [API documentation](https://influencemapping.github.io/whos_got_dirt-server/).

## Development

```
bundle
bundle exec rackup
```

See the [Ruby gem](https://github.com/influencemapping/whos_got_dirt-gem) for technical details.

## Deployment

The API is a simple Ruby Sinatra app. You may deploy on Heroku (below) or your own infrastructure.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

```
heroku apps:create
heroku addons:create memcachier:dev
git push heroku master
```

Copyright (c) 2015 James McKinney, released under the MIT license
