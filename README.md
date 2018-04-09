# Creating a REST API Instance
```
curl --anyauth --user admin:admin -X POST -d@"rest-config.xml" -i -H "Content-type: application/xml" http://localhost:8002/v1/rest-apis
```
```
curl --anyauth --user admin:admin -X POST -d@"rest-config.json" -i -H "Content-type: application/json" http://localhost:8002/v1/rest-apis
```
# MLCP load
```
./mlcp.sh import -host localhost -port 8011 -username admin -password admin \
     -input_file_path $HOME/dev/marklogic-samples/news/data \
     -mode local \
     -input_file_type documents \
     -output_collections "http://www.bbc.co.uk/news/content" \
     -output_uri_replace "$HOME/dev/marklogic-samples/news/data, 'content/news'"
```

# Searching a database
## Query 1 XQuery
```
cts:search(fn:doc(), "nuclear")[1 to 10]
```

## Query 2 XQuery
```
declare namespace ns = "http://www.w3.org/1999/xhtml";

for $doc in cts:search(fn:doc(), "nuclear")[1 to 10]
return $doc//ns:title/text()
```

## Query 3 XQuery
```
declare namespace ns = "http://www.w3.org/1999/xhtml";

for $title in cts:search(fn:doc()//ns:title, "nuclear")[1 to 10]
return $title/text()
```

## Query 4 JavaScript
```
'use strict';

fn.subsequence(cts.search('nuclear'), 1, 10);
```

## Query 5 JavaScript
```
'use strict';
var namespace = 'http://www.w3.org/1999/xhtml';
var documents = cts.search('nuclear');

var results = [];
for (var document of documents) {
  var node = document.root;
  var title = node.xpath("//ns:title/text()", {ns:namespace}).toString().replace(/\r?\n|\r/g, " ");
  results.push(title);                                                                                
}
results;
```

## Query 6 
```
xquery version "1.0-ml";
import module namespace search = "http://marklogic.com/appservices/search"
  at "/MarkLogic/appservices/search/search.xqy";

search:search("nuclear")
```

# Using the REST API for search
```
curl --anyauth --user admin:admin -X GET "http://localhost:8011/v1/search?q=nuclear"
```

