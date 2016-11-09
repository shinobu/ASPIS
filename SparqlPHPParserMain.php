<?php

include 'lib/sparql.lex.php';
include 'lib/sparql.php';

class SparqlPHPParserMain {
	//root gets set in the parser
	public $root = null;
  public $parser = null;

  private function parse($fp) {
		if (!isset($parser)) {
			$this->parser = new SparqlPHPParser($this);
		}
    $scanner = new SparqlLexer($fp);
	    while ($x = $scanner->nextToken())
		  {
		    if($x->type != -1) {
					$this->parser->doParse($x->type, $x);
				} else {
					$err = 'Invalid Input in line ' . $x->line . '. Problem with: ' . $x->value . fgets($fp, 15);
					throw new Exception($err);
				}
		  }
			$this->parser->doParse(0);
			
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
	
	function resetParser() {
		//TODO
	}
}
