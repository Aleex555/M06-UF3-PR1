declare option output:method "xml";
declare option output:indent "yes";

let $posts := /posts/row

(: Troba les preguntes amb el major score :)
let $preguntes := $posts[(@PostTypeId="1")]

(: Ordena les preguntes per score de manera descendent :)
let $preguntesOrdenades := for $p in $preguntes
order by number($p/@Score) descending
return $p

(: Selecciona las primeras 1000 preguntas ordenadas :)
let $top100Preguntes := subsequence($preguntesOrdenades, 1, 100)

(: Per a cada pregunta del top 1000, troba la resposta amb més vots :)
let $resultat := for $pregunta in $top1000Preguntes
let $idPregunta := $pregunta/@Id
let $respostaMesVotada := (
  for $resposta in $posts[(@PostTypeId="2") and (@ParentId=$idPregunta)]
  order by number($resposta/@Score) descending
  return $resposta
)[1]
return
  <resultat>
    <pregunta>
      <titol>{$pregunta/@Title}</titol>
      <cos>{$pregunta/@Body}</cos>
      <score>{$pregunta/@Score}</score>
      <tags>{$pregunta/@Tags}</tags>
    </pregunta>
    <respostaMesVotada>
      <cos>{$respostaMesVotada/@Body}</cos>
      <score>{$respostaMesVotada/@Score}</score>
    </respostaMesVotada>
  </resultat>

return $resultat
