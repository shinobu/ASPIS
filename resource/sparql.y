/* !!!!!!!!!!!!!!!!!SCOPING NOTES !!!!!!!!!!!!!!!!!!!
 * might need to throw A->ssVars = B->ssVars; to everyting containing "expression" rules
 * need to rework catching errors (use throw error)
 *
 */

/* This is a lemon grammar for the Sparql1.1 language */
%name SparqlPHPParser
%token_prefix TK_

/* as the extra argument doesn't work for the php version, You need to add this manually 
afterwards into the parser class (otherwhise we would need to use global vars):

public $main;
public $allNS = array();

function __construct ($parent) {
    $this->main = $parent;
}

function addNS($alias, $iri) {
    $this->allNS[$alias] = $iri;
}

function checkNS($alias) {
    if ($alias == null) {
        return false;
    }
    if (isset($allNS[$alias])) {
        return true;
    }
    return false;
}

function checkBase($alias) {
    if (strcmp(substr($alias,1,7),'http://') == 0 || strcmp(substr($alias,1,8),'https://') == 0) {
        return true;
    } else {
        if($this->checkNS('base')) {
            return true;
        } else {
            return false;
        }
    }
}

*/
%include { /* this will be copied blindly */

class NTToken {
	/* arrays, the array will be considered as sets, as only a few situations need an actual check for duplicates. 
   * This is achieved in PHP with using the value as key and a uniformed value for all keys. 
   * Example: ?text will be saved in the array as array['?text'] = 1, that way if we merge it with another array through the union operator (+)
   * we will get a resultarray with only 1 key called ?text instead of 2 arbitrary keys with both having ?text as value.
   * Furthermore this allows for a quick isset check for searching duplicates
   */
	public $vars = array();
  /* need to somehow check Scoping for (only?) vars noted with AS, only needs to be checked (for subselects) until a whereclause (and for the select it belongs to), 
   *the as's of the selectclause count for the above area as well though 
   */
  public $ssVars = array();
	public $bNodes = array();
  /* needs to be an array, because multiple binds can be reduced and be checked against one triplegroup preceding all binds */
  public $bindVar = array();
	/* non-arrays */
	public $query = null;
  public $counter = 0;
	/* booleans */
  public $hasSS = false;
	public $hasBN = false;
	public $hasFNC = false;
	public $hasAGG = false;

  /* to reduce the amount of isset calls the 'usual' smaller set should be set 1, returns null if NO duplicates are found
   * might be useful to return the duplicate for the error message tho (TODO)
   * array_intersect_key could be faster 
   */
  function noDuplicates($set1, $set2) {
		$noDuplicate = null;
        if ($set1 == null || $set2 == null) {
            return $noDuplicate;
        } else {
            foreach (array_keys($set1) as $key) {
                if (isset($set2[$key])) {
                    $noDuplicate = $key;
                }
    	      }
        }
        return $noDuplicate;
	}

	function copyBools($tmpToken) {
		if ($this->hasBN == false) {
			  $this->hasBN = $tmpToken->hasBN;
		}
		if ($this->hasFNC == false) {
			  $this->hasFNC = $tmpToken->hasFNC;
		}
		if ($this->hasAGG == false) {
			  $this->hasAGG = $tmpToken->hasAGG;
		}
    if ($this->hasSS == false) {
        $this->hasSS == $tmpToken->hasSS;
    }
	}
}  
}

%parse_accept {
    /*add a function to print a clean version of query (or a sparql algebra version)*/
}

%parse_failure {
    /*transfer somehow execution class and write the error into it maybe? maybe as fourth parameter (kinda wasteful as every token will throw it in the parser again)*/
}

/* this defines a symbol for the lexer */
%nonassoc PRAGMA.

start(A) ::= query(B). { A = B; }
start(B) ::= update(B). { A = B; }

query(A) ::= prologue(B) selectQuery(C) valuesClause(D). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; }
query(A) ::= prologue(B) constructQuery(C) valuesClause(D). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; }
query(A) ::= prologue(B) describeQuery(C) valuesClause(D). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; }
query(A) ::= prologue(B) askQuery(C) valuesClause(D). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; }
query(A) ::= selectQuery(B) valuesClause(C). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query; }
query(A) ::= constructQuery(B) valuesClause(C). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query; }
query(A) ::= describeQuery(B) valuesClause(C). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query; }
query(A) ::= askQuery(B) valuesClause(C). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query; }
query(A) ::= prologue(B) selectQuery(C). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query; }
query(A) ::= prologue(B) constructQuery(C). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query; }
query(A) ::= prologue(B) describeQuery(C). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query; }
query(A) ::= prologue(B) askQuery(C). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query; }
query(A) ::= selectQuery(B). { A = B; }
query(A) ::= constructQuery(B). { A = B; }
query(A) ::= describeQuery(B). { A = B; }
query(A) ::= askQuery(B). { A = B; }

prologue(A) ::= prefixDeclX(B) baseDecl(C) prefixDeclX(D). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query;}
prologue(A) ::= baseDecl(B) prefixDeclX(C). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query;}
prologue(A) ::= prefixDeclX(B) baseDecl(C). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query;}
prologue(A) ::= baseDecl(B). { A = new NTToken(); A->query = B->query;}
prefixDeclX(A) ::= prefixDeclX(B) prefixDecl(C). { A = new NTToken(); A->query = B->query . PHP_EOL . C->query;}
prefixDeclX(A) ::= prefixDecl(B). { A = new NTToken(); A->query = B->query;}

baseDecl(A) ::= BASE IRIREF(B) DOT. { addNS('base',B->value); A = new NTToken(); A->query = 'BASE ' . B->value . ' .';}
baseDecl(A) ::= BASE IRIREF(B). { addNS('base',B->value); A = new NTToken(); A->query = 'BASE ' . B->value;}

prefixDecl(A) ::= PREFIX PNAME_NS(B) IRIREF(C) DOT. { addNS(B->value, C->value); A = new NTToken(); A->query = 'PREFIX ' . B->value . C->value . ' .';}
prefixDecl(A) ::= PREFIX PNAME_NS(B) IRIREF(C). { addNS(B->value, C->value); A = new NTToken(); A->query = 'PREFIX ' . B->value . C->value;}

selectQuery(A) ::= selectClause(B) datasetClauseX(C) whereclause(D) solutionModifier(E).
selectQuery(A) ::= selectClause(B) datasetClauseX(C) whereclause(D).
selectQuery(A) ::= selectClause(B) whereclause(C) solutionModifier(D).
selectQuery(A) ::= selectClause(B) whereclause(C).
datasetClauseX(A) ::= datasetClauseX(B) datasetClause(C).
datasetClauseX(A) ::= datasetClause(B).


subSelect(A) ::= selectClause(B) whereclause(C) solutionModifier(D) valuesClause(E).
subSelect(A) ::= selectClause(B) whereclause(C) valuesClause(D).
subSelect(A) ::= selectClause(B) whereclause(C) solutionModifier(D).
subSelect(A) ::= selectClause(B) whereclause(C).


