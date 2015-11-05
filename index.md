---
layout: default
title: Who's got dirt?
---
## Supported APIs

<i>Who's got dirt?</i> supports these APIs:

* [CorpWatch](http://corpwatch.org/) ([docs](http://api.corpwatch.org/))
* [LittleSis](http://littlesis.org/) ([docs](https://api.littlesis.org/))
* [OpenCorporates](https://opencorporates.com/)  ([docs](https://api.opencorporates.com/))
* [OpenDuka](http://www.openduka.org/) ([docs](http://www.openduka.org/index.php/api/documentation))
* [OpenOil](http://openoil.net/) ([docs](http://openoil.net/openoil-api/))
* [Poderopedia](http://www.poderopedia.org/) ([docs](http://api.poderopedia.org/))

Don't see an API you use? Please request its support in [this issue](https://github.com/influencemapping/whos_got_dirt-gem/issues/3).

### API Keys

An API key is required to submit requests to some APIs. You may register for API keys at:

* [CorpWatch](http://api.corpwatch.org/register.php)
* [LittleSis](http://api.littlesis.org/register) (required)
* [OpenCorporates](https://opencorporates.com/api_accounts/new) (sometimes required)
* [OpenDuka](http://www.openduka.org/index.php/api) (required)
* [OpenOil](http://openoil.net/openoil-api/) (required)
* [Poderopedia](https://poderopedia.3scale.net/login) (required)

## API Security

Some APIs do not support HTTPS:

* CorpWatch
* OpenDuka
* Poderopedia

If you do not trust the public API at [`https://whosgotdirt.herokuapp.com/`](https://whosgotdirt.herokuapp.com/), please read the [technical documentation](https://github.com/influencemapping/whos_got_dirt-server#deployment) to deploy your own private API.

### API Terms & Conditions

Please be aware of each API's terms and conditions:

* [CorpWatch](http://api.corpwatch.org/register.php)
* [LittleSis](https://api.littlesis.org/documentation#license) ([CC BY-SA 3.0 US](https://creativecommons.org/licenses/by-sa/3.0/us/))
* [OpenCorporates](https://opencorporates.com/info/licence) ([ODbL 1.0](http://opendatacommons.org/licenses/odbl/1.0/))
* [OpenDuka](http://www.openduka.org/index.php/faq) ([CC BY-NC 3.0](https://creativecommons.org/licenses/by-nc/3.0/))
* [OpenOil](http://openoil.net/openoil-api/) ([CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/))
* [Poderopedia](http://www.poderopedia.org/poderopedia/pages/index/20)

{% comment %}
* [CrunchBase](http://data.crunchbase.com/page/accessing-the-dataset) ([CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/))
{% endcomment %}

## Usage

### `GET /entities?queries=<queries>`

`<queries>` looks like:

{% include entities_request.md %}

You may use any query ID instead of `q0`. You may submit multiple queries with different query IDs.

Not every API supports every parameter (for example, `name`) and operator (for example, `~=`). **If a parameter or operator is unsupported, it is silently ignored** ([issue #1](https://github.com/influencemapping/whos_got_dirt-server/issues/1)).

**If an API returns an error, its response is silently ignored** ([issue #2](https://github.com/influencemapping/whos_got_dirt-server/issues/2)).

#### API Parameters Support

This table documents which operators, if any, are supported by each API for each parameter.

{% include entities_table.html %}

#### Example of sending a request in Ruby

{% include entities_ruby.md %}

### `GET /relations?queries=<queries>`

#### API Parameters Support

{% include relations_table.html %}

### `GET /lists?queries=<queries>`

#### API Parameters Support

{% include lists_table.html %}

### Differences from the Metaweb Query Language (MQL)

The API's request and response formats are inspired from the [Metaweb Query Language](http://mql.freebaseapps.com/index.html) and the [OpenRefine Reconciliation Service API](https://github.com/OpenRefine/OpenRefine/wiki/Reconciliation-Service-API). The differences are:

* Does not support [MQL Read](https://developers.google.com/freebase/v1/mqlread) parameters other than `query`.
* Does not support [MQL directives](http://wiki.freebase.com/wiki/MQL_directives) other than `limit`; instead of [counting results](https://developers.google.com/freebase/mql/ch03#countingresults), returns a new `count` field at the same level as the `result` field.
* Does not support [asking for values](https://developers.google.com/freebase/mql/ch03#reviewvaluequeries) or [wildcards](https://developers.google.com/freebase/mql/ch03#wildcards); instead returns all fields.
* Does not return `status` or `code` fields at the query or response levels, because it would need to report the status of many API responses [#2](https://github.com/influencemapping/whos_got_dirt-server/issues/2).
