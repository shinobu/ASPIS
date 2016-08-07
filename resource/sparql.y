/* This is a lemon grammar for the Sparql1.1 language */
%name SparqlPHPParser
%token_prefix TK_

/* this defines a symbol for the lexer */
%nonassoc PRAGMA.

start ::= Query.
start ::= Update.

Query ::= Prologue SelectQuery ValuesClause.
Query ::= Prologue ConstructQuery ValuesClause.
Query ::= Prologue DescribeQuery ValuesClause.
Query ::= Prologue AskQuery ValuesClause.
Query ::= SelectQuery ValuesClause.
Query ::= ConstructQuery ValuesClause.
Query ::= DescribeQuery ValuesClause.
Query ::= AskQuery ValuesClause.
Query ::= Prologue SelectQuery.
Query ::= Prologue ConstructQuery.
Query ::= Prologue DescribeQuery.
Query ::= Prologue AskQuery.
Query ::= SelectQuery.
Query ::= ConstructQuery.
Query ::= DescribeQuery.
Query ::= AskQuery.

Prologue ::= BaseDecl.
Prologue ::= PrefixDeclX BaseDecl.
Prologue ::= BaseDecl PrefixDeclX.
Prologue ::= PrefixDeclX BaseDecl PrefixDeclX.
PrefixDeclX ::= PrefixDecl.
PrefixDeclX ::= PrefixDecl PrefixDeclX.

BaseDecl ::= BASE IRIREF.
BaseDecl ::= BASE IRIREF DOT.

PrefixDecl ::= PREFIX PNAME_NS IRIREF.
PrefixDecl ::= PREFIX PNAME_NS IRIREF DOT.

SelectQuery ::= SelectClause WhereClause.
SelectQuery ::= SelectClause WhereClause SolutionModifier.
SelectQuery ::= SelectClause DatasetClauseX WhereClause.
SelectQuery ::= SelectClause DatasetClauseX WhereClause SolutionModifier.
DatasetClauseX ::= DatasetClause.
DatasetClauseX ::= DatasetClause DatasetClauseX.

SubSelect ::= SelectClause WhereClause.
SubSelect ::= SelectClause WhereClause SolutionModifier.
SubSelect ::= SelectClause WhereClause ValuesClause.
SubSelect ::= SelectClause WhereClause SolutionModifier ValuesClause.

SelectClause ::= SELECT STAR.
SelectClause ::= SELECT DISTINCT STAR.
SelectClause ::= SELECT REDUCED STAR.
SelectClause ::= SELECT DISTINCT SelectClauseX.
SelectClause ::= SELECT REDUCED SelectClauseX.
SelectClause ::= SELECT STAR SelectClauseX.
SelectClauseX ::= BuiltInCall.
SelectClauseX ::= RDFLiteral.
SelectClauseX ::= NumericLiteral.
SelectClauseX ::= BooleanLiteral.
SelectClauseX ::= Var.
SelectClauseX ::= Aggregate.
SelectClauseX ::= FunctionCall.
SelectClauseX ::= LPARENTHESE Expression RPARENTHESE.
SelectClauseX ::= LPARENTHESE Expression AS Var RPARENTHESE.
SelectClauseX ::= BuiltInCall SelectClauseX.
SelectClauseX ::= RDFLiteral SelectClauseX.
SelectClauseX ::= NumericLiteral SelectClauseX.
SelectClauseX ::= BooleanLiteral SelectClauseX.
SelectClauseX ::= Var SelectClauseX.
SelectClauseX ::= Aggregate SelectClauseX.
SelectClauseX ::= FunctionCall SelectClauseX.
SelectClauseX ::= LPARENTHESE Expression RPARENTHESE SelectClauseX.
SelectClauseX ::= LPARENTHESE Expression AS Var RPARENTHESE SelectClauseX.

