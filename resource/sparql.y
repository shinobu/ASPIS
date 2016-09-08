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
	/* arrays */
	public $vars = null;
  /* need to somehow check Scoping for (only?) vars noted with AS */
  publice $ssVars = null;
	public $bNodes = array();
	/* non-arrays */
	public $bindVar = null;
	public $query = null;
  public $counter = 0;
	/* booleans */
  public $hasSS = false;
	public $hasBN = false;
	public $hasFNC = false;
	public $hasAGG = false;

  function addBNodes($tmpBN) {
      if (!empty($tmpBN)) {
          $duplicate = false;
          foreach ($tmpBN as $toAdd) {
              foreach ($this->bNodes as $exists) {
                  if (strcmp($exists, $toAdd) == 0) {
                      $duplicate = true;
                  }
              }
              if ($duplicate == false) {
                  $this->bNodes[] = $toAdd;
              }
              $duplicate = false;
          }
      }
  }
  
  function noDuplicatesBNodes($tmpVar) {
    $noDuplicate = true;
        if ($this->bNodes == null || $tmpVar == null) {
            return $noDuplicate;
        } else {
            foreach ($tmpVar as $toAdd) {
              foreach ($this->bNodes as $exists) {
                  if (strcmp($exists, $toAdd) == 0) {
                      $noDuplicate = false;
                  }
              }
          }
        }
        return $noDuplicate;
  }

	function addVars($tmpVar) {
		if (!empty($tmpVar)) {
    	    if ($this->vars == null) {
    	        $this->vars = array();
    	    }
    	    $duplicate = false;
    	    foreach ($tmpVar as $toAdd) {
    	        foreach ($this->vars as $exists) {
    	            if (strcmp($exists, $toAdd) == 0) {
    	                $duplicate = true;
    	            }
    	        }
    	        if ($duplicate == false) {
    	            $this->vars[] = $toAdd;
    	        }
              $duplicate = false;
    	    }
    	}
	}

	function noDuplicates($tmpVar) {
		$noDuplicate = true;
        if ($this->vars == null || $tmpVar == null) {
            return $noDuplicate;
        } else {
            foreach ($tmpVar as $toAdd) {
    	        foreach ($this->vars as $exists) {
    	            if (strcmp($exists, $toAdd) == 0) {
    	                $noDuplicate = false;
    	            }
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

selectQuery ::= selectClause datasetClauseX whereclause solutionModifier.
selectQuery ::= selectClause datasetClauseX whereclause.
selectQuery ::= selectClause whereclause solutionModifier.
selectQuery ::= selectClause whereclause.
datasetClauseX ::= datasetClauseX datasetClause.
datasetClauseX ::= datasetClause.


subSelect ::= selectClause whereclause solutionModifier valuesClause.
subSelect ::= selectClause whereclause valuesClause.
subSelect ::= selectClause whereclause solutionModifier.
subSelect ::= selectClause whereclause.


selectClause ::= SELECT DISTINCT selectClauseX.
selectClause ::= SELECT REDUCED selectClauseX.
selectClause ::= SELECT STAR selectClauseX.
selectClause ::= SELECT DISTINCT STAR.
selectClause ::= SELECT REDUCED STAR.
selectClause ::= SELECT selectClauseX.
selectClause ::= SELECT STAR.
selectClauseX ::= selectClauseX LPARENTHESE expression AS var RPARENTHESE.
selectClauseX ::= selectClauseX LPARENTHESE expression RPARENTHESE.
selectClauseX ::= selectClauseX builtInCall.
selectClauseX ::= selectClauseX rdfLiteral.
selectClauseX ::= selectClauseX numericLiteral.
selectClauseX ::= selectClauseX booleanLiteral.
selectClauseX ::= selectClauseX var.
selectClauseX ::= selectClauseX functionCall.
selectClauseX ::= LPARENTHESE expression AS var RPARENTHESE.
selectClauseX ::= LPARENTHESE expression RPARENTHESE.
selectClauseX ::= builtInCall.
selectClauseX ::= rdfLiteral.
selectClauseX ::= numericLiteral.
selectClauseX ::= booleanLiteral.
selectClauseX ::= var.
selectClauseX ::= functionCall.

constructQuery ::= CONSTRUCT constructTemplate datasetClauseX whereclause solutionModifier.
constructQuery ::= CONSTRUCT datasetClauseX WHERE LBRACE triplesTemplate RBRACE solutionModifier.
constructQuery ::= CONSTRUCT datasetClauseX WHERE LBRACE RBRACE solutionModifier.
constructQuery ::= CONSTRUCT constructTemplate whereclause.
constructQuery ::= CONSTRUCT constructTemplate datasetClauseX whereclause.
constructQuery ::= CONSTRUCT constructTemplate whereclause solutionModifier.
constructQuery ::= CONSTRUCT WHERE LBRACE triplesTemplate RBRACE.
constructQuery ::= CONSTRUCT WHERE LBRACE RBRACE.
constructQuery ::= CONSTRUCT datasetClauseX  WHERE LBRACE triplesTemplate RBRACE.
constructQuery ::= CONSTRUCT datasetClauseX  WHERE LBRACE  RBRACE.
constructQuery ::= CONSTRUCT WHERE LBRACE triplesTemplate RBRACE solutionModifier.
constructQuery ::= CONSTRUCT WHERE LBRACE RBRACE solutionModifier.

describeQuery ::= DESCRIBE varOrIriX datasetClauseX whereclause solutionModifier.
describeQuery ::= DESCRIBE varOrIriX whereclause solutionModifier.
describeQuery ::= DESCRIBE varOrIriX datasetClauseX solutionModifier.
describeQuery ::= DESCRIBE varOrIriX datasetClauseX whereclause.
describeQuery ::= DESCRIBE varOrIriX solutionModifier.
describeQuery ::= DESCRIBE varOrIriX whereclause.
describeQuery ::= DESCRIBE varOrIriX datasetClauseX.
describeQuery ::= DESCRIBE varOrIriX.
describeQuery ::= DESCRIBE STAR datasetClauseX whereclause solutionModifier.
describeQuery ::= DESCRIBE STAR whereclause solutionModifier.
describeQuery ::= DESCRIBE STAR datasetClauseX solutionModifier.
describeQuery ::= DESCRIBE STAR datasetClauseX whereclause.
describeQuery ::= DESCRIBE STAR solutionModifier.
describeQuery ::= DESCRIBE STAR whereclause.
describeQuery ::= DESCRIBE STAR datasetClauseX.
describeQuery ::= DESCRIBE STAR.
varOrIriX ::= varOrIriX varOrIri.
varOrIriX ::= varOrIri.

askQuery ::= ASK datasetClauseX whereclause.
askQuery ::= ASK datasetClauseX whereclause solutionModifier.
askQuery ::= ASK whereclause solutionModifier.
askQuery ::= ASK whereclause.

datasetClause ::= FROM NAMED iri.
datasetClause ::= FROM iri.

whereclause ::= WHERE groupGraphPattern.
whereclause ::= groupGraphPattern.

solutionModifier ::= groupClause havingClause orderClause limitOffsetClauses.
solutionModifier ::= havingClause orderClause limitOffsetClauses.
solutionModifier ::= groupClause orderClause limitOffsetClauses.
solutionModifier ::= groupClause havingClause limitOffsetClauses.
solutionModifier ::= groupClause havingClause orderClause.
solutionModifier ::= groupClause havingClause.
solutionModifier ::= groupClause orderClause.
solutionModifier ::= groupClause limitOffsetClauses.
solutionModifier ::= orderClause limitOffsetClauses.
solutionModifier ::= havingClause limitOffsetClauses.
solutionModifier ::= havingClause orderClause.
solutionModifier ::= groupClause.
solutionModifier ::= havingClause.
solutionModifier ::= orderClause.
solutionModifier ::= limitOffsetClauses.

groupClause ::= GROUP BY groupConditionX.
groupConditionX ::= groupConditionX LPARENTHESE expression AS var RPARENTHESE.
groupConditionX ::= groupConditionX builtInCall.
groupConditionX ::= groupConditionX functionCall.
groupConditionX ::= groupConditionX LPARENTHESE expression RPARENTHESE.
groupConditionX ::= groupConditionX var.
groupConditionX ::= LPARENTHESE expression AS var RPARENTHESE.
groupConditionX ::= builtInCall.
groupConditionX ::= functionCall.
groupConditionX ::= LPARENTHESE expression RPARENTHESE.
groupConditionX ::= var.

havingClause ::= HAVING constraintX.
constraintX ::= constraintX LPARENTHESE expression RPARENTHESE.
constraintX ::= constraintX builtInCall.
constraintX ::= constraintX functionCall.
constraintX ::= LPARENTHESE expression RPARENTHESE.
constraintX ::= builtInCall.
constraintX ::= functionCall.

orderClause ::= ORDER BY orderConditionX.
orderConditionX ::= orderConditionX orderCondition.
orderConditionX ::= orderCondition.

orderCondition ::= ASC LPARENTHESE expression RPARENTHESE.
orderCondition ::= DESC LPARENTHESE expression RPARENTHESE.
orderCondition ::= LPARENTHESE expression RPARENTHESE.
orderCondition ::= builtInCall.
orderCondition ::= functionCall.
orderCondition ::= var.

limitOffsetClauses ::= limitClause offsetClause.
limitOffsetClauses ::= offsetClause limitClause.
limitOffsetClauses ::= limitClause.
limitOffsetClauses ::= offsetClause.

limitClause ::= LIMIT INTEGER.

offsetClause ::= OFFSET INTEGER.

valuesClause ::= VALUES dataBlock.

update ::= prologue update1 SEMICOLON update.
update ::= update1 SEMICOLON update.
update ::= prologue update1.
update ::= update1.

update1(A) ::= load(B).
update1(A) ::= clear(B).
update1(A) ::= drop(B).
update1(A) ::= add(B).
update1(A) ::= move(B).
update1(A) ::= copy(B).
update1(A) ::= create(B).
update1(A) ::= insertData(B).
update1(A) ::= deleteData(B).
update1(A) ::= deletewhere(B).
update1(A) ::= modify(B).

load(A) ::= LOAD SILENT iri(B) INTO graphRef(C).
load(A) ::= LOAD iri(B) INTO graphRef(C).
load(A) ::= LOAD SILENT iri(B).
load(A) ::= LOAD iri(B).

clear(A) ::= CLEAR SILENT graphRefAll(B).
clear(A) ::= CLEAR graphRefAll(B).

drop(A) ::= DROP SILENT graphRefAll(B).
drop(A) ::= DROP graphRefAll(B).

create(A) ::= CREATE SILENT graphRef(B).
create(A) ::= CREATE graphRef(B).

add(A) ::= ADD SILENT graphOrDefault(B) TO graphOrDefault(C).
add(A) ::= ADD graphOrDefault(B) TO graphOrDefault(C).

move(A) ::= MOVE SILENT graphOrDefault(C) TO graphOrDefault(D).
move(A) ::= MOVE graphOrDefault(B) TO graphOrDefault(D).

copy(A) ::= COPY SILENT graphOrDefault(B) TO graphOrDefault(C).
copy(A) ::= COPY graphOrDefault(B) TO graphOrDefault(C).

insertData(A) ::= INSERTDATA quadData(B).

deleteData(A) ::= DELETEDATA quadData(B).

deletewhere(A) ::= DELETEWHERE quadPattern(B).

modify(A) ::= WITH iri(B) deleteClause(C) insertClause(D) usingClauseX(E) WHERE groupGraphPattern(F).
modify(A) ::= WITH iri(B) deleteClause(C) usingClauseX(D) WHERE groupGraphPattern(E).
modify(A) ::= WITH iri(B) insertClause(C) usingClauseX(D) WHERE groupGraphPattern(E).
modify(A) ::= WITH iri(B) deleteClause(C) insertClause(D) WHERE groupGraphPattern(E).
modify(A) ::= WITH iri(B) deleteClause(C) WHERE groupGraphPattern(D).
modify(A) ::= WITH iri(B) insertClause(C) WHERE groupGraphPattern(D).
modify(A) ::= deleteClause(B) insertClause(C) usingClauseX(D) WHERE groupGraphPattern(E).
modify(A) ::= deleteClause(B) usingClauseX(C) WHERE groupGraphPattern(D).
modify(A) ::= insertClause(B) usingClauseX(C) WHERE groupGraphPattern(D).
modify(A) ::= deleteClause(B) insertClause(C) WHERE groupGraphPattern(D).
modify(A) ::= deleteClause(B) WHERE groupGraphPattern(C).
modify(A) ::= insertClause(B) WHERE groupGraphPattern(C).
usingClauseX(A) ::= usingClauseX(B) usingClause(C).
usingClauseX(A) ::= usingClause(B).

deleteClause(A) ::= DELETE quadPattern(B).

insertClause(A) ::= INSERT quadPattern(B).

usingClause(A) ::= USING NAMED iri(B).
usingClause(A) ::= USING iri(B).

graphOrDefault(A) ::= GRAPH iri(B).
graphOrDefault(A) ::= DEFAULT.
graphOrDefault(A) ::= iri(B).

graphRef(A) ::= GRAPH iri(B).

graphRefAll(A) ::= graphRef(B).
graphRefAll(A) ::= DEFAULT.
graphRefAll(A) ::= NAMED.
graphRefAll(A) ::= ALL.

quadPattern(A) ::= LBRACE quads(B) RBRACE.
quadPattern(A) ::= LBRACE RBRACE.

quadData(A) ::= LBRACE quads(B) RBRACE.
quadData(A) ::= LBRACE RBRACE.

quads(A) ::= triplesTemplate(B) quadsX(C).
quads(A) ::= triplesTemplate(B).
quads(A) ::= quadsX(B).
quadsX(A) ::= quadsX(A) quadsNotTriples(B) DOT triplesTemplate(C).
quadsX(A) ::= quadsX(A) quadsNotTriples(B) triplesTemplate(C).
quadsX(A) ::= quadsX(A) quadsNotTriples(B) DOT.
quadsX(A) ::= quadsX(A) quadsNotTriples(B).
quadsX(A) ::= quadsNotTriples(B) DOT triplesTemplate(C).
quadsX(A) ::= quadsNotTriples(B) triplesTemplate(C).
quadsX(A) ::= quadsNotTriples(B) DOT.
quadsX(A) ::= quadsNotTriples(B).

quadsNotTriples(A) ::= GRAPH varOrIri(B) LBRACE triplesTemplate(C) RBRACE.
quadsNotTriples(A) ::= GRAPH varOrIri(B) LBRACE RBRACE.

triplesTemplate(A) ::= triplesSameSubject(B) DOT triplesTemplate(C).
triplesTemplate(A) ::= triplesSameSubject(B) DOT.
triplesTemplate(A) ::= triplesSameSubject(B).

groupGraphPattern(A) ::= LBRACE groupGraphPatternSub(B) RBRACE.
groupGraphPattern(A) ::= LBRACE subSelect(B) RBRACE.
groupGraphPattern(A) ::= LBRACE RBRACE.


groupGraphPatternSub(A) ::= triplesBlock(B) groupGraphPatternSubX(C). {/*check variable if GoupGraphPatternSubX has some in the array*/ A->test = B + C; }
groupGraphPatternSub(A) ::= triplesBlock(B).
groupGraphPatternSub(A) ::= groupGraphPatternSubX(B).
groupGraphPatternSubX(A) ::= groupGraphPatternSubX(B) graphPatternNotTriples(C) DOT triplesBlock(D). {/*for all below set variable from graphPatternNotTriples to X and for all Tripleblock check if both have variable*/}
groupGraphPatternSubX(A) ::= groupGraphPatternSubX(B) graphPatternNotTriples(C) triplesBlock(D).
groupGraphPatternSubX(A) ::= groupGraphPatternSubX(B) graphPatternNotTriples(C) DOT.
groupGraphPatternSubX(A) ::= groupGraphPatternSubX(B) graphPatternNotTriples(C).
groupGraphPatternSubX(A) ::= graphPatternNotTriples(B) DOT triplesBlock(C).
groupGraphPatternSubX(A) ::= graphPatternNotTriples(B) triplesBlock(C).
groupGraphPatternSubX(A) ::= graphPatternNotTriples(B) DOT.
groupGraphPatternSubX(A) ::= graphPatternNotTriples(B). 

triplesBlock(A) ::= triplesSameSubjectPath(B) DOT triplesBlock(C).
triplesBlock(A) ::= triplesSameSubjectPath(B) DOT.
triplesBlock(A) ::= triplesSameSubjectPath(B). {/*if variable - check*/}



graphPatternNotTriples(A) ::= groupOrUnionGraphPattern(B).
graphPatternNotTriples(A) ::= optionalGraphPattern(B).
graphPatternNotTriples(A) ::= minusGraphPattern(B).
graphPatternNotTriples(A) ::= graphGraphPattern(B).
graphPatternNotTriples(A) ::= serviceGraphPattern(B).
graphPatternNotTriples(A) ::= filter(B).
graphPatternNotTriples(A) ::= bind(B). {/*set variable*/}
graphPatternNotTriples(A) ::= inlineData(B).

optionalGraphPattern(A) ::= OPTIONAL groupGraphPattern(B).

graphGraphPattern(A) ::= GRAPH varOrIri(B) groupGraphPattern(C).

serviceGraphPattern(A) ::= SERVICE SILENT varOrIri(B) groupGraphPattern(C).
serviceGraphPattern(A) ::= SERVICE varOrIri(B) groupGraphPattern(C).

bind(A) ::= BIND LPARENTHESE expression(B) AS var(C) RPARENTHESE.

inlineData(A) ::= VALUES dataBlock(B).

dataBlock(A) ::= inlineDataOneVar(B).
dataBlock(A) ::= inlineDataFull(B).

inlineDataOneVar(A) ::= var(B) LBRACE dataBlockValueX(C) RBRACE.
inlineDataOneVar(A) ::= var(B) LBRACE RBRACE.
dataBlockValueX(A) ::= dataBlockValueX(B) dataBlockValue(C). {/*count +1*/}
dataBlockValueX(A) ::= dataBlockValue(B). {/*count +1*/}

inlineDataFull(A) ::= LPARENTHESE varX(B) RPARENTHESE LBRACE inlineDataFullX(C) RBRACE. {/*if both >0 and equal ok, var>0 i..X =0 ok else break*/} 
inlineDataFull(A) ::= NIL LBRACE nilX(B) RBRACE.
inlineDataFull(A) ::= NIL LBRACE RBRACE.
nilX(A) ::= nilX(B) NIL.
nilX(A) ::= NIL.
varX(A) ::= varX(B) var(C). {/*count +1*/}
varX(A) ::= var(B). {/*count +1*/}
inlineDataFullX(A) ::= inlineDataFullX(B) LPARENTHESE dataBlockValueX(C) RPARENTHESE. {/*if (both >0 and equal - count = i..X.count else if unequal - break, else d..X.count)*/}
inlineDataFullX(A) ::= inlineDataFullX(B) NIL. {/*count = i..X.count*/}
inlineDataFullX(A) ::= LPARENTHESE dataBlockValueX(B) RPARENTHESE. {/*count = d..X.count*/}
inlineDataFullX(A) ::= NIL. {/*count = 0*/}

dataBlockValue(A) ::= iri(B).
dataBlockValue(A) ::= rdfLiteral(B).
dataBlockValue(A) ::= numericLiteral(B).
dataBlockValue(A) ::= booleanLiteral(B).
dataBlockValue(A) ::= UNDEF.

minusGraphPattern(A) ::= SMINUS groupGraphPattern(B).

groupOrUnionGraphPattern(A) ::= groupGraphPattern(B) groupOrUnionGraphPatternX(C).
groupOrUnionGraphPattern(A) ::= groupGraphPattern(B).
groupOrUnionGraphPatternX(A) ::= groupOrUnionGraphPatternX(B) UNION groupGraphPattern(C).
groupOrUnionGraphPatternX(A) ::= UNION GroupGraphPattern(B).

filter(A) ::= FILTER LPARENTHESE expression(B) RPARENTHESE.
filter(A) ::= FILTER builtInCall(B).
filter(A) ::= FILTER functionCall(B).

functionCall(A) ::= iri(B) argList(C).

argList(A) ::= LPARENTHESE DISTINCT expression(B) argListX(C) RPARENTHESE.
argList(A) ::= LPARENTHESE expression(B) argListX(C) RPARENTHESE.
argList(A) ::= NIL.
argListX(A) ::= argListX(B) COMMA expression(C).
argListX(A) ::= COMMA expression(B).

expressionList(A) ::= LPARENTHESE expression(B) argListX(C) RPARENTHESE.
expressionList(A) ::= NIL.

constructTemplate(A) ::= LBRACE constructTriples(B) RBRACE.
constructTemplate(A) ::= LBRACE RBRACE.

constructTriples(A) ::= triplesSameSubject(B) DOT constructTriples(C).
constructTriples(A) ::= triplesSameSubject(B) DOT.
constructTriples(A) ::= triplesSameSubject(B).

triplesSameSubject(A) ::= varOrTerm(B) propertyListNotEmpty(C).
triplesSameSubject(A) ::= triplesNode(B) propertyListNotEmpty(C).
triplesSameSubject(A) ::= triplesNode(B).

propertyListNotEmpty(A) ::= verb(B) objectList(C) propertyListNotEmptyX(D).
propertyListNotEmpty(A) ::= verb(B) objectList(C).
propertyListNotEmptyX(A) ::= propertyListNotEmptyX(B) SEMICOLON verb(C) objectList(D).
propertyListNotEmptyX(A) ::= propertyListNotEmptyX(B) SEMICOLON.
propertyListNotEmptyX(A) ::= SEMICOLON verb(B) objectList(C).
propertyListNotEmptyX(A) ::= SEMICOLON.

verb(A) ::= varOrIri(B).
verb(A) ::= A.

objectList(A) ::= graphNode(B) objectListX(C).
objectList(A) ::= graphNode(B).
objectListX(A) ::= objectListX(B) COMMA graphNode(C).
objectListX(A) ::= COMMA graphNode(B).

triplesSameSubjectPath(A) ::= varOrTerm(B) propertyListPathNotEmpty(C).
triplesSameSubjectPath(A) ::= triplesNodePath(B) propertyListPathNotEmpty(C).
triplesSameSubjectPath(A) ::= triplesNodePath(B).

propertyListPathNotEmpty(A) ::= pathAlternative(B) objectListPath(C) propertyListPathNotEmptyX(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->addVars(B->vars); A->addVars(C->vars); A->addVars(D->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->addBNodes(D->bNodes); A->query = B->query . ' ' . C->query . ' ' D->query; }
propertyListPathNotEmpty(A) ::= var(B) objectListPath(C) propertyListPathNotEmptyX(D). { A = new NTToken(); A->copyBools(C); A->copyBools(D); A->addVars(B->vars); A->addVars(C->vars); A->addVars(D->vars); A->addBNodes(C->bNodes); A->addBNodes(D->bNodes); A->query = B->query . ' ' . C->query . ' ' D->query; }
propertyListPathNotEmpty(A) ::= pathAlternative(B) objectListPath(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' ' . C->query; }
propertyListPathNotEmpty(A) ::= var(B) objectListPath(C). { A = new NTToken(); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(C->bNodes); A->query = B->query . ' ' . C->query; }
propertyListPathNotEmptyX(A) ::= propertyListPathNotEmptyX(B) SEMICOLON pathAlternative(C) objectList(D). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->addVars(B->vars); A->addVars(C->vars); A->addVars(D->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->addBNodes(D->bNodes); A->query = B->query . '; ' . C->query . ' ' D->query; }
propertyListPathNotEmptyX(A) ::= propertyListPathNotEmptyX(B) SEMICOLON var(C) objectList(D). { A = new NTToken(); A->copyBools(B); A->copyBools(D); A->addVars(B->vars); A->addVars(C->vars) A->addVars(D->vars); A->addBNodes(B->bNodes); A->addBNodes(D->bNodes); A->query = B->query . '; ' . C->query . ' ' D->query; }
propertyListPathNotEmptyX(A) ::= propertyListPathNotEmptyX(B) SEMICOLON. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query. ';'; }
propertyListPathNotEmptyX(A) ::= SEMICOLON pathAlternative(B) objectList(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = '; ' . B->query . ' ' . C->query; }
propertyListPathNotEmptyX(A) ::= SEMICOLON var(B) objectList(C). { A = new NTToken(); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(C->bNodes); A->query = '; ' . ' ' . B->query . C->query; }
propertyListPathNotEmptyX(A) ::= SEMICOLON. { A = new NTToken(); A->query = ';'; }

objectListPath(A) ::= objectPath(B) objectListPathX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . C->query; }
objectListPath(A) ::= objectPath(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
objectListPathX(A) ::= objectListPathX(B) COMMA objectPath(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ', ' . C->query; }
objectListPathX(A) ::= COMMA objectPath(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = ', ' . B->query; }

pathAlternative(A) ::= pathSequence(B) pathAlternativeX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . C->query; }
pathAlternative(A) ::= pathSequence(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
pathAlternativeX(A) ::= pathAlternativeX(B) VBAR pathSequence(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . '|' . C->query; }
pathAlternativeX(A) ::= VBAR pathSequence(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '|' . B->query; }

pathSequence(A) ::= pathEltOrInverse(B) pathSequenceX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . C->query; }
pathSequence(A) ::= pathEltOrInverse(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
pathSequenceX(A) ::= pathSequenceX(B) SLASH pathEltOrInverse(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . '/' . C->query; }
pathSequenceX(A) ::= SLASH pathEltOrInverse(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '/' . B->query; }

pathElt(A) ::= pathPrimary(B) pathMod(C). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query . C->query; }
pathElt(A) ::= pathPrimary(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }

pathEltOrInverse(A) ::= HAT pathElt(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '^' . B->query; }
pathEltOrInverse(A) ::= pathElt(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }

pathMod(A) ::= STAR. { A = new NTToken(); A->query = '*'; }
pathMod(A) ::= PLUS. { A = new NTToken(); A->query = '+'; }
pathMod(A) ::= QUESTION. { A = new NTToken(); A->query = '?'; }

pathPrimary(A) ::= LPARENTHESE pathAlternative(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '( ' . B->query . ' )'; }
pathPrimary(A) ::= EXCLAMATION pathNegatedPropertySet(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '!' . B->query; }
pathPrimary(A) ::= A. { A = new NTToken(); A->query = 'rdf:type'; }
pathPrimary(A) ::= iri(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }

pathNegatedPropertySet(A) ::= LPARENTHESE pathOneInPropertySet(B) pathNegatedPropertySetX(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' ' . C->query; }
pathNegatedPropertySet(A) ::= LPARENTHESE pathOneInPropertySet(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '( ' . B->query . ' )'; }
pathNegatedPropertySet(A) ::= LPARENTHESE RPARENTHESE. { A = new NTToken(); A->query = '( )'; }
pathNegatedPropertySet(A) ::= pathOneInPropertySet(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
pathNegatedPropertySetX(A) ::= pathNegatedPropertySetX(B) VBAR pathOneInPropertySet(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' | ' . C->query; }
pathNegatedPropertySetX(A) ::= VBAR pathOneInPropertySet(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '| ' . B->query; }

pathOneInPropertySet(A) ::= HAT iri(B). { A = new NTToken(); A->query = '^' . B->query; }
pathOneInPropertySet(A) ::= HAT A. { if(!checkNS('rdf:type')){$main->error = "Missing Prefix for rdf:type (a)";yy_parse_failed();} A = new NTToken(); ; A->query = '^rdf:type'; }
pathOneInPropertySet(A) ::= A. { if(!checkNS('rdf:type')){$main->error = "Missing Prefix for rdf:type (a)";yy_parse_failed();} A = new NTToken(); A->query = 'rdf:type'; }
pathOneInPropertySet(A) ::= iri(B). { A = new NTToken(); A->query = B->query; }

triplesNode(A) ::= collection(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
triplesNode(A) ::= blankNodePropertyList(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }

blankNodePropertyList(A) ::= LBRACKET propertyListNotEmpty(B) RBRACKET. { A = new NTToken(); A->hasBN = true; A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '[ ' . B->query . ' ]'; }

triplesNodePath(A) ::= collectionPath(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
triplesNodePath(A) ::= blankNodePropertyListPath(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }

blankNodePropertyListPath(A) ::= LBRACKET propertyListPathNotEmpty(B) RBRACKET. { A = new NTToken(); A->hasBN = true; A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '[ ' . B->query . ' ]'; }

collection(A) ::= LPARENTHESE graphNodeX(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '( ' . B->query . ' )'; }
graphNodeX(A) ::= graphNodeX(B) graphNode(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' ' . C->query; }
graphNodeX(A) ::= graphNode(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }

collectionPath(A) ::= LPARENTHESE graphNodePathX(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '( ' . B->query . ' )'; }
graphNodePathX(A) ::= graphNodePathX(B) graphNodePath(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' ' . C->query; }
graphNodePathX(A) ::= graphNodePath(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }

graphNode(A) ::= varOrTerm(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
graphNode(A) ::= triplesNode(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }

graphNodePath(A) ::= varOrTerm(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
graphNodePath(A) ::= triplesNodePath(B).  { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }

varOrTerm(A) ::= var(B). { A = new NTToken(); A->addVars(B->vars); A->query = B->query; }
varOrTerm(A) ::= graphTerm(B). { A = new NTToken(); A->copyBools(B); A->addBNodes(B->bNodes); A->query = B->query; }

varOrIri(A) ::= var(B). { A = new NTToken(); A->addVars(B->vars); A->query = B->query; }
varOrIri(A) ::= iri(B). { A = new NTToken(); A->query = B->query; }

var(A) ::= VAR1(B). { A = new NTToken(); A->vars = array(); A->vars[] = B->value A->query = B->value; }
var(A) ::= VAR2(B). { A = new NTToken(); A->vars = array(); A->vars[] = B->value A->query = B->value; }

graphTerm(A) ::= iri(B). { A = new NTToken(); A->query = B->query; }
graphTerm(A) ::= rdfLiteral(B). { A = new NTToken(); A->query = B->query; }
graphTerm(A) ::= numericLiteral(B). { A = new NTToken(); A->query = B->query; }
graphTerm(A) ::= booleanLiteral(B). { A = new NTToken(); A->query = B->query; }
graphTerm(A) ::= blankNode(B). { A = new NTToken(); A->copyBools(B); A->addBNodes(B->bNodes); A->query = B->query; }
graphTerm(A) ::= NIL. { A = new NTToken(); A->query = '( )'; }

expression(A) ::= conditionalAndExpression(B) conditionalOrExpressionX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' ' . C->query; }
expression(A) ::= conditionalAndExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
conditionalOrExpressionX(A) ::= conditionalOrExpressionX(B) OR conditionalAndExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' || ' . C->query; }
conditionalOrExpressionX(A) ::= OR conditionalAndExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '|| ' . B->query; }

conditionalAndExpression(A) ::= relationalExpression(B) conditionalAndExpressionX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' ' . C->query; }
conditionalAndExpression(A) ::= relationalExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
conditionalAndExpressionX(A) ::= conditionalAndExpressionX(B) AND relationalExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' && ' . C->query; }
conditionalAndExpressionX(A) ::= AND relationalExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '&& ' . B->query; }


relationalExpression(A) ::= additiveExpression(B) relationalExpressionX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' ' . C->query; }
relationalExpression(A) ::= additiveExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
relationalExpressionX(A) ::= EQUAL additiveExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '= ' . B->query; }
relationalExpressionX(A) ::= NEQUAL additiveExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '!= ' . B->query; }
relationalExpressionX(A) ::= SMALLERTHEN additiveExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '< ' . B->query; }
relationalExpressionX(A) ::= GREATERTHEN additiveExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '> ' . B->query; }
relationalExpressionX(A) ::= SMALLERTHENQ additiveExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '<= ' . B->query; }
relationalExpressionX(A) ::= GREATERTHENQ additiveExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '>= ' . B->query; }
relationalExpressionX(A) ::= IN expressionList(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'IN' . B->query; }
relationalExpressionX(A) ::= NOT IN expressionList(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'NOT IN' . B->query; }

