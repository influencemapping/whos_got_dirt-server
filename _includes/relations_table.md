<table>
  <thead>
    <tr>
      <th>Parameter</th>
      <th>Definition</th>
      <th>Example</th>
      <th class="api">OpenCorporates</th>
      <th class="api">OpenOil</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>API key <a href="#note1"><sup>1</sup></a></td>
      <td>Supply an API key.</td>
      <td class="example"><pre>"open_oil_api_key": "..."</pre></td>
      <td><code>=</code></td>
      <td><code>=</code></td>
    </tr>
    <tr>
      <td><code>limit</code></td>
      <td>Limit the number of results.</td>
      <td class="example"><pre>"limit": 5</pre></td>
      <td><code>=</code></td>
      <td><code>=</code></td>
    </tr>
    <tr>
      <td><code>subject<br>.name</code></td>
      <td>Find related entities by name.</td>
      <td class="example"><pre>
"subject": [{
  "name~=": "John Smith"
}]</pre></td>
      <td><code>~=</code></td>
      <td><code>=</code></td>
    </tr>
    <tr>
      <td><code>subject<br>.birth_date</code></td>
      <td>Find related people by birth date.</td>
      <td class="example"><pre>
"subject": [{
  "birth_date": "2010-01-01"
}]</pre></td>
      <td><code>=</code> <code>&gt;=</code> <code>&gt;</code> <code>&lt;=</code> <code>&lt;</code></td>
      <td></td>
    </tr>
    <tr>
      <td><code>subject<br>.contact_details<br>.value</code> <a href="#note2"><sup>2</sup></a></td>
      <td>Find related entities by address.</td>
      <td class="example"><pre>
"subject": [{
  "contact_details": [{
    "type": "address",
    "value~=": "52 London"
  }]
}]</pre></td>
      <td><code>~=</code></td>
      <td></td>
    </tr>
    <tr>
      <td><code>jurisdiction_code</code></td>
      <td>Find officerships by jurisdiction code.</td>
      <td class="example"><pre>"jurisdiction_code": "gb"</pre></td>
      <td><code>=</code> <code>|=</code></td>
      <td></td>
    </tr>
    <tr>
      <td><code>role</code></td>
      <td>Find officerships by role.</td>
      <td class="example"><pre>"role": "ceo"</pre></td>
      <td><code>=</code></td>
      <td></td>
    </tr>
    <tr>
      <td><code>inactive</code></td>
      <td>Find active or inactive officerships.</td>
      <td class="example"><pre>"inactive": false</pre></td>
      <td><code>=</code></td>
      <td></td>
    </tr>
    <tr>
      <td><code>country_code</code></td>
      <td>Find concessions by country code.</td>
      <td class="example"><pre>"country_code": "BR"</pre></td>
      <td></td>
      <td><code>=</code></td>
    </tr>
    <tr>
      <td><code>status</code></td>
      <td>Find concessions with a "licensed" or "unlicensed" status.</td>
      <td class="example"><pre>"status": "licensed"</pre></td>
      <td></td>
      <td><code>=</code></td>
    </tr>
    <tr>
      <td><code>type</code></td>
      <td>Find concessions with an "offshore" or "onshore" type.</td>
      <td class="example"><pre>"type": "offshore"</pre></td>
      <td></td>
      <td><code>=</code></td>
    </tr>
  </tbody>
</table>