ConstructQuery ::= CONSTRUCT QuadPattern WhereClause.
ConstructQuery ::= CONSTRUCT QuadPattern DatasetClauseX WhereClause.
ConstructQuery ::= CONSTRUCT QuadPattern WhereClause SolutionModifier.
ConstructQuery ::= CONSTRUCT QuadPattern DatasetClauseX WhereClause SolutionModifier.
ConstructQuery ::= CONSTRUCT WHERE QuadPattern.
ConstructQuery ::= CONSTRUCT DatasetClauseX  WHERE QuadPattern.
ConstructQuery ::= CONSTRUCT WHERE QuadPattern SolutionModifier.
ConstructQuery ::= CONSTRUCT DatasetClauseX Where QuadPattern SolutionModifier.

DescribeQuery ::= DESCRIBE STAR.
DescribeQuery ::= DESCRIBE STAR DatasetClauseX.
DescribeQuery ::= DESCRIBE STAR WhereClause.
DescribeQuery ::= DESCRIBE STAR SolutionModifier.
DescribeQuery ::= DESCRIBE STAR DatasetClauseX WhereClause.
DescribeQuery ::= DESCRIBE STAR DatasetClauseX SolutionModifier.
DescribeQuery ::= DESCRIBE STAR WhereClause SolutionModifier.
DescribeQuery ::= DESCRIBE STAR DatasetClauseX WhereClause SolutionModifier.
DescribeQuery ::= DESCRIBE VarOrIriX.
DescribeQuery ::= DESCRIBE VarOrIriX DatasetClauseX.
DescribeQuery ::= DESCRIBE VarOrIriX WhereClause.
DescribeQuery ::= DESCRIBE VarOrIriX SolutionModifier.
DescribeQuery ::= DESCRIBE VarOrIriX DatasetClauseX WhereClause.
DescribeQuery ::= DESCRIBE VarOrIriX DatasetClauseX SolutionModifier.
DescribeQuery ::= DESCRIBE VarOrIriX WhereClause SolutionModifier.
DescribeQuery ::= DESCRIBE VarOrIriX DatasetClauseX WhereClause SolutionModifier.
VarOrIriX ::= VarOrIri.
VarOrIriX ::= VarOrIri VarOrIriX.

AskQuery ::= ASK WhereClause.
AskQuery ::= ASK DatasetClauseX WhereClause.
AskQuery ::= ASK WhereClause SolutionModifier.
AskQuery ::= ASK DatasetClauseX WhereClause SolutionModifier.

DatasetClause ::= FROM DefaultGraphClause.
DatasetClause ::= FROM NamedGraphClause.

DefaultGraphClause ::= iri.

NamedGraphClause ::= NAMED iri.

WhereClause ::= GroupGraphPattern.
WhereClause ::= WHERE GroupGraphPattern.

SolutionModifier ::= GroupClause.
SolutionModifier ::= HavingClause.
SolutionModifier ::= OrderClause.
SolutionModifier ::= LimitClause.
SolutionModifier ::= GroupClause HavingClause.
SolutionModifier ::= GroupClause OrderClause.
SolutionModifier ::= GroupClause LimitClause.
SolutionModifier ::= HavingClause OrderClause.
SolutionModifier ::= HavingClause LimitClause.
SolutionModifier ::= OrderClause LimitClause.
SolutionModifier ::= GroupClause HavingClause OrderClause.
SolutionModifier ::= GroupClause HavingClause LimitClause.
SolutionModifier ::= GroupClause OrderClause LimitClause.
SolutionModifier ::= HavingClause OrderClause LimitClause.
SolutionModifier ::= GroupClause HavingClause OrderClause LimitClause.

GroupClause ::= GROUP BY GroupConditionX.
GroupConditionX ::= GroupCondition.
GroupConditionX ::= GroupCondition GroupConditionX.

GroupCondition ::= BultInCall.
GroupCondition ::= FunctionCall.
GroupCondition ::= Expression.
GroupCondition ::= Expression AS Var.
GroupCondition ::= Var.

HavingClause ::= HAVING ConstraintX.
ConstraintX ::= Constraint.
ConstraintX ::= Constraint ConstraintX.