additiveExpression(A) ::= multiplicativeExpression(B) additiveExpressionX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' ' . C->query; }
additiveExpression(A) ::= multiplicativeExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralPositive(C) additiveExpressionY(D). { A = new NTToken(); A->copyBools(B); A->copyBools(D); A->addVars(B->vars); A->addVars(D->vars); A->addBNodes(B->bNodes); A->addBNodes(D->bNodes); A->query = B->query . ' ' . C->query . ' ' D->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralNegative(C) additiveExpressionY(D). { A = new NTToken(); A->copyBools(B); A->copyBools(D); A->addVars(B->vars); A->addVars(D->vars); A->addBNodes(B->bNodes); A->addBNodes(D->bNodes); A->query = B->query . ' ' . C->query . ' ' D->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralPositive(C). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query . ' ' . C->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralNegative(C). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query . ' ' . C->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) PLUS multiplicativeExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' + ' . C->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) MINUS multiplicativeExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' - ' . C->query; }
additiveExpressionX(A) ::= numericLiteralPositive(B) additiveExpressionY(C). { A = new NTToken(); A->copyBools(C); A->addVars(C->vars); A->addBNodes(C->bNodes); A->query = B->query . ' ' C->query; }
additiveExpressionX(A) ::= numericLiteralNegative(B) additiveExpressionY(C). { A = new NTToken(); A->copyBools(C); A->addVars(C->vars); A->addBNodes(C->bNodes); A->query = B->query . ' ' C->query; }
additiveExpressionX(A) ::= numericLiteralPositive(B). { A = new NTToken(); A->query = B->query; }
additiveExpressionX(A) ::= numericLiteralNegative(B). { A = new NTToken(); A->query = B->query; }
additiveExpressionX(A) ::= PLUS multiplicativeExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '+ ' . B->query; }
additiveExpressionX(A) ::= MINUS multiplicativeExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '- ' . B->query; }
additiveExpressionY(A) ::= additiveExpressionY(B) STAR unaryExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' * ' . C->query; }
additiveExpressionY(A) ::= additiveExpressionY(B) SLASH unaryExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' * ' . C->query; }
additiveExpressionY(A) ::= STAR unaryExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '* ' . B->query; }
additiveExpressionY(A) ::= SLASH unaryExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '/ ' . B->query; }

