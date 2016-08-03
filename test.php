<?php 

include 'lib/sparql.lex.php';

class SparqlPHPParser
{
  const TK_SELECT = 0;
  const TK_FAIL = 1;
  const TK_STAR = 2;
  const TK_FROM = 3;
  const TK_INSERTDATA = 4;
  const TK_INSERT = 5;
  const TK_PNAME_LN = 6;
  const TK_BLANK_NODE_LABEL = 7;
  const TK_INTEGER = 8;
  const TK_PREFIX = 9;
  const TK_PNAME_NS = 10;
  const TK_IRIREF = 11;
  const TK_DOT = 12;
  const TK_STRING_LITERAL1 = 13;
  const TK_STRING_LITERAL2 = 14;
  const TK_LANGTAG = 15;
  const TK_VAR1 = 16;
  const TK_WHERE = 17;
  const TK_LBRACE = 18;
  const TK_RBRACE = 19;
  CONST TK_FILTER = 20;
  const TK_A = 21;
  const TK_GREATERTHEN = 22;
  const TK_SEMICOLON = 23;
  const TK_LPARENTHESE = 24;
  const TK_RPARENTHESE = 25;
}

$fp = fopen("php://memory", 'r+');
fwrite($fp, '@PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>        
PREFIX type: <http://dbpedia.org/class/yago/>
PREFIX prop: <http://dbpedia.org/property/>
SELECT ?country_name ?population
WHERE {
    ?country a type:LandlockedCountries ;
             rdfs:label ?country_name ;
             prop:populationEstimate ?population .
    FILTER (?population > 15000000) .
}');
rewind($fp);
$scanner = new SparqlLexer($fp);

while ($x = $scanner->nextToken())
{
print($x->type . ' ');
}
 ?>
