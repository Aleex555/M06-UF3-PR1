declare option output:method "xml";
declare option output:indent "yes";

<posts>{
  for $p in /posts/row[@PostTypeId='1']
  order by number($p/@ViewCount) descending
  return 
    <post>
      <title>{data($p/@Title)}</title>
      <views>{data($p/@ViewCount)}</views>
    </post>
}</posts>

