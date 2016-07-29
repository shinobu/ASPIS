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
}

$fp = fopen("php://memory", 'r+');
fwrite($fp, 'Select from  _:ABCD ');
rewind($fp);
$scanner = new SparqlLexer($fp);

while ($x = $scanner->nextToken())
{
print($x->type);
}
 ?>
