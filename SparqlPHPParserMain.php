<?php

include 'lib/sparql.lex.php';
include 'lib/sparql.php';

class SparqlPHPParserMain {
	public $error = null;
  public $parser = new SparqlPHPParserParser($this);

  private function parse($fp) {
    $scanner = new SparqlLexer($fp);
	    while ($x = $scanner->nextToken())
		  {
		    if($x->type != SparqlPHPParser::TK_FAIL) {
					
				} else {
					throw Exception('...');
				}
		  }
  }

	function parseString($string) {
		$fp = fopen("php://memory", 'r+');
		fwrite($fp, $string);
		rewind($fp);
		return $this->parse($fp);
	}

	function parseFile($file) {
    $fp = fopen($file, 'r+') or die('Unable to open file with path: ' . $file);
		return $this->parse($fp);
	}
}
