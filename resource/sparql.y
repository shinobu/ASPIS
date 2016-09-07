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

update1 ::= load.
update1 ::= clear.
update1 ::= drop.
update1 ::= add.
update1 ::= move.
update1 ::= copy.
update1 ::= create.
update1 ::= insertData.
update1 ::= deleteData.
update1 ::= deletewhere.
update1 ::= modify.

load ::= LOAD SILENT iri INTO graphRef.
load ::= LOAD iri INTO graphRef.
load ::= LOAD SILENT iri.
load ::= LOAD iri.

clear ::= CLEAR SILENT graphRefAll.
clear ::= CLEAR graphRefAll.

drop ::= DROP SILENT graphRefAll.
drop ::= DROP graphRefAll.

create ::= CREATE SILENT graphRef.
create ::= CREATE graphRef.

add ::= ADD SILENT graphOrDefault TO graphOrDefault.
add ::= ADD graphOrDefault TO graphOrDefault.

move ::= MOVE SILENT graphOrDefault TO graphOrDefault.
move ::= MOVE graphOrDefault TO graphOrDefault.

copy ::= COPY SILENT graphOrDefault TO graphOrDefault.
copy ::= COPY graphOrDefault TO graphOrDefault.

insertData ::= INSERTDATA quadData.

deleteData ::= DELETEDATA quadData.

deletewhere ::= DELETEWHERE quadPattern.

modify ::= WITH iri deleteClause insertClause usingClauseX WHERE groupGraphPattern.
modify ::= WITH iri deleteClause usingClauseX WHERE groupGraphPattern.
modify ::= WITH iri insertClause usingClauseX WHERE groupGraphPattern.
modify ::= WITH iri deleteClause insertClause WHERE groupGraphPattern.
modify ::= WITH iri deleteClause WHERE groupGraphPattern.
modify ::= WITH iri insertClause WHERE groupGraphPattern.
modify ::= deleteClause insertClause usingClauseX WHERE groupGraphPattern.
modify ::= deleteClause usingClauseX WHERE groupGraphPattern.
modify ::= insertClause usingClauseX WHERE groupGraphPattern.
modify ::= deleteClause insertClause WHERE groupGraphPattern.
modify ::= deleteClause WHERE groupGraphPattern.
modify ::= insertClause WHERE groupGraphPattern.
usingClauseX ::= usingClauseX usingClause.
usingClauseX ::= usingClause.

deleteClause ::= DELETE quadPattern.

insertClause ::= INSERT quadPattern.

usingClause ::= USING NAMED iri.
usingClause ::= USING iri.

graphOrDefault ::= GRAPH iri.
graphOrDefault ::= DEFAULT.
graphOrDefault ::= iri.

graphRef ::= GRAPH iri.

graphRefAll ::= graphRef.
graphRefAll ::= DEFAULT.
graphRefAll ::= NAMED.
graphRefAll ::= ALL.

quadPattern ::= LBRACE quads RBRACE.
quadPattern ::= LBRACE RBRACE.

quadData ::= LBRACE quads RBRACE.
quadData ::= LBRACE RBRACE.

quads ::= triplesTemplate quadsX.
quads ::= triplesTemplate.
quads ::= quadsX.
quadsX ::= quadsX quadsNotTriples DOT triplesTemplate.
quadsX ::= quadsX quadsNotTriples triplesTemplate.
quadsX ::= quadsX quadsNotTriples DOT.
quadsX ::= quadsX quadsNotTriples.
quadsX ::= quadsNotTriples DOT triplesTemplate.
quadsX ::= quadsNotTriples triplesTemplate.
quadsX ::= quadsNotTriples DOT.
quadsX ::= quadsNotTriples.

quadsNotTriples ::= GRAPH varOrIri LBRACE triplesTemplate RBRACE.
quadsNotTriples ::= GRAPH varOrIri LBRACE RBRACE.

triplesTemplate ::= triplesSameSubject DOT triplesTemplate.
triplesTemplate ::= triplesSameSubject DOT.
triplesTemplate ::= triplesSameSubject.

groupGraphPattern ::= LBRACE groupGraphPatternSub RBRACE.
groupGraphPattern ::= LBRACE subSelect RBRACE.
groupGraphPattern ::= LBRACE RBRACE.


