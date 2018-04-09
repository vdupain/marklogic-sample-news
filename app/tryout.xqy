xquery version "1.0-ml";
declare namespace ns = "http://www.w3.org/1999/xhtml";

for $doc in cts:search(fn:doc(), "nuclear")[1 to 10]
return $doc//ns:title/text()