OrderClause ::= ORDER BY OrderConditionX.
OrderConditionX ::= OrderCondition.
OrderConditionX ::= OrderCondition OrderConditionX.

OrderCondition ::= ASC BrackettedExpression.
OrderCondition ::= DESC BrackettedExpression.
OrderCondition ::= Constraint.
OrderCondition ::= Var.

LimitOffsetClauses ::= LimitClause.
LimitOffsetClauses ::= LimitClause OffsetClause.
LimitOffsetClauses ::= OffsetClause.
LimitOffsetClauses ::= OffsetClause LimitClause.

LimitClause ::= LIMIT INTEGER.

OffsetClause ::= OFFSET INTEGER.

ValuesClause ::= VALUES DataBlock.

Update ::= Prologue Update1.
Update ::= Update1.
Update ::= Update1 SEMICOLON Update.
Update ::= Prologue Update1 SEMICOLON Update.

Update1 ::= Load.
Update1 ::= Clear.
Update1 ::= Drop.
Update1 ::= Add.
Update1 ::= Move.
Update1 ::= Copy.
Update1 ::= Create.
Update1 ::= InsertData.
Update1 ::= DeleteData.
Update1 ::= DeleteWhere.
Update1 ::= Modify.

Load ::= LOAD iri.
Load ::= LOAD SILENT iri.
Load ::= LOAD iri INTO GraphRef.
Load ::= LOAD SILENT iri INTO GraphRef.

Clear ::= CLEAR GraphRefAll.
Clear ::= CLEAR SILENT GraphRefall.

Drop ::= DROP GraphRefAll.
Drop ::= DROP SILENT GraphRefall.

Create ::= CREATE GraphRef.
Create ::= CREATE SILENT GraphRef.

Add ::= ADD GraphOrDefault TO GraphOrDefault.
Add ::= ADD SILENT GraphOrDefault TO GraphOrDefault.

Move ::= MOVE GraphOrDefault TO GraphOrDefault.
Move ::= MOVE SILENT GraphOrDefault TO GraphOrDefault.

Copy ::= COPY GraphOrDefault TO GraphOrDefault.
Copy ::= COPY SILENT GraphOrDefault TO GraphOrDefault.

InsertData ::= INSERTDATA QuadData.

DeleteData ::= DELETEDATA QuadData1.!!!!!!!!!!!!

DeleteWhere ::= DELETEWHERE QuadPattern1.!!!!!!!

Modify ::= DeleteClause WHERE GroupGraphPattern.
Modify ::= DeleteClause InsertClause WHERE GroupGraphPattern.
Modify ::= InsertClause WHERE GroupGraphPattern.
Modify ::= WITH iri DeleteClause WHERE GroupGraphPattern.
Modify ::= WITH iri DeleteClause InsertClause WHERE GroupGraphPattern.
Modify ::= WITH iri InsertClause WHERE GroupGraphPattern.
Modify ::= DeleteClause UsingClauseX WHERE GroupGraphPattern.
Modify ::= DeleteClause InsertClause UsingClauseX WHERE GroupGraphPattern.
Modify ::= InsertClause UsingClauseX WHERE GroupGraphPattern.
Modify ::= WITH iri DeleteClause UsingClauseX WHERE GroupGraphPattern.
Modify ::= WITH iri DeleteClause InsertClause UsingClauseX WHERE GroupGraphPattern.
Modify ::= WITH iri InsertClause UsingClauseX WHERE GroupGraphPattern.
UsingClauseX ::= UsingClause.
UsingClauseX ::= UsingClause UsingClauseX.

DeleteClause ::= DELETE QuadPattern1.!!!!!!!!!

InsertClause ::= INSERT QuadPattern.

UsingClause ::= USING iri.
UsingClause ::= USING NAMED iri.

GraphOrDefault ::= DEFAULT.
GraphOrDefault ::= iri.
GraphOrDefault ::= GRAPH iri.

GraphRef ::= GRAPH iri.

