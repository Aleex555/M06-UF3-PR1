declare option output:method "xml";
declare option output:indent "yes";

<posts>{
  let $posts := (
    for $p in /posts/row[@PostTypeId='1']
    order by number($p/@ViewCount) descending
    return $p
  )
  return (
    for $p in subsequence($posts, 1, 100)
    return 
      <post>
        <title>{data($p/@Title)}</title>
      </post>
  )
}</posts>