selectClause(A) ::= SELECT DISTINCT selectClauseX(B). { A = B; A->query = 'SELECT DISTINCT' . B->query}
selectClause(A) ::= SELECT REDUCED selectClauseX(B). { A = B; A->query = 'SELECT REDUCED' . B->query}
selectClause(A) ::= SELECT STAR selectClauseX(B). { A = B; A->query = 'SELECT *' . B->query}
selectClause(A) ::= SELECT DISTINCT STAR. 'SELECT DISTINCT *'; }
selectClause(A) ::= SELECT REDUCED STAR. 'SELECT REDUCED *'; }
selectClause(A) ::= SELECT selectClauseX(B). { A = B; A->query = 'SELECT ' . B->query}
selectClause(A) ::= SELECT STAR. { A = B; A->query = 'SELECT *'; }
selectClauseX(A) ::= selectClauseX(B) LPARENTHESE expression(C) AS var(D) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . '( ' . C->query . ' AS ' . C->query . ' )'; }
selectClauseX(A) ::= selectClauseX(B) LPARENTHESE expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . '( ' . C->query . ' )'; }
selectClauseX(A) ::= selectClauseX(B) builtInCall(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
selectClauseX(A) ::= selectClauseX(B) rdfLiteral(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
selectClauseX(A) ::= selectClauseX(B) numericLiteral(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
selectClauseX(A) ::= selectClauseX(B) booleanLiteral(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
selectClauseX(A) ::= selectClauseX(B) var(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
selectClauseX(A) ::= selectClauseX(B) functionCall(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
selectClauseX(A) ::= LPARENTHESE expression(B) AS var(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = '( ' . B->query . ' AS ' . C->query . ' )'; }
selectClauseX(A) ::= LPARENTHESE expression(B) RPARENTHESE. { A = B; A->query = '( ' . B->query . ' )'; }
selectClauseX(A) ::= builtInCall(B). { A = B; }
selectClauseX(A) ::= rdfLiteral(B). { A = B; }
selectClauseX(A) ::= numericLiteral(B). { A = B; }
selectClauseX(A) ::= booleanLiteral(B). { A = B; }
selectClauseX(A) ::= var(B). { A = B; }
selectClauseX(A) ::= functionCall(B). { A = B; }

constructQuery(A) ::= CONSTRUCT LBRACE triplesTemplate(B) RBRACE datasetClauseX(C) whereclause(D) solutionModifier(E). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars + C->ssVars + D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'CONSTRUCT' . PHP_EOL . '{' . PHP_EOL . B->query . PHP_EOL . '}' . PHP_EOL. C->query . PHP_EOL . D->query . PHP_EOL . E->query; }
constructQuery(A) ::= CONSTRUCT LBRACE RBRACE datasetClauseX(B) whereclause(C) solutionModifier(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars + C->ssVars + D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'CONSTRUCT { }' . PHP_EOL . B->query . PHP_EOL. C->query . PHP_EOL . D->query; }
constructQuery(A) ::= CONSTRUCT datasetClauseX(B) WHERE LBRACE triplesTemplate(C) RBRACE solutionModifier(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars + C->ssVars + D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'CONSTRUCT' . PHP_EOL . B->query . PHP_EOL . 'WHERE' . PHP_EOL . '{' . PHP_EOL . C->query . PHP_EOL . '}' . PHP_EOL. D->query; }
constructQuery(A) ::= CONSTRUCT datasetClauseX(B) WHERE LBRACE RBRACE solutionModifier(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'CONSTRUCT' . PHP_EOL . B->query . PHP_EOL ' WHERE' . PHP_EOL . '{' . PHP_EOL . B->query . PHP_EOL . '}' . PHP_EOL . C->query; }
constructQuery(A) ::= CONSTRUCT LBRACE triplesTemplate(B) RBRACE whereclause(C) solutionModifier(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars + C->ssVars + D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'CONSTRUCT {' . PHP_EOL . B->query . PHP_EOL . '}' . PHP_EOL. C->query . PHP_EOL . D->query; }
constructQuery(A) ::= CONSTRUCT LBRACE RBRACE whereclause(B) solutionModifier(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'CONSTRUCT { }' . PHP_EOL . B->query . PHP_EOL . C->query; }
constructQuery(A) ::= CONSTRUCT LBRACE triplesTemplate(B) RBRACE whereclause(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'CONSTRUCT {' . PHP_EOL . B->query . PHP_EOL . '}' . PHP_EOL . C->query; }
constructQuery(A) ::= CONSTRUCT LBRACE RBRACE whereclause(B). { A = B; A->query = 'CONSTRUCT { }' . PHP_EOL B->query; }
constructQuery(A) ::= CONSTRUCT LBRACE triplesTemplate(B) RBRACE datasetClauseX(C) whereclause(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars + C->ssVars + D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'CONSTRUCT {' . PHP_EOL . B->query . PHP_EOL . '}' . PHP_EOL. C->query . PHP_EOL . D->query; }
constructQuery(A) ::= CONSTRUCT LBRACE RBRACE datasetClauseX(B) whereclause(C).{ A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'CONSTRUCT { }' . PHP_EOL . B->query . PHP_EOL . C->query; }
constructQuery(A) ::= CONSTRUCT datasetClauseX(B)  WHERE LBRACE triplesTemplate(C) RBRACE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'CONSTRUCT' . PHP_EOL . B->query . PHP_EOL . 'WHERE {' . PHP_EOL . C->query . PHP_EOL . '}'; }
constructQuery(A) ::= CONSTRUCT datasetClauseX(B)  WHERE LBRACE  RBRACE. { A = B; A->query = 'CONSTRUCT' . PHP_EOL . B->query . 'WHERE { }'; }
constructQuery(A) ::= CONSTRUCT WHERE LBRACE triplesTemplate(B) RBRACE solutionModifier(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'CONSTRUCT WHERE {' . PHP_EOL . B->query . PHP_EOL . '}' . PHP_EOL . C->query; }
constructQuery(A) ::= CONSTRUCT WHERE LBRACE RBRACE solutionModifier(B). { A = B; A->query = 'CONSTRUCT WHERE { }' . PHP_EOL . B->query; }
constructQuery(A) ::= CONSTRUCT WHERE LBRACE triplesTemplate(B) RBRACE. { A = B; A->query = 'CONSTRUCT WHERE {' . PHP_EOL B->query . PHP_EOL . '}'; }
constructQuery(A) ::= CONSTRUCT WHERE LBRACE RBRACE. { A = new NTToken(); A->query = 'CONSTRUCT WHERE { }'; }

describeQuery(A) ::= DESCRIBE varOrIriX(B) datasetClauseX(C) whereclause(D) solutionModifier(E). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->copyBools(E); A->ssVars = B->ssVars + C->ssVars + D->ssVars + E->ssVars; A->vars = B->vars + C->vars + D->vars + E->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes + E->bNodes; A->query = 'DESCRIBE ' . B->query . PHP_EOL . C->query . PHP_EOL . D->query . PHP_EOL . E->query; }
describeQuery(A) ::= DESCRIBE varOrIriX(B) whereclause(C) solutionModifier(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars + C->ssVars + D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'DESCRIBE ' . B->query . PHP_EOL . C->query . PHP_EOL . D->query; }
describeQuery(A) ::= DESCRIBE varOrIriX(B) datasetClauseX(C) solutionModifier(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars + C->ssVars + D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'DESCRIBE ' . B->query . PHP_EOL . C->query . PHP_EOL . D->query; }
describeQuery(A) ::= DESCRIBE varOrIriX(B) datasetClauseX(C) whereclause(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars + C->ssVars + D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'DESCRIBE ' . B->query . PHP_EOL . C->query . PHP_EOL . D->query; }
describeQuery(A) ::= DESCRIBE varOrIriX(B) solutionModifier(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'DESCRIBE ' . B->query . PHP_EOL . C->query; }
describeQuery(A) ::= DESCRIBE varOrIriX(B) whereclause(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'DESCRIBE ' . B->query . PHP_EOL . C->query; }
describeQuery(A) ::= DESCRIBE varOrIriX(B) datasetClauseX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'DESCRIBE ' . B->query . PHP_EOL . C->query; }
describeQuery(A) ::= DESCRIBE varOrIriX(B). { A = B; A->query = 'DESCRIBE ' . B->query;}
describeQuery(A) ::= DESCRIBE STAR datasetClauseX(B) whereclause(C) solutionModifier(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars + C->ssVars + D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'DESCRIBE *' . PHP_EOL . B->query . PHP_EOL . C->query . PHP_EOL . D->query; }
describeQuery(A) ::= DESCRIBE STAR whereclause(B) solutionModifier(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'DESCRIBE *' . PHP_EOL . B->query . PHP_EOL . C->query; }
describeQuery(A) ::= DESCRIBE STAR datasetClauseX(B) solutionModifier(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'DESCRIBE *' . PHP_EOL . B->query . PHP_EOL . C->query; }
describeQuery(A) ::= DESCRIBE STAR datasetClauseX(B) whereclause(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'DESCRIBE *' . PHP_EOL . B->query . PHP_EOL . C->query; }
describeQuery(A) ::= DESCRIBE STAR solutionModifier(B). { A = B; A->query = 'DESCRIBE *' . PHP_EOL . B->query; }
describeQuery(A) ::= DESCRIBE STAR whereclause(B). { A = B; A->query = 'DESCRIBE *' . PHP_EOL . B->query; }
describeQuery(A) ::= DESCRIBE STAR datasetClauseX(B). { A = B; A->query = 'DESCRIBE *' . PHP_EOL . B->query; }
describeQuery(A) ::= DESCRIBE STAR. { A = new NTToken(); A->query = 'DESCRIBE *'; }
varOrIriX(A) ::= varOrIriX(B) varOrIri(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
varOrIriX(A) ::= varOrIri(B). { A = B; }

askQuery(A) ::= ASK datasetClauseX(B) whereclause(C) solutionModifier(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars + C->ssVars + D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'ASK' . B->query . PHP_EOL . C->query . PHP_EOL . D->query; }
askQuery(A) ::= ASK datasetClauseX(B) whereclause(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'ASK' . B->query . PHP_EOL . C->query; }
askQuery(A) ::= ASK whereclause(B) solutionModifier(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'ASK' . B->query . PHP_EOL . C->query; }
askQuery(A) ::= ASK whereclause(B). { A = B; A->query = 'ASK ' . B->query;}

datasetClause(A) ::= FROM NAMED iri(B). { A = B; A->query = 'FROM NAMED ' . B->query;}
datasetClause(A) ::= FROM iri(B). { A = B; A->query = 'FROM ' . B->query;}

whereclause(A) ::= WHERE groupGraphPattern(B). { A = B; A->query = 'WHERE ' . B->query;}
whereclause(A) ::= groupGraphPattern(B). { A = B; }

solutionModifier(A) ::= groupClause(B) havingClause(C) orderClause(D) limitOffsetClauses(E). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->copyBools(E); A->ssVars = B->ssVars; A->vars = B->vars + C->vars + D->vars + E->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes + E->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query . PHP_EOL . E->query; }
solutionModifier(A) ::= havingClause(B) orderClause(C) limitOffsetClauses(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; }
solutionModifier(A) ::= groupClause(B) orderClause(C) limitOffsetClauses(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; }
solutionModifier(A) ::= groupClause(B) havingClause(C) limitOffsetClauses(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; }
solutionModifier(A) ::= groupClause(B) havingClause(C) orderClause(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; }
solutionModifier(A) ::= groupClause(B) havingClause(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
solutionModifier(A) ::= groupClause(B) orderClause(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
solutionModifier(A) ::= groupClause(B) limitOffsetClauses(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
solutionModifier(A) ::= orderClause(B) limitOffsetClauses(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
solutionModifier(A) ::= havingClause(B) limitOffsetClauses(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
solutionModifier(A) ::= havingClause(B) orderClause(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
solutionModifier(A) ::= groupClause(B). { A = B; }
solutionModifier(A) ::= havingClause(B). { A = B; }
solutionModifier(A) ::= orderClause(B). { A = B; }
solutionModifier(A) ::= limitOffsetClauses(B). { A = B; }

groupClause(A) ::= GROUP BY groupConditionX(B). { A = B; A->query = 'GROUP BY ' . B->query;}
groupConditionX(A) ::= groupConditionX(B) LPARENTHESE expression(C) AS var(D) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars + D->query; A->vars = B->vars + C->vars D->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' (' . C->query . ' AS ' . D->query . ' )';}
groupConditionX(A) ::= groupConditionX(B) builtInCall(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query;}
groupConditionX(A) ::= groupConditionX(B) functionCall(C). { A = new NTToken(); A->hasFNC = true; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query;}
groupConditionX(A) ::= groupConditionX(B) LPARENTHESE expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' (' . C->query . ' )';}
groupConditionX(A) ::= groupConditionX(B) var(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query;}
groupConditionX(A) ::= LPARENTHESE expression(B) AS var(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = C->query; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = '( ' . B->query . ' AS ' . C->query ' )';}
groupConditionX(A) ::= builtInCall(B). { A = B; }
groupConditionX(A) ::= functionCall(B). { A = B; A->hasFNC = true; }
groupConditionX(A) ::= LPARENTHESE expression(B) RPARENTHESE. { A = B; A->query = '( ' . B->query . ' )';}
groupConditionX(A) ::= var(B). { A = B; }

havingClause(A) ::= HAVING constraintX(B). { A = B; A->query = 'HAVING ' . B->query;}
constraintX(A) ::= constraintX(B) LPARENTHESE expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' (' . C->query . ' )'; }
constraintX(A) ::= constraintX(B) builtInCall(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
constraintX(A) ::= constraintX(B) functionCall(C). { A = new NTToken(); A->hasFNC = true; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
constraintX(A) ::= LPARENTHESE expression(B) RPARENTHESE. { A = B; A->query = '( ' . B->query . ' )';}
constraintX(A) ::= builtInCall(B). { A = B; }
constraintX(A) ::= functionCall(B). { A = B; A->hasFNC = true;}

orderClause(A) ::= ORDER BY orderConditionX(B). { A = B; A->query = 'ORDER BY ' . B->query;}
orderConditionX(A) ::= orderConditionX(B) orderCondition(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
orderConditionX(A) ::= orderCondition(B). { A = B; }

orderCondition(A) ::= ASC LPARENTHESE expression(B) RPARENTHESE. { A = B; A->query = 'ASC( ' . B->query . ' )';}
orderCondition(A) ::= DESC LPARENTHESE expression(B) RPARENTHESE. { A = B; A->query = 'DESC( ' . B->query . ' )';}
orderCondition(A) ::= LPARENTHESE expression(B) RPARENTHESE. { A = B; A->query = '( ' . B->query . ' )';}
orderCondition(A) ::= builtInCall(B). { A = B; }
orderCondition(A) ::= functionCall(B). { A = B; }
orderCondition(A) ::= var(B). { A = B; }

limitOffsetClauses(A) ::= limitClause(B) offsetClause(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->query = B->query . PHP_EOL . C->query; }
limitOffsetClauses(A) ::= offsetClause(B) limitClause(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->query = B->query . PHP_EOL . C->query; }
limitOffsetClauses(A) ::= limitClause(B). { A = B; }
limitOffsetClauses(A) ::= offsetClause(B). { A = B; }

limitClause(A) ::= LIMIT INTEGER(B). { A = B; A->query = 'LIMIT ' . B->value; }

offsetClause(A) ::= OFFSET INTEGER(B). { A = B; A->query = 'OFFSET ' . B->value; }

valuesClause(A) ::= VALUES dataBlock(B). { A = B; A->query = 'VALUES ' . B->query;}

update(A) ::= prologue(B) update1(C) SEMICOLON update(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . PHP_EOL . C->query . ' ;' . PHP_EOL . D->query; }
update(A) ::= update1(B) SEMICOLON update(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ;' . PHP_EOL . C->query; }
update(A) ::= prologue(B) update1(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
update(A) ::= update1(B). { A = B; }

update1(A) ::= load(B). { A = B; }
update1(A) ::= clear(B). { A = B; }
update1(A) ::= drop(B). { A = B; }
update1(A) ::= add(B). { A = B; }
update1(A) ::= move(B). { A = B; }
update1(A) ::= copy(B). { A = B; }
update1(A) ::= create(B). { A = B; }
update1(A) ::= insertData(B). { A = B; }
update1(A) ::= deleteData(B). { A = B; }
update1(A) ::= deletewhere(B). { A = B; }
update1(A) ::= modify(B). { A = B; }

load(A) ::= LOAD SILENT iri(B) INTO graphRef(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'LOAD SILENT ' B->query . ' INTO ' . C->query; }
load(A) ::= LOAD iri(B) INTO graphRef(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'LOAD ' B->query . ' INTO ' . C->query; }
load(A) ::= LOAD SILENT iri(B). { A = B; A->query = 'LOAD SILENT ' . B->query; }
load(A) ::= LOAD iri(B). { A = B; A->query = 'LOAD ' . B->query; }

clear(A) ::= CLEAR SILENT graphRefAll(B). { A = B; A->query = 'CLEAR SILENT ' . B->query; }
clear(A) ::= CLEAR graphRefAll(B). { A = B; A->query = 'CLEAR ' . B->query; }

drop(A) ::= DROP SILENT graphRefAll(B). { A = B; A->query = 'DROP SILENT ' . B->query; }
drop(A) ::= DROP graphRefAll(B). { A = B; A->query = 'DROP ' . B->query; }

create(A) ::= CREATE SILENT graphRef(B). { A = B; A->query = 'CREATE SILENT ' . B->query; }
create(A) ::= CREATE graphRef(B). { A = B; A->query = 'CREATE ' . B->query; }

add(A) ::= ADD SILENT graphOrDefault(B) TO graphOrDefault(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'ADD ' . B->query . ' TO ' . C->query; }
add(A) ::= ADD graphOrDefault(B) TO graphOrDefault(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'ADD ' . B->query . ' TO ' . C->query; }

move(A) ::= MOVE SILENT graphOrDefault(C) TO graphOrDefault(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'MOVE SILENT ' . B->query . ' TO ' . C->query; }
move(A) ::= MOVE graphOrDefault(B) TO graphOrDefault(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'MOVE ' . B->query . ' TO ' . C->query; }

copy(A) ::= COPY SILENT graphOrDefault(B) TO graphOrDefault(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'COPY SILENT ' . B->query . ' TO ' . C->query; }
copy(A) ::= COPY graphOrDefault(B) TO graphOrDefault(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'COPY ' . B->query . ' TO ' . C->query; }

insertData(A) ::= INSERTDATA quadData(B). { A = B; A->query = 'DELETE DATA ' . B->query; }

deleteData(A) ::= DELETEDATA quadData(B). { if(B->hasBN){$this->main->error = "A Deleteclause is not allowed to contain Blanknodesyntax: DELETE DATA" . B->query; yy_parse_failed();} A = B; A->query = 'DELETE DATA ' . B->query; }

deletewhere(A) ::= DELETEWHERE quadPattern(B). { if(B->hasBN){$this->main->error = "A Deleteclause is not allowed to contain Blanknodesyntax: DELETE WHERE" . B->query; yy_parse_failed();} A = B; A->query = 'DELETE WHERE ' . B->query; }

modify(A) ::= WITH iri(B) deleteClause(C) insertClause(D) usingClauseX(E) WHERE groupGraphPattern(F). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->copyBools(E); A->copyBools(F); A->ssVars = F->ssVars; A->vars = B->vars + C->vars + D->vars + E->vars + F->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes + E->bNodes + F->bNodes; A->query = 'WITH ' . B->query . PHP_EOL . C->query . PHP_EOL . D->query . PHP_EOL . E->query . PHP_EOL . 'WHERE' . PHP_EOL . F->query; }
modify(A) ::= WITH iri(B) deleteClause(C) usingClauseX(D) WHERE groupGraphPattern(E).{ A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->copyBools(E); A->ssVars = E->ssVars; A->vars = B->vars + C->vars + D->vars + E->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes + E->bNodes; A->query = 'WITH ' . B->query . PHP_EOL . C->query . PHP_EOL . D->query . PHP_EOL . 'WHERE' . PHP_EOL . E->query; }
modify(A) ::= WITH iri(B) insertClause(C) usingClauseX(D) WHERE groupGraphPattern(E).{ A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->copyBools(E); A->ssVars = E->ssVars; A->vars = B->vars + C->vars + D->vars + E->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes + E->bNodes; A->query = 'WITH ' . B->query . PHP_EOL . C->query . PHP_EOL . D->query . PHP_EOL . 'WHERE' . PHP_EOL . E->query; }
modify(A) ::= WITH iri(B) deleteClause(C) insertClause(D) WHERE groupGraphPattern(E).{ A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->copyBools(E); A->ssVars = E->ssVars; A->vars = B->vars + C->vars + D->vars + E->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes + E->bNodes; A->query = 'WITH ' . B->query . PHP_EOL . C->query . PHP_EOL . D->query . PHP_EOL . 'WHERE' . PHP_EOL . E->query; }
modify(A) ::= WITH iri(B) deleteClause(C) WHERE groupGraphPattern(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'WITH ' . B->query . PHP_EOL . C->query . PHP_EOL . 'WHERE' . PHP_EOL . D->query; }
modify(A) ::= WITH iri(B) insertClause(C) WHERE groupGraphPattern(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'WITH ' . B->query . PHP_EOL . C->query . PHP_EOL . 'WHERE' . PHP_EOL . D->query; }
modify(A) ::= deleteClause(B) insertClause(C) usingClauseX(D) WHERE groupGraphPattern(E). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->copyBools(E); A->ssVars = E->ssVars; A->vars = B->vars + C->vars + D->vars + E->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes + E->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query . PHP_EOL . 'WHERE' . PHP_EOL . E->query; }
modify(A) ::= deleteClause(B) usingClauseX(C) WHERE groupGraphPattern(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . 'WHERE' . PHP_EOL . D->query; }
modify(A) ::= insertClause(B) usingClauseX(C) WHERE groupGraphPattern(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . 'WHERE' . PHP_EOL . D->query; }
modify(A) ::= deleteClause(B) insertClause(C) WHERE groupGraphPattern(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = D->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . 'WHERE' . PHP_EOL . D->query; }
modify(A) ::= deleteClause(B) WHERE groupGraphPattern(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = D->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . 'WHERE' . PHP_EOL . C->query; }
modify(A) ::= insertClause(B) WHERE groupGraphPattern(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = D->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . 'WHERE' . PHP_EOL . C->query; }
usingClauseX(A) ::= usingClauseX(B) usingClause(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->query = B->query . PHP_EOL . C->query; }
usingClauseX(A) ::= usingClause(B). {A = B;}

deleteClause(A) ::= DELETE quadPattern(B). { if(B->hasBN){$this->main->error = "A Deleteclause is not allowed to contain Blanknodesyntax: DELETE" . B->query; yy_parse_failed();} A = B; A->query = 'DELETE ' . B->query; }

insertClause(A) ::= INSERT quadPattern(B). { A = B; A->query = 'INSERT ' . B->query; }

usingClause(A) ::= USING NAMED iri(B). { A = B; A->query = 'USING NAMED ' . B->query; }
usingClause(A) ::= USING iri(B). { A = B; A->query = 'USING ' . B->query; }

graphOrDefault(A) ::= GRAPH iri(B). { A = B; A->query = 'GRAPH ' . B->query; }
graphOrDefault(A) ::= DEFAULT. { A = new NTToken(); A->query = 'DEFAULT';}
graphOrDefault(A) ::= iri(B). {A = B;}

graphRef(A) ::= GRAPH iri(B). { A = B; A->query = 'GRAPH ' . B->query; }

graphRefAll(A) ::= graphRef(B). { A = B; }
graphRefAll(A) ::= DEFAULT. { A = new NTToken(); A->query = 'DEFAULT';}
graphRefAll(A) ::= NAMED. { A = new NTToken(); A->query = 'NAMED';}
graphRefAll(A) ::= ALL. { A = new NTToken(); A->query = 'ALL';}

quadPattern(A) ::= LBRACE quads(B) RBRACE. { A = B; A->query = '{ ' . PHP_EOL . B->query . PHP_EOL . ' }'; }
quadPattern(A) ::= LBRACE RBRACE. {A = new NTToken(); A->query = '{ }'}

quadData(A) ::= LBRACE quads(B) RBRACE. { if(!empty(B->vars)){$this->main->error = "QuadPattern arent allowed to contain variables: " . B->query; yy_parse_failed();} A = B; A->query = '{ ' . PHP_EOL . B->query . PHP_EOL . ' }'; }
quadData(A) ::= LBRACE RBRACE. {A = new NTToken(); A->query = '{ }'}

quads(A) ::= triplesTemplate(B) quadsX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query; }
quads(A) ::= triplesTemplate(B). { A = B; }
quads(A) ::= quadsX(B). { A = B; }
quadsX(A) ::= quadsX(B) quadsNotTriples(C) DOT triplesTemplate(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query . ' .' . PHP_EOL . D->query; }
quadsX(A) ::= quadsX(B) quadsNotTriples(C) triplesTemplate(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query . PHP_EOL . D->query; }
quadsX(A) ::= quadsX(B) quadsNotTriples(C) DOT. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query; }
quadsX(A) ::= quadsX(B) quadsNotTriples(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
quadsX(A) ::= quadsNotTriples(B) DOT triplesTemplate(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query; }
quadsX(A) ::= quadsNotTriples(B) triplesTemplate(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
quadsX(A) ::= quadsNotTriples(B) DOT. { A = B; A->query = B->query . ' .'}
quadsX(A) ::= quadsNotTriples(B). { A = B; }

quadsNotTriples(A) ::= GRAPH varOrIri(B) LBRACE triplesTemplate(C) RBRACE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'GRAPH ' . B->query . PHP_EOL . ' { ' .  PHP_EOL . C->query . PHP_EOL . ' }'; }
quadsNotTriples(A) ::= GRAPH varOrIri(B) LBRACE RBRACE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->query = 'GRAPH ' . B->query . ' { }'; }

triplesTemplate(A) ::= triplesSameSubject(B) DOT triplesTemplateX(C) DOT. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query ' .'; }
triplesTemplate(A) ::= triplesSameSubject(B) DOT triplesTemplateX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query; }
triplesTemplate(A) ::= triplesSameSubject(B) DOT. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query . ' .'; }
triplesTemplate(A) ::= triplesSameSubject(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
triplesTemplateX(A) ::= triplesTemplateX(B) DOT triplesSameSubject(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query; }
triplesTemplateX(A) ::= triplesSameSubject(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

groupGraphPattern(A) ::= LBRACE groupGraphPatternSub(B) RBRACE. { A = B; A->query = '{ ' . PHP_EOL . B->query . PHP_EOL . ' }'; }
groupGraphPattern(A) ::= LBRACE subSelect(B) RBRACE. { A = B; A->query = '{ ' . PHP_EOL . B->query . PHP_EOL . ' }'; }
groupGraphPattern(A) ::= LBRACE RBRACE. {A = new NTToken(); A->query = '{ }'}

groupGraphPatternSub(A) ::= triplesBlock(B) groupGraphPatternSubX(C). { if(!empty(C->bindVar)){ $tmp = B->noDuplicates(C->bindVar, B->vars); if(isset($tmp)){$this->main->error = "Bindvariable is already in scope: " . $tmp; unset($tmp); yy_parse_failed();}} A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = C->ssVars; A->bindVar = C->bindVar; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
groupGraphPatternSub(A) ::= triplesBlock(B). {A = B}
groupGraphPatternSub(A) ::= groupGraphPatternSubX(B). {A = B;}
groupGraphPatternSubX(A) ::= groupGraphPatternSubX(B) graphPatternNotTriples(C) DOT triplesBlock(D). { $tmp = B->noDuplicates(C->ssVars, B->ssVars); if(isset($tmp)){$this->main->error = "Variable is already in scope: " . $tmp; unset($tmp); yy_parse_failed();} else if(!empty(C->bindVar)){ $tmp = B->noDuplicates(C->bindVar, B->vars); if(isset($tmp)){$this->main->error = "Bindvariable is already in scope: " . $tmp; unset($tmp); yy_parse_failed();}} A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->bindVar = B->bindVar + C->bindVar; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query . ' .' . PHP_EOL . D->query; }
groupGraphPatternSubX(A) ::= groupGraphPatternSubX(B) graphPatternNotTriples(C) triplesBlock(D). { $tmp = B->noDuplicates(C->ssVars, B->ssVars); if(isset($tmp)){$this->main->error = "Variable is already in scope: " . $tmp; unset($tmp); yy_parse_failed();} else if(!empty(C->bindVar)){ $tmp = B->noDuplicates(C->bindVar, B->vars); if(isset($tmp)){$this->main->error = "Bindvariable is already in scope: " . $tmp; unset($tmp); yy_parse_failed();}} A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->bindVar = B->bindVar + C->bindVar; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; }
groupGraphPatternSubX(A) ::= groupGraphPatternSubX(B) graphPatternNotTriples(C) DOT. { $tmp = B->noDuplicates(C->ssVars, B->ssVars); if(isset($tmp)){$this->main->error = "Variable is already in scope: " . $tmp; unset($tmp); yy_parse_failed();} else if(!empty(C->bindVar)){ $tmp = B->noDuplicates(C->bindVar, B->vars); if(isset($tmp)){$this->main->error = "Bindvariable is already in scope: " . $tmp; unset($tmp); yy_parse_failed();}} A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->bindVar = B->bindVar + C->bindVar; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query . ' .'; }
groupGraphPatternSubX(A) ::= groupGraphPatternSubX(B) graphPatternNotTriples(C). { $tmp = B->noDuplicates(C->ssVars, B->ssVars); if(isset($tmp)){$this->main->error = "Variable is already in scope: " . $tmp; unset($tmp); yy_parse_failed();} else if(!empty(C->bindVar)){ $tmp = B->noDuplicates(C->bindVar, B->vars); if(isset($tmp)){$this->main->error = "Bindvariable is already in scope: " . $tmp; unset($tmp); yy_parse_failed();}} A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->bindVar = B->bindVar + C->bindVar; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
groupGraphPatternSubX(A) ::= graphPatternNotTriples(B) DOT triplesBlock(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query; }
groupGraphPatternSubX(A) ::= graphPatternNotTriples(B) triplesBlock(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
groupGraphPatternSubX(A) ::= graphPatternNotTriples(B) DOT. { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query . ' .'; }
groupGraphPatternSubX(A) ::= graphPatternNotTriples(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

triplesBlock(A) ::= triplesSameSubjectPath(B) DOT triplesBlockX(C) DOT. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query ' .'; }
triplesBlock(A) ::= triplesSameSubjectPath(B) DOT triplesBlockX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query; }
triplesBlock(A) ::= triplesSameSubjectPath(B) DOT. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query . ' .'; }
triplesBlock(A) ::= triplesSameSubjectPath(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
triplesBlockX(A) ::= triplesBlockX(B) DOT triplesSameSubjectPath(C) { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query; }
triplesBlockX(A) ::= triplesSameSubjectPath(B) { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

graphPatternNotTriples(A) ::= groupOrUnionGraphPattern(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
graphPatternNotTriples(A) ::= optionalGraphPattern(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
graphPatternNotTriples(A) ::= minusGraphPattern(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
graphPatternNotTriples(A) ::= graphGraphPattern(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
graphPatternNotTriples(A) ::= serviceGraphPattern(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
graphPatternNotTriples(A) ::= filter(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
graphPatternNotTriples(A) ::= bind(B). { A = new NTToken(); A->ssVars = B->ssVars; A->bindVar = B->bindVar; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
graphPatternNotTriples(A) ::= inlineData(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

optionalGraphPattern(A) ::= OPTIONAL groupGraphPattern(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'OPTIONAL ' . B->query; }

graphGraphPattern(A) ::= GRAPH varOrIri(B) groupGraphPattern(C). { A = new NTToken(); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = C->bNodes; A->query = 'GRAPH ' . B->query . ' ' . C->query; }

serviceGraphPattern(A) ::= SERVICE SILENT varOrIri(B) groupGraphPattern(C). { A = new NTToken(); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = C->bNodes; A->query = 'SERVICE SILENT ' . B->query . ' ' . C->query; }
serviceGraphPattern(A) ::= SERVICE varOrIri(B) groupGraphPattern(C). { A = new NTToken(); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = C->bNodes; A->query = 'SERVICE ' . B->query . ' ' . C->query; }

bind(A) ::= BIND LPARENTHESE expression(B) AS var(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->ssVars[C->query] = 1; A->bindVar[C->query] = 1; A->vars = B->vars + C->vars; A->bNodes = B->bNodes; A->query = B->query . ' AS ' . C->query; }

inlineData(A) ::= VALUES dataBlock(B). { A = new NTToken(); A->vars = B->vars; A->query = B->query; }

dataBlock(A) ::= inlineDataOneVar(B). { A = new NTToken(); A->vars = B->vars; A->query = B->query; }
dataBlock(A) ::= inlineDataFull(B). { A = new NTToken(); A->vars = B->vars; A->query = B->query; }

inlineDataOneVar(A) ::= var(B) LBRACE dataBlockValueX(C) RBRACE. { A = new NTToken(); A->vars = B->vars; A->query = B->query . ' { ' . C->query .  ' }'; }
inlineDataOneVar(A) ::= var(B) LBRACE RBRACE. { A = new NTToken(); A->vars = B->vars; A->query = B->query . '{ }'; }
dataBlockValueX(A) ::= dataBlockValueX(B) dataBlockValue(C). { A = new NTToken(); A->count = B->count + 1; A->query = B->query . ' ' . C->query; }
dataBlockValueX(A) ::= dataBlockValue(B). { A = new NTToken(); A->count = 1; A->query = B->query; }

inlineDataFull(A) ::= LPARENTHESE varX(B) RPARENTHESE LBRACE inlineDataFullX(C) RBRACE. {if(C->count > 0 ){if(B->count == C->count){ A = new NTToken(); A->vars = B->vars; A->query = '( ' . B->query . ' ) {' . PHP_EOL . C->query . ' }';}else{$main->error = "Different Amount of Variables and Values for Value Clause : " . B->query . ' and ' . C->query; yy_parse_failed();}}else{A = new NTToken(); A->addVars(B->vars); A->query = '( ' . B->query . ' ) {' . PHP_EOL . C->query . ' }';}}
inlineDataFull(A) ::= NIL LBRACE nilX(B) RBRACE. { A = new NTToken(); A->query = '( ) { ' . B->query . ' }'; }
inlineDataFull(A) ::= NIL LBRACE RBRACE. { A = new NTToken(); A->query = '( ) { }'; }
nilX(A) ::= nilX(B) NIL.{ A = new NTToken(); A->query = B->query . ' ( )'; }
nilX(A) ::= NIL. { A = new NTToken(); A->query = '( )'; }
varX(A) ::= varX(B) var(C). { A = new NTToken(); A->count = B->count + 1; A->vars = B->vars + C->vars; A->query = B->query . ' ' . C->query; }
varX(A) ::= var(B). { A = new NTToken(); A->addVars(B->vars); A->count = 1; A->query = B->query; }
inlineDataFullX(A) ::= inlineDataFullX(B) LPARENTHESE dataBlockValueX(C) RPARENTHESE. {if(B->count > 0 ){if(B->count == C->count){ A = new NTToken(); A->count = B->count; A->query = B->query . PHP_EOL . '( ' . C->query . ' )';}else{$main->error = "Different Amount of Values for Value Clause : " . B->query . ' and ' . C->query; yy_parse_failed();}}else{A = new NTToken(); A->count = C->count; A->query = B->query . PHP_EOL . '( ' . C->query . ' )';}}
inlineDataFullX(A) ::= inlineDataFullX(B) NIL. { A = new NTToken(); A->query = B->query . PHP_EOL . '( )'; }
inlineDataFullX(A) ::= LPARENTHESE dataBlockValueX(B) RPARENTHESE.  { A = new NTToken(); A->count = B->count; A->query = '( ' . B->query . ' )'; }
inlineDataFullX(A) ::= NIL. { A = new NTToken(); A->query = '( )'; }

dataBlockValue(A) ::= iri(B). { A = new NTToken(); A->query = B->query; }
dataBlockValue(A) ::= rdfLiteral(B). { A = new NTToken(); A->query = B->query; }
dataBlockValue(A) ::= numericLiteral(B). { A = new NTToken(); A->query = B->query; }
dataBlockValue(A) ::= booleanLiteral(B). { A = new NTToken(); A->query = B->query; }
dataBlockValue(A) ::= UNDEF. { A = new NTToken(); A->query = 'UNDEF'; }

minusGraphPattern(A) ::= SMINUS groupGraphPattern(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'MINUS ' . PHP_EOL .  B->query; }

groupOrUnionGraphPattern(A) ::= groupGraphPattern(B) groupOrUnionGraphPatternX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; }
groupOrUnionGraphPattern(A) ::= groupGraphPattern(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
groupOrUnionGraphPatternX(A) ::= groupOrUnionGraphPatternX(B) UNION groupGraphPattern(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . ' UNION ' . PHP_EOL . C->query; }
groupOrUnionGraphPatternX(A) ::= UNION GroupGraphPattern(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'UNION ' . PHP_EOL . B->query; }

filter(A) ::= FILTER LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'FILTER ( ' . B->query . ' )'; }
filter(A) ::= FILTER builtInCall(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'FILTER ' . B->query; }
filter(A) ::= FILTER functionCall(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'FILTER ' . B->query; }

functionCall(A) ::= iri(B) argList(C). { A = new NTToken(); A->hasFNC = true, A->hasAGG = true; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = B->query . C->query; }

argList(A) ::= LPARENTHESE DISTINCT expression(B) argListX(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = '( DISTINCT' . B->query . PHP_EOL . C->query .  ' )'; }
argList(A) ::= LPARENTHESE expression(B) argListX(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = '( ' . B->query . PHP_EOL . C->query .  ' )'; }
argList(A) ::= NIL. { A = new NTToken(); A->query = '( )' . PHP_EOL; }
argListX(A) ::= argListX(B) COMMA expression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ', ' . PHP_EOL . C->query; }
argListX(A) ::= COMMA expression(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = ', ' . PHP_EOL . B->query; }

expressionList(A) ::= LPARENTHESE expression(B) argListX(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = '( ' . B->query . PHP_EOL . C->query .  ' )'; }
expressionList(A) ::= NIL. LBRACE RBRACE. { A = new NTToken(); A->query = '( )' . PHP_EOL; }

triplesSameSubject(A) ::= varOrTerm(B) propertyListNotEmpty(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
triplesSameSubject(A) ::= triplesNode(B) propertyListNotEmpty(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
triplesSameSubject(A) ::= triplesNode(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

propertyListNotEmpty(A) ::= verb(B) objectList(C) propertyListNotEmptyX(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + C->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . ' ' . C->query . ' ' D->query; }
propertyListNotEmpty(A) ::= verb(B) objectList(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
propertyListNotEmptyX(A) ::= propertyListNotEmptyX(B) SEMICOLON verb(C) objectList(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . '; ' . C->query . ' ' D->query; }
propertyListNotEmptyX(A) ::= propertyListNotEmptyX(B) SEMICOLON. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query. ';'; }
propertyListNotEmptyX(A) ::= SEMICOLON verb(B) objectList(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = '; ' . B->query . ' ' . C->query; }
propertyListNotEmptyX(A) ::= SEMICOLON. { A = new NTToken(); A->query = ';'; }

verb(A) ::= varOrIri(B). { A = new NTToken(); A->vars = B->vars; A->query = B->query; }
verb(A) ::= A. { if(!checkNS('rdf:type')){$main->error = "Missing Prefix for rdf:type (a)";yy_parse_failed();} A = new NTToken(); A->query = 'rdf:type'; }

objectList(A) ::= graphNode(B) objectListX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
objectList(A) ::= graphNode(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
objectListX(A) ::= objectListX(B) COMMA graphNode(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ', ' . C->query; }
objectListX(A) ::= COMMA graphNode(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = ', ' . B->query; }

triplesSameSubjectPath(A) ::= varOrTerm(B) propertyListPathNotEmpty(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
triplesSameSubjectPath(A) ::= triplesNodePath(B) propertyListPathNotEmpty(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
triplesSameSubjectPath(A) ::= triplesNodePath(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

propertyListPathNotEmpty(A) ::= pathAlternative(B) objectListPath(C) propertyListPathNotEmptyX(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . ' ' . C->query . ' ' D->query; }
propertyListPathNotEmpty(A) ::= var(B) objectListPath(C) propertyListPathNotEmptyX(D). { A = new NTToken(); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = C->bNodes + D->bNodes; A->query = B->query . ' ' . C->query . ' ' D->query; }
propertyListPathNotEmpty(A) ::= pathAlternative(B) objectListPath(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
propertyListPathNotEmpty(A) ::= var(B) objectListPath(C). { A = new NTToken(); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = C->bNodes; A->query = B->query . ' ' . C->query; }
propertyListPathNotEmptyX(A) ::= propertyListPathNotEmptyX(B) SEMICOLON pathAlternative(C) objectList(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . '; ' . C->query . ' ' D->query; }
propertyListPathNotEmptyX(A) ::= propertyListPathNotEmptyX(B) SEMICOLON var(C) objectList(D). { A = new NTToken(); A->copyBools(B); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . '; ' . C->query . ' ' D->query; }
propertyListPathNotEmptyX(A) ::= propertyListPathNotEmptyX(B) SEMICOLON. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query. ';'; }
propertyListPathNotEmptyX(A) ::= SEMICOLON pathAlternative(B) objectList(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = '; ' . B->query . ' ' . C->query; }
propertyListPathNotEmptyX(A) ::= SEMICOLON var(B) objectList(C). { A = new NTToken(); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = '; ' . ' ' . B->query . C->query; }
propertyListPathNotEmptyX(A) ::= SEMICOLON. { A = new NTToken(); A->query = ';'; }

objectListPath(A) ::= objectPath(B) objectListPathX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . C->query; }
objectListPath(A) ::= objectPath(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
objectListPathX(A) ::= objectListPathX(B) COMMA objectPath(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ', ' . C->query; }
objectListPathX(A) ::= COMMA objectPath(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = ', ' . B->query; }

pathAlternative(A) ::= pathSequence(B) pathAlternativeX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . C->query; }
pathAlternative(A) ::= pathSequence(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
pathAlternativeX(A) ::= pathAlternativeX(B) VBAR pathSequence(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . '|' . C->query; }
pathAlternativeX(A) ::= VBAR pathSequence(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = '|' . B->query; }

pathSequence(A) ::= pathEltOrInverse(B) pathSequenceX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . C->query; }
pathSequence(A) ::= pathEltOrInverse(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
pathSequenceX(A) ::= pathSequenceX(B) SLASH pathEltOrInverse(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . '/' . C->query; }
pathSequenceX(A) ::= SLASH pathEltOrInverse(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = '/' . B->query; }

pathElt(A) ::= pathPrimary(B) pathMod(C). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query . C->query; }
pathElt(A) ::= pathPrimary(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

pathEltOrInverse(A) ::= HAT pathElt(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = '^' . B->query; }
pathEltOrInverse(A) ::= pathElt(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

pathMod(A) ::= STAR. { A = new NTToken(); A->query = '*'; }
pathMod(A) ::= PLUS. { A = new NTToken(); A->query = '+'; }
pathMod(A) ::= QUESTION. { A = new NTToken(); A->query = '?'; }

pathPrimary(A) ::= LPARENTHESE pathAlternative(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = '( ' . B->query . ' )'; }
pathPrimary(A) ::= EXCLAMATION pathNegatedPropertySet(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = '!' . B->query; }
pathPrimary(A) ::= A. { if(!checkNS('rdf:type')){$main->error = "Missing Prefix for rdf:type (a)";yy_parse_failed();} A = new NTToken(); A->query = 'rdf:type'; }
pathPrimary(A) ::= iri(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

pathNegatedPropertySet(A) ::= LPARENTHESE pathOneInPropertySet(B) pathNegatedPropertySetX(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
pathNegatedPropertySet(A) ::= LPARENTHESE pathOneInPropertySet(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = '( ' . B->query . ' )'; }
pathNegatedPropertySet(A) ::= LPARENTHESE RPARENTHESE. { A = new NTToken(); A->query = '( )'; }
pathNegatedPropertySet(A) ::= pathOneInPropertySet(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
pathNegatedPropertySetX(A) ::= pathNegatedPropertySetX(B) VBAR pathOneInPropertySet(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' | ' . C->query; }
pathNegatedPropertySetX(A) ::= VBAR pathOneInPropertySet(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = '| ' . B->query; }

pathOneInPropertySet(A) ::= HAT iri(B). { A = new NTToken(); A->query = '^' . B->query; }
pathOneInPropertySet(A) ::= HAT A. { if(!checkNS('rdf:type')){$main->error = "Missing Prefix for rdf:type (a)";yy_parse_failed();} A = new NTToken(); ; A->query = '^rdf:type'; }
pathOneInPropertySet(A) ::= A. { if(!checkNS('rdf:type')){$main->error = "Missing Prefix for rdf:type (a)";yy_parse_failed();} A = new NTToken(); A->query = 'rdf:type'; }
pathOneInPropertySet(A) ::= iri(B). { A = new NTToken(); A->query = B->query; }

triplesNode(A) ::= collection(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
triplesNode(A) ::= blankNodePropertyList(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

blankNodePropertyList(A) ::= LBRACKET propertyListNotEmpty(B) RBRACKET. { A = new NTToken(); A->hasBN = true; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = '[ ' . B->query . ' ]'; }

triplesNodePath(A) ::= collectionPath(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
triplesNodePath(A) ::= blankNodePropertyListPath(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

blankNodePropertyListPath(A) ::= LBRACKET propertyListPathNotEmpty(B) RBRACKET. { A = new NTToken(); A->hasBN = true; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = '[ ' . B->query . ' ]'; }

collection(A) ::= LPARENTHESE graphNodeX(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = '( ' . B->query . ' )'; }
graphNodeX(A) ::= graphNodeX(B) graphNode(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
graphNodeX(A) ::= graphNode(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

collectionPath(A) ::= LPARENTHESE graphNodePathX(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = '( ' . B->query . ' )'; }
graphNodePathX(A) ::= graphNodePathX(B) graphNodePath(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
graphNodePathX(A) ::= graphNodePath(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

graphNode(A) ::= varOrTerm(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
graphNode(A) ::= triplesNode(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

graphNodePath(A) ::= varOrTerm(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
graphNodePath(A) ::= triplesNodePath(B).  { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

varOrTerm(A) ::= var(B). { A = new NTToken(); A->vars = B->vars; A->query = B->query; }
varOrTerm(A) ::= graphTerm(B). { A = new NTToken(); A->copyBools(B); A->bNodes = B->bNodes; A->query = B->query; }

varOrIri(A) ::= var(B). { A = new NTToken(); A->vars = B->vars; A->query = B->query; }
varOrIri(A) ::= iri(B). { A = new NTToken(); A->query = B->query; }

var(A) ::= VAR1(B). { A = new NTToken(); A->vars = array(); A->vars[B->value] = 1; A->query = B->value; }
var(A) ::= VAR2(B). { A = new NTToken(); A->vars = array(); A->vars[B->value] = 1; A->query = B->value; }

graphTerm(A) ::= iri(B). { A = new NTToken(); A->query = B->query; }
graphTerm(A) ::= rdfLiteral(B). { A = new NTToken(); A->query = B->query; }
graphTerm(A) ::= numericLiteral(B). { A = new NTToken(); A->query = B->query; }
graphTerm(A) ::= booleanLiteral(B). { A = new NTToken(); A->query = B->query; }
graphTerm(A) ::= blankNode(B). { A = new NTToken(); A->copyBools(B); A->bNodes = B->bNodes; A->query = B->query; }
graphTerm(A) ::= NIL. { A = new NTToken(); A->query = '( )'; }

expression(A) ::= conditionalAndExpression(B) conditionalOrExpressionX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
expression(A) ::= conditionalAndExpression(B). { A = new NTToken(); A->copyBools(B);A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
conditionalOrExpressionX(A) ::= conditionalOrExpressionX(B) OR conditionalAndExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' || ' . C->query; }
conditionalOrExpressionX(A) ::= OR conditionalAndExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '|| ' . B->query; }

conditionalAndExpression(A) ::= relationalExpression(B) conditionalAndExpressionX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
conditionalAndExpression(A) ::= relationalExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
conditionalAndExpressionX(A) ::= conditionalAndExpressionX(B) AND relationalExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' && ' . C->query; }
conditionalAndExpressionX(A) ::= AND relationalExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '&& ' . B->query; }

relationalExpression(A) ::= additiveExpression(B) relationalExpressionX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
relationalExpression(A) ::= additiveExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
relationalExpressionX(A) ::= EQUAL additiveExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '= ' . B->query; }
relationalExpressionX(A) ::= NEQUAL additiveExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '!= ' . B->query; }
relationalExpressionX(A) ::= SMALLERTHEN additiveExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '< ' . B->query; }
relationalExpressionX(A) ::= GREATERTHEN additiveExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '> ' . B->query; }
relationalExpressionX(A) ::= SMALLERTHENQ additiveExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '<= ' . B->query; }
relationalExpressionX(A) ::= GREATERTHENQ additiveExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '>= ' . B->query; }
relationalExpressionX(A) ::= IN expressionList(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'IN' . B->query; }
relationalExpressionX(A) ::= NOT IN expressionList(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'NOT IN' . B->query; }

additiveExpression(A) ::= multiplicativeExpression(B) additiveExpressionX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; }
additiveExpression(A) ::= multiplicativeExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralPositive(C) additiveExpressionY(D). { A = new NTToken(); A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' ' . C->query . ' ' D->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralNegative(C) additiveExpressionY(D). { A = new NTToken(); A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' ' . C->query . ' ' D->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralPositive(C). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query . ' ' . C->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralNegative(C). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query . ' ' . C->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) PLUS multiplicativeExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' + ' . C->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) MINUS multiplicativeExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' - ' . C->query; }
additiveExpressionX(A) ::= numericLiteralPositive(B) additiveExpressionY(C). { A = new NTToken(); A->copyBools(C); A->ssVars = B->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = B->query . ' ' C->query; }
additiveExpressionX(A) ::= numericLiteralNegative(B) additiveExpressionY(C). { A = new NTToken(); A->copyBools(C); A->ssVars = B->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = B->query . ' ' C->query; }
additiveExpressionX(A) ::= numericLiteralPositive(B). { A = new NTToken(); A->query = B->query; }
additiveExpressionX(A) ::= numericLiteralNegative(B). { A = new NTToken(); A->query = B->query; }
additiveExpressionX(A) ::= PLUS multiplicativeExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '+ ' . B->query; }
additiveExpressionX(A) ::= MINUS multiplicativeExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '- ' . B->query; }
additiveExpressionY(A) ::= additiveExpressionY(B) STAR unaryExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' * ' . C->query; }
additiveExpressionY(A) ::= additiveExpressionY(B) SLASH unaryExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' * ' . C->query; }
additiveExpressionY(A) ::= STAR unaryExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '* ' . B->query; }
additiveExpressionY(A) ::= SLASH unaryExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '/ ' . B->query; }

multiplicativeExpression(A) ::= unaryExpression(B) additiveExpressionY(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; } 
multiplicativeExpression(A) ::= unaryExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

unaryExpression(A) ::= EXCLAMATION primaryExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '! ' . B->query; }
unaryExpression(A) ::= PLUS primaryExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '+ ' . B->query; }
unaryExpression(A) ::= MINUS primaryExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '- ' . B->query; }
unaryExpression(A) ::= primaryExpression(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }

primaryExpression(A) ::= LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = '( ' . B->query . ' )'; }
primaryExpression(A) ::= builtInCall(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
primaryExpression(A) ::= iri(B). { A = new NTToken(); A->query = B->query; }
primaryExpression(A) ::= functionCall(B). { A = new NTToken(); A->hasFNC = true; A->hasAGG = true; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
primaryExpression(A) ::= rdfLiteral(B). { A = new NTToken(); A->query = B->query; }
primaryExpression(A) ::= numericLiteral(B). { A = new NTToken(); A->query = B->query; }
primaryExpression(A) ::= booleanLiteral(B). { A = new NTToken(); A->query = B->query; }
primaryExpression(A) ::= var(B). { A = new NTToken(); A->vars = B->vars; A->query = B->query; }

builtInCall(A) ::= aggregate(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
builtInCall(A) ::= regexExpression(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
builtInCall(A) ::= existsFunc(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
builtInCall(A) ::= notExistsFunc(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
builtInCall(A) ::= STR LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'STR( ' . B->query . ' )'; }
builtInCall(A) ::= LANG LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'STR( ' . B->query . ' )'; }
builtInCall(A) ::= LANGMATCHES LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); copyBools(C) A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'LANGMATCHES( ' . B->query . ', ' . C->query . ' )'; }
builtInCall(A) ::= DATATYPE LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'DATATYPE( ' . B->query . ' )'; }
builtInCall(A) ::= BOUND LPARENTHESE var(B) RPARENTHESE. { A = new NTToken(); A->vars = B->vars; A->query = 'BOUND( ' . B->query . ' )'; }
builtInCall(A) ::= URI LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'URI( ' . B->query . ' )'; }
builtInCall(A) ::= BNODE LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->hasBN = true; A->copyBools(B); A->vars = B->vars; A->bNodes[B->query] = 1; A->addBNodes(B->bNodes); A->query = 'BNODE( ' B->query; ' )'; }
builtInCall(A) ::= BNODE NIL. { A = new NTToken(); A->hasBN = true; A->query = 'BNODE( )'; }
builtInCall(A) ::= RAND NIL. { A = new NTToken(); A->query = 'RAND( )'; }
builtInCall(A) ::= ABS LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'ABS(' . B->query . ' )'; }
builtInCall(A) ::= CEIL LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars;A->bNodes = B->bNodes; A->query = 'CEIL(' . B->query . ' )'; }
builtInCall(A) ::= FLOOR LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'FLOOR(' . B->query . ' )'; }
builtInCall(A) ::= ROUND LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'ROUND(' . B->query . ' )'; }
builtInCall(A) ::= CONCAT expressionList(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars;A->bNodes = B->bNodes; A->query = 'CONCAT' . B->query; }
builtInCall(A) ::= subStringExpression(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
builtInCall(A) ::= STRLEN LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'STRLEN( ' . B->query . ' )'; }
builtInCall(A) ::= strReplaceExpression(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; }
builtInCall(A) ::= UCASE LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'UCASE( ' . B->query . ' )'; }
builtInCall(A) ::= LCASE LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query =  'LCASE( ' . B->query . ' )'; }
builtInCall(A) ::= ENCODE_FOR_URI LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'ENCODE_FOR_URI( ' . B->query . ' )'; }
builtInCall(A) ::= CONTAINS LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'CONTAINS( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= STRSTARTS LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'STRSTARTS( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= STRENDS LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'STRENDS( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= STBEFORE LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'STBEFORE( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= STRAFTER LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'STRAFTER( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= YEAR LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'YEAR( ' . B->query . ' )'; }
builtInCall(A) ::= MONTH LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'MONTH( ' . B->query . ' )'; }
builtInCall(A) ::= DAY LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'DAY( ' . B->query . ' )'; }
builtInCall(A) ::= HOURS LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'HOURS( ' . B->query . ' )'; }
builtInCall(A) ::= MINUTES LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'MINUTES( ' . B->query . ' )'; }
builtInCall(A) ::= SECONDS LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'SECONDS( ' . B->query . ' )'; }
builtInCall(A) ::= TIMEZONE LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'TIMEZONE( ' . B->query . ' )'; }
builtInCall(A) ::= TZ LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'TZ( ' . B->query . ' )'; }
builtInCall(A) ::= NOW NIL. { A = new NTToken(); A->query = 'NOW( )'; }
builtInCall(A) ::= UUID NIL. { A = new NTToken(); A->query = 'UUID( )'; }
builtInCall(A) ::= STRUUID NIL. { A = new NTToken(); A->query = 'STRUUID( )'; }
builtInCall(A) ::= MD5 LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'MD5( ' . B->query . ' )'; }
builtInCall(A) ::= SHA1 LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'SHA1( ' . B->query . ' )'; }
builtInCall(A) ::= SHA256 LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'SHA256( ' . B->query . ' )'; }
builtInCall(A) ::= SHA384 LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'SHA384( ' . B->query . ' )'; }
builtInCall(A) ::= SHA512 LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'SHA512( ' . B->query . ' )'; }
builtInCall(A) ::= COALESCE expressionList(B). { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'COALESCE' . B->query; }
builtInCall(A) ::= IF LPARENTHESE expression(B) COMMA expression(C) COMMA expression(D) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'IF( ' . B->query . ', ' . C->query .  ', ' . D->query . ' )'; }
builtInCall(A) ::= STRLANG LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = 'STRLANG( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= STRDT LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'STRDT( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= SAMETERM LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'SAMETERM( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= ISIRI LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'ISIRI( ' . B->query . ' )'; }
builtInCall(A) ::= ISURI LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'ISURI( ' . B->query . ' )'; }
builtInCall(A) ::= ISBLANK LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'ISBLANK( ' . B->query . ' )'; }
builtInCall(A) ::= ISLITERAL LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'ISLITERAL( ' . B->query . ' )'; }
builtInCall(A) ::= ISNUMERIC LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'ISNUMERIC( ' . B->query . ' )'; }

