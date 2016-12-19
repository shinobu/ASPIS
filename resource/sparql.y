/* !!!!!!!!!!!!!!!!!SCOPING NOTES !!!!!!!!!!!!!!!!!!!
 * might need to throw A->ssVars = B->ssVars; to everyting containing "expression" rules
 * need to rework catching errors (use throw error)
 *
 */

/* This is a lemon grammar for the Sparql1.1 language */
%name SparqlPHPParser
%token_prefix TK_

%include { /* this will be copied blindly */
namespace aSPPis\lib;
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
    //NTToken Type to differentiate different Tokens in the Syntax Tree, starts at 500 (TTokens use 1-164 right now, up to 500 is just a buffer)
    public $type = -1;
    //Childs of the NTToken to create the parse tree
    public $childs = array();
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
                    break;
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

%include_class {
/* putting the ns and base information in the parser class and adding access to the SparqlPHPParserMain.php, removes the necessity to use 
 * global variables/add another parameter to the parse function.
 */
public $main;
public $base = null;
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
        if(isset($this->base)) {
            return true;
        } else {
            return false;
        }
    }
}
}

%parse_accept {
print('Success');

}

%parse_failure {
    /*transfer somehow execution class and write the error into it maybe? maybe as fourth parameter (kinda wasteful as every token will throw it in the parser again)*/
}

/* this defines a symbol for the lexer */
%nonassoc PRAGMA.

start(A) ::= query(B). { A = B; $this->main->root = B; }
start(A) ::= update(B). { A = B; $this->main->root = B; }

