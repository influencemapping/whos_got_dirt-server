## Differences from the Freebase API

* Does not support [MQL Read](https://developers.google.com/freebase/v1/mqlread) parameters other than `query`.
* Does not support [MQL directives](http://wiki.freebase.com/wiki/MQL_directives) other than `limit`; instead of [counting results](https://developers.google.com/freebase/mql/ch03#countingresults), returns a new `count` field at the same level as the `result` field.
* Does not support [asking for values](https://developers.google.com/freebase/mql/ch03#reviewvaluequeries) or [wildcards](https://developers.google.com/freebase/mql/ch03#wildcards); instead returns all fields.
* Does not return `status` or `code` fields at the query or response levels, because it would need to report the status of many API responses [#2](https://github.com/influencemapping/whos_got_dirt-server/issues/2).
