---
layout: default
title: Who's got dirt?
---
The <i>Who's got dirt?</i> API provides a single access point to multiple APIs of influence data on the web. It proxies requests to the supported APIs, so that users only need to learn a single request format and a single response format.

<h1>Documentation</h1>

1. [Basics](#basics)
1. [Supported APIs](#supported-apis)
  1. [API keys](#api-keys)
  1. [API security](#api-security)
  1. [API terms & conditions](#api-terms-and-conditions)
1. [Usage](#usage)
  1. [Query format](#query-format)
  1. [Error handling](#error-handling)
    1. [Request errors](#request-errors)
    1. [Query errors](#query-errors)
    1. [API errors](#api-errors)
1. [Endpoints](#endpoints)
  1. [Entities](#entities)
      1. [Ruby example](#entities-example-ruby)
  1. [Relations](#relations)
  1. [Lists](#lists)
  1. [Footnotes](#footnotes)
1. [Response formats](#response-formats)
1. [Notes](#notes)
  1. [Differences from the Metaweb Query Language (MQL)](#differences-from-mql)


<h2 id="basics">Basics</h2>

<i>Who's got dirt?</i> recognizes three types of influence data:

* An **entity** is a person or an organization: for example, a company.
* A **relation** exists between entities: for example, a person is an officer of a company.
* A **list** is a listing of entities: for example, the companies within a corporate grouping.


<h2 id="supported-apis">Supported APIs</h2>

<i>Who's got dirt?</i> supports the following endpoints of these APIs of influence data:

* [CorpWatch](http://corpwatch.org/) has information on public companies and their subsidiaries, based on SEC filings. ([docs](http://api.corpwatch.org/))
  * [/companies.json](http://api.corpwatch.org/documentation/api_examples.html#A17), queried via [`/entities`](#entities)
* [LittleSis](http://littlesis.org/) has information on American people and organizations in business and government, and the relationships between them. ([docs](https://api.littlesis.org/))
  * [/entities.xml](http://api.littlesis.org/documentation#entities), queried via[`/entities`](#entities)
  * [/lists.xml](http://api.littlesis.org/documentation#lists), queried via[`/lists`](#lists)
* [OpenCorporates](https://opencorporates.com/) has information on over 90 million companies around the world. ([docs](https://api.opencorporates.com/))
  * [/companies/search](https://api.opencorporates.com/documentation/API-Reference), queried via[`/entities`](#entities)
  * [/corporate_groupings/search](https://api.opencorporates.com/documentation/API-Reference), queried via[`/lists`](#lists)
  * [/officers/search](https://api.opencorporates.com/documentation/API-Reference), queried via[`/relations`](#relations)
* [OpenDuka](http://www.openduka.org/) has information on Kenyan people and organizations. ([docs](http://www.openduka.org/index.php/api/documentation))
  * [/search](http://www.openduka.org/index.php/api/documentation), queried via[`/entities`](#entities)
* [OpenOil](http://openoil.net/) has information on oil concessions around the world. ([docs](http://openoil.net/openoil-api/))
  * [/concession/search](http://openoil.net/openoil-api/), queried via[`/relations`](#relations)
* [Poderopedia](http://www.poderopedia.org/) has information on Chilean organizations and people in business and politics. ([docs](http://api.poderopedia.org/))
  * [/search](http://api.poderopedia.org/search), queried via[`/entities`](#entities)

Don't see an API you use? Please request its support in [this issue](https://github.com/influencemapping/whos_got_dirt-gem/issues/3).


<h3 id="api-keys">API Keys</h3>

An API key is **required** to proxy requests to some APIs. You may register for API keys at:

* [CorpWatch](http://api.corpwatch.org/register.php)
* [LittleSis](http://api.littlesis.org/register) (required)
* [OpenCorporates](https://opencorporates.com/api_accounts/new) (sometimes required)
* [OpenDuka](http://www.openduka.org/index.php/api) (required)
* [OpenOil](http://openoil.net/openoil-api/) (required)
* [Poderopedia](https://poderopedia.3scale.net/login) (required)


<h3 id="api-security">API Security</h3>

Some APIs do not support HTTPS:

* CorpWatch
* OpenDuka
* Poderopedia

Also, if you do not trust the public API at [https://whosgotdirt.herokuapp.com/](https://whosgotdirt.herokuapp.com/), please read the [technical documentation](https://github.com/influencemapping/whos_got_dirt-server#deployment) to deploy your own private API.


<h3 id="api-terms-and-conditions">API Terms &amp; Conditions</h3>

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


<h2 id="usage">Usage</h2>

The <i>Who's got dirt?</i> API's base URL is [https://whosgotdirt.herokuapp.com/](https://whosgotdirt.herokuapp.com/).

Each endpoint ([`/entities`](#entities), for example) accepts a single query string parameter `queries`. For the request `GET /entities?queries=<queries>`, `<queries>` may look like:

{% include request.md %}

You may use any query ID instead of `q0`. You may submit multiple queries with different query IDs. You may use the `POST` HTTP method if the query string is too long.

You may use `endpoints` within each query to request the given endpoints only. The valid values for `endpoints` are:

* `CorpWatch`
* `LittleSis`
* `OpenCorporates`
* `OpenDuka`
* `OpenOil`
* `Poderopedia`

<h3 id="query-format">Query format</h3>

The format of `query` within each query is inspired from the [Metaweb Query Language](http://mql.freebaseapps.com/index.html). Each property name (`name`, for example) in `query` may be followed by an [MQL operator](http://mql.freebaseapps.com/ch03.html#operators) (`~=`, for example). If no operator follows a property name, the operator is equality. (In the tables below, `=` denotes equality, but you should never append `=` to a property name: for example, use `name`, not `name=`.) The other operators are:

<dl>
  <dt><code>~=</code></dt>
  <dd>
    The pattern matching operator tests whether a property contains a word or phrase.<br>
    <code>"name~=": "ACME Inc."</code>
  </dd>
  <dt><code>|=</code></dt>
  <dd>
    The "one of" operator tests whether a property is equal to any value in an array.<br>
    <code>"country_code|=": ["gb", "us"]</code>
  </dd>
  <dt><code>&gt;=</code></dt>
  <dd>
    The greater-than-or-equal operators tests whether a property is greater than or equal to a value.<br>
    <code>"founding_date&gt;=": "2010-01-01"</code>
  </dd>
  <dt><code>&gt;</code></dt>
  <dd>
    The greater-than operators tests whether a property is greater than a value.<br>
    <code>"founding_date&gt;": "2010-01-01"</code>
  </dd>
  <dt><code>&lt;=</code></dt>
  <dd>
    The less-than-or-equal operators tests whether a property is less than or equal to a value.<br>
    <code>"founding_date&lt;=": "2010-01-01"</code>
  </dd>
  <dt><code>&lt;</code></dt>
  <dd>
    The less-than operators tests whether a property is less than a value.<br>
    <code>"founding_date&lt;": "2010-01-01"</code>
  </dd>
  <dt><code>a:</code></dt>
  <dd>
    While not an operator, a property prefix (<code>a:</code>, for example) can be used to express the <code>AND</code> operator.<br>
    <code>"a:industry_code": "be_nace_2008-66191", "b:industry_code": "be_nace_2008-66199"</code>
  </dd>
</dl>

Not all APIs support all parameters (`created_at`, for example) and operators (`|=`, for example). See the tables below for each API's support for parameters and operators.

**If a parameter or operator is unsupported by an API, it is silently ignored**.


<h3 id="error-handling">Error handling</h3>

Errors may occur at the **request**, **query** or **response** level.

<h4 id="request-errors">Request errors</h4>

* If the `queries` parameter is invalid JSON, a `400 Bad Request` is returned.
* If the `queries` parameter is missing, blank, or not a JSON object, a `422 Unprocessable Entity` is returned.

For example, [`GET /entities`](https://whosgotdirt.herokuapp.com/entities) returns:

```json
{
  "status": "422 Unprocessable Entity",
  "messages": [{
    "message": "parameter 'queries' must be provided"
  }]
}
```

<h4 id="query-errors">Query errors</h4>

* If a query in the `queries` parameter is not a JSON object, has no `query`, or has a `query` that is not a JSON object, an error message is returned for that query.

For example, [`GET /entities?queries={"q0":{}}`](http://whosgotdirt.herokuapp.com/entities?queries={"q0":{}}) returns:

```json
{
  "status": "200 OK",
  "q0": {
    "count": 0,
    "result": [],
    "messages": [{
      "message": "'query' must be provided"
    }]
  }
}
```

<h4 id="api-errors">API errors</h4>

* If an API returns an error, an error message is returned for that response. <i>Who's got dirt?</i> returns the API's original error message, however cryptic.

For example, [`GET /entities?queries={"q0":{"query":{"type":"Person","name":"John Smith"}}}`](http://whosgotdirt.herokuapp.com/entities?queries={"q0":{"query":{"type":"Person","name":"John Smith"}}}) returns:

```json
{
  "status": "200 OK",
  "q0": {
    "count": 100,
    "result": [
      …
    ],
    "messages": [{
      "info": {
        "url": "https://api.littlesis.org/entities.xml?q=John+Smith"
      },
      "status": "401 Unauthorized",
      "message": "Your request must include a query parameter named \"_key\" with a valid API key value. To obtain an API key, visit http://api.littlesis.org/register."
    }, {
      "info": {
        "url": "http://api.poderopedia.org/visualizacion/search?alias=John+Smith&entity=persona"
      },
      "status": "400 Bad Request",
      "message": "400 BAD REQUEST"
    }]
  }
}
```


<h2 id="endpoints">Endpoints</h2>

<h3 id="entities">Entities</h3>

The endpoint is `GET /entities?queries=<queries>`.

This table documents which operators, if any, are supported by each API for each parameter. You may need to scroll the table to the right to see all columns.

Note: The `type` parameter is **required** by Poderopedia.

{% include entities_table.md %}

<h4 id="entities-example-ruby">Ruby Example</h4>

{% include entities_ruby.md %}


<h3 id="relations">Relations</h3>

The API endpoint is `GET /relations?queries=<queries>`.

{% include relations_table.md %}


<h3 id="lists">Lists</h3>

The endpoint is `GET /lists?queries=<queries>`.

{% include lists_table.md %}


<h3 id="footnotes">Footnotes</h3>

<p id="note1">1. Each API has its own API key parameter:</p>

* `corp_watch_api_key`
* `little_sis_api_key`
* `open_corporates_api_key`
* `open_duka_api_key`
* `poderopedia_api_key`

<p id="note2">2. Only <code>contact_details</code> with a <code>type</code> of <code>address</code> are supported.</p>


<h2 id="response-formats">Response formats</h2>

A set of JSON Schema describe the response formats of:

* [Entities](https://github.com/influencemapping/whos_got_dirt-gem/blob/master/schemas/schema.json#L4)
* [Relations](https://github.com/influencemapping/whos_got_dirt-gem/blob/master/schemas/schema.json#L132)
* [Lists](https://github.com/influencemapping/whos_got_dirt-gem/blob/master/schemas/schema.json#L213)

The [Entity schema](https://github.com/influencemapping/whos_got_dirt-gem/blob/master/schemas/schema.json#L4) is a combination of the Person and Organization models in [Popolo](http://www.popoloproject.com/), a format used by dozens of civil society organizations, businesses and governments to model government and legislative data.

The [Relation schema](https://github.com/influencemapping/whos_got_dirt-gem/blob/master/schemas/schema.json#L132) combines terms from RDF and Schema.org, with a few additional properties shared with other Popolo models.

The [List schema](https://github.com/influencemapping/whos_got_dirt-gem/blob/master/schemas/schema.json#L213) is a JSON Schema version of [Schema.org](http://schema.org/)'s [ItemList](http://schema.org/ItemList), with a few additional properties shared with other Popolo models.


<h2 id="notes">Notes</h2>

After performing an initial query – for example, a search for companies – a common use case is to perform a second query using the results of the first query – for example, a search for all officers of those companies. <i>Who's got dirt?</i> does not (yet) support this use case, because such second-level queries are more numerous and variable across APIs ([issue #15](https://github.com/influencemapping/whos_got_dirt-server/issues/15)). However, you may nonetheless use the results of the first <i>Who's got dirt?</i>  query to perform your own API-specific second query.

<h3 id="differences-from-mql">Differences from the Metaweb Query Language (MQL)</h3>

The API's request and response formats are inspired from the [Metaweb Query Language](http://mql.freebaseapps.com/index.html) and the [OpenRefine Reconciliation Service API](https://github.com/OpenRefine/OpenRefine/wiki/Reconciliation-Service-API). The differences are:

* Does not support [MQL Read](https://developers.google.com/freebase/v1/mqlread) parameters other than `query`.
* Does not support [MQL directives](http://wiki.freebase.com/wiki/MQL_directives) other than `limit`; instead of [counting results](https://developers.google.com/freebase/mql/ch03#countingresults), returns a new `count` field at the same level as the `result` field.
* Does not support [asking for values](https://developers.google.com/freebase/mql/ch03#reviewvaluequeries) or [wildcards](https://developers.google.com/freebase/mql/ch03#wildcards); instead returns all fields.
* Does not return a `status` field at the query level, because it would need to report the status of many responses. Does not return a `code` field.