multiplicativeExpression(A) ::= unaryExpression(B) additiveExpressionY(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = B->query . ' ' . C->query; } 
multiplicativeExpression(A) ::= unaryExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }

unaryExpression(A) ::= EXCLAMATION primaryExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '! ' . B->query; }
unaryExpression(A) ::= PLUS primaryExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '+ ' . B->query; }
unaryExpression(A) ::= MINUS primaryExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '- ' . B->query; }
unaryExpression(A) ::= primaryExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }

primaryExpression(A) ::= LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '( ' . B->query . ' )'; }
primaryExpression(A) ::= builtInCall(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
primaryExpression(A) ::= iri(B). { A = new NTToken(); A->query = B->query; }
primaryExpression(A) ::= functionCall(B). { A = new NTToken(); A->hasFNC = true; A->hasAGG = true; A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
primaryExpression(A) ::= rdfLiteral(B). { A = new NTToken(); A->query = B->query; }
primaryExpression(A) ::= numericLiteral(B). { A = new NTToken(); A->query = B->query; }
primaryExpression(A) ::= booleanLiteral(B). { A = new NTToken(); A->query = B->query; }
primaryExpression(A) ::= var(B). { A = new NTToken(); A->addVars(B->vars); A->query = B->query; }

builtInCall(A) ::= aggregate(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
builtInCall(A) ::= regexExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
builtInCall(A) ::= existsFunc(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
builtInCall(A) ::= notExistsFunc(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
builtInCall(A) ::= STR LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'STR( ' . B->query . ' )'; }
builtInCall(A) ::= LANG LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'STR( ' . B->query . ' )'; }
builtInCall(A) ::= LANGMATCHES LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); copyBools(C) A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = 'LANGMATCHES( ' . B->query . ', ' . C->query . ' )'; }
builtInCall(A) ::= DATATYPE LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'DATATYPE( ' . B->query . ' )'; }
builtInCall(A) ::= BOUND LPARENTHESE var(B) RPARENTHESE. { A = new NTToken(); A->addVars(B->vars); A->query = 'BOUND( ' . B->query . ' )'; }
builtInCall(A) ::= URI LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'URI( ' . B->query . ' )'; }
builtInCall(A) ::= BNODE LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->hasBN = true; A->copyBools(B); A->addVars(B->vars); A->bNodes[] = B->query; A->addBNodes(B->bNodes); A->query = 'BNODE( ' B->query; ' )'; }
builtInCall(A) ::= BNODE NIL. { A = new NTToken(); A->hasBN = true; A->query = 'BNODE( )'; }
builtInCall(A) ::= RAND NIL. { A = new NTToken(); A->query = 'RAND( )'; }
builtInCall(A) ::= ABS LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'ABS(' . B->query . ' )'; }
builtInCall(A) ::= CEIL LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'CEIL(' . B->query . ' )'; }
builtInCall(A) ::= FLOOR LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'FLOOR(' . B->query . ' )'; }
builtInCall(A) ::= ROUND LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'ROUND(' . B->query . ' )'; }
builtInCall(A) ::= CONCAT expressionList(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'CONCAT' . B->query; }
builtInCall(A) ::= subStringExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
builtInCall(A) ::= STRLEN LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'STRLEN( ' . B->query . ' )'; }
builtInCall(A) ::= strReplaceExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
builtInCall(A) ::= UCASE LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'UCASE( ' . B->query . ' )'; }
builtInCall(A) ::= LCASE LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query =  'LCASE( ' . B->query . ' )'; }
builtInCall(A) ::= ENCODE_FOR_URI LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'ENCODE_FOR_URI( ' . B->query . ' )'; }
builtInCall(A) ::= CONTAINS LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = 'CONTAINS( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= STRSTARTS LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = 'STRSTARTS( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= STRENDS LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = 'STRENDS( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= STBEFORE LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = 'STBEFORE( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= STRAFTER LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = 'STRAFTER( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= YEAR LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'YEAR( ' . B->query . ' )'; }
builtInCall(A) ::= MONTH LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'MONTH( ' . B->query . ' )'; }
builtInCall(A) ::= DAY LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'DAY( ' . B->query . ' )'; }
builtInCall(A) ::= HOURS LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'HOURS( ' . B->query . ' )'; }
builtInCall(A) ::= MINUTES LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'MINUTES( ' . B->query . ' )'; }
builtInCall(A) ::= SECONDS LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'SECONDS( ' . B->query . ' )'; }
builtInCall(A) ::= TIMEZONE LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars);A->addBNodes(B->bNodes); A->query = 'TIMEZONE( ' . B->query . ' )'; }
builtInCall(A) ::= TZ LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'TZ( ' . B->query . ' )'; }
builtInCall(A) ::= NOW NIL. { A = new NTToken(); A->query = 'NOW( )'; }
builtInCall(A) ::= UUID NIL. { A = new NTToken(); A->query = 'UUID( )'; }
builtInCall(A) ::= STRUUID NIL. { A = new NTToken(); A->query = 'STRUUID( )'; }
builtInCall(A) ::= MD5 LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'MD5( ' . B->query . ' )'; }
builtInCall(A) ::= SHA1 LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'SHA1( ' . B->query . ' )'; }
builtInCall(A) ::= SHA256 LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'SHA256( ' . B->query . ' )'; }
builtInCall(A) ::= SHA384 LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'SHA384( ' . B->query . ' )'; }
builtInCall(A) ::= SHA512 LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'SHA512( ' . B->query . ' )'; }
builtInCall(A) ::= COALESCE expressionList(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'COALESCE' . B->query; }
builtInCall(A) ::= IF LPARENTHESE expression(B) COMMA expression(C) COMMA expression(D) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->copyBools(D); A->addVars(B->vars); A->addVars(C->vars); A->addVars(D->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->addBNodes(D->bNodes); A->query = 'IF( ' . B->query . ', ' . C->query .  ', ' . D->query . ' )'; }
builtInCall(A) ::= STRLANG LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = 'STRLANG( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= STRDT LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = 'STRDT( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= SAMETERM LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = 'SAMETERM( ' . B->query . ', ' . C->query .  ' )'; }
builtInCall(A) ::= ISIRI LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'ISIRI( ' . B->query . ' )'; }
builtInCall(A) ::= ISURI LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'ISURI( ' . B->query . ' )'; }
builtInCall(A) ::= ISBLANK LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'ISBLANK( ' . B->query . ' )'; }
builtInCall(A) ::= ISLITERAL LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'ISLITERAL( ' . B->query . ' )'; }
builtInCall(A) ::= ISNUMERIC LPARENTHESE expression(B) RPARENTHESE. { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'ISNUMERIC( ' . B->query . ' )'; }