query(A) ::= prologue(B) selectQuery(C) valuesClause(D). { A = new NTToken(); A->type = 500; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
query(A) ::= prologue(B) constructQuery(C) valuesClause(D). { A = new NTToken(); A->type = 500; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
query(A) ::= prologue(B) describeQuery(C) valuesClause(D). { A = new NTToken(); A->type = 500; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
query(A) ::= prologue(B) askQuery(C) valuesClause(D). { A = new NTToken(); A->type = 500; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
query(A) ::= selectQuery(B) valuesClause(C). { A = new NTToken(); A->type = 500; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
query(A) ::= constructQuery(B) valuesClause(C). { A = new NTToken(); A->type = 500; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
query(A) ::= describeQuery(B) valuesClause(C). { A = new NTToken(); A->type = 500; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
query(A) ::= askQuery(B) valuesClause(C). { A = new NTToken(); A->type = 500; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
query(A) ::= prologue(B) selectQuery(C). { A = new NTToken(); A->type = 500; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
query(A) ::= prologue(B) constructQuery(C). { A = new NTToken(); A->type = 500; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
query(A) ::= prologue(B) describeQuery(C). { A = new NTToken(); A->type = 500; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
query(A) ::= prologue(B) askQuery(C). { A = new NTToken(); A->type = 500; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
query(A) ::= selectQuery(B). { A = B;  A->type = 500; A->childs = array(B); }
query(A) ::= constructQuery(B). { A = B;  A->type = 500; A->childs = array(B); }
query(A) ::= describeQuery(B). { A = B;  A->type = 500; A->childs = array(B); }
query(A) ::= askQuery(B). { A = B;  A->type = 500; A->childs = array(B); }

prologue(A) ::= prefixDeclX(B) baseDecl(C) prefixDeclX(D). { A = new NTToken(); A->type = 501; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
prologue(A) ::= baseDecl(B) prefixDeclX(C). { A = new NTToken(); A->type = 501; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
prologue(A) ::= prefixDeclX(B) baseDecl(C). { A = new NTToken(); A->type = 501; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
prologue(A) ::= baseDecl(B). { A = new NTToken(); A->type = 501; A->query = B->query; A->childs = array(B); }
prologue(A) ::= prefixDeclX(B). { A = new NTToken(); A->type = 501; A->query = B->query; A->childs = array(B); }
prefixDeclX(A) ::= prefixDeclX(B) prefixDecl(C). { A = new NTToken(); A->type = 502; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
prefixDeclX(A) ::= prefixDecl(B). { A = new NTToken(); A->type = 502; A->query = B->query; A->childs = array(B); }

baseDecl(A) ::= BASE(B) IRIREF(C) DOT(D). { $this->base = C->value; A = new NTToken(); A->type = 503; A->query = strtoupper(B->value) . ' ' . C->value . ' .'; A->childs = array(B, C, D); }
baseDecl(A) ::= BASE(B) IRIREF(C). { $this->base = C->value; A = new NTToken(); A->type = 503; A->query = strtoupper(B->value) . ' ' . C->value; A->childs = array(B, C); }

prefixDecl(A) ::= PREFIX(B) PNAME_NS(C) IRIREF(D) DOT(E). { $this->addNS(C->value, D->value); A = new NTToken(); A->type = 504; A->query = strtoupper(B->value) . ' ' . C->value . D->value . ' .'; A->childs = array(B, C, D, E); }
prefixDecl(A) ::= PREFIX(B) PNAME_NS(C) IRIREF(D). { $this->addNS(C->value, D->value); A = new NTToken(); A->type = 504; A->query = strtoupper(B->value) . ' ' . C->value . D->value; A->childs = array(B, C, D); }

selectQuery(A) ::= selectClause(B) datasetClauseX(C) whereclause(D) solutionModifier(E). { $tmp = B->noDuplicates(B->ssVars, D->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = B->noDuplicates(B->ssVars, E->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = B->noDuplicates(D->ssVars, E->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} A = new NTToken(); A->type = 505; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->copyBools(E); A->ssVars = B->ssVars; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
selectQuery(A) ::= selectClause(B) datasetClauseX(C) whereclause(D). { $tmp = B->noDuplicates(B->ssVars, D->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} A = new NTToken(); A->type = 505; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
selectQuery(A) ::= selectClause(B) whereclause(C) solutionModifier(D). { $tmp = B->noDuplicates(B->ssVars, C->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = B->noDuplicates(B->ssVars, D->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = B->noDuplicates(D->ssVars, C->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} A = new NTToken(); A->type = 505; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
selectQuery(A) ::= selectClause(B) whereclause(C). { $tmp = B->noDuplicates(B->ssVars, C->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} A = new NTToken(); A->type = 505; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
datasetClauseX(A) ::= datasetClauseX(B) datasetClause(C). { A = new NTToken(); A->type = 506; A->query = B->query . PHP_EOL . C->query;A->childs = array(B, C); }
datasetClauseX(A) ::= datasetClause(B). { A = B;  A->type = 506;A->childs = array(B); }


subSelect(A) ::= selectClause(B) whereclause(C) solutionModifier(D) valuesClause(E). { $tmp = B->noDuplicates(B->ssVars, C->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = B->noDuplicates(B->ssVars, D->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = B->noDuplicates(D->ssVars, C->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = B->noDuplicates(B->ssVars, E->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = B->noDuplicates(E->ssVars, C->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = B->noDuplicates(D->ssVars, E->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} A = new NTToken(); A->type = 507; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
subSelect(A) ::= selectClause(B) whereclause(C) valuesClause(D). { $tmp = B->noDuplicates(B->ssVars, C->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = B->noDuplicates(B->ssVars, D->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = B->noDuplicates(D->ssVars, C->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} A = new NTToken(); A->type = 507; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
subSelect(A) ::= selectClause(B) whereclause(C) solutionModifier(D). { $tmp = B->noDuplicates(B->ssVars, C->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = B->noDuplicates(B->ssVars, D->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = B->noDuplicates(D->ssVars, C->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} A = new NTToken(); A->type = 507; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
subSelect(A) ::= selectClause(B) whereclause(C). { $tmp = B->noDuplicates(B->ssVars, C->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} A = new NTToken(); A->type = 507; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }

selectClause(A) ::= SELECT(B) DISTINCT(C) selectClauseX(D). { A = D; A->type = 508; A->query = 'SELECT DISTINCT' . D->query;A->childs = array(B, C, D); }
selectClause(A) ::= SELECT(B) REDUCED(C) selectClauseX(D). { A = D; A->type = 508; A->query = 'SELECT REDUCED' . D->query;A->childs = array(B, C, D); }
selectClause(A) ::= SELECT(B) STAR(C) selectClauseX(D). { A = D; A->type = 508; A->query = 'SELECT *' . D->query;A->childs = array(B, C, D); }
selectClause(A) ::= SELECT(B) DISTINCT(C) STAR(D). { A = new NTToken(); A->type = 508; A->query = 'SELECT DISTINCT *'; A->childs = array(B, C, D); }
selectClause(A) ::= SELECT(B) REDUCED(C) STAR(D). { A = new NTToken(); A->type = 508; A->query = 'SELECT REDUCED *'; A->childs = array(B, C, D); }
selectClause(A) ::= SELECT(B) selectClauseX(C). { A = C; A->type = 508; A->query = 'SELECT ' . C->query;A->childs = array(B, C); }
selectClause(A) ::= SELECT(B) STAR(C). { A = new NTToken(); A->type = 508; A->query = 'SELECT *'; A->childs = array(B, C); }
selectClauseX(A) ::= selectClauseX(B) LPARENTHESE(C) expression(D) AS(E) var(F) RPARENTHESE(G). { A = new NTToken(); A->type = 509; A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars + D->ssVars + F->vars; A->vars = B->vars + D->vars + F->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . '( ' . D->query . ' AS ' . F->query . ' )'; A->childs = array(B, C, D, E, F, G); }
selectClauseX(A) ::= selectClauseX(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 509; A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars + D->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . PHP_EOL . '( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
selectClauseX(A) ::= selectClauseX(B) builtInCall(C). { A = new NTToken(); A->type = 509; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
selectClauseX(A) ::= selectClauseX(B) rdfLiteral(C). { A = new NTToken(); A->type = 509; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
selectClauseX(A) ::= selectClauseX(B) numericLiteral(C). { A = new NTToken(); A->type = 509; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
selectClauseX(A) ::= selectClauseX(B) booleanLiteral(C). { A = new NTToken(); A->type = 509; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
selectClauseX(A) ::= selectClauseX(B) var(C). { A = new NTToken(); A->type = 509; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
selectClauseX(A) ::= selectClauseX(B) functionCall(C). { A = new NTToken(); A->type = 509; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
selectClauseX(A) ::= LPARENTHESE(B) expression(C) AS(D) var(E) RPARENTHESE(F). { A = new NTToken(); A->type = 509; A->copyBools(C); A->ssVars = C->ssVars + E->vars; A->vars = C->vars + E->vars; A->bNodes = C->bNodes; A->query = '( ' . C->query . ' AS ' . E->query . ' )'; A->childs = array(B, C, D, E, F); }
selectClauseX(A) ::= LPARENTHESE(B) expression(C) RPARENTHESE(D). { A = C; A->type = 509; A->query = '( ' . C->query . ' )'; A->childs = array(B, C, D); }
selectClauseX(A) ::= builtInCall(B). { A = B; A->type = 509; A->childs = array(B); }
selectClauseX(A) ::= rdfLiteral(B). { A = B; A->type = 509; A->childs = array(B); }
selectClauseX(A) ::= numericLiteral(B). { A = B; A->type = 509; A->childs = array(B); }
selectClauseX(A) ::= booleanLiteral(B). { A = B; A->type = 509; A->childs = array(B); }
selectClauseX(A) ::= var(B). { A = B; A->type = 509; A->childs = array(B); }
selectClauseX(A) ::= functionCall(B). { A = B; A->type = 509; A->childs = array(B); }

constructQuery(A) ::= CONSTRUCT(B) LBRACE(C) triplesTemplate(D) RBRACE(E) datasetClauseX(F) whereclause(G) solutionModifier(H). { A = new NTToken(); A->type = 510; A->copyBools(D); A->copyBools(G); A->copyBools(H); A->ssVars = D->ssVars + G->ssVars + H->ssVars; A->vars = D->vars + G->vars + H->vars; A->bNodes = D->bNodes + G->bNodes + H->bNodes; A->query = 'CONSTRUCT' . PHP_EOL . '{' . PHP_EOL . D->query . PHP_EOL . '}' . PHP_EOL. F->query . PHP_EOL . G->query . PHP_EOL . H->query; A->childs = array(B, C, D, E, F, G, H); }
constructQuery(A) ::= CONSTRUCT(B) LBRACE(C) RBRACE(D) datasetClauseX(E) whereclause(F) solutionModifier(G). { A = new NTToken(); A->type = 510; A->copyBools(F); A->copyBools(G); A->ssVars = F->ssVars + G->ssVars; A->vars = F->vars + G->vars; A->bNodes = F->bNodes + G->bNodes; A->query = 'CONSTRUCT { }' . PHP_EOL . E->query . PHP_EOL. F->query . PHP_EOL . G->query; A->childs = array(B, C, D, E, F, G); }
constructQuery(A) ::= CONSTRUCT(B) datasetClauseX(C) WHERE(D) LBRACE(E) triplesTemplate(F) RBRACE(G) solutionModifier(H). { A = new NTToken(); A->type = 510; A->copyBools(F); A->copyBools(H); A->ssVars = F->ssVars + H->ssVars; A->vars = F->vars + H->vars; A->bNodes = F->bNodes + H->bNodes; A->query = 'CONSTRUCT' . PHP_EOL . C->query . PHP_EOL . 'WHERE' . PHP_EOL . '{' . PHP_EOL . F->query . PHP_EOL . '}' . PHP_EOL. G->query; A->childs = array(B, C, D, E, F, G, H); }
constructQuery(A) ::= CONSTRUCT(B) datasetClauseX(C) WHERE(D) LBRACE(E) RBRACE(F) solutionModifier(G). { A = new NTToken(); A->type = 510; A->copyBools(G); A->ssVars = G->ssVars; A->vars = G->vars; A->bNodes = G->bNodes; A->query = 'CONSTRUCT' . PHP_EOL . C->query . PHP_EOL . ' WHERE' . PHP_EOL . '{ }' . PHP_EOL . G->query; A->childs = array(B, C, D, E, F, G); }
constructQuery(A) ::= CONSTRUCT(B) LBRACE(C) triplesTemplate(D) RBRACE(E) whereclause(F) solutionModifier(G). { A = new NTToken(); A->type = 510; A->copyBools(D); A->copyBools(F); A->copyBools(G); A->ssVars = D->ssVars + F->ssVars + G->ssVars; A->vars = D->vars + F->vars + G->vars; A->bNodes = D->bNodes + F->bNodes + G->bNodes; A->query = 'CONSTRUCT {' . PHP_EOL . D->query . PHP_EOL . '}' . PHP_EOL. F->query . PHP_EOL . G->query; A->childs = array(B, C, D, E, F, G); }
constructQuery(A) ::= CONSTRUCT(B) LBRACE(C) RBRACE(D) whereclause(E) solutionModifier(F). { A = new NTToken(); A->type = 510; A->copyBools(E); A->copyBools(F); A->ssVars = E->ssVars + F->ssVars; A->vars = E->vars + F->vars; A->bNodes = E->bNodes + F->bNodes; A->query = 'CONSTRUCT { }' . PHP_EOL . E->query . PHP_EOL . F->query; A->childs = array(B, C, D, E, F); }
constructQuery(A) ::= CONSTRUCT(B) LBRACE(C) triplesTemplate(D) RBRACE(E) whereclause(F). { A = new NTToken(); A->type = 510; A->copyBools(D); A->copyBools(F); A->ssVars = D->ssVars + F->ssVars; A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'CONSTRUCT {' . PHP_EOL . D->query . PHP_EOL . '}' . PHP_EOL . F->query; A->childs = array(B, C, D, E, F); }
constructQuery(A) ::= CONSTRUCT(B) LBRACE(C) RBRACE(D) whereclause(E). { A = E; A->type = 510; A->query = 'CONSTRUCT { }' . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
constructQuery(A) ::= CONSTRUCT(B) LBRACE(C) triplesTemplate(D) RBRACE(E) datasetClauseX(F) whereclause(G). { A = new NTToken(); A->type = 510; A->copyBools(D); A->copyBools(G); A->ssVars = D->ssVars + G->ssVars; A->vars = D->vars + G->vars; A->bNodes = D->bNodes + G->bNodes; A->query = 'CONSTRUCT {' . PHP_EOL . D->query . PHP_EOL . '}' . PHP_EOL. F->query . PHP_EOL . G->query; A->childs = array(B, C, D, E, F, G); }
constructQuery(A) ::= CONSTRUCT(B) LBRACE(C) RBRACE(D) datasetClauseX(E) whereclause(F).{ A = new NTToken(); A->type = 510; A->copyBools(F); A->ssVars = F->ssVars; A->vars = F->vars; A->bNodes = F->bNodes; A->query = 'CONSTRUCT { }' . PHP_EOL . E->query . PHP_EOL . F->query; A->childs = array(B, C, D, E, F); }
constructQuery(A) ::= CONSTRUCT(B) datasetClauseX(C)  WHERE(D) LBRACE(E) triplesTemplate(F) RBRACE(G). { A = new NTToken(); A->type = 510; A->copyBools(F); A->ssVars = F->ssVars; A->vars = F->vars; A->bNodes = F->bNodes; A->query = 'CONSTRUCT' . PHP_EOL . C->query . PHP_EOL . 'WHERE {' . PHP_EOL . F->query . PHP_EOL . '}'; A->childs = array(B, C, D, E, F, G); }
constructQuery(A) ::= CONSTRUCT(B) datasetClauseX(C)  WHERE(D) LBRACE(E)  RBRACE(F). { A = C; A->type = 510; A->query = 'CONSTRUCT' . PHP_EOL . C->query . 'WHERE { }'; A->childs = array(B, C, D, E, F); }
constructQuery(A) ::= CONSTRUCT(B) WHERE(C) LBRACE(D) triplesTemplate(E) RBRACE(F) solutionModifier(G). { A = new NTToken(); A->type = 510; A->copyBools(E); A->copyBools(G); A->ssVars = E->ssVars + G->ssVars; A->vars = E->vars + G->vars; A->bNodes = E->bNodes + G->bNodes; A->query = 'CONSTRUCT WHERE {' . PHP_EOL . E->query . PHP_EOL . '}' . PHP_EOL . G->query; A->childs = array(B, C, D, E, F, G); }
constructQuery(A) ::= CONSTRUCT(B) WHERE(C) LBRACE(D) RBRACE(E) solutionModifier(F). { A = F; A->type = 510; A->query = 'CONSTRUCT WHERE { }' . PHP_EOL . F->query; A->childs = array(B, C, D, E, F); }
constructQuery(A) ::= CONSTRUCT(B) WHERE(C) LBRACE(D) triplesTemplate(E) RBRACE(F). { A = E; A->type = 510; A->query = 'CONSTRUCT WHERE {' . PHP_EOL . E->query . PHP_EOL . '}'; A->childs = array(B, C, D, E, F); }
constructQuery(A) ::= CONSTRUCT(B) WHERE(C) LBRACE(D) RBRACE(E). { A = new NTToken(); A->type = 510; A->query = 'CONSTRUCT WHERE { }'; A->childs = array(B, C, D, E); }

describeQuery(A) ::= DESCRIBE(B) varOrIriX(C) datasetClauseX(D) whereclause(E) solutionModifier(F). { A = new NTToken(); A->type = 511; A->copyBools(C); A->copyBools(E); A->copyBools(F); A->ssVars = C->ssVars + E->ssVars + F->ssVars; A->vars = C->vars + E->vars + F->vars; A->bNodes = C->bNodes + E->bNodes + F->bNodes; A->query = 'DESCRIBE ' . C->query . PHP_EOL . D->query . PHP_EOL . E->query . PHP_EOL . F->query; A->childs = array(B, C, D, E, F); }
describeQuery(A) ::= DESCRIBE(B) varOrIriX(C) whereclause(D) solutionModifier(E). { A = new NTToken(); A->type = 511; A->copyBools(C); A->copyBools(D); A->copyBools(E); A->ssVars = C->ssVars + D->ssVars + E->ssVars; A->vars = C->vars + D->vars + E->vars; A->bNodes = C->bNodes + D->bNodes + E->bNodes; A->query = 'DESCRIBE ' . C->query . PHP_EOL . D->query . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
describeQuery(A) ::= DESCRIBE(B) varOrIriX(C) datasetClauseX(D) solutionModifier(E). { A = new NTToken(); A->type = 511; A->copyBools(C); A->copyBools(E); A->ssVars = C->ssVars + E->ssVars; A->vars = C->vars + E->vars; A->bNodes = C->bNodes + E->bNodes; A->query = 'DESCRIBE ' . C->query . PHP_EOL . D->query . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
describeQuery(A) ::= DESCRIBE(B) varOrIriX(C) datasetClauseX(D) whereclause(E). { A = new NTToken(); A->type = 511; A->copyBools(C); A->copyBools(E); A->ssVars = C->ssVars + E->ssVars; A->vars = C->vars + E->vars; A->bNodes = C->bNodes + E->bNodes; A->query = 'DESCRIBE ' . C->query . PHP_EOL . D->query . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
describeQuery(A) ::= DESCRIBE(B) varOrIriX(C) solutionModifier(D). { A = new NTToken(); A->type = 511; A->copyBools(C); A->copyBools(D); A->ssVars = C->ssVars + D->ssVars; A->vars = C->vars + D->vars; A->bNodes = C->bNodes + D->bNodes; A->query = 'DESCRIBE ' . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
describeQuery(A) ::= DESCRIBE(B) varOrIriX(C) whereclause(D). { A = new NTToken(); A->type = 511; A->copyBools(C); A->copyBools(D); A->ssVars = C->ssVars + D->ssVars; A->vars = C->vars + D->vars; A->bNodes = C->bNodes + D->bNodes; A->query = 'DESCRIBE ' . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
describeQuery(A) ::= DESCRIBE(B) varOrIriX(C) datasetClauseX(D). { A = new NTToken(); A->type = 511; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = 'DESCRIBE ' . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
describeQuery(A) ::= DESCRIBE(B) varOrIriX(C). { A = C; A->type = 511; A->query = 'DESCRIBE ' . C->query;A->childs = array(B, C); }
describeQuery(A) ::= DESCRIBE(B) STAR(C) datasetClauseX(D) whereclause(E) solutionModifier(F). { A = new NTToken(); A->type = 511; A->copyBools(E); A->copyBools(F); A->ssVars = E->ssVars + F->ssVars; A->vars = E->vars + F->vars; A->bNodes = E->bNodes + F->bNodes; A->query = 'DESCRIBE *' . PHP_EOL . D->query . PHP_EOL . E->query . PHP_EOL . F->query; A->childs = array(B, C, D, E, F); }
describeQuery(A) ::= DESCRIBE(B) STAR(C) whereclause(D) solutionModifier(E). { A = new NTToken(); A->type = 511; A->copyBools(D); A->copyBools(E); A->ssVars = D->ssVars + E->ssVars; A->vars = D->vars + E->vars; A->bNodes = D->bNodes + E->bNodes; A->query = 'DESCRIBE *' . PHP_EOL . D->query . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
describeQuery(A) ::= DESCRIBE(B) STAR(C) datasetClauseX(D) solutionModifier(E). { A = new NTToken(); A->type = 511; A->copyBools(E); A->ssVars = E->ssVars; A->vars = E->vars; A->bNodes = E->bNodes; A->query = 'DESCRIBE *' . PHP_EOL . D->query . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
describeQuery(A) ::= DESCRIBE(B) STAR(C) datasetClauseX(D) whereclause(E). { A = new NTToken(); A->type = 511; A->copyBools(D); A->copyBools(E); A->ssVars = D->ssVars + E->ssVars; A->vars = D->vars + E->vars; A->bNodes = D->bNodes + E->bNodes; A->query = 'DESCRIBE *' . PHP_EOL . D->query . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
describeQuery(A) ::= DESCRIBE(B) STAR(C) solutionModifier(D). { A = D; A->type = 511; A->query = 'DESCRIBE *' . PHP_EOL . D->query; A->childs = array(B, C, D); }
describeQuery(A) ::= DESCRIBE(B) STAR(C) whereclause(D). { A = D; A->type = 511; A->query = 'DESCRIBE *' . PHP_EOL . D->query; A->childs = array(B, C, D); }
describeQuery(A) ::= DESCRIBE(B) STAR(C) datasetClauseX(D). { A = D; A->type = 511; A->query = 'DESCRIBE *' . PHP_EOL . D->query; A->childs = array(B, C, D); }
describeQuery(A) ::= DESCRIBE(B) STAR(C). { A = new NTToken(); A->type = 511; A->query = 'DESCRIBE *'; A->childs = array(B, C); }
varOrIriX(A) ::= varOrIriX(B) varOrIri(C). { A = new NTToken(); A->type = 512; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
varOrIriX(A) ::= varOrIri(B). { A = B; A->type = 512; A->childs = array(B); }

askQuery(A) ::= ASK(B) datasetClauseX(C) whereclause(D) solutionModifier(E). { A = new NTToken(); A->type = 513; A->copyBools(D); A->copyBools(E); A->ssVars = D->ssVars + E->ssVars; A->vars = D->vars + E->vars; A->bNodes = D->bNodes + E->bNodes; A->query = 'ASK' . C->query . PHP_EOL . D->query . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
askQuery(A) ::= ASK(B) datasetClauseX(C) whereclause(D). { A = new NTToken(); A->type = 513; A->copyBools(D); A->ssVars = D->ssVars; A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'ASK' . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
askQuery(A) ::= ASK(B) whereclause(C) solutionModifier(D). { A = new NTToken(); A->type = 513; A->copyBools(C); A->copyBools(D); A->ssVars = C->ssVars + D->ssVars; A->vars = C->vars + D->vars; A->bNodes = C->bNodes + D->bNodes; A->query = 'ASK' . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
askQuery(A) ::= ASK(B) whereclause(C). { A = C; A->type = 513; A->query = 'ASK ' . C->query;A->childs = array(B, C); }

datasetClause(A) ::= FROM(B) NAMED(C) iri(D). { A = D; A->type = 514; A->query = 'FROM NAMED ' . D->query;A->childs = array(B, C, D); }
datasetClause(A) ::= FROM(B) iri(C). { A = C; A->type = 514; A->query = 'FROM ' . C->query;A->childs = array(B, C); }

whereclause(A) ::= WHERE(B) groupGraphPattern(C). { A = C; A->type = 515; A->query = 'WHERE ' . C->query;A->childs = array(B, C); }
whereclause(A) ::= groupGraphPattern(B). { A = B; A->type = 515; A->childs = array(B); }

solutionModifier(A) ::= groupClause(B) havingClause(C) orderClause(D) limitOffsetClauses(E). { A = new NTToken(); A->type = 516; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->copyBools(E); A->ssVars = B->ssVars; A->vars = B->vars + C->vars + D->vars + E->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes + E->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
solutionModifier(A) ::= havingClause(B) orderClause(C) limitOffsetClauses(D). { A = new NTToken(); A->type = 516; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
solutionModifier(A) ::= groupClause(B) orderClause(C) limitOffsetClauses(D). { A = new NTToken(); A->type = 516; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
solutionModifier(A) ::= groupClause(B) havingClause(C) limitOffsetClauses(D). { A = new NTToken(); A->type = 516; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
solutionModifier(A) ::= groupClause(B) havingClause(C) orderClause(D). { A = new NTToken(); A->type = 516; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->ssVars = B->ssVars; A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C); }
solutionModifier(A) ::= groupClause(B) havingClause(C). { A = new NTToken(); A->type = 516; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
solutionModifier(A) ::= groupClause(B) orderClause(C). { A = new NTToken(); A->type = 516; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
solutionModifier(A) ::= groupClause(B) limitOffsetClauses(C). { A = new NTToken(); A->type = 516; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
solutionModifier(A) ::= orderClause(B) limitOffsetClauses(C). { A = new NTToken(); A->type = 516; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
solutionModifier(A) ::= havingClause(B) limitOffsetClauses(C). { A = new NTToken(); A->type = 516; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
solutionModifier(A) ::= havingClause(B) orderClause(C). { A = new NTToken(); A->type = 516; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
solutionModifier(A) ::= groupClause(B). { A = B; A->type = 516; A->childs = array(B); }
solutionModifier(A) ::= havingClause(B). { A = B; A->type = 516; A->childs = array(B); }
solutionModifier(A) ::= orderClause(B). { A = B; A->type = 516; A->childs = array(B); }
solutionModifier(A) ::= limitOffsetClauses(B). { A = B; A->type = 516; A->childs = array(B); }

groupClause(A) ::= GROUP(B) BY(C) groupConditionX(D). { A = D; A->type = 517; A->query = 'GROUP BY ' . D->query;A->childs = array(B, C, D); }
groupConditionX(A) ::= groupConditionX(B) LPARENTHESE(C) expression(D) AS(E) var(F) RPARENTHESE(G). { A = new NTToken(); A->type = 518; A->copyBools(B); A->copyBools(D); A->copyBools(F); A->ssVars = B->ssVars + F->vars; A->vars = B->vars + D->vars + F->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' (' . D->query . ' AS ' . F->query . ' )';A->childs = array(B, C, D, E, F, G); }
groupConditionX(A) ::= groupConditionX(B) builtInCall(C). { A = new NTToken(); A->type = 518; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query;A->childs = array(B, C); }
groupConditionX(A) ::= groupConditionX(B) functionCall(C). { A = new NTToken(); A->type = 518; A->hasFNC = true; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query;A->childs = array(B, C); }
groupConditionX(A) ::= groupConditionX(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 518; A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . '( ' . D->query . ' )';A->childs = array(B, C, D, E); }
groupConditionX(A) ::= groupConditionX(B) var(C). { A = new NTToken(); A->type = 518; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query;A->childs = array(B, C); }
groupConditionX(A) ::= LPARENTHESE(B) expression(C) AS(D) var(E) RPARENTHESE(F). { A = new NTToken(); A->type = 518; A->copyBools(C); A->copyBools(E); A->ssVars = E->vars; A->vars = C->vars + E->vars; A->bNodes = C->bNodes + E->bNodes; A->query = '( ' . C->query . ' AS ' . E->query . ' )';A->childs = array(B, C, D, E, F); }
groupConditionX(A) ::= builtInCall(B). { A = B; A->type = 518; A->childs = array(B); }
groupConditionX(A) ::= functionCall(B). { A = B; A->type = 518; A->hasFNC = true; A->childs = array(B); }
groupConditionX(A) ::= LPARENTHESE(B) expression(C) RPARENTHESE(D). { A = C; A->type = 518; A->query = '( ' . C->query . ' )';A->childs = array(B, C, D); }
groupConditionX(A) ::= var(B). { A = B; A->type = 518; A->childs = array(B); }

havingClause(A) ::= HAVING(B) constraintX(C). { A = C; A->type = 519; A->query = 'HAVING ' . C->query;A->childs = array(B, C); }
constraintX(A) ::= constraintX(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 520; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' (' . D->query . ' )'; A->childs = array(B, C, D, E); }
constraintX(A) ::= constraintX(B) builtInCall(C). { A = new NTToken(); A->type = 520; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
constraintX(A) ::= constraintX(B) functionCall(C). { A = new NTToken(); A->type = 520; A->hasFNC = true; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
constraintX(A) ::= LPARENTHESE(B) expression(C) RPARENTHESE(D). { A = C; A->type = 520; A->query = '( ' . C->query . ' )';A->childs = array(B, C, D); }
constraintX(A) ::= builtInCall(B). { A = B; A->type = 520; A->childs = array(B); }
constraintX(A) ::= functionCall(B). { A = B; A->type = 520; A->hasFNC = true;A->childs = array(B); }

orderClause(A) ::= ORDER(B) BY(C) orderConditionX(D). { A = D; A->type = 521; A->query = 'ORDER BY ' . D->query;A->childs = array(B, C, D); }
orderConditionX(A) ::= orderConditionX(B) orderCondition(C). { A = new NTToken(); A->type = 522; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
orderConditionX(A) ::= orderCondition(B). { A = B; A->type = 522; A->childs = array(B); }

orderCondition(A) ::= ASC(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = D; A->type = 523; A->query = 'ASC( ' . D->query . ' )';A->childs = array(B, C, D, E); }
orderCondition(A) ::= DESC(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = D; A->type = 523; A->query = 'DESC( ' . D->query . ' )';A->childs = array(B, C, D, E); }
orderCondition(A) ::= LPARENTHESE(B) expression(C) RPARENTHESE(D). { A = C; A->type = 523; A->query = '( ' . C->query . ' )';A->childs = array(B, C, D); }
orderCondition(A) ::= builtInCall(B). { A = B; A->type = 523; A->childs = array(B); }
orderCondition(A) ::= functionCall(B). { A = B; A->type = 523; A->childs = array(B); }
orderCondition(A) ::= var(B). { A = B; A->type = 523; A->childs = array(B); }

limitOffsetClauses(A) ::= limitClause(B) offsetClause(C). { A = new NTToken(); A->type = 524; A->copyBools(B); A->copyBools(C); A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
limitOffsetClauses(A) ::= offsetClause(B) limitClause(C). { A = new NTToken(); A->type = 524; A->copyBools(B); A->copyBools(C); A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
limitOffsetClauses(A) ::= limitClause(B). { A = B; A->type = 524; A->childs = array(B); }
limitOffsetClauses(A) ::= offsetClause(B). { A = B; A->type = 524; A->childs = array(B); }

limitClause(A) ::= LIMIT(B) INTEGER(C). { A = B; A->type = 525; A->query = 'LIMIT ' . C->value; A->childs = array(B, C); }

offsetClause(A) ::= OFFSET(B) INTEGER(C). { A = C; A->type = 526; A->query = 'OFFSET ' . C->value; A->childs = array(B, C); }

valuesClause(A) ::= VALUES(B) dataBlock(C). { A = C; A->type = 527; A->query = 'VALUES ' . C->query;A->childs = array(B, C); }

update(A) ::= prologue(B) update1(C) updateX(D). { A = new NTToken(); A->type = 528; A->copyBools(C); A->copyBools(D); A->vars = C->vars + D->vars; A->bNodes = C->bNodes + D->bNodes; A->query = B->query . PHP_EOL . C->query . ' ' . D->query; A->childs = array(B, C, D); }
update(A) ::= update1(B) updateX(C). { A = new NTToken(); A->type = 528; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
update(A) ::= prologue(B) update1(C). { A = new NTToken(); A->type = 528; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
update(A) ::= update1(B). { A = B; A->type = 528; A->childs = array(B); }
updateX(A) ::= updateX(B) SEMICOLON(C) prologue(D) update1(E). { A = new NTToken(); A->type = 529; A->copyBools(B); A->copyBools(E); A->vars = B->vars + E->vars; A->bNodes = B->bNodes + E->bNodes; A->query = B->query . ' ;' . PHP_EOL . D->query . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
updateX(A) ::= updateX(B) SEMICOLON(C) update1(D). { A = new NTToken(); A->type = 529; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' ;' . PHP_EOL . D->query; A->childs = array(B, C, D); }
updateX(A) ::= SEMICOLON(B) prologue(C) update1(D). { A = new NTToken(); A->type = 529; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = ';' . PHP_EOL . B->query . PHP_EOL . C->query; A->childs = array(B, C, D); }
updateX(A) ::= SEMICOLON(B) update1(C). { A = B; A->type = 529; A->query = ';' . PHP_EOL . B->query; A->childs = array(B, C); }

update1(A) ::= load(B). { A = B; A->type = 530; A->childs = array(B); }
update1(A) ::= clear(B). { A = B; A->type = 530; A->childs = array(B); }
update1(A) ::= drop(B). { A = B; A->type = 530; A->childs = array(B); }
update1(A) ::= add(B). { A = B; A->type = 530; A->childs = array(B); }
update1(A) ::= move(B). { A = B; A->type = 530; A->childs = array(B); }
update1(A) ::= copy(B). { A = B; A->type = 530; A->childs = array(B); }
update1(A) ::= create(B). { A = B; A->type = 530; A->childs = array(B); }
update1(A) ::= insertData(B). { A = B; A->type = 530; A->childs = array(B); }
update1(A) ::= deleteData(B). { A = B; A->type = 530; A->childs = array(B); }
update1(A) ::= deletewhere(B). { A = B; A->type = 530; A->childs = array(B); }
update1(A) ::= modify(B). { A = B; A->type = 530; A->childs = array(B); }

load(A) ::= LOAD(B) SILENT(C) iri(D) INTO(E) graphRef(F). { A = new NTToken(); A->type = 531; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'LOAD SILENT ' . D->query . ' INTO ' . F->query; A->childs = array(B, C, D, E, F); }
load(A) ::= LOAD(B) iri(C) INTO(D) graphRef(E). { A = new NTToken(); A->type = 531; A->copyBools(C); A->copyBools(E); A->vars = C->vars + E->vars; A->bNodes = C->bNodes + E->bNodes; A->query = 'LOAD ' . C->query . ' INTO ' . E->query; A->childs = array(B, C, D, E); }
load(A) ::= LOAD(B) SILENT(C) iri(D). { A = D; A->type = 531; A->query = 'LOAD SILENT ' . D->query; A->childs = array(B, C, D); }
load(A) ::= LOAD(B) iri(C). { A = C; A->type = 531; A->query = 'LOAD ' . C->query; A->childs = array(B, C); }

clear(A) ::= CLEAR(B) SILENT(C) graphRefAll(D). { A = D; A->type = 532; A->query = 'CLEAR SILENT ' . D->query; A->childs = array(B, C, D); }
clear(A) ::= CLEAR(B) graphRefAll(C). { A = C; A->type = 532; A->query = 'CLEAR ' . C->query; A->childs = array(B, C); }

drop(A) ::= DROP(B) SILENT(C) graphRefAll(D). { A = D; A->type = 533; A->query = 'DROP SILENT ' . D->query; A->childs = array(B, C, D); }
drop(A) ::= DROP(B) graphRefAll(C). { A = C; A->type = 533; A->query = 'DROP ' . C->query; A->childs = array(B, C); }

create(A) ::= CREATE(B) SILENT(C) graphRef(D). { A = D; A->type = 534; A->query = 'CREATE SILENT ' . D->query; A->childs = array(B, C, D); }
create(A) ::= CREATE(B) graphRef(C). { A = C; A->type = 534; A->query = 'CREATE ' . C->query; A->childs = array(B, C); }

add(A) ::= ADD(B) SILENT(C) graphOrDefault(D) TO(E) graphOrDefault(F). { A = new NTToken(); A->type = 535; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'ADD ' . D->query . ' TO ' . F->query; A->childs = array(B, C, D, E, F); }
add(A) ::= ADD(B) graphOrDefault(C) TO(D) graphOrDefault(E). { A = new NTToken(); A->type = 535; A->copyBools(C); A->copyBools(E); A->vars = C->vars + E->vars; A->bNodes = C->bNodes + E->bNodes; A->query = 'ADD ' . C->query . ' TO ' . E->query; A->childs = array(B, C, D, E); }

move(A) ::= MOVE(B) SILENT(C) graphOrDefault(D) TO(E) graphOrDefault(F). { A = new NTToken(); A->type = 536; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'MOVE SILENT ' . D->query . ' TO ' . F->query; A->childs = array(B, C, D, E, F); }
move(A) ::= MOVE(B) graphOrDefault(C) TO(D) graphOrDefault(E). { A = new NTToken(); A->type = 536; A->copyBools(C); A->copyBools(E); A->vars = C->vars + E->vars; A->bNodes = C->bNodes + E->bNodes; A->query = 'MOVE ' . C->query . ' TO ' . E->query; A->childs = array(B, C, D, E); }

copy(A) ::= COPY(B) SILENT(C) graphOrDefault(D) TO(E) graphOrDefault(F). { A = new NTToken(); A->type = 537; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'COPY SILENT ' . D->query . ' TO ' . F->query; A->childs = array(B, C, D, E, F); }
copy(A) ::= COPY(B) graphOrDefault(C) TO(D) graphOrDefault(E). { A = new NTToken(); A->type = 537; A->copyBools(C); A->copyBools(E); A->vars = C->vars + E->vars; A->bNodes = C->bNodes + E->bNodes; A->query = 'COPY ' . C->query . ' TO ' . E->query; A->childs = array(B, C, D, E); }

insertData(A) ::= INSERTDATA(B) quadData(C). { A = B; A->type = 538; A->query = 'DELETE DATA ' . C->query; A->childs = array(B, C); }

deleteData(A) ::= DELETEDATA(B) quadData(C). { if(C->hasBN){ throw new Exception("Deleteclause is not allowed to contain Blanknodesyntax: DELETE DATA" . C->query); } A = C; A->type = 539; A->query = 'DELETE DATA ' . C->query; A->childs = array(B, C); }

deletewhere(A) ::= DELETEWHERE(B) quadPattern(C). { if(C->hasBN){throw new Exception("Deleteclause is not allowed to contain Blanknodesyntax: DELETE WHERE" . C->query);} A = C; A->type = 540; A->query = 'DELETE WHERE ' . C->query; A->childs = array(B, C); }

modify(A) ::= WITH(B) iri(C) deleteClause(D) insertClause(E) usingClauseX(F) WHERE(G) groupGraphPattern(H). { A = new NTToken(); A->type = 541; A->copyBools(C); A->copyBools(D); A->copyBools(E); A->copyBools(F); A->copyBools(H); A->ssVars = H->ssVars; A->vars = C->vars + D->vars + E->vars + F->vars + H->vars; A->bNodes = C->bNodes + D->bNodes + E->bNodes + F->bNodes + H->bNodes; A->query = 'WITH ' . C->query . PHP_EOL . D->query . PHP_EOL . E->query . PHP_EOL . F->query . PHP_EOL . 'WHERE' . PHP_EOL . G->query; A->childs = array(B, C, D, E, F, G, H); }
modify(A) ::= WITH(B) iri(C) deleteClause(D) usingClauseX(E) WHERE(F) groupGraphPattern(G).{ A = new NTToken(); A->type = 541; A->copyBools(C); A->copyBools(D); A->copyBools(E); A->copyBools(G); A->ssVars = G->ssVars; A->vars = C->vars + D->vars + E->vars + G->vars; A->bNodes = C->bNodes + D->bNodes + E->bNodes + G->bNodes; A->query = 'WITH ' . C->query . PHP_EOL . D->query . PHP_EOL . E->query . PHP_EOL . 'WHERE' . PHP_EOL . G->query; A->childs = array(B, C, D, E, F, G); }
modify(A) ::= WITH(B) iri(C) insertClause(D) usingClauseX(E) WHERE(F) groupGraphPattern(G).{ A = new NTToken(); A->type = 541; A->copyBools(C); A->copyBools(D); A->copyBools(E); A->copyBools(G); A->ssVars = G->ssVars; A->vars = C->vars + D->vars + E->vars + G->vars; A->bNodes = C->bNodes + D->bNodes + E->bNodes + G->bNodes; A->query = 'WITH ' . C->query . PHP_EOL . D->query . PHP_EOL . E->query . PHP_EOL . 'WHERE' . PHP_EOL . G->query; A->childs = array(B, C, D, E, F, G); }
modify(A) ::= WITH(B) iri(C) deleteClause(D) insertClause(E) WHERE(F) groupGraphPattern(G).{ A = new NTToken(); A->type = 541; A->copyBools(C); A->copyBools(D); A->copyBools(E); A->copyBools(G); A->ssVars = G->ssVars; A->vars = C->vars + D->vars + E->vars + G->vars; A->bNodes = C->bNodes + D->bNodes + E->bNodes + G->bNodes; A->query = 'WITH ' . C->query . PHP_EOL . D->query . PHP_EOL . E->query . PHP_EOL . 'WHERE' . PHP_EOL . G->query; A->childs = array(B, C, D, E, F, G); }
modify(A) ::= WITH(B) iri(C) deleteClause(D) WHERE(E) groupGraphPattern(F). { A = new NTToken(); A->type = 541; A->copyBools(C); A->copyBools(D); A->copyBools(F); A->ssVars = F->ssVars; A->vars = C->vars + D->vars + F->vars; A->bNodes = C->bNodes + D->bNodes + F->bNodes; A->query = 'WITH ' . C->query . PHP_EOL . D->query . PHP_EOL . 'WHERE' . PHP_EOL . F->query; A->childs = array(B, C, D, E, F); }
modify(A) ::= WITH(B) iri(C) insertClause(D) WHERE(E) groupGraphPattern(F). { A = new NTToken(); A->type = 541; A->copyBools(C); A->copyBools(D); A->copyBools(F); A->ssVars = F->ssVars; A->vars = C->vars + D->vars + F->vars; A->bNodes = C->bNodes + D->bNodes + F->bNodes; A->query = 'WITH ' . C->query . PHP_EOL . D->query . PHP_EOL . 'WHERE' . PHP_EOL . F->query; A->childs = array(B, C, D, E, F); }
modify(A) ::= deleteClause(B) insertClause(C) usingClauseX(D) WHERE(E) groupGraphPattern(F). { A = new NTToken(); A->type = 541; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->copyBools(F); A->ssVars = F->ssVars; A->vars = B->vars + C->vars + D->vars + F->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes + F->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query . PHP_EOL . 'WHERE' . PHP_EOL . F->query; A->childs = array(B, C, D, E, F); }
modify(A) ::= deleteClause(B) usingClauseX(C) WHERE(D) groupGraphPattern(E). { A = new NTToken(); A->type = 541; A->copyBools(B); A->copyBools(C); A->copyBools(E); A->ssVars = E->ssVars; A->vars = B->vars + C->vars + E->vars; A->bNodes = B->bNodes + C->bNodes + E->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . 'WHERE' . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
modify(A) ::= insertClause(B) usingClauseX(C) WHERE(D) groupGraphPattern(E). { A = new NTToken(); A->type = 541; A->copyBools(B); A->copyBools(C); A->copyBools(E); A->ssVars = E->ssVars; A->vars = B->vars + C->vars + E->vars; A->bNodes = B->bNodes + C->bNodes + E->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . 'WHERE' . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
modify(A) ::= deleteClause(B) insertClause(C) WHERE(D) groupGraphPattern(E). { A = new NTToken(); A->type = 541; A->copyBools(B); A->copyBools(C); A->copyBools(E); A->ssVars = E->ssVars; A->vars = B->vars + C->vars + E->vars; A->bNodes = B->bNodes + C->bNodes + E->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . 'WHERE' . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
modify(A) ::= deleteClause(B) WHERE(C) groupGraphPattern(D). { A = new NTToken(); A->type = 541; A->copyBools(B); A->copyBools(D); A->ssVars = D->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . PHP_EOL . 'WHERE' . PHP_EOL . D->query; A->childs = array(B, C, D); }
modify(A) ::= insertClause(B) WHERE(C) groupGraphPattern(D). { A = new NTToken(); A->type = 541; A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars + D->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . PHP_EOL . 'WHERE' . PHP_EOL . D->query; A->childs = array(B, C, D); }
usingClauseX(A) ::= usingClauseX(B) usingClause(C). { A = new NTToken(); A->type = 542; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
usingClauseX(A) ::= usingClause(B). {A = B; A->type = 542; A->childs = array(B); }

deleteClause(A) ::= DELETE(B) quadPattern(C). { if(C->hasBN){throw new Exception("Deleteclause is not allowed to contain Blanknodesyntax: DELETE" . C->query);} A = C; A->type = 543; A->query = 'DELETE ' . C->query; A->childs = array(B, C); }

insertClause(A) ::= INSERT(B) quadPattern(C). { A = C; A->type = 544; A->query = 'INSERT ' . C->query; A->childs = array(B, C); }

usingClause(A) ::= USING(B) NAMED(C) iri(D). { A = D; A->type = 545; A->query = 'USING NAMED ' . D->query; A->childs = array(B, C, D); }
usingClause(A) ::= USING(B) iri(C). { A = C; A->type = 545; A->query = 'USING ' . C->query; A->childs = array(B, C); }

graphOrDefault(A) ::= GRAPH(B) iri(C). { A = B; A->type = 546; A->query = 'GRAPH ' . C->query; A->childs = array(B, C); }
graphOrDefault(A) ::= DEFAULT(B). { A = new NTToken(); A->type = 546; A->query = 'DEFAULT';A->childs = array(B); }
graphOrDefault(A) ::= iri(B). {A = B; A->type = 546;A->childs = array(B); }

graphRef(A) ::= GRAPH(B) iri(C). { A = B; A->type = 547; A->query = 'GRAPH ' . C->query; A->childs = array(B, C); }

graphRefAll(A) ::= graphRef(B). { A = B; A->type = 548; A->childs = array(B); }
graphRefAll(A) ::= DEFAULT(B). { A = new NTToken(); A->type = 548; A->query = 'DEFAULT';A->childs = array(B); }
graphRefAll(A) ::= NAMED(B). { A = new NTToken(); A->type = 548; A->query = 'NAMED';A->childs = array(B); }
graphRefAll(A) ::= ALL(B). { A = new NTToken(); A->type = 548; A->query = 'ALL';A->childs = array(B); }

quadPattern(A) ::= LBRACE(B) quads(C) RBRACE(D). { A = B; A->type = 549; A->query = '{ ' . PHP_EOL . C->query . PHP_EOL . ' }'; A->childs = array(B, C, D); }
quadPattern(A) ::= LBRACE(B) RBRACE(C). {A = new NTToken(); A->type = 549; A->query = '{ }';A->childs = array(B, C); }

quadData(A) ::= LBRACE(B) quads(C) RBRACE(D). { if(!empty(C->vars)){throw new Exception("QuadPattern arent allowed to contain variables: " . C->query);} A = C; A->type = 550; A->query = '{ ' . PHP_EOL . C->query . PHP_EOL . ' }'; A->childs = array(B, C, D); }
quadData(A) ::= LBRACE(B) RBRACE(C). {A = new NTToken(); A->type = 550; A->query = '{ }'; A->childs = array(B, C); }

quads(A) ::= triplesTemplate(B) quadsX(C). { A = new NTToken(); A->type = 551; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query; A->childs = array(B, C); }
quads(A) ::= triplesTemplate(B). { A = B; A->type = 551; A->childs = array(B); }
quads(A) ::= quadsX(B). { A = B; A->type = 551; A->childs = array(B); }
quadsX(A) ::= quadsX(B) quadsNotTriples(C) DOT(D) triplesTemplate(E). { A = new NTToken(); A->type = 552; A->copyBools(B); A->copyBools(C); A->copyBools(E); A->vars = B->vars + C->vars + E->vars; A->bNodes = B->bNodes + C->bNodes + E->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query . ' .' . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
quadsX(A) ::= quadsX(B) quadsNotTriples(C) triplesTemplate(D). { A = new NTToken(); A->type = 552; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
quadsX(A) ::= quadsX(B) quadsNotTriples(C) DOT(D). { A = new NTToken(); A->type = 552; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' .' . PHP_EOL . C->query; A->childs = array(B, C, D); }
quadsX(A) ::= quadsX(B) quadsNotTriples(C). { A = new NTToken(); A->type = 552; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
quadsX(A) ::= quadsNotTriples(B) DOT(C) triplesTemplate(D). { A = new NTToken(); A->type = 552; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' .' . PHP_EOL . D->query; A->childs = array(B, C, D); }
quadsX(A) ::= quadsNotTriples(B) triplesTemplate(C). { A = new NTToken(); A->type = 552; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
quadsX(A) ::= quadsNotTriples(B) DOT(C). { A = B; A->type = 552; A->query = B->query . ' .';A->childs = array(B, C); }
quadsX(A) ::= quadsNotTriples(B). { A = B; A->type = 552; A->childs = array(B); }

quadsNotTriples(A) ::= GRAPH(B) varOrIri(C) LBRACE(D) triplesTemplate(E) RBRACE(F). { A = new NTToken(); A->type = 553; A->copyBools(C); A->copyBools(E); A->vars = C->vars + E->vars; A->bNodes = E->bNodes; A->query = 'GRAPH ' . C->query . PHP_EOL . ' { ' .  PHP_EOL . E->query . PHP_EOL . ' }'; A->childs = array(B, C, D, E, F); }
quadsNotTriples(A) ::= GRAPH(B) varOrIri(C) LBRACE(D) RBRACE(E). { A = new NTToken(); A->type = 553; A->copyBools(C); A->vars = C->vars; A->query = 'GRAPH ' . C->query . ' { }'; A->childs = array(B, C, D, E); }

triplesTemplate(A) ::= triplesSameSubject(B) DOT(C) triplesTemplateX(D) DOT(E). { A = new NTToken(); A->type = 554; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' .' . PHP_EOL . D->query . ' .'; A->childs = array(B, C, D, E); }
triplesTemplate(A) ::= triplesSameSubject(B) DOT(C) triplesTemplateX(D). { A = new NTToken(); A->type = 554; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' .' . PHP_EOL . D->query; A->childs = array(B, C, D); }
triplesTemplate(A) ::= triplesSameSubject(B) DOT(C). { A = new NTToken(); A->type = 554; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query . ' .'; A->childs = array(B, C); }
triplesTemplate(A) ::= triplesSameSubject(B). { A = new NTToken(); A->type = 554; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
triplesTemplateX(A) ::= triplesTemplateX(B) DOT(C) triplesSameSubject(D). { A = new NTToken(); A->type = 555; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' .' . PHP_EOL . D->query; A->childs = array(B, C, D); }
triplesTemplateX(A) ::= triplesSameSubject(B). { A = new NTToken(); A->type = 555; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

groupGraphPattern(A) ::= LBRACE(B) groupGraphPatternSub(C) RBRACE(D). { A = C; A->type = 556; A->query = '{ ' . PHP_EOL . C->query . PHP_EOL . ' }'; A->childs = array(B, C, D); }
groupGraphPattern(A) ::= LBRACE(B) subSelect(C) RBRACE(D). { A = C; A->type = 556; A->query = '{ ' . PHP_EOL . C->query . PHP_EOL . ' }'; A->childs = array(B, C, D); }
groupGraphPattern(A) ::= LBRACE(B) RBRACE(C). {A = new NTToken(); A->type = 556; A->query = '{ }'; A->childs = array(B, C); }

groupGraphPatternSub(A) ::= triplesBlock(B) groupGraphPatternSubX(C). { if(!empty(C->bindVar)){ $tmp = B->noDuplicates(C->bindVar, B->vars); if(isset($tmp)){throw new Exception("Bindvariable is already in scope: " . $tmp);}} A = new NTToken(); A->type = 557; A->copyBools(B); A->copyBools(C); A->ssVars = C->ssVars; A->bindVar = C->bindVar; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
groupGraphPatternSub(A) ::= triplesBlock(B). {A = B; A->type = 557;A->childs = array(B); }
groupGraphPatternSub(A) ::= groupGraphPatternSubX(B). {A = B; A->type = 557;A->childs = array(B); }
groupGraphPatternSubX(A) ::= groupGraphPatternSubX(B) graphPatternNotTriples(C) DOT(D) triplesBlock(E). { $tmp = B->noDuplicates(C->ssVars, B->ssVars); if(isset($tmp)){throw new Exception("Variable is already in scope: " . $tmp);} else if(!empty(C->bindVar)){ $tmp = B->noDuplicates(C->bindVar, B->vars); if(isset($tmp)){throw new Exception("Bindvariable is already in scope: " . $tmp);}} A = new NTToken(); A->type = 558; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->bindVar = B->bindVar + C->bindVar; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query . ' .' . PHP_EOL . E->query; A->childs = array(B, C, D, E); }
groupGraphPatternSubX(A) ::= groupGraphPatternSubX(B) graphPatternNotTriples(C) triplesBlock(D). { $tmp = B->noDuplicates(C->ssVars, B->ssVars); if(isset($tmp)){throw new Exception("Variable is already in scope: " . $tmp);} else if(!empty(C->bindVar)){ $tmp = B->noDuplicates(C->bindVar, B->vars); if(isset($tmp)){throw new Exception("Bindvariable is already in scope: " . $tmp);}} A = new NTToken(); A->type = 558; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->bindVar = B->bindVar + C->bindVar; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query . PHP_EOL . D->query; A->childs = array(B, C, D); }
groupGraphPatternSubX(A) ::= groupGraphPatternSubX(B) graphPatternNotTriples(C) DOT(D). { $tmp = B->noDuplicates(C->ssVars, B->ssVars); if(isset($tmp)){throw new Exception("Variable is already in scope: " . $tmp);} else if(!empty(C->bindVar)){ $tmp = B->noDuplicates(C->bindVar, B->vars); if(isset($tmp)){throw new Exception("Bindvariable is already in scope: " . $tmp);}} A = new NTToken(); A->type = 558; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->bindVar = B->bindVar + C->bindVar; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query . ' .'; A->childs = array(B, C, D); }
groupGraphPatternSubX(A) ::= groupGraphPatternSubX(B) graphPatternNotTriples(C). { $tmp = B->noDuplicates(C->ssVars, B->ssVars); if(isset($tmp)){throw new Exception("Variable is already in scope: " . $tmp);} else if(!empty(C->bindVar)){ $tmp = B->noDuplicates(C->bindVar, B->vars); if(isset($tmp)){throw new Exception("Bindvariable is already in scope: " . $tmp);}} A = new NTToken(); A->type = 558; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->bindVar = B->bindVar + C->bindVar; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
groupGraphPatternSubX(A) ::= graphPatternNotTriples(B) DOT(C) triplesBlock(D). { A = new NTToken(); A->type = 558; A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' .' . PHP_EOL . D->query; A->childs = array(B, C, D); }
groupGraphPatternSubX(A) ::= graphPatternNotTriples(B) triplesBlock(C). { A = new NTToken(); A->type = 558; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
groupGraphPatternSubX(A) ::= graphPatternNotTriples(B) DOT(C). { A = new NTToken(); A->type = 558; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query . ' .'; A->childs = array(B, C); }
groupGraphPatternSubX(A) ::= graphPatternNotTriples(B). { A = new NTToken(); A->type = 558; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

triplesBlock(A) ::= triplesSameSubjectPath(B) DOT(C) triplesBlockX(D) DOT(E). { A = new NTToken(); A->type = 559; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' .' . PHP_EOL . D->query . ' .'; A->childs = array(B, C, D, E); }
triplesBlock(A) ::= triplesSameSubjectPath(B) DOT(C) triplesBlockX(D). { A = new NTToken(); A->type = 559; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' .' . PHP_EOL . D->query; A->childs = array(B, C, D); }
triplesBlock(A) ::= triplesSameSubjectPath(B) DOT(C). { A = new NTToken(); A->type = 559; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query . ' .'; A->childs = array(B, C); }
triplesBlock(A) ::= triplesSameSubjectPath(B). { A = new NTToken(); A->type = 559; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
triplesBlockX(A) ::= triplesBlockX(B) DOT(C) triplesSameSubjectPath(D). { A = new NTToken(); A->type = 560; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' .' . PHP_EOL . D->query; A->childs = array(B, C, D); }
triplesBlockX(A) ::= triplesSameSubjectPath(B). { A = new NTToken(); A->type = 560; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

graphPatternNotTriples(A) ::= groupOrUnionGraphPattern(B). { A = new NTToken(); A->type = 561; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
graphPatternNotTriples(A) ::= optionalGraphPattern(B). { A = new NTToken(); A->type = 561; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
graphPatternNotTriples(A) ::= minusGraphPattern(B). { A = new NTToken(); A->type = 561; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
graphPatternNotTriples(A) ::= graphGraphPattern(B). { A = new NTToken(); A->type = 561; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
graphPatternNotTriples(A) ::= serviceGraphPattern(B). { A = new NTToken(); A->type = 561; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
graphPatternNotTriples(A) ::= filter(B). { A = new NTToken(); A->type = 561; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
graphPatternNotTriples(A) ::= bind(B). { A = new NTToken(); A->type = 561; A->ssVars = B->ssVars; A->bindVar = B->bindVar; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
graphPatternNotTriples(A) ::= inlineData(B). { A = new NTToken(); A->type = 561; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

optionalGraphPattern(A) ::= OPTIONAL(B) groupGraphPattern(C). { A = new NTToken(); A->type = 562; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = 'OPTIONAL ' . C->query; A->childs = array(B, C); }

graphGraphPattern(A) ::= GRAPH(B) varOrIri(C) groupGraphPattern(D). { A = new NTToken(); A->type = 563; A->copyBools(D); A->ssVars = D->ssVars; A->vars = C->vars + D->vars; A->bNodes = D->bNodes; A->query = 'GRAPH ' . C->query . ' ' . D->query; A->childs = array(B, C, D); }

serviceGraphPattern(A) ::= SERVICE(B) SILENT(C) varOrIri(D) groupGraphPattern(E). { A = new NTToken(); A->type = 564; A->copyBools(E); A->ssVars = E->ssVars; A->vars = D->vars + E->vars; A->bNodes = E->bNodes; A->query = 'SERVICE SILENT ' . D->query . ' ' . E->query; A->childs = array(B, C, D, E); }
serviceGraphPattern(A) ::= SERVICE(B) varOrIri(C) groupGraphPattern(D). { A = new NTToken(); A->type = 564; A->copyBools(D); A->ssVars = C->ssVars; A->vars = C->vars + D->vars; A->bNodes = D->bNodes; A->query = 'SERVICE ' . C->query . ' ' . D->query; A->childs = array(B, C, D); }

bind(A) ::= BIND(B) LPARENTHESE(C) expression(D) AS(E) var(F) RPARENTHESE(G). { A = new NTToken(); A->type = 565; A->copyBools(D); A->ssVars[F->query] = 1; A->ssVars += D->ssVars; A->bindVar[F->query] = 1; A->vars = D->vars + F->vars; A->bNodes = D->bNodes; A->query = D->query . ' AS ' . F->query; A->childs = array(B, C, D, E, F, G); }

inlineData(A) ::= VALUES(B) dataBlock(C). { A = new NTToken(); A->type = 566; A->vars = C->vars; A->query = C->query; A->childs = array(B, C); }

dataBlock(A) ::= inlineDataOneVar(B). { A = new NTToken(); A->type = 567; A->vars = B->vars; A->query = B->query; A->childs = array(B); }
dataBlock(A) ::= inlineDataFull(B). { A = new NTToken(); A->type = 567; A->vars = B->vars; A->query = B->query; A->childs = array(B); }

inlineDataOneVar(A) ::= var(B) LBRACE(C) dataBlockValueX(D) RBRACE(E). { A = new NTToken(); A->type = 568; A->vars = B->vars; A->query = B->query . ' { ' . D->query .  ' }'; A->childs = array(B, C, D, E); }
inlineDataOneVar(A) ::= var(B) LBRACE(C) RBRACE(D). { A = new NTToken(); A->type = 568; A->vars = B->vars; A->query = B->query . '{ }'; A->childs = array(B, C, D); }
dataBlockValueX(A) ::= dataBlockValueX(B) dataBlockValue(C). { A = new NTToken(); A->type = 569; A->count = B->count + 1; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
dataBlockValueX(A) ::= dataBlockValue(B). { A = new NTToken(); A->type = 569; A->count = 1; A->query = B->query; A->childs = array(B); }

inlineDataFull(A) ::= LPARENTHESE(B) varX(C) RPARENTHESE(D) LBRACE(E) inlineDataFullX(F) RBRACE(G). {if(F->count > 0 ){if(C->count == F->count){ A = new NTToken(); A->type = 570; A->vars = C->vars; A->query = '( ' . C->query . ' ) {' . PHP_EOL . F->query . ' }';}else{throw new Exception("Different Amount of Variables and Values for Value Clause : " . C->query . ' and ' . F->query);}}else{A = new NTToken(); A->type = 570; A->vars = C->vars; A->query = '( ' . C->query . ' ) {' . PHP_EOL . F->query . ' }';}A->childs = array(B, C, D, E, F, G); }
inlineDataFull(A) ::= NIL(B) LBRACE(C) nilX(D) RBRACE(E). { A = new NTToken(); A->type = 570; A->query = '( ) { ' . D->query . ' }'; A->childs = array(B, C, D, E); }
inlineDataFull(A) ::= NIL(B) LBRACE(C) RBRACE(D). { A = new NTToken(); A->type = 570; A->query = '( ) { }'; A->childs = array(B, C, D); }
nilX(A) ::= nilX(B) NIL(C).{ A = new NTToken(); A->type = 571; A->query = B->query . ' ( )'; A->childs = array(B, C); }
nilX(A) ::= NIL(B). { A = new NTToken(); A->type = 571; A->query = '( )'; A->childs = array(B); }
varX(A) ::= varX(B) var(C). { A = new NTToken(); A->type = 572; A->count = B->count + 1; A->vars = B->vars + C->vars; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
varX(A) ::= var(B). { A = new NTToken(); A->type = 572; A->vars = B->vars; A->count = 1; A->query = B->query; A->childs = array(B); }
inlineDataFullX(A) ::= inlineDataFullX(B) LPARENTHESE(C) dataBlockValueX(D) RPARENTHESE(E). {if(B->count > 0 ){if(B->count == D->count){ A = new NTToken(); A->type = 573; A->count = B->count; A->query = B->query . PHP_EOL . '( ' . D->query . ' )';}else{throw new Exception("Different Amount of Values for Value Clause : " . B->query . ' and ' . C->query);}}else{A = new NTToken(); A->type = 573; A->count = D->count; A->query = B->query . PHP_EOL . '( ' . D->query . ' )';}A->childs = array(B, C, D, E); }
inlineDataFullX(A) ::= inlineDataFullX(B) NIL(C). { A = new NTToken(); A->type = 573; A->query = B->query . PHP_EOL . '( )'; A->childs = array(B, C); }
inlineDataFullX(A) ::= LPARENTHESE(B) dataBlockValueX(C) RPARENTHESE(D).  { A = new NTToken(); A->type = 573; A->count = C->count; A->query = '( ' . C->query . ' )'; A->childs = array(B, C, D); }
inlineDataFullX(A) ::= NIL(B). { A = new NTToken(); A->type = 573; A->query = '( )'; A->childs = array(B); }

dataBlockValue(A) ::= iri(B). { A = new NTToken(); A->type = 574; A->query = B->query; A->childs = array(B); }
dataBlockValue(A) ::= rdfLiteral(B). { A = new NTToken(); A->type = 574; A->query = B->query; A->childs = array(B); }
dataBlockValue(A) ::= numericLiteral(B). { A = new NTToken(); A->type = 574; A->query = B->query; A->childs = array(B); }
dataBlockValue(A) ::= booleanLiteral(B). { A = new NTToken(); A->type = 574; A->query = B->query; A->childs = array(B); }
dataBlockValue(A) ::= UNDEF(B). { A = new NTToken(); A->type = 574; A->query = 'UNDEF'; A->childs = array(B); }

minusGraphPattern(A) ::= SMINUS(B) groupGraphPattern(C). { A = new NTToken(); A->type = 575; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = 'MINUS ' . PHP_EOL .  C->query; A->childs = array(B, C); }

groupOrUnionGraphPattern(A) ::= groupGraphPattern(B) groupOrUnionGraphPatternX(C). { A = new NTToken(); A->type = 576; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars + C->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . PHP_EOL . C->query; A->childs = array(B, C); }
groupOrUnionGraphPattern(A) ::= groupGraphPattern(B). { A = new NTToken(); A->type = 576; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
groupOrUnionGraphPatternX(A) ::= groupOrUnionGraphPatternX(B) UNION(C) groupGraphPattern(D). { A = new NTToken(); A->type = 577; A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars + D->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . PHP_EOL . ' UNION ' . PHP_EOL . D->query; A->childs = array(B, C, D); }
groupOrUnionGraphPatternX(A) ::= UNION(B) GroupGraphPattern(C). { A = new NTToken(); A->type = 577; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = 'UNION ' . PHP_EOL . C->query; A->childs = array(B, C); }

filter(A) ::= FILTER(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 578; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'FILTER ( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
filter(A) ::= FILTER(B) builtInCall(C). { A = new NTToken(); A->type = 578; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = 'FILTER ' . C->query; A->childs = array(B, C); }
filter(A) ::= FILTER(B) functionCall(C). { A = new NTToken(); A->type = 578; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = 'FILTER ' . C->query; A->childs = array(B, C); }

functionCall(A) ::= iri(B) argList(C). { A = new NTToken(); A->type = 579; A->hasFNC = true; A->hasAGG = true; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = B->query . C->query; A->childs = array(B, C); }

argList(A) ::= LPARENTHESE(B) DISTINCT(C) expression(D) argListX(E) RPARENTHESE(F). { A = new NTToken(); A->type = 580; A->copyBools(D); A->copyBools(E); A->vars = D->vars + E->vars; A->bNodes = D->bNodes + E->bNodes; A->query = '( DISTINCT' . D->query . PHP_EOL . E->query .  ' )'; A->childs = array(B, C, D, E, F); }
argList(A) ::= LPARENTHESE(B) expression(C) argListX(D) RPARENTHESE(E). { A = new NTToken(); A->type = 580; A->copyBools(C); A->copyBools(D); A->vars = C->vars +  D->vars; A->bNodes = C->bNodes + D->bNodes; A->query = '( ' . C->query . PHP_EOL . D->query .  ' )'; A->childs = array(B, C, D, E); }
argList(A) ::= NIL(B). { A = new NTToken(); A->type = 580; A->query = '( )' . PHP_EOL; A->childs = array(B); }
argListX(A) ::= argListX(B) COMMA(C) expression(D). { A = new NTToken(); A->type = 581; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ', ' . PHP_EOL . D->query; A->childs = array(B, C, D); }
argListX(A) ::= COMMA(B) expression(C). { A = new NTToken(); A->type = 581; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = ', ' . PHP_EOL . C->query; A->childs = array(B, C); }

expressionList(A) ::= LPARENTHESE(B) expression(C) argListX(D) RPARENTHESE(E). { A = new NTToken(); A->type = 582; A->copyBools(C); A->copyBools(D); A->vars = C->vars + D->vars; A->bNodes = C->bNodes + D->bNodes; A->query = '( ' . C->query . PHP_EOL . D->query .  ' )'; A->childs = array(B, C, D, E); }
expressionList(A) ::= NIL(B) LBRACE(C) RBRACE(D). { A = new NTToken(); A->type = 582; A->query = '( )' . PHP_EOL; A->childs = array(B, C, D); }

triplesSameSubject(A) ::= varOrTerm(B) propertyListNotEmpty(C). { A = new NTToken(); A->type = 583; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
triplesSameSubject(A) ::= triplesNode(B) propertyListNotEmpty(C). { A = new NTToken(); A->type = 583; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
triplesSameSubject(A) ::= triplesNode(B). { A = new NTToken(); A->type = 583; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

propertyListNotEmpty(A) ::= verb(B) objectList(C) propertyListNotEmptyX(D). { A = new NTToken(); A->type = 584; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + C->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . ' ' . C->query . ' ' . D->query; A->childs = array(B, C, D); }
propertyListNotEmpty(A) ::= verb(B) objectList(C). { A = new NTToken(); A->type = 584; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
propertyListNotEmptyX(A) ::= propertyListNotEmptyX(B) SEMICOLON(C) verb(D) objectList(E). { A = new NTToken(); A->type = 585; A->copyBools(B); A->copyBools(D); A->copyBools(E); A->vars = B->vars + D->vars + E->vars; A->bNodes = B->bNodes + D->bNodes + E->bNodes; A->query = B->query . '; ' . D->query . ' ' . E->query; A->childs = array(B, C, D, E); }
propertyListNotEmptyX(A) ::= propertyListNotEmptyX(B) SEMICOLON(C). { A = new NTToken(); A->type = 585; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query. ';'; A->childs = array(B, C); }
propertyListNotEmptyX(A) ::= SEMICOLON(B) verb(C) objectList(D). { A = new NTToken(); A->type = 585; A->copyBools(C); A->copyBools(D); A->vars = C->vars + D->vars; A->bNodes = C->bNodes + D->bNodes; A->query = '; ' . C->query . ' ' . D->query; A->childs = array(B, C, D); }
propertyListNotEmptyX(A) ::= SEMICOLON(B). { A = new NTToken(); A->type = 585; A->query = ';'; A->childs = array(B); }

verb(A) ::= varOrIri(B). { A = new NTToken(); A->type = 586; A->vars = B->vars; A->query = B->query; A->childs = array(B); }
verb(A) ::= A(B). { if(!checkNS('rdf:type')){throw new Exception("Missing Prefix for rdf:type (a)");} A = new NTToken(); A->type = 586; A->query = 'rdf:type'; A->childs = array(B); }

objectList(A) ::= graphNode(B) objectListX(C). { A = new NTToken(); A->type = 587; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
objectList(A) ::= graphNode(B). { A = new NTToken(); A->type = 587; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
objectListX(A) ::= objectListX(B) COMMA(C) graphNode(D). { A = new NTToken(); A->type = 588; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ', ' . D->query; A->childs = array(B, C, D); }
objectListX(A) ::= COMMA(B) graphNode(C). { A = new NTToken(); A->type = 588; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = ', ' . C->query; A->childs = array(B, C); }

triplesSameSubjectPath(A) ::= varOrTerm(B) propertyListPathNotEmpty(C). { A = new NTToken(); A->type = 589; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
triplesSameSubjectPath(A) ::= triplesNodePath(B) propertyListPathNotEmpty(C). { A = new NTToken(); A->type = 589; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
triplesSameSubjectPath(A) ::= triplesNodePath(B). { A = new NTToken(); A->type = 589; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

propertyListPathNotEmpty(A) ::= pathAlternative(B) objectListPath(C) propertyListPathNotEmptyX(D). { A = new NTToken(); A->type = 590; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = B->bNodes + C->bNodes + D->bNodes; A->query = B->query . ' ' . C->query . ' ' . D->query; A->childs = array(B, C, D); }
propertyListPathNotEmpty(A) ::= var(B) objectListPath(C) propertyListPathNotEmptyX(D). { A = new NTToken(); A->type = 590; A->copyBools(C); A->copyBools(D); A->vars = B->vars + C->vars + D->vars; A->bNodes = C->bNodes + D->bNodes; A->query = B->query . ' ' . C->query . ' ' . D->query; A->childs = array(B, C, D); }
propertyListPathNotEmpty(A) ::= pathAlternative(B) objectListPath(C). { A = new NTToken(); A->type = 590; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
propertyListPathNotEmpty(A) ::= var(B) objectListPath(C). { A = new NTToken(); A->type = 590; A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
propertyListPathNotEmptyX(A) ::= propertyListPathNotEmptyX(B) SEMICOLON(C) pathAlternative(D) objectList(E). { A = new NTToken(); A->type = 591; A->copyBools(B); A->copyBools(D); A->copyBools(E); A->vars = B->vars + D->vars + E->vars; A->bNodes = B->bNodes + D->bNodes + E->bNodes; A->query = B->query . '; ' . D->query . ' ' . E->query; A->childs = array(B, C, D, E); }
propertyListPathNotEmptyX(A) ::= propertyListPathNotEmptyX(B) SEMICOLON(C) var(D) objectList(E). { A = new NTToken(); A->type = 591; A->copyBools(B); A->copyBools(E); A->vars = B->vars + D->vars + E->vars; A->bNodes = B->bNodes + E->bNodes; A->query = B->query . '; ' . D->query . ' ' . E->query; A->childs = array(B, C, D, E); }
propertyListPathNotEmptyX(A) ::= propertyListPathNotEmptyX(B) SEMICOLON(C). { A = new NTToken(); A->type = 591; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query. ';'; A->childs = array(B, C); }
propertyListPathNotEmptyX(A) ::= SEMICOLON(B) pathAlternative(C) objectList(D). { A = new NTToken(); A->type = 591; A->copyBools(C); A->copyBools(D); A->vars = C->vars + D->vars; A->bNodes = C->bNodes + D->bNodes; A->query = '; ' . C->query . ' ' . D->query; A->childs = array(B, C, D); }
propertyListPathNotEmptyX(A) ::= SEMICOLON(B) var(C) objectList(D). { A = new NTToken(); A->type = 591; A->copyBools(D); A->vars = C->vars + D->vars; A->bNodes = D->bNodes; A->query = '; ' . ' ' . C->query . D->query; A->childs = array(B, C, D); }
propertyListPathNotEmptyX(A) ::= SEMICOLON(B). { A = new NTToken(); A->type = 591; A->query = ';'; A->childs = array(B); }

objectListPath(A) ::= graphNodePath(B) objectListPathX(C). { A = new NTToken(); A->type = 592; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . C->query; A->childs = array(B, C); }
objectListPath(A) ::= graphNodePath(B). { A = new NTToken(); A->type = 592; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
objectListPathX(A) ::= objectListPathX(B) COMMA(C) graphNodePath(D). { A = new NTToken(); A->type = 593; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ', ' . D->query; A->childs = array(B, C, D); }
objectListPathX(A) ::= COMMA(B) graphNodePath(C). { A = new NTToken(); A->type = 593; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = ', ' . C->query; A->childs = array(B, C); }

pathAlternative(A) ::= pathSequence(B) pathAlternativeX(C). { A = new NTToken(); A->type = 594; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . C->query; A->childs = array(B, C); }
pathAlternative(A) ::= pathSequence(B). { A = new NTToken(); A->type = 594; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
pathAlternativeX(A) ::= pathAlternativeX(B) VBAR(C) pathSequence(D). { A = new NTToken(); A->type = 595; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . '|' . D->query; A->childs = array(B, C, D); }
pathAlternativeX(A) ::= VBAR(B) pathSequence(C). { A = new NTToken(); A->type = 595; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = '|' . C->query; A->childs = array(B, C); }

pathSequence(A) ::= pathEltOrInverse(B) pathSequenceX(C). { A = new NTToken(); A->type = 596; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . C->query; A->childs = array(B, C); }
pathSequence(A) ::= pathEltOrInverse(B). { A = new NTToken(); A->type = 596; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
pathSequenceX(A) ::= pathSequenceX(B) SLASH(C) pathEltOrInverse(D). { A = new NTToken(); A->type = 597; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . '/' . D->query; A->childs = array(B, C, D); }
pathSequenceX(A) ::= SLASH(B) pathEltOrInverse(C). { A = new NTToken(); A->type = 597; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = '/' . C->query; A->childs = array(B, C); }

pathElt(A) ::= pathPrimary(B) pathMod(C). { A = new NTToken(); A->type = 598; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query . C->query; A->childs = array(B, C); }
pathElt(A) ::= pathPrimary(B). { A = new NTToken(); A->type = 598; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

pathEltOrInverse(A) ::= HAT(B) pathElt(C). { A = new NTToken(); A->type = 599; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = '^' . C->query; A->childs = array(B, C); }
pathEltOrInverse(A) ::= pathElt(B). { A = new NTToken(); A->type = 599; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

pathMod(A) ::= STAR(B). { A = new NTToken(); A->type = 600; A->query = '*'; A->childs = array(B); }
pathMod(A) ::= PLUS(B). { A = new NTToken(); A->type = 600; A->query = '+'; A->childs = array(B); }
pathMod(A) ::= QUESTION(B). { A = new NTToken(); A->type = 600; A->query = '?'; A->childs = array(B); }

pathPrimary(A) ::= LPARENTHESE(B) pathAlternative(C) RPARENTHESE(D). { A = new NTToken(); A->type = 601; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = '( ' . C->query . ' )'; A->childs = array(B, C, D); }
pathPrimary(A) ::= EXCLAMATION(B) pathNegatedPropertySet(C). { A = new NTToken(); A->type = 601; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = '!' . C->query; A->childs = array(B, C); }
pathPrimary(A) ::= A(B). { if(!checkNS('rdf:type')){throw new Exception("Missing Prefix for rdf:type (a)");} A = new NTToken(); A->type = 601; A->query = 'rdf:type'; A->childs = array(B); }
pathPrimary(A) ::= iri(B). { A = new NTToken(); A->type = 601; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

pathNegatedPropertySet(A) ::= LPARENTHESE(B) pathOneInPropertySet(C) pathNegatedPropertySetX(D) RPARENTHESE(E). { A = new NTToken(); A->type = 602; A->copyBools(C); A->copyBools(D); A->vars = C->vars + D->vars; A->bNodes = C->bNodes + D->bNodes; A->query = C->query . ' ' . D->query; A->childs = array(B, C, D, E); }
pathNegatedPropertySet(A) ::= LPARENTHESE(B) pathOneInPropertySet(C) RPARENTHESE(D). { A = new NTToken(); A->type = 602; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = '( ' . C->query . ' )'; A->childs = array(B, C, D); }
pathNegatedPropertySet(A) ::= LPARENTHESE(B) RPARENTHESE(C). { A = new NTToken(); A->type = 602; A->query = '( )'; A->childs = array(B, C); }
pathNegatedPropertySet(A) ::= pathOneInPropertySet(B). { A = new NTToken(); A->type = 602; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
pathNegatedPropertySetX(A) ::= pathNegatedPropertySetX(B) VBAR(C) pathOneInPropertySet(D). { A = new NTToken(); A->type = 603; A->copyBools(B); A->copyBools(D); A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . '|' . D->query; A->childs = array(B, C, D); }
pathNegatedPropertySetX(A) ::= VBAR pathOneInPropertySet(B). { A = new NTToken(); A->type = 603; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = '|' . B->query; A->childs = array(B); }

pathOneInPropertySet(A) ::= HAT(B) iri(C). { A = new NTToken(); A->type = 604; A->query = '^' . C->query; A->childs = array(B, C); }
pathOneInPropertySet(A) ::= HAT(B) A(C). { if(!checkNS('rdf:type')){throw new Exception("Missing Prefix for rdf:type (a)");} A = new NTToken(); A->type = 604; ; A->query = '^rdf:type'; A->childs = array(B, C); }
pathOneInPropertySet(A) ::= A(B). { if(!checkNS('rdf:type')){throw new Exception("Missing Prefix for rdf:type (a)");} A = new NTToken(); A->type = 604; A->query = 'rdf:type'; A->childs = array(B); }
pathOneInPropertySet(A) ::= iri(B). { A = new NTToken(); A->type = 604; A->query = B->query; A->childs = array(B); }

triplesNode(A) ::= collection(B). { A = new NTToken(); A->type = 605; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
triplesNode(A) ::= blankNodePropertyList(B). { A = new NTToken(); A->type = 605; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

blankNodePropertyList(A) ::= LBRACKET(B) propertyListNotEmpty(C) RBRACKET(D). { A = new NTToken(); A->type = 606; A->hasBN = true; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = '[ ' . C->query . ' ]'; A->childs = array(B, C, D); }

triplesNodePath(A) ::= collectionPath(B). { A = new NTToken(); A->type = 607; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
triplesNodePath(A) ::= blankNodePropertyListPath(B). { A = new NTToken(); A->type = 607; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

blankNodePropertyListPath(A) ::= LBRACKET(B) propertyListPathNotEmpty(C) RBRACKET(D). { A = new NTToken(); A->type = 608; A->hasBN = true; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = '[ ' . C->query . ' ]'; A->childs = array(B, C, D); }

collection(A) ::= LPARENTHESE(B) graphNodeX(C) RPARENTHESE(D). { A = new NTToken(); A->type = 609; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = '( ' . C->query . ' )'; A->childs = array(B, C, D); }
graphNodeX(A) ::= graphNodeX(B) graphNode(C). { A = new NTToken(); A->type = 610; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
graphNodeX(A) ::= graphNode(B). { A = new NTToken(); A->type = 610; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

collectionPath(A) ::= LPARENTHESE(B) graphNodePathX(C) RPARENTHESE(D). { A = new NTToken(); A->type = 611; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = '( ' . C->query . ' )'; A->childs = array(B, C, D); }
graphNodePathX(A) ::= graphNodePathX(B) graphNodePath(C). { A = new NTToken(); A->type = 612; A->copyBools(B); A->copyBools(C); A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
graphNodePathX(A) ::= graphNodePath(B). { A = new NTToken(); A->type = 612; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

graphNode(A) ::= varOrTerm(B). { A = new NTToken(); A->type = 613; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
graphNode(A) ::= triplesNode(B). { A = new NTToken(); A->type = 613; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

graphNodePath(A) ::= varOrTerm(B). { A = new NTToken(); A->type = 614; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
graphNodePath(A) ::= triplesNodePath(B).  { A = new NTToken(); A->type = 614; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

varOrTerm(A) ::= var(B). { A = new NTToken(); A->type = 615; A->vars = B->vars; A->query = B->query; A->childs = array(B); }
varOrTerm(A) ::= graphTerm(B). { A = new NTToken(); A->type = 615; A->copyBools(B); A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

varOrIri(A) ::= var(B). { A = new NTToken(); A->type = 616; A->vars = B->vars; A->query = B->query; A->childs = array(B); }
varOrIri(A) ::= iri(B). { A = new NTToken(); A->type = 616; A->query = B->query; A->childs = array(B); }

var(A) ::= VAR1(B). { A = new NTToken(); A->type = 617; A->vars = array(); A->vars[B->value] = 1; A->query = B->value; A->childs = array(B); }
var(A) ::= VAR2(B). { A = new NTToken(); A->type = 617; A->vars = array(); A->vars[B->value] = 1; A->query = B->value; A->childs = array(B); }

graphTerm(A) ::= iri(B). { A = new NTToken(); A->type = 618; A->query = B->query; A->childs = array(B); }
graphTerm(A) ::= rdfLiteral(B). { A = new NTToken(); A->type = 618; A->query = B->query; A->childs = array(B); }
graphTerm(A) ::= numericLiteral(B). { A = new NTToken(); A->type = 618; A->query = B->query; A->childs = array(B); }
graphTerm(A) ::= booleanLiteral(B). { A = new NTToken(); A->type = 618; A->query = B->query; A->childs = array(B); }
graphTerm(A) ::= blankNode(B). { A = new NTToken(); A->type = 618; A->copyBools(B); A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
graphTerm(A) ::= NIL(B). { A = new NTToken(); A->type = 618; A->query = '( )'; A->childs = array(B); }

expression(A) ::= conditionalAndExpression(B) conditionalOrExpressionX(C). { A = new NTToken(); A->type = 619; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
expression(A) ::= conditionalAndExpression(B). { A = new NTToken(); A->type = 619; A->copyBools(B);A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
conditionalOrExpressionX(A) ::= conditionalOrExpressionX(B) OR(C) conditionalAndExpression(D). { A = new NTToken(); A->type = 620; A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars + D->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' || ' . D->query; A->childs = array(B, C, D); }
conditionalOrExpressionX(A) ::= OR(B) conditionalAndExpression(C). { A = new NTToken(); A->type = 620; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '|| ' . C->query; A->childs = array(B, C); }

conditionalAndExpression(A) ::= relationalExpression(B) conditionalAndExpressionX(C). { A = new NTToken(); A->type = 621; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
conditionalAndExpression(A) ::= relationalExpression(B). { A = new NTToken(); A->type = 621; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
conditionalAndExpressionX(A) ::= conditionalAndExpressionX(B) AND(C) relationalExpression(D). { A = new NTToken(); A->type = 622; A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars + D->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' && ' . D->query; A->childs = array(B, C, D); }
conditionalAndExpressionX(A) ::= AND(B) relationalExpression(C). { A = new NTToken(); A->type = 622; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '&& ' . C->query; A->childs = array(B, C); }

relationalExpression(A) ::= additiveExpression(B) relationalExpressionX(C). { A = new NTToken(); A->type = 623; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
relationalExpression(A) ::= additiveExpression(B). { A = new NTToken(); A->type = 623; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
relationalExpressionX(A) ::= EQUAL(B) additiveExpression(C). { A = new NTToken(); A->type = 624; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '= ' . C->query; A->childs = array(B, C); }
relationalExpressionX(A) ::= NEQUAL(B) additiveExpression(C). { A = new NTToken(); A->type = 624; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '!= ' . C->query; A->childs = array(B, C); }
relationalExpressionX(A) ::= SMALLERTHEN(B) additiveExpression(C). { A = new NTToken(); A->type = 624; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '< ' . C->query; A->childs = array(B, C); }
relationalExpressionX(A) ::= GREATERTHEN(B) additiveExpression(C). { A = new NTToken(); A->type = 624; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '> ' . C->query; A->childs = array(B, C); }
relationalExpressionX(A) ::= SMALLERTHENQ(B) additiveExpression(C). { A = new NTToken(); A->type = 624; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '<= ' . C->query; A->childs = array(B, C); }
relationalExpressionX(A) ::= GREATERTHENQ(B) additiveExpression(C). { A = new NTToken(); A->type = 624; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '>= ' . C->query; A->childs = array(B, C); }
relationalExpressionX(A) ::= IN(B) expressionList(C). { A = new NTToken(); A->type = 624; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = 'IN' . C->query; A->childs = array(B, C); }
relationalExpressionX(A) ::= NOT(B) IN(C) expressionList(D). { A = new NTToken(); A->type = 624; A->copyBools(D); A->ssVars = D->ssVars; A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'NOT IN' . D->query; A->childs = array(B, C, D); }

additiveExpression(A) ::= multiplicativeExpression(B) additiveExpressionX(C). { A = new NTToken(); A->type = 625; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
additiveExpression(A) ::= multiplicativeExpression(B). { A = new NTToken(); A->type = 625; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralPositive(C) additiveExpressionY(D). { A = new NTToken(); A->type = 626; A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' ' . C->query . ' ' . D->query; A->childs = array(B, C, D); }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralNegative(C) additiveExpressionY(D). { A = new NTToken(); A->type = 626; A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' ' . C->query . ' ' . D->query; A->childs = array(B, C, D); }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralPositive(C). { A = new NTToken(); A->type = 626; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralNegative(C). { A = new NTToken(); A->type = 626; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
additiveExpressionX(A) ::= additiveExpressionX(B) PLUS(C) multiplicativeExpression(D). { A = new NTToken(); A->type = 626; A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars + D->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' + ' . D->query; A->childs = array(B, C, D); }
additiveExpressionX(A) ::= additiveExpressionX(B) MINUS(C) multiplicativeExpression(D). { A = new NTToken(); A->type = 626; A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars + D->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' - ' . D->query; A->childs = array(B, C, D); }
additiveExpressionX(A) ::= numericLiteralPositive(B) additiveExpressionY(C). { A = new NTToken(); A->type = 626; A->copyBools(C); A->ssVars = B->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
additiveExpressionX(A) ::= numericLiteralNegative(B) additiveExpressionY(C). { A = new NTToken(); A->type = 626; A->copyBools(C); A->ssVars = B->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); }
additiveExpressionX(A) ::= numericLiteralPositive(B). { A = new NTToken(); A->type = 626; A->query = B->query; A->childs = array(B); }
additiveExpressionX(A) ::= numericLiteralNegative(B). { A = new NTToken(); A->type = 626; A->query = B->query; A->childs = array(B); }
additiveExpressionX(A) ::= PLUS(B) multiplicativeExpression(C). { A = new NTToken(); A->type = 626; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '+ ' . C->query; A->childs = array(B, C); }
additiveExpressionX(A) ::= MINUS(B) multiplicativeExpression(C). { A = new NTToken(); A->type = 626; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '- ' . C->query; A->childs = array(B, C); }
additiveExpressionY(A) ::= additiveExpressionY(B) STAR(C) unaryExpression(D). { A = new NTToken(); A->type = 627; A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars + D->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' * ' . D->query; A->childs = array(B, C, D); }
additiveExpressionY(A) ::= additiveExpressionY(B) SLASH(C) unaryExpression(D). { A = new NTToken(); A->type = 627; A->copyBools(B); A->copyBools(D); A->ssVars = B->ssVars + D->ssVars; A->vars = B->vars + D->vars; A->bNodes = B->bNodes + D->bNodes; A->query = B->query . ' / ' . D->query; A->childs = array(B, C, D); }
additiveExpressionY(A) ::= STAR(B) unaryExpression(C). { A = new NTToken(); A->type = 627; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '* ' . C->query; A->childs = array(B, C); }
additiveExpressionY(A) ::= SLASH(B) unaryExpression(C). { A = new NTToken(); A->type = 627; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '/ ' . C->query; A->childs = array(B, C); }

multiplicativeExpression(A) ::= unaryExpression(B) additiveExpressionY(C). { A = new NTToken(); A->type = 628; A->copyBools(B); A->copyBools(C); A->ssVars = B->ssVars; A->vars = B->vars + C->vars; A->bNodes = B->bNodes + C->bNodes; A->query = B->query . ' ' . C->query; A->childs = array(B, C); } 
multiplicativeExpression(A) ::= unaryExpression(B). { A = new NTToken(); A->type = 628; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

unaryExpression(A) ::= EXCLAMATION(B) primaryExpression(C). { A = new NTToken(); A->type = 629; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '! ' . C->query; A->childs = array(B, C); }
unaryExpression(A) ::= PLUS(B) primaryExpression(C). { A = new NTToken(); A->type = 629; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '+ ' . C->query; A->childs = array(B, C); }
unaryExpression(A) ::= MINUS(B) primaryExpression(C). { A = new NTToken(); A->type = 629; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '- ' . C->query; A->childs = array(B, C); }
unaryExpression(A) ::= primaryExpression(B). { A = new NTToken(); A->type = 629; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }

primaryExpression(A) ::= LPARENTHESE(B) expression(C) RPARENTHESE(D). { A = new NTToken(); A->type = 630; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = '( ' . C->query . ' )'; A->childs = array(B, C, D); }
primaryExpression(A) ::= builtInCall(B). { A = new NTToken(); A->type = 630; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
primaryExpression(A) ::= iri(B). { A = new NTToken(); A->type = 630; A->query = B->query; A->childs = array(B); }
primaryExpression(A) ::= functionCall(B). { A = new NTToken(); A->type = 630; A->hasFNC = true; A->hasAGG = true; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
primaryExpression(A) ::= rdfLiteral(B). { A = new NTToken(); A->type = 630; A->query = B->query; A->childs = array(B); }
primaryExpression(A) ::= numericLiteral(B). { A = new NTToken(); A->type = 630; A->query = B->query; A->childs = array(B); }
primaryExpression(A) ::= booleanLiteral(B). { A = new NTToken(); A->type = 630; A->query = B->query; A->childs = array(B); }
primaryExpression(A) ::= var(B). { A = new NTToken(); A->type = 630; A->vars = B->vars; A->query = B->query; A->childs = array(B); }

builtInCall(A) ::= aggregate(B). { A = new NTToken(); A->type = 631; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
builtInCall(A) ::= regexExpression(B). { A = new NTToken(); A->type = 631; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
builtInCall(A) ::= existsFunc(B). { A = new NTToken(); A->type = 631; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
builtInCall(A) ::= notExistsFunc(B). { A = new NTToken(); A->type = 631; A->copyBools(B); A->ssVars = B->ssVars; A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
builtInCall(A) ::= STR(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'STR( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= LANG(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'STR( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= LANGMATCHES(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) RPARENTHESE(G). { A = new NTToken(); A->type = 631; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'LANGMATCHES( ' . D->query . ', ' . F->query . ' )'; A->childs = array(B, C, D, E, G); }
builtInCall(A) ::= DATATYPE(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'DATATYPE( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= BOUND(B) LPARENTHESE(C) var(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->vars = D->vars; A->query = 'BOUND( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= URI(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'URI( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= BNODE(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->hasBN = true; A->copyBools(D); A->vars = D->vars; A->bNodes[D->query] = 1; A->bNodes += D->bNodes; A->query = 'BNODE( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= BNODE(B) NIL(C). { A = new NTToken(); A->type = 631; A->hasBN = true; A->query = 'BNODE( )'; A->childs = array(B, C); }
builtInCall(A) ::= RAND(B) NIL(C). { A = new NTToken(); A->type = 631; A->query = 'RAND( )'; A->childs = array(B, C); }
builtInCall(A) ::= ABS(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'ABS(' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= CEIL(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars;A->bNodes = D->bNodes; A->query = 'CEIL(' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= FLOOR(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'FLOOR(' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= ROUND(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'ROUND(' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= CONCAT(B) expressionList(C). { A = new NTToken(); A->type = 631; A->copyBools(C); A->vars = C->vars;A->bNodes = C->bNodes; A->query = 'CONCAT' . C->query; A->childs = array(B, C); }
builtInCall(A) ::= subStringExpression(B). { A = new NTToken(); A->type = 631; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
builtInCall(A) ::= STRLEN(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'STRLEN( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= strReplaceExpression(B). { A = new NTToken(); A->type = 631; A->copyBools(B); A->vars = B->vars; A->bNodes = B->bNodes; A->query = B->query; A->childs = array(B); }
builtInCall(A) ::= UCASE(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'UCASE( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= LCASE(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query =  'LCASE( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= ENCODE_FOR_URI(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'ENCODE_FOR_URI( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= CONTAINS(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) RPARENTHESE(G). { A = new NTToken(); A->type = 631; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'CONTAINS( ' . D->query . ', ' . F->query .  ' )'; A->childs = array(B, C, D, E, F, G); }
builtInCall(A) ::= STRSTARTS(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) RPARENTHESE(G). { A = new NTToken(); A->type = 631; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'STRSTARTS( ' . D->query . ', ' . F->query .  ' )'; A->childs = array(B, C, D, E, F, G); }
builtInCall(A) ::= STRENDS(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) RPARENTHESE(G). { A = new NTToken(); A->type = 631; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'STRENDS( ' . D->query . ', ' . F->query .  ' )'; A->childs = array(B, C, D, E, F, G); }
builtInCall(A) ::= STBEFORE(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) RPARENTHESE(G). { A = new NTToken(); A->type = 631; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'STBEFORE( ' . D->query . ', ' . F->query .  ' )'; A->childs = array(B, C, D, E, F, G); }
builtInCall(A) ::= STRAFTER(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) RPARENTHESE(G). { A = new NTToken(); A->type = 631; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'STRAFTER( ' . D->query . ', ' . F->query .  ' )'; A->childs = array(B, C, D, E, F, G); }
builtInCall(A) ::= YEAR(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'YEAR( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= MONTH(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'MONTH( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= DAY(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'DAY( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= HOURS(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'HOURS( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= MINUTES(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'MINUTES( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= SECONDS(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'SECONDS( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= TIMEZONE(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'TIMEZONE( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= TZ(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'TZ( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= NOW(B) NIL(C). { A = new NTToken(); A->type = 631; A->query = 'NOW( )'; A->childs = array(B, C); }
builtInCall(A) ::= UUID(B) NIL(C). { A = new NTToken(); A->type = 631; A->query = 'UUID( )'; A->childs = array(B, C); }
builtInCall(A) ::= STRUUID(B) NIL(C). { A = new NTToken(); A->type = 631; A->query = 'STRUUID( )'; A->childs = array(B, C); }
builtInCall(A) ::= MD5(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'MD5( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= SHA1(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'SHA1( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= SHA256(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'SHA256( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= SHA384(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'SHA384( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= SHA512(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'SHA512( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= COALESCE(B) expressionList(C). { A = new NTToken(); A->type = 631; A->copyBools(C); A->vars = C->vars; A->bNodes = C->bNodes; A->query = 'COALESCE' . C->query; A->childs = array(B, C); }
builtInCall(A) ::= IF(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) COMMA(G) expression(H) RPARENTHESE(I). { A = new NTToken(); A->type = 631; A->copyBools(D); A->copyBools(F); A->copyBools(H); A->vars = D->vars + F->vars + H->vars; A->bNodes = D->bNodes + F->bNodes + H->bNodes; A->query = 'IF( ' . D->query . ', ' . F->query .  ', ' . H->query . ' )'; A->childs = array(B, C, D, E, F, G, H, I); }
builtInCall(A) ::= STRLANG(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) RPARENTHESE(G). { A = new NTToken(); A->type = 631; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'STRLANG( ' . D->query . ', ' . F->query .  ' )'; A->childs = array(B, C, D, E, F, G); }
builtInCall(A) ::= STRDT(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) RPARENTHESE(G). { A = new NTToken(); A->type = 631; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'STRDT( ' . D->query . ', ' . F->query .  ' )'; A->childs = array(B, C, D, E, F, G); }
builtInCall(A) ::= SAMETERM(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) RPARENTHESE(G). { A = new NTToken(); A->type = 631; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'SAMETERM( ' . D->query . ', ' . F->query .  ' )'; A->childs = array(B, C, D, E, F, G); }
builtInCall(A) ::= ISIRI(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'ISIRI( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= ISURI(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'ISURI( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= ISBLANK(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'ISBLANK( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= ISLITERAL(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'ISLITERAL( ' . D->query . ' )'; A->childs = array(B, C, D, E); }
builtInCall(A) ::= ISNUMERIC(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 631; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'ISNUMERIC( ' . D->query . ' )'; A->childs = array(B, C, D, E); }

regexExpression(A) ::= REGEX(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) COMMA(G) expression(H) RPARENTHESE(I). { A = new NTToken(); A->type = 632; A->copyBools(D); A->copyBools(F); A->copyBools(H); A->vars = D->vars + F->vars + H->vars; A->bNodes = D->bNodes + F->bNodes + H->bNodes; A->query = 'REGEX( ' . D->query . ', ' . F->query . ', ' . H->query . ' )'; A->childs = array(B, C, D, E, F, G, H, I); }
regexExpression(A) ::= REGEX(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) RPARENTHESE(G).{ A = new NTToken(); A->type = 632; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'REGEX( ' . D->query . ', ' . F->query . ' )'; A->childs = array(B, C, D, E, F, G); }

subStringExpression(A) ::= SUBSTR(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) COMMA(G) expression(H) RPARENTHESE(I). { A = new NTToken(); A->type = 633; A->copyBools(D); A->copyBools(F); A->copyBools(H); A->vars = D->vars + F->vars + H->vars; A->bNodes = D->bNodes + F->bNodes + H->bNodes; A->query = 'SUBSTR( ' . D->query . ', ' . F->query . ', ' . H->query . ' )'; A->childs = array(B, C, D, E, F, G, H, I); }
subStringExpression(A) ::= SUBSTR(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) RPARENTHESE(G). { A = new NTToken(); A->type = 633; A->copyBools(D); A->copyBools(F); A->vars = D->vars + F->vars; A->bNodes = D->bNodes + F->bNodes; A->query = 'SUBSTR( ' . D->query . ', ' . F->query . ' )'; A->childs = array(B, C, D, E, F, G); }

strReplaceExpression(A) ::= REPLACE(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) COMMA(G) expression(H) COMMA(I) expression(J) RPARENTHESE(K). { A = new NTToken(); A->type = 634; A->copyBools(D); A->copyBools(F); A->copyBools(H); A->copyBools(J); A->vars = D->vars + F->vars + H->vars + J->vars; A->bNodes = D->bNodes + F->bNodes + H->bNodes + J->bNodes; A->query = 'REPLACE( ' . D->query . ', ' . F->query . ', ' . H->query . ', ' . J->query . ' )'; A->childs = array(B, C, D, E, F, G, H, I, J, K); } 
strReplaceExpression(A) ::= REPLACE(B) LPARENTHESE(C) expression(D) COMMA(E) expression(F) COMMA(G) expression(H) RPARENTHESE(I). { A = new NTToken(); A->type = 634; A->copyBools(D); A->copyBools(F); A->copyBools(H); A->vars = D->vars + F->vars + H->vars; A->bNodes = D->bNodes + F->bNodes + H->bNodes; A->query = 'REPLACE( ' . D->query . ', ' . F->query . ', ' . H->query . ' )'; A->childs = array(B, C, D, E, F, G, H, I); }

existsFunc(A) ::= EXISTS(B) groupGraphPattern(C). { A = new NTToken(); A->type = 635; A->copyBools(C); A->ssVars = C->ssVars; A->vars = C->vars; A->bNodes = C->bNodes; A->query = 'EXISTS ' . C->query; A->childs = array(B, C); }

notExistsFunc(A) ::= NOT(B) EXISTS(C) groupGraphPattern(D). { A = new NTToken(); A->type = 636; A->copyBools(D); A->ssVars = D->ssVars; A->vars = D->vars; A->bNodes = D->bNodes; A->query = 'NOT EXISTS ' . D->query; A->childs = array(B, C, D); }

aggregate(A) ::= COUNT(B) LPARENTHESE(C) DISTINCT(D) STAR(E) RPARENTHESE(F). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'COUNT( DISTINCT * )'; A->childs = array(B, C, D, E, F); }
aggregate(A) ::= COUNT(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'COUNT( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; A->childs = array(B, C, D, E, F); }
aggregate(A) ::= COUNT(B) LPARENTHESE(C) STAR(D) RPARENTHESE(E). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'COUNT( * )'; A->childs = array(B, C, D, E); }
aggregate(A) ::= COUNT(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'COUNT( ' . D->query . ' )'; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->childs = array(B, C, D, E); }
aggregate(A) ::= SUM(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'SUM( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; A->childs = array(B, C, D, E, F); }
aggregate(A) ::= MIN(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'MIN( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; A->childs = array(B, C, D, E, F); }
aggregate(A) ::= MAX(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'MAX( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; A->childs = array(B, C, D, E, F); }
aggregate(A) ::= AVG(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'AVG( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; A->childs = array(B, C, D, E, F); }
aggregate(A) ::= SAMPLE(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'SAMPLE( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; A->childs = array(B, C, D, E, F); }
aggregate(A) ::= SUM(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'SUM( ' . D->query . ' )'; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->childs = array(B, C, D, E); }
aggregate(A) ::= MIN(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'MIN( ' . D->query . ' )'; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->childs = array(B, C, D, E); }
aggregate(A) ::= MAX(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'MAX( ' . D->query . ' )'; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->childs = array(B, C, D, E); }
aggregate(A) ::= AVG(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'AVG( ' . D->query . ' )'; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->childs = array(B, C, D, E); }
aggregate(A) ::= SAMPLE(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'SAMPLE( ' . D->query . ' )'; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->childs = array(B, C, D, E); }
aggregate(A) ::= GROUP_CONCAT(B) LPARENTHESE(C) DISTINCT(D) expression(E) SEMICOLON(F) SEPARATOR(G) EQUAL(H) string(I) RPARENTHESE(J). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'GROUP_CONCAT( DISTINCT ' . E->query . ' ; SEPARATOR = ' . I->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; A->childs = array(B, C, D, E, F, G, H, I, J); }
aggregate(A) ::= GROUP_CONCAT(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'GROUP_CONCAT( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->vars = E->vars; A->bNodes = E->bNodes; A->childs = array(B, C, D, E, F); }
aggregate(A) ::= GROUP_CONCAT(B) LPARENTHESE(C) expression(D) SEMICOLON(E) SEPARATOR(F) EQUAL(G) string(H) RPARENTHESE(I). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'GROUP_CONCAT( ' . D->query . ' ; SEPARATOR = ' . H->query . ' )'; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->childs = array(B, C, D, E, F, G, H, I); }
aggregate(A) ::= GROUP_CONCAT(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->type = 637; A->hasAGG = true; A->query = 'GROUP_CONCAT( ' . D->query . ' )'; A->copyBools(D); A->vars = D->vars; A->bNodes = D->bNodes; A->childs = array(B, C, D, E); }

rdfLiteral(A) ::= string(B) LANGTAG(C). { A = new NTToken(); A->type = 638; A->query = B->query . C->value; A->childs = array(B, C); }
rdfLiteral(A) ::= string(B) DHAT(C) iri(D). { A = new NTToken(); A->type = 638; A->query = B->query . C->value . D->query; A->childs = array(B, C, D); }
rdfLiteral(A) ::= string(B). { A = new NTToken(); A->type = 638; A->query = B->query; A->childs = array(B); }

numericLiteral(A) ::= numericLiteralUnsigned(B). { A = B; A->type = 639; A->childs = array(B); }
numericLiteral(A) ::= numericLiteralPositive(B). { A = B; A->type = 639; A->childs = array(B); }
numericLiteral(A) ::= numericLiteralNegative(B). { A = B; A->type = 639; A->childs = array(B); }

numericLiteralUnsigned(A) ::= INTEGER(B). {A = new NTToken(); A->type = 640; A->query = B->value; A->childs = array(B); }
numericLiteralUnsigned(A) ::= DECIMAL(B). {A = new NTToken(); A->type = 640; A->query = B->value; A->childs = array(B); }
numericLiteralUnsigned(A) ::= DOUBLE(B). {A = new NTToken(); A->type = 640; A->query = B->value; A->childs = array(B); }

numericLiteralPositive(A) ::= INTEGER_POSITIVE(B). {A = new NTToken(); A->type = 641; A->query = B->value; A->childs = array(B); }
numericLiteralPositive(A) ::= DECIMAL_POSITIVE(B). {A = new NTToken(); A->type = 641; A->query = B->value; A->childs = array(B); }
numericLiteralPositive(A) ::= DOUBLE_POSITIVE(B). {A = new NTToken(); A->type = 641; A->query = B->value; A->childs = array(B); }

numericLiteralNegative(A) ::= INTEGER_NEGATIVE(B). { A = new NTToken(); A->type = 642; A->query = B->value; A->childs = array(B); }
numericLiteralNegative(A) ::= DECIMAL_NEGATIVE(B). { A = new NTToken(); A->type = 642; A->query = B->value; A->childs = array(B); }
numericLiteralNegative(A) ::= DOUBLE_NEGATIVE(B). { A = new NTToken(); A->type = 642; A->query = B->value; A->childs = array(B); }

booleanLiteral(A) ::= TRUE(B). { A = new NTToken(); A->type = 643; A->query = "true";A->childs = array(B); }
booleanLiteral(A) ::= FALSE(B). { A = new NTToken(); A->type = 643; A->query = "false";A->childs = array(B); }

string(A) ::= STRING_LITERAL1(B). { A = new NTToken(); A->type = 644; A->query = B->value;A->childs = array(B); }
string(A) ::= STRING_LITERAL2(B). { A = new NTToken(); A->type = 644; A->query = B->value;A->childs = array(B); }
string(A) ::= STRING_LITERAL_LONG1(B). { A = new NTToken(); A->type = 644; A->query = B->value;A->childs = array(B); }
string(A) ::= STRING_LITERAL_LONG2(B). { A = new NTToken(); A->type = 644; A->query = B->value;A->childs = array(B); }

iri(A) ::= IRIREF(B). { if(!$this->checkBase(B->value)){throw new Exception("Missing Base for " . B->value);} A = new NTToken(); A->type = 645; A->query = B->value;A->childs = array(B); }
iri(A) ::= prefixedName(B). { A = new NTToken(); A->type = 645; A->query = B->query;A->childs = array(B); }

prefixedName(A) ::= PNAME_LN(B). {if(!$this->checkNS(B->value)){throw new Exception("Missing Prefix for " . B->value);} A = new NTToken(); A->type = 646; A->query = B->value;A->childs = array(B); }
prefixedName(A) ::= PNAME_NS(B). {if(!$this->checkNS(B->value)){throw new Exception("Missing Prefix for " . B->value);} A = new NTToken(); A->type = 646; A->query = B->value;A->childs = array(B); }

blankNode(A) ::= BLANK_NODE_LABEL(B). {A = new NTToken(); A->type = 647; A->hasBN = true; A->bNodes[B->value] = 1;A->childs = array(B); }
blankNode(A) ::= ANON(B). {A = new NTToken(); A->type = 647; A->hasBN = true;A->childs = array(B); }

/* solved issues: * + through loops, update is allowed to be empty (completely empty) -> removed, 
 * no vars in quadData -> class which remembers if vars/bnodes/etc are used, 
 * delete data -> same as above
 * DataBlock - needs same amount of variables and datablockvalues -> the class counts values
 * troublemaker:  scoping, as the exact places to check and the exact points to check it and how deep i need to check (it seems that as looses its power after a where clause except for the select for this where clause) - extra array for as vars (every kind of as inclusion)
 * limiting aggregates, custom aggregates through vars/bools
*/
