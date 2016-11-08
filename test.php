<?php 

include 'SparqlPHPParserMain.php';

$parser = new SparqlPHPParserMain();
$parser->parseString('Select * where { }');
 ?>
