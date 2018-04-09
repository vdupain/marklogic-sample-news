declare namespace ns = "http://www.w3.org/1999/xhtml";

for $title in 
   cts:search(fn:doc()//ns:title, "nuclear") [1 to 10] 
return $title/text()