groupGraphPatternSub(A) ::= triplesBlock(B) groupGraphPatternSubX(C). {/*check variable if GoupGraphPatternSubX has some in the array*/ A->test = B + C; }
groupGraphPatternSub ::= triplesBlock.
groupGraphPatternSub ::= groupGraphPatternSubX.
groupGraphPatternSubX ::= groupGraphPatternSubX graphPatternNotTriples DOT triplesBlock. {/*for all below set variable from graphPatternNotTriples to X and for all Tripleblock check if both have variable*/}
groupGraphPatternSubX ::= groupGraphPatternSubX graphPatternNotTriples triplesBlock.
groupGraphPatternSubX ::= groupGraphPatternSubX graphPatternNotTriples DOT.
groupGraphPatternSubX ::= groupGraphPatternSubX graphPatternNotTriples.
groupGraphPatternSubX ::= graphPatternNotTriples DOT triplesBlock.
groupGraphPatternSubX ::= graphPatternNotTriples triplesBlock.
groupGraphPatternSubX ::= graphPatternNotTriples DOT.
groupGraphPatternSubX ::= graphPatternNotTriples. 

triplesBlock ::= triplesSameSubjectPath DOT triplesBlock.
triplesBlock ::= triplesSameSubjectPath DOT.
triplesBlock ::= triplesSameSubjectPath. {/*if variable - check*/}



graphPatternNotTriples ::= groupOrUnionGraphPattern.
graphPatternNotTriples ::= optionalGraphPattern.
graphPatternNotTriples ::= minusGraphPattern.
graphPatternNotTriples ::= graphGraphPattern.
graphPatternNotTriples ::= serviceGraphPattern.
graphPatternNotTriples ::= filter.
graphPatternNotTriples ::= bind. {/*set variable*/}
graphPatternNotTriples ::= inlineData.

optionalGraphPattern ::= OPTIONAL groupGraphPattern.

graphGraphPattern ::= GRAPH varOrIri groupGraphPattern.

serviceGraphPattern ::= SERVICE SILENT varOrIri groupGraphPattern.
serviceGraphPattern ::= SERVICE varOrIri groupGraphPattern.

bind ::= BIND LPARENTHESE expression AS var RPARENTHESE.

inlineData ::= VALUES dataBlock.

dataBlock ::= inlineDataOneVar.
dataBlock ::= inlineDataFull.

inlineDataOneVar ::= var LBRACE dataBlockValueX RBRACE.
inlineDataOneVar ::= var LBRACE RBRACE.
dataBlockValueX ::= dataBlockValueX dataBlockValue. {/*count +1*/}
dataBlockValueX ::= dataBlockValue. {/*count +1*/}

inlineDataFull ::= LPARENTHESE varX RPARENTHESE LBRACE inlineDataFullX RBRACE. {/*if both >0 and equal ok, var>0 i..X =0 ok else break*/} 
inlineDataFull ::= NIL LBRACE nilX RBRACE.
inlineDataFull ::= NIL LBRACE RBRACE.
nilX ::= nilX NIL.
nilX ::= NIL.
varX ::= varX var. {/*count +1*/}
varX ::= var. {/*count +1*/}
inlineDataFullX ::= inlineDataFullX LPARENTHESE dataBlockValueX RPARENTHESE. {/*if (both >0 and equal - count = i..X.count else if unequal - break, else d..X.count)*/}
inlineDataFullX ::= inlineDataFullX NIL. {/*count = i..X.count*/}
inlineDataFullX ::= LPARENTHESE dataBlockValueX RPARENTHESE. {/*count = d..X.count*/}
inlineDataFullX ::= NIL. {/*count = 0*/}

dataBlockValue ::= iri.
dataBlockValue ::= rdfLiteral.
dataBlockValue ::= numericLiteral.
dataBlockValue ::= booleanLiteral.
dataBlockValue ::= UNDEF.

minusGraphPattern ::= SMINUS groupGraphPattern.

groupOrUnionGraphPattern ::= groupGraphPattern groupOrUnionGraphPatternX.
groupOrUnionGraphPattern ::= groupGraphPattern.
groupOrUnionGraphPatternX ::= groupOrUnionGraphPatternX UNION groupGraphPattern.
groupOrUnionGraphPatternX ::= UNION GroupGraphPattern.

filter ::= FILTER LPARENTHESE expression RPARENTHESE.
filter ::= FILTER builtInCall.
filter ::= FILTER functionCall.

functionCall ::= iri argList.

argList ::= LPARENTHESE DISTINCT expression argListX RPARENTHESE.
argList ::= LPARENTHESE expression argListX RPARENTHESE.
argList ::= NIL.
argListX ::= argListX COMMA expression.
argListX ::= COMMA expression.

expressionList ::= LPARENTHESE expression argListX RPARENTHESE.
expressionList ::= NIL.

constructTemplate ::= LBRACE constructTriples RBRACE.
constructTemplate ::= LBRACE RBRACE.

constructTriples ::= triplesSameSubject DOT constructTriples.
constructTriples ::= triplesSameSubject DOT.
constructTriples ::= triplesSameSubject.

