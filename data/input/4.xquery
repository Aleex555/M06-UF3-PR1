declare option output:method "xml";
declare option output:indent "yes";

let $top-tags := 
  for $tag in /posts/row/@Tags/tokenize(substring(., 2, string-length(.) - 2), '&gt;|&lt;')
  where string-length($tag) > 0
  group by $tag
  order by count($tag) descending
  return $tag
let $top-10-tags := subsequence($top-tags, 1, 10)
return
<posts>{
  (for $p in /posts/row[@PostTypeId='1']
  where some $tag in $top-10-tags satisfies contains($p/@Tags, $tag)
  order by number($p/@ViewCount) descending
  return 
    <post>
      <title>{data($p/@Title)}</title>
      <views>{data($p/@ViewCount)}</views>
      <tags>{data($p/@Tags)}</tags>
    </post>)[position() <= 100]
}</posts>

