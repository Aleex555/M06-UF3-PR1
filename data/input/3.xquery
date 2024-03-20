declare option output:method "xml";
declare option output:indent "yes";

<tags>{
  for $row in /posts/row
  let $tags := tokenize(substring($row/@Tags, 2, string-length($row/@Tags) - 2), '&gt;|&lt;')
  for $tag in $tags
  where string-length($tag) > 0
  group by $tag
  order by count($tag) descending
  return 
    <tag>
      <name>{$tag}</name>
      <count>{count($tag)}</count>
    </tag>
}</tags>