regexExpression(A) ::= REGEX LPARENTHESE expression(B) COMMA expression(C) COMMA expression(D) RPARENTHESE. { A = new NTToken; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->addVars(B->vars); A->addVars(C->vars); A->addVars(D->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->addBNodes(D->bNodes); A->query = 'REGEX( ' . B->query . ', ' . C->query . ', ' . D->query . ' )'; }
regexExpression(A) ::= REGEX LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE.{ A = new NTToken; A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = 'REGEX( ' . B->query . ', ' . C->query . ' )'; }

subStringExpression(A) ::= SUBSTR LPARENTHESE expression(B) COMMA expression(C) COMMA expression(D) RPARENTHESE. { A = new NTToken; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->addVars(B->vars); A->addVars(C->vars); A->addVars(D->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->addBNodes(D->bNodes); A->query = 'SUBSTR( ' . B->query . ', ' . C->query . ', ' . D->query . ' )'; }
subStringExpression(A) ::= SUBSTR LPARENTHESE expression(B) COMMA expression(C) RPARENTHESE. { A = new NTToken; A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->query = 'SUBSTR( ' . B->query . ', ' . C->query . ' )'; }

strReplaceExpression(A) ::= REPLACE LPARENTHESE expression(B) COMMA expression(C) COMMA expression(D) COMMA expression(E) RPARENTHESE. { A = new NTToken; A->copyBools(B); A->copyBools(C); A->copyBools(D); A-> copyBools(E); A->addVars(B->vars); A->addVars(C->vars); A->addVars(D->vars); A->addVars(E->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->addBNodes(D->bNodes); A->addBNodes(E->bNodes); A->query = 'REPLACE( ' . B->query . ', ' . C->query . ', ' . D->query . ', ' . E->query . ' )'; } 
strReplaceExpression(A) ::= REPLACE LPARENTHESE expression(B) COMMA expression(C) COMMA expression(D) RPARENTHESE. { A = new NTToken; A->copyBools(B); A->copyBools(C); A->copyBools(D); A->addVars(B->vars); A->addVars(C->vars); A->addVars(D->vars); A->addBNodes(B->bNodes); A->addBNodes(C->bNodes); A->addBNodes(D->bNodes); A->query = 'REPLACE( ' . B->query . ', ' . C->query . ', ' . D->query . ' )'; }

existsFunc(A) ::= EXISTS groupGraphPattern(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'EXISTS ' . B->query; }

notExistsFunc(A) ::= NOT EXISTS groupGraphPattern(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = 'NOT EXISTS ' . B->query; }

aggregate(A) ::= COUNT(B) LPARENTHESE(C) DISTINCT(D) STAR(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'COUNT( DISTINCT * )'; }
aggregate(A) ::= COUNT(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'COUNT( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->addVars(E); A->addBNodes(E->bNodes); }
aggregate(A) ::= COUNT(B) LPARENTHESE(C) STAR(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'COUNT( * )'; }
aggregate(A) ::= COUNT(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'COUNT( ' . D->query . ' )'; A->copyBools(D); A->addVars(E); A->addBNodes(E->bNodes); }
aggregate(A) ::= SUM(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'SUM( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->addVars(E); A->addBNodes(E->bNodes); }
aggregate(A) ::= MIN(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'MIN( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->addVars(E); A->addBNodes(E->bNodes); }
aggregate(A) ::= MAX(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'MAX( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->addVars(E); A->addBNodes(E->bNodes); }
aggregate(A) ::= AVG(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'AVG( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->addVars(E); A->addBNodes(E->bNodes); }
aggregate(A) ::= SAMPLE(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'SAMPLE( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->addVars(E); A->addBNodes(E->bNodes); }
aggregate(A) ::= SUM(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'SUM( ' . D->query . ' )'; A->copyBools(D); A->addVars(D); A->addBNodes(D->bNodes); }
aggregate(A) ::= MIN(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'MIN( ' . D->query . ' )'; A->copyBools(D); A->addVars(D); A->addBNodes(D->bNodes); }
aggregate(A) ::= MAX(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'MAX( ' . D->query . ' )'; A->copyBools(D); A->addVars(D); A->addBNodes(D->bNodes); }
aggregate(A) ::= AVG(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'AVG( ' . D->query . ' )'; A->copyBools(D); A->addVars(D); A->addBNodes(D->bNodes); }
aggregate(A) ::= SAMPLE(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'SAMPLE( ' . D->query . ' )'; A->copyBools(D); A->addVars(D); A->addBNodes(D->bNodes); }
aggregate(A) ::= GROUP_CONCAT(B) LPARENTHESE(C) DISTINCT(D) expression(E) SEMICOLON(F) SEPARATOR(G) EQUAL(H) string(I) RPARENTHESE(J). { A = new NTToken(); A->hasAGG = true; A->query = 'GROUP_CONCAT( DISTINCT ' . E->query . ' ; SEPARATOR = ' . I->query . ' )'; A->copyBools(E); A->addVars(E); A->addBNodes(E->bNodes); }
aggregate(A) ::= GROUP_CONCAT(B) LPARENTHESE(C) DISTINCT(D) expression(E) RPARENTHESE(F). { A = new NTToken(); A->hasAGG = true; A->query = 'GROUP_CONCAT( DISTINCT ' . E->query . ' )'; A->copyBools(E); A->addVars(E); A->addBNodes(E->bNodes); }
aggregate(A) ::= GROUP_CONCAT(B) LPARENTHESE(C) expression(D) SEMICOLON(E) SEPARATOR(F) EQUAL(G) string(H) RPARENTHESE(I). { A = new NTToken(); A->hasAGG = true; A->query = 'GROUP_CONCAT( ' . D->query . ' ; SEPARATOR = ' H->query . ' )'; A->copyBools(D); A->addVars(D); A->addBNodes(D->bNodes); }
aggregate(A) ::= GROUP_CONCAT(B) LPARENTHESE(C) expression(D) RPARENTHESE(E). { A = new NTToken(); A->hasAGG = true; A->query = 'GROUP_CONCAT( ' . D->query . ' )'; A->copyBools(D); A->addVars(D); A->addBNodes(D->bNodes); }

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

iri(A) ::= IRIREF(B). { if(!checkBase(B->value)){$main->error = "Missing Base for " . B->value; yy_parse_failed();} A = new NTToken(); A->query = B->value;}
iri(A) ::= prefixedName(B). { A = new NTToken(); A->query = B->query;}

prefixedName(A) ::= PNAME_LN(B). {if(!checkNS(B->value)){$main->error = "Missing Prefix for " . B->value;yy_parse_failed();} A = new NTToken(); A->query = B->value;}
prefixedName(A) ::= PNAME_NS(B). {if(!checkNS(B->value)){$main->error = "Missing Prefix for " . B->value;yy_parse_failed();} A = new NTTOKEN(); A->query = B->value;}

blankNode(A) ::= BLANK_NODE_LABEL(B). {A = new NTToken(); A->hasBN = true; A->bNodes[] = B->value;}
blankNode(A) ::= ANON. {A = new NTToken(); A->hasBN = true;}

/* solved issues: * + through loops, update is allowed to be empty (completely empty) -> removed, 
 * no vars in quadData -> class which remembers if vars/bnodes/etc are used, 
 * delete data -> extra rules,
 * troublemaker: DataBlock - needs same amount of variables and datablockvalues, scoping, 
 * limiting aggregates, custom aggregates
 * idea for variables - store them in a array and shove them up (if you need to) --- check variable arrays where you need to for scoping 
*/
