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