triplesSameSubject ::= varOrTerm propertyListNotEmpty.
triplesSameSubject ::= triplesNode propertyListNotEmpty.
triplesSameSubject ::= triplesNode.

propertyListNotEmpty ::= verb objectList propertyListNotEmptyX.
propertyListNotEmpty ::= verb objectList.
propertyListNotEmptyX ::= propertyListNotEmptyX SEMICOLON verb objectList.
propertyListNotEmptyX ::= propertyListNotEmptyX SEMICOLON.
propertyListNotEmptyX ::= SEMICOLON verb objectList.
propertyListNotEmptyX ::= SEMICOLON.

verb ::= varOrIri.
verb ::= A.

objectList ::= graphNode objectListX.
objectList ::= graphNode.
objectListX ::= objectListX COMMA graphNode.
objectListX ::= COMMA graphNode.

triplesSameSubjectPath ::= varOrTerm propertyListPathNotEmpty.
triplesSameSubjectPath ::= triplesNodePath propertyListPathNotEmpty.
triplesSameSubjectPath ::= triplesNodePath.

propertyListPathNotEmpty ::= pathAlternative objectListPath propertyListPathNotEmptyX.
propertyListPathNotEmpty ::= var objectListPath propertyListPathNotEmptyX.
propertyListPathNotEmpty ::= pathAlternative objectListPath.
propertyListPathNotEmpty ::= var objectListPath.
propertyListPathNotEmptyX ::= propertyListPathNotEmptyX SEMICOLON pathAlternative objectList.
propertyListPathNotEmptyX ::= propertyListPathNotEmptyX SEMICOLON var objectList.
propertyListPathNotEmptyX ::= propertyListPathNotEmptyX SEMICOLON.
propertyListPathNotEmptyX ::= SEMICOLON pathAlternative objectList.
propertyListPathNotEmptyX ::= SEMICOLON var objectList.
propertyListPathNotEmptyX ::= SEMICOLON.

objectListPath ::= objectPath objectListPathX.
objectListPath ::= objectPath.
objectListPathX ::= objectListPathX COMMA objectPath.
objectListPathX ::= COMMA objectPath.

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

additiveExpression(A) ::= multiplicativeExpression(B) additiveExpressionX(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); ->addBNodes(C->bNodes); A->query = B->query . ' ' . C->query; }
additiveExpression(A) ::= multiplicativeExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralPositive(C) additiveExpressionY(D). { A = new NTToken(); A->copyBools(B); A->copyBools(D); A->addVars(B->vars); A->addVars(D->vars); A->addBNodes(B->bNodes); ->addBNodes(D->bNodes); A->query = B->query . ' ' . C->query . ' ' D->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralNegative(C) additiveExpressionY(D). { A = new NTToken(); A->copyBools(B); A->copyBools(D); A->addVars(B->vars); A->addVars(D->vars); A->addBNodes(B->bNodes); ->addBNodes(D->bNodes); A->query = B->query . ' ' . C->query . ' ' D->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralPositive(C). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query . ' ' . C->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) numericLiteralNegative(C). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = B->query . ' ' . C->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) PLUS multiplicativeExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); ->addBNodes(C->bNodes); A->query = B->query . ' + ' . C->query; }
additiveExpressionX(A) ::= additiveExpressionX(B) MINUS multiplicativeExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); ->addBNodes(C->bNodes); A->query = B->query . ' - ' . C->query; }
additiveExpressionX(A) ::= numericLiteralPositive(B) additiveExpressionY(C). { A = new NTToken(); A->copyBools(C); A->addVars(C->vars); A->addBNodes(C->bNodes); A->query = B->query . ' ' C->query; }
additiveExpressionX(A) ::= numericLiteralNegative(B) additiveExpressionY(C). { A = new NTToken(); A->copyBools(C); A->addVars(C->vars); A->addBNodes(C->bNodes); A->query = B->query . ' ' C->query; }
additiveExpressionX(A) ::= numericLiteralPositive(B). { A = new NTToken(); A->query = B->query; }
additiveExpressionX(A) ::= numericLiteralNegative(B). { A = new NTToken(); A->query = B->query; }
additiveExpressionX(A) ::= PLUS multiplicativeExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '+ ' . B->query; }
additiveExpressionX(A) ::= MINUS multiplicativeExpression(B). { A = new NTToken(); A->copyBools(B); A->addVars(B->vars); A->addBNodes(B->bNodes); A->query = '- ' . B->query; }
additiveExpressionY(A) ::= additiveExpressionY(B) STAR unaryExpression(C). { A = new NTToken(); A->copyBools(B); A->copyBools(C); A->addVars(B->vars); A->addVars(C->vars); A->addBNodes(B->bNodes); ->addBNodes(C->bNodes); A->query = B->query . ' * ' . C->query; }
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
