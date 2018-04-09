xquery version "1.0-ml";

import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

declare namespace ns = "http://www.w3.org/1999/xhtml";

declare function local:result-controller()
{
	if(xdmp:get-request-field("uri"))
	then local:display-article()
	else 
		if(xdmp:get-request-field("term"))
		then local:search-results()
		else local:default-results()
};

declare function local:default-results()
{
   (for $doc in fn:doc()
	order by ($doc/ns:html/ns:head/ns:meta[@property eq "rnews:datePublished"]/@content)
	return <div class="result-item">
				<span class="article-heading">
					<a href="index.xqy?uri={xdmp:url-encode(fn:base-uri($doc))}">
					{$doc/ns:html/ns:body/ns:div/ns:h1/text()}
					</a>
				</span><br/>
				{$doc/ns:html/ns:body/ns:div/ns:p[1]/string(), " ", $doc/ns:html/ns:body/ns:div/ns:p[2]/string()}
				{" ", fn:string($doc/ns:html/ns:head/ns:meta[@property eq "rnews:datePublished"]/@content)}
			</div>) [1 to 10]
};

declare function local:search-results()
{
	for $result in search:search(xdmp:get-request-field("term"))/search:result
	let $uri := fn:string($result/@uri)
    let $doc := fn:doc($uri)
	return <div class="result-item">
				<span class="article-heading">
					<a href="index.xqy?uri={xdmp:url-encode(fn:base-uri($doc))}">
					{$doc/ns:html/ns:body/ns:div/ns:h1/text()}
					</a>
				</span><br/>
				{
				for $text in $result/search:snippet/search:match/node() 
				return
					if(fn:node-name($text) eq xs:QName("search:highlight"))
					then <span class="highlight">{$text/text()}</span>
					else ($text, " ")
				}
				{" ", fn:string($doc/ns:html/ns:head/ns:meta[@property eq "rnews:datePublished"]/@content)}
			</div>
};

declare function local:display-article()
{
	let $uri := xdmp:get-request-field("uri")
	let $doc := fn:doc($uri) 
	return <div>
		{if ($doc/ns:html/ns:body/ns:div//ns:img[1]) then <p><img src="{($doc/ns:html/ns:body/ns:div//ns:img/@src)[1]}"/></p> else ()}
		<div class="article-heading">
			{$doc/ns:html/ns:body/ns:div/ns:h1/text()}
		</div>
		{
			for $p in $doc/ns:html/ns:body/ns:div/ns:p
			return <p>{$p/string()}</p>
		}
		<div>{fn:string($doc/ns:html/ns:head/ns:meta[@property eq "rnews:datePublished"]/@content)}</div>
	</div>
};

xdmp:set-response-content-type("text/html; charset=utf-8"),
<html>
<head>
<title>News</title>
<link href="boilerplate.css" rel="stylesheet" type="text/css"/>
<link href="fluid.css" rel="stylesheet" type="text/css"/>
<link href="news.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<div class="gridContainer clearfix">
      <div class="header"><br/><h1>News</h1></div>
      <div class="section">
		<div class="main-column">  
			<div id="form">
				<form name="form" method="get" action="index.xqy" id="form">
					<input type="text" name="term" id="term" size="50" value="{xdmp:get-request-field("term")}"/>
					<input type="submit" name="submitbtn" id="submitbtn" value="search"/>
				</form> 
				<br/>
				{local:result-controller()}
				
			</div>
		</div>
	  </div>
      <div class="footer"><br/><br/><hr/>source articles from <b class="dark-gray">BBC News</b><br/><br/></div>
	</div>
</body>
</html>