GraphRefAll ::= GraphRef.
GraphRefAll ::= DEFAULT.
GraphRefAll ::= NAMED.
GraphRefAll ::= ALL.

QuadPattern ::= LBRACE RBRACE.
QuadPattern ::= LBRACE Quads RBRACE.

QuadData ::= LBRACE RBRACE.
QuadData ::= LBRACE Quads1 RBRACE.

Quads ::= TriplesTemplate.
Quads ::= QuadsX.
Quads ::= TriplesTemplate QuadsX.
QuadsX ::= QuadsNotTriples.
QuadsX ::= QuadsNotTriples DOT.
QuadsX ::= QuadsNotTriples TriplesTemplate.
QuadsX ::= QuadsNotTriples DOT TriplesTemplate.
QuadsX ::= QuadsNotTriples QuadsX.
QuadsX ::= QuadsNotTriples DOT QuadsX.
QuadsX ::= QuadsNotTriples TriplesTemplate QuadsX.
QuadsX ::= QuadsNotTriples DOT TriplesTemplate QuadsX.

QuadsNotTriples ::= GRAPH VarOrIri LBRACE RBRACE.
QuadsNotTriples ::= GRAPH VarOrIri LBRACE TriplesTemplate RBRACE.

TriplesTemplate ::= TriplesSameSubject.
TriplesTemplate ::= TriplesSameSubject DOT.
TriplesTemplate ::= TriplesSameSubject DOT TriplesTemplate.

GroupGraphPattern ::= LBRACE RBRACE.
GroupGraphPattern ::= LBRACE SubSelect RBRACE.
GroupGraphPattern ::= LBRACE GroupGraphPatternSub RBRACE.

GroupGraphPatternSub ::= TriplesBlock.
GroupGraphPatternSub ::= GroupGraphPatternSubX.
GroupGraphPatternSub ::= TriplesBlock GroupGraphPatternSubX.
GroupGraphPatternSubX ::= GraphPatternNotTriples.
GroupGraphPatternSubX ::= GraphPatternNotTriples DOT.
GroupGraphPatternSubX ::= GraphPatternNotTriples TriplesBlock.
GroupGraphPatternSubX ::= GraphPatternNotTriples DOT TriplesBlock.
GroupGraphPatternSubX ::= GraphPatternNotTriples GroupGraphPatternSubX.
GroupGraphPatternSubX ::= GraphPatternNotTriples DOT GroupGraphPatternSubX.
GroupGraphPatternSubX ::= GraphPatternNotTriples TriplesBlock GroupGraphPatternSubX.
GroupGraphPatternSubX ::= GraphPatternNotTriples DOT TriplesBlock GroupGraphPatternSubX.

TriplesBlock ::= TriplesSameSubjectPath.
TriplesBlock ::= TriplesSameSubjectPath DOT.
TriplesBlock ::= TriplesSameSubjectPath DOT TriplesBlock.

GraphPatternNotTriples ::= GroupOrUnionGraphPattern.
GraphPatternNotTriples ::= OptionalGraphPattern.
GraphPatternNotTriples ::= MinusGraphPattern.
GraphPatternNotTriples ::= GraphGraphPattern.
GraphPatternNotTriples ::= ServiceGraphPattern.
GraphPatternNotTriples ::= Filter.
GraphPatternNotTriples ::= Bind.
GraphPatternNotTriples ::= InlineData.

OptionalGraphPattern ::= OPTIONAL GroupGraphPattern.

ServiceGraphPattern ::= SERVICE VarOrIri GroupGraphPattern.
ServiceGraphPattern ::= SERVICE SILENT VarOrIri GroupGraphPattern.

Bind ::= BIND LPARENTHESE Expression AS Var RPARENTHESE.

/* solved issues: * + through loops, update is allowed to be empty (completely empty) -> removed, 
 * no vars in QuadData -> extra rules, no blanknodes in delete where, delete clause, 
 * delete data -> extra rules,
 * troublemaker: DataBlock - needs same amount of variables and datablockvalues, scoping, 
 * limiting aggregates, custom aggregates
*/