regexExpression(A) ::= REGEX LPARENTHESE expression(B) COMMA expression(C) COMMA expression(D) RPARENTHESE. { A = new NTToken; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'REGEX( ' . B->query . ', ' . C->query . ', ' . D->query . ' )'; }
regexExpression(A) ::= REGEX LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE.{ A = new NTToken; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'REGEX( ' . B->query . ', ' . C->query . ' )'; }

subStringExpression(A) ::= SUBSTR LPARENTHESE expression(B) COMMA expression(C) COMMA expression(D) RPARENTHESE. { A = new NTToken; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'SUBSTR( ' . B->query . ', ' . C->query . ', ' . D->query . ' )'; }
subStringExpression(A) ::= SUBSTR LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = 'SUBSTR( ' . B->query . ', ' . C->query . ' )'; }

strReplaceExpression(A) ::= REPLACE LPARENTHESE expression(B) COMMA expression(C) COMMA expression(D) COMMA expression(E) RPARENTHESE. { A = new NTToken; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->copyBools(E); A->vars = B->vars + C->vars + D->vars + E->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes + E->bNodes; A->query = 'REPLACE( ' . B->query . ', ' . C->query . ', ' . D->query . ', ' . E->query . ' )'; } 
strReplaceExpression(A) ::= REPLACE LPARENTHESE expression(B) COMMA expression(C) COMMA expression(D) RPARENTHESE. { A = new NTToken; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = 'REPLACE( ' . B->query . ', ' . C->query . ', ' . D->query . ' )'; }

