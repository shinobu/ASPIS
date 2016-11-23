<?php 

include 'SparqlPHPParserMain.php';

$parser = new SparqlPHPParserMain();
$parser->parseString('@Base <http://guessit.com> 
Prefix abc:<https://www.getit> Select * where { <abc> ?b ?c }');
print_r(PHP_EOL);
print_r($parser->root->query);
 ?>
