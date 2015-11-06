<div class="table-responsive">
  <table>
    <thead>
      <tr>
        <th class="parameter">Parameter</th>
        <th class="definition">Definition</th>
        <th class="example">Example</th>
        <th class="api">CorpWatch</th>
        <th class="api">LittleSis</th>
        <th class="api">OpenCorporates</th>
        <th class="api">OpenDuka</th>
        <th class="api">Poderopedia</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>API key <a href="#note1"><sup>1</sup></a></td>
        <td>Supply an API key.</td>
        <td class="example"><pre>"corp_watch_api_key": "..."</pre></td>
        <td><code>=</code></td>
        <td><code>=</code></td>
        <td><code>=</code></td>
        <td><code>=</code></td>
        <td><code>=</code></td>
      </tr>
      <tr>
        <td><code>limit</code></td>
        <td>Limit the number of results.</td>
        <td class="example"><pre>"limit": 5</pre></td>
        <td><code>=</code></td>
        <td><code>=</code></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>name</code></td>
        <td>Find entities by name.</td>
        <td class="example"><pre>"name~=": "ACME Inc."</pre></td>
        <td><code>~=</code></td>
        <td><code>~=</code></td>
        <td><code>~=</code></td>
        <td><code>~=</code></td>
        <td><code>~=</code></td>
      </tr>
      <tr>
        <td><code>classification</code></td>
        <td>Find entities by classification.</td>
        <td class="example"><pre>"classification": "LLC"</pre></td>
        <td></td>
        <td><code>=</code></td>
        <td><code>=</code> <code>|=</code></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>created_at</code></td>
        <td>Find entities by the creation date of the metadata.</td>
        <td class="example"><pre>"created_at>=": "2010-01-01"</pre></td>
        <td></td>
        <td></td>
        <td><code>&gt;=</code></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>founding_date</code></td>
        <td>Find organizations by founding date.</td>
        <td class="example"><pre>"founding_date": "2010-01-01"</pre></td>
        <td></td>
        <td></td>
        <td><code>=</code> <code>&gt;=</code> <code>&gt;</code> <code>&lt;=</code> <code>&lt;</code></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>dissolution_date</code></td>
        <td>Find organizations by dissolution date.</td>
        <td class="example"><pre>"dissolution_date": "2010-01-01"</pre></td>
        <td></td>
        <td></td>
        <td><code>=</code> <code>&gt;=</code> <code>&gt;</code> <code>&lt;=</code> <code>&lt;</code></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>identifiers<br>.identifier</code></td>
        <td>Find entities by identifier.</td>
        <td class="example"><pre>
"identifiers": [{
  "identifier": "911653725",
  "scheme": "SEC Central Index Key"
}]</pre></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>identifiers<br>.scheme</code></td>
        <td>Find entities by identifier scheme.</td>
        <td class="example"><pre>
"identifiers": [{
  "identifier": "911653725",
  "scheme": "SEC Central Index Key"
}]</pre></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>contact_details<br>.value</code> <a href="#note2"><sup>2</sup></a></td>
        <td>Find entities by address.</td>
        <td class="example"><pre>
"contact_details": [{
  "type": "address",
  "value~=": "52 London"
}]</pre></td>
        <td><code>~=</code></td>
        <td></td>
        <td><code>~=</code></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>industry_code</code></td>
        <td>Find organizations by industry (SIC) code.</td>
        <td class="example"><pre>"industry_code": "2011"</pre></td>
        <td><code>=</code></td>
        <td></td>
        <td><code>=</code> <code>|=</code> <code>a:</code></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>sector_code</code></td>
        <td>Find organizations by SIC sector.</td>
        <td class="example"><pre>"sector_code": "4100"</pre></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>substring_match</code></td>
        <td>Match within words on <code>name~=</code> and address queries.</td>
        <td class="example"><pre>"substring_match": 1</pre></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>country_code</code></td>
        <td>Find entities by country code.</td>
        <td class="example"><pre>"country_code": "US"</pre></td>
        <td><code>=</code></td>
        <td></td>
        <td><code>=</code> <code>|=</code></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>subdiv_code</code></td>
        <td>Find entities by country subdivision code.</td>
        <td class="example"><pre>"subdiv_code": "OR"</pre></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>year</code></td>
        <td>Find organizations with SEC filings in a given year.</td>
        <td class="example"><pre>"year": 2005</pre></td>
        <td><code>=</code> <code>&gt;=</code> <code>&lt;=</code></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>source_type</code></td>
        <td>Find organizations that appear as "filers" in SEC filings or as subsidiaries ("relationships") only.</td>
        <td class="example"><pre>"source_type": "relationships"</pre></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>num_children</code></td>
        <td>Find organizations by the number of direct descendants in a hierarchy.</td>
        <td class="example"><pre>"num_children": 3</pre></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>num_parents</code></td>
        <td>Find organizations by the number of direct ancestors in a hierarchy.</td>
        <td class="example"><pre>"num_parents": 2</pre></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>top_parent_id</code></td>
        <td>Find organizations within the hierarchy of another organization.</td>
        <td class="example"><pre>"top_parent_id": "cw_7324"</pre></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>search_all</code></td>
        <td>Match descriptions and summaries on <code>name~=</code> queries.</td>
        <td class="example"><pre>"search_all": 1</pre></td>
        <td></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>jurisdiction_code</code></td>
        <td>Find organizations by jurisdiction code.</td>
        <td class="example"><pre>"jurisdiction_code": "gb"</pre></td>
        <td></td>
        <td></td>
        <td><code>=</code> <code>|=</code></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>current_status</code></td>
        <td>Find organizations by status.</td>
        <td class="example"><pre>"current_status": "Dissolved"</pre></td>
        <td></td>
        <td></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>inactive</code></td>
        <td>Find active or inactive organizations.</td>
        <td class="example"><pre>"inactive": false</pre></td>
        <td></td>
        <td></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>branch</code></td>
        <td>Find branch or non-branch organizations.</td>
        <td class="example"><pre>"branch": true</pre></td>
        <td></td>
        <td></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>nonprofit</code></td>
        <td>Find nonprofit or other organizations.</td>
        <td class="example"><pre>"nonprofit": true</pre></td>
        <td></td>
        <td></td>
        <td><code>=</code></td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td><code>entity</code></td>
        <td>Find entities of the class <code>Person</code> or <code>Organization</code>.</td>
        <td class="example"><pre>"entity": "Person"</pre></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td><code>=</code></td>
      </tr>
    </tbody>
  </table>
</div>
