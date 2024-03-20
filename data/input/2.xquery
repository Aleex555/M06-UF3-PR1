declare option output:method "xml";
declare option output:indent "yes";

<users>{
  for $u in /posts/row[@PostTypeId='1']
  group by $userId := $u/@OwnerUserId
  order by count($u) descending
  return 
    <user>
      <userId>{$userId}</userId>
      <questions>{count($u)}</questions>
    </user>
}</users>