existsFunc(A) ::= EXISTS groupGraphPattern(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'EXISTS ' . B->query; }

notExistsFunc(A) ::= NOT EXISTS groupGraphPattern(B). { A = new NTToken(); A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = 'NOT EXISTS ' . B->query; }

aggregate(A) ::= COUNT(B) LPARENTHESE(C) DISTINCT(D) STAR(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'COUNT( DISTINCT * )'; }
aggregate(A) ::= COUNT(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'COUNT( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; }
aggregate(A) ::= COUNT(B) LPARENTHESE(C) STAR(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'COUNT( * )'; }
aggregate(A) ::= COUNT(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'COUNT( ' . D->query . ' )'; A->copyBools(D); A->vars = E->vars; A->bNodes = E->bNodes; }
aggregate(A) ::= SUM(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'SUM( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; }
aggregate(A) ::= MIN(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'MIN( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; }
aggregate(A) ::= MAX(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'MAX( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; }
aggregate(A) ::= AVG(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'AVG( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; }
aggregate(A) ::= SAMPLE(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'SAMPLE( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes); }
aggregate(A) ::= SUM(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'SUM( ' . D->query . ' )'; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; }
aggregate(A) ::= MIN(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'MIN( ' . D->query . ' )'; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; }
aggregate(A) ::= MAX(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'MAX( ' . D->query . ' )'; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; }
aggregate(A) ::= AVG(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'AVG( ' . D->query . ' )'; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; }
aggregate(A) ::= SAMPLE(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'SAMPLE( ' . D->query . ' )'; A->copyBools(D); A->addVars(D); A->addBNodes(D->bNodes); }
aggregate(A) ::= GROUP_CONCAT(B) LPARENTHESE(C) DISTINCT(D) expression(E) SEMICOLON(F) SEPARATOR(G) EQUAL(H) string(I) RPARENTHESE(J). { A = new NTToken(); A->hasAGG = true; A->query = 'GROUP_CONCAT( DISTINCT ' . E->query . ' ; SEPARATOR = ' . I->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; }
aggregate(A) ::= GROUP_CONCAT(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'GROUP_CONCAT( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; }
aggregate(A) ::= GROUP_CONCAT(B) LPARENTHESE(C) expression(D) SEMICOLON(E) SEPARATOR(F) EQUAL(G) string(H) RPARENTHESE(I). { A = new NTToken(); A->hasAGG = true; A->query = 'GROUP_CONCAT( ' . D->query . ' ; SEPARATOR = ' H->query . ' )'; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; }
aggregate(A) ::= GROUP_CONCAT(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'GROUP_CONCAT( ' . D->query . ' )'; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; }

rdfLiteral(A) ::= string(B) LANGTAG(C). { A = new NTToken(); A->query = B->query . C->value; }
rdfLiteral(A) ::= string(B) DHAT(C) iri(D). { A = new NTToken(); A->query = B->query . C->value . D->query;
rdfLiteral(A) ::= string(B). { A = new NTToken(); A->query = B->query; }

numericLiteral(A) ::= numericLiteralUnsigned(B). { A = new NTToken(); A->query = B->query; }
numericLiteral(A) ::= numericLiteralPositive(B). { A = new NTToken(); A->query = B->query; }
numericLiteral(A) ::= numericLiteralNegative(B). { A = new NTToken(); A->query = B->query; }

numericLiteralUnsigned(A) ::= INTEGER(B). {A = new NTToken(); A->query = B->value; }
numericLiteralUnsigned(A) ::= DECIMAL(B). {A = new NTToken(); A->query = B->value; }
numericLiteralUnsigned(A) ::= DOUBLE(B). {A = new NTToken(); A->query = B->value; }

numericLiteralPositive(A) ::= INTEGER_POSITIVE(B). {A = new NTToken(); A->query = B->value; }
numericLiteralPositive(A) ::= DECIMAL_POSITIVE(B). {A = new NTToken(); A->query = B->value; }
numericLiteralPositive(A) ::= DOUBLE_POSITIVE(B). {A = new NTToken(); A->query = B->value; }

numericLiteralNegative(A) ::= INTEGER_NEGATIVE(B). { A = new NTToken(); A->query = B->value; }
numericLiteralNegative(A) ::= DECIMAL_NEGATIVE(B). { A = new NTToken(); A->query = B->value; }
numericLiteralNegative(A) ::= DOUBLE_NEGATIVE(B). { A = new NTToken(); A->query = B->value; }

booleanLiteral(A) ::= TRUE. { A = new NTToken(); A->query = "true";}
booleanLiteral(A) ::= FALSE. { A = new NTToken(); A->query = "false";}

string(A) ::= STRING_LITERAL1(B). { A = new NTToken(); A->query = B->value;}
string(A) ::= STRING_LITERAL2(B). { A = new NTToken(); A->query = B->value;}
string(A) ::= STRING_LITERAL_LONG1(B). { A = new NTToken(); A->query = B->value;}
string(A) ::= STRING_LITERAL_LONG2(B). { A = new NTToken(); A->query = B->value;}

iri(A) ::= IRIREF(B). { if(!$this->checkBase(B->value)){$this->main->error = "Missing Base for " . B->value; yy_parse_failed();} A = new NTToken(); A->query = B->value;}
iri(A) ::= prefixedName(B). { A = new NTToken(); A->query = B->query;}

prefixedName(A) ::= PNAME_LN(B). {if(!$this->checkNS(B->value)){$this->main->error = "Missing Prefix for " . B->value;yy_parse_failed();} A = new NTToken(); A->query = B->value;}
prefixedName(A) ::= PNAME_NS(B). {if(!$this->checkNS(B->value)){$this->main->error = "Missing Prefix for " . B->value;yy_parse_failed();} A = new NTTOKEN(); A->query = B->value;}

blankNode(A) ::= BLANK_NODE_LABEL(B). {A = new NTToken(); A->hasBN = true; A->bNodes[B->value] = 1;}
blankNode(A) ::= ANON. {A = new NTToken(); A->hasBN = true;}

/* solved issues: * + through loops, update is allowed to be empty (completely empty) -> removed, 
 * no vars in quadData -> class which remembers if vars/bnodes/etc are used, 
 * delete data -> same as above
 * DataBlock - needs same amount of variables and datablockvalues -> the class counts values
 * troublemaker:  scoping, as the exact places to check and the exact points to check it and how deep i need to check (it seems that as looses its power after a where clause except for the select for this where clause) - extra array for as vars (every kind of as inclusion)
 * limiting aggregates, custom aggregates through vars/bools
*/
