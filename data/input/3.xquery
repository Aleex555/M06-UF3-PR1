declare option output:method "xml";
declare option output:indent "yes";

<tags>{
  let $tags := 
    for $tag in distinct-values(/posts/row/tokenize(substring(@Tags, 2, string-length(@Tags) - 2), '&gt;|&lt;'))
    let $count := count(/posts/row[contains(@Tags, concat('&lt;', $tag, '&gt;'))])
    order by $count descending
    return 
      <tag>
        <name>{$tag}</name>
        <count>{$count}</count>
      </tag>
  return subsequence($tags, 1, 1000)
}</tags>

