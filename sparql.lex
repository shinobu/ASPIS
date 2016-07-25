<?php
include 'jlex.php';

/*todo make a list of all Terminals to tokenize, make makros of things like echar, make extra tokens for all keywords
/* TerminalTokens: IRIREF PNAME_NS PNAME_LN BLANK_NODE_LABEL VAR1 VAR2 LANGTAG INTEGER DECIMAL DOUBLE INTEGER_POSITIVE 
DECIMAL POSITIVE DOUBLE_POSITIVE INTEGER_NEGATIVE DECIMAL_NEGATIVE STRING LITERAL1 STRING_LITERAL2 STRING_LITERAL_LONG1 
STRING_LITERAL_LONG2 NIL WS ANON 
/*need to check if unicode with more then 4 digits is allowed and \x with 1 or how to fill
/*Makros Done
%%
%{
	/* blah */
%}
%function nextToken
%line
%char
%state COMMENT
%class SparqlLexer
D	=	[0-9]
EXPONENT = [eE][+-]?{D}+
ECHAR = '\\'[tbnrf\\'"'"'"]
PN_CHARS_BASE = [A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|[\u10000-\uEFFFF]
PN_CHARS_U = {PN_CHARS_BASE}|'_'
VARNAME = ({PN_CHARS_U}|{D})({PN_CHARS_U}|{D}|\u00B7|[\u0300-\u036F]|[\u203F-\u2040])*
PN_CHARS = {PN_CHARS_U}|'-'|{D}|\u00B7|[\u0300-\u036F]|[\u203F-\u2040]
PN_PREFIX = {PN_CHARS_BASE}(({PN_CHARS}|'.')*{PN_CHARS})?
PN_LOCAL = ({PN_CHARS_U}|':'|{D}|{PLX})(({PN_CHARS}|'.'|':'|{PLX})*({PN_CHARS}|':'|{PLX}))?
PN_LOCAL_ESC = '\\'('_'|'~'|'.'|'-'|'!'|'$'|'&'|"'"|'('|')'|'*'|'+'|','|';'|'='|'/'|'?'|'#'|'@'|'%')
HEX = [0-9]|[A-F]|[a-f]
PERCENT = '%'{HEX}{HEX}
PLX = {PERCENT}|{PN_LOCAL_ESC}

%%

<YYINITIAL> '<'([^<>\"{}|^`\\]-[\x00-\x20])*'>' 	{ return $this->createToken(SparqlPHPParser::TK_IRIREF); }
<YYINITIAL> {PN_PREFIX}?':' { return $this->createToken(SparqlPHPParser::TK_PNAME_NS); }
<YYINITIAL> {PN_PREFIX}?':'{PN_LOCAL} 	{ return $this->createToken(SparqlPHPParser::TK_PNAME_LN); }
<YYINITIAL> '_:'({PN_CHARS_U}|{D})(({PN_CHARS}|'.')*{PN_CHARS})? 	{ return $this->createToken(SparqlPHPParser::TK_BLANK_NODE_LABEL); }
<YYINITIAL> '?'{VARNAME}  { return $this->createToken(SparqlPHPParser::TK_VAR1); }
<YYINITIAL> '$'{VARNAME} 	{ return $this->createToken(SparqlPHPParser::TK_VAR2); }
<YYINITIAL> '@'[a-zA-Z]+('-'[a-zA-Z0-9]+)* 	{ return $this->createToken(SparqlPHPParser::TK_LANGTAG); }
<YYINITIAL> {D}+ 	{ return $this->createToken(SparqlPHPParser::TK_INTEGER); }
<YYINITIAL> {D}*'.'{D}+ 	{ return $this->createToken(SparqlPHPParser::TK_DECIMAL); }
<YYINITIAL> {D}+'.'{D}*{EXPONENT}|'.'({D})+{EXPONENT}|({D})+{EXPONENT} 	{ return $this->createToken(SparqlPHPParser::TK_DOUBLE); }
<YYINITIAL> '+'{D}+ 	{ return $this->createToken(SparqlPHPParser::TK_INTEGER_POSITIVE); }
<YYINITIAL> '+'{D}*'.'{D}+ 	{ return $this->createToken(SparqlPHPParser::TK_DECIMAL_POSITIVE); }
<YYINITIAL> '+'{D}+'.'{D}*{EXPONENT}|'.'({D})+{EXPONENT}|({D})+{EXPONENT} 	{ return $this->createToken(SparqlPHPParser::TK_DOUBLE_POSITIVE); }
<YYINITIAL> '-'{D}+ 	{ return $this->createToken(SparqlPHPParser::TK_INTEGER_NEGATIVE); }
<YYINITIAL> '-'{D}*'.'{D}+ 	{ return $this->createToken(SparqlPHPParser::TK_DECIMAL_NEGATIVE); }
<YYINITIAL> '-'{D}+'.'{D}*{EXPONENT}|'.'({D})+{EXPONENT}|({D})+{EXPONENT} 	{ return $this->createToken(SparqlPHPParser::TK_DOUBLE_NEGATIVE); }
<YYINITIAL> "'"(([^\x27\x5C\xA\xD])|{ECHAR})*"'" 	{ return $this->createToken(SparqlPHPParser::TK_STRING_LITERAL1); }
<YYINITIAL> '"'(([^\x22\x5C\xA\xD])|{ECHAR})*'"' 	{ return $this->createToken(SparqlPHPParser::TK_STRING_LITERAL2); }
<YYINITIAL> "'''"(("'"|"''")?([^"'"\\]|{ECHAR}))*"'''" 	{ return $this->createToken(SparqlPHPParser::TK_STRING_LITERAL_LONG1); }
<YYINITIAL> '"""'(('"'|'""')?([^'"'\\]|{ECHAR}))*'"""' 	{ return $this->createToken(SparqlPHPParser::TK_STRING_LITERAL_LONG2); }
<YYINITIAL> '('(\x20|\x9|\xD|\xA)*')' 	{ return $this->createToken(SparqlPHPParser::TK_NIL); }
<YYINITIAL> \x20|\x9|\xD|\xA 	{ return $this->createToken(SparqlPHPParser::TK_WS); }
<YYINITIAL> '['(\x20|\x9|\xD|\xA)*']' 	{ return $this->createToken(SparqlPHPParser::TK_ANON); }

<YYINITIAL> [Bb][Aa][Ss][Ee] { return $this->createToken(SparqlPHPParser::TK_BASE); }
<YYINITIAL> [Pp][Rr][Ee][Ff][Ii][Xx] { return $this->createToken(SparqlPHPParser::TK_PREFIX); }
<YYINITIAL> [Ss][Ee][Ll][Ee][Cc][Tt] { return $this->createToken(SparqlPHPParser::TK_SELECT); }
<YYINITIAL> [Dd][Ii][Ss][Tt][Ii][Nn][Cc][Tt] { return $this->createToken(SparqlPHPParser::TK_DISTINCT); }
<YYINITIAL> [Rr][Ee][Dd][Uu][Cc][Ee][Dd] { return $this->createToken(SparqlPHPParser::TK_REDUCED); }
<YYINITIAL> '(' { return $this->createToken(SparqlPHPParser::TK_LPARENTHESE); }
<YYINITIAL> ')' { return $this->createToken(SparqlPHPParser::TK_RPARENTHESE); }
<YYINITIAL> [Aa][Ss] { return $this->createToken(SparqlPHPParser::TK_AS); }
<YYINITIAL> '*' { return $this->createToken(SparqlPHPParser::TK_STAR); }
<YYINITIAL> [Cc][Oo][Nn][Ss][Tt][Rr][Uu][Cc][Tt] { return $this->createToken(SparqlPHPParser::TK_CONSTRUCT); }
<YYINITIAL> [Dd][Ee][Ss][Cc][Rr][Ii][Bb][Ee] { return $this->createToken(SparqlPHPParser::TK_DESCRIBE); }
<YYINITIAL> [Aa][Ss][Kk] { return $this->createToken(SparqlPHPParser::TK_ASK); }
<YYINITIAL> [Ff][Rr][Oo][Mm] { return $this->createToken(SparqlPHPParser::TK_FROM); }
<YYINITIAL> [Nn][Aa][Mm][Ee][Dd] { return $this->createToken(SparqlPHPParser::TK_NAMED); }
<YYINITIAL> [Gg][Rr][Oo][Uu][Pp] { return $this->createToken(SparqlPHPParser::TK_GROUP); }
<YYINITIAL> [Bb][Yy] { return $this->createToken(SparqlPHPParser::TK_BY); }
<YYINITIAL> [Hh][Aa][Vv][Ii][Nn][Gg] { return $this->createToken(SparqlPHPParser::TK_HAVING); }
<YYINITIAL> [Oo][Rr][Dd][Ee][Rr] { return $this->createToken(SparqlPHPParser::TK_ORDER); }
<YYINITIAL> [Aa][Ss][Cc] { return $this->createToken(SparqlPHPParser::TK_ASC); }
<YYINITIAL> [Dd][Ee][Ss][Cc] { return $this->createToken(SparqlPHPParser::TK_DESC); }
<YYINITIAL> [Ll][Ii][Mm][Ii][Tt] { return $this->createToken(SparqlPHPParser::TK_LIMIT); }
<YYINITIAL> [Oo][Ff][Ff][Ss][Ee][Tt] { return $this->createToken(SparqlPHPParser::TK_OFFSET); }
<YYINITIAL> [Vv][Aa][Ll][Uu][Ee][Ss] { return $this->createToken(SparqlPHPParser::TK_VALUES); }
<YYINITIAL> ';' { return $this->createToken(SparqlPHPParser::TK_SEMICOLON); }
<YYINITIAL> [Ll][Oo][Aa][Dd] { return $this->createToken(SparqlPHPParser::TK_LOAD); }
<YYINITIAL> [Ss][Ii][Ll][Ee][Nn][Tt] { return $this->createToken(SparqlPHPParser::TK_SILENT); }
<YYINITIAL> [Ii][Nn][Tt][Oo] { return $this->createToken(SparqlPHPParser::TK_INTO); }
<YYINITIAL> [Cc][Ll][Ee][Aa][Rr] { return $this->createToken(SparqlPHPParser::TK_CLEAR); }
<YYINITIAL> [Dd][Rr][Oo][Pp] { return $this->createToken(SparqlPHPParser::TK_DROP); }
<YYINITIAL> [Cc][Rr][Ee][Aa][Tt][Ee] { return $this->createToken(SparqlPHPParser::TK_CREATE); }
<YYINITIAL> [Aa][Dd][Dd] { return $this->createToken(SparqlPHPParser::TK_ADD); }
<YYINITIAL> [Tt][Oo] { return $this->createToken(SparqlPHPParser::TK_TO); }
<YYINITIAL> [Mm][Oo][Vv][Ee] { return $this->createToken(SparqlPHPParser::TK_MOVE); }
<YYINITIAL> [Cc][Oo][Pp][Yy] { return $this->createToken(SparqlPHPParser::TK_COPY); }
<YYINITIAL> [Ww][Ii][Tt][Hh] { return $this->createToken(SparqlPHPParser::TK_WITH); }
<YYINITIAL> [Ww][Hh][Ee][Rr][Ee] { return $this->createToken(SparqlPHPParser::TK_WHERE); }
<YYINITIAL> [Dd][Ee][Ll][Ee][Tt][Ee] { return $this->createToken(SparqlPHPParser::TK_DELETE); }
<YYINITIAL> [Ii][Nn][Ss][Ee][Rr][Tt] { return $this->createToken(SparqlPHPParser::TK_INSERT); }
<YYINITIAL> [Uu][Ss][Ii][Nn][Gg] { return $this->createToken(SparqlPHPParser::TK_USING); }
<YYINITIAL> [Nn][Aa][Mm][Ee][Dd] { return $this->createToken(SparqlPHPParser::TK_NAMED); }
<YYINITIAL> [Dd][Ee][Ff][Aa][Uu][Ll][Tt] { return $this->createToken(SparqlPHPParser::TK_DEFAULT); }
<YYINITIAL> [Gg][Rr][Aa][Pp][Hh] { return $this->createToken(SparqlPHPParser::TK_GRAPH); }
<YYINITIAL> [Aa][Ll][Ll] { return $this->createToken(SparqlPHPParser::TK_ALL); }
<YYINITIAL> '{' { return $this->createToken(SparqlPHPParser::TK_LBRACE); }
<YYINITIAL> '}' { return $this->createToken(SparqlPHPParser::TK_RBRACE); }
<YYINITIAL> '.' { return $this->createToken(SparqlPHPParser::TK_DOT); }
<YYINITIAL> [Oo][Pp][Tt][Ii][Oo][Nn][Aa][Ll] { return $this->createToken(SparqlPHPParser::TK_OPTIONAL); }
<YYINITIAL> [Ss][Ee][Rr][Vv][Ii][Cc][Ee] { return $this->createToken(SparqlPHPParser::TK_SERVICE); }
<YYINITIAL> [Bb][Ii][Nn][Dd] { return $this->createToken(SparqlPHPParser::TK_BIND); }
<YYINITIAL> [Uu][Nn][Dd][Ee][Ff] { return $this->createToken(SparqlPHPParser::TK_UNDEF); }
<YYINITIAL> [Mm][Ii][Nn][Uu][Ss] { return $this->createToken(SparqlPHPParser::TK_SMINUS); }
<YYINITIAL> [Uu][Nn][Ii][Oo][Nn] { return $this->createToken(SparqlPHPParser::TK_UNION); }
<YYINITIAL> [Ff][Ii][Ll][Tt][Ee][Rr] { return $this->createToken(SparqlPHPParser::TK_FILTER); }
<YYINITIAL> ',' { return $this->createToken(SparqlPHPParser::TK_COMMA); }
<YYINITIAL> 'a' { return $this->createToken(SparqlPHPParser::TK_A); }
<YYINITIAL> '|' { return $this->createToken(SparqlPHPParser::TK_VBAR); }
<YYINITIAL> '/' { return $this->createToken(SparqlPHPParser::TK_SLASH); }
<YYINITIAL> '^' { return $this->createToken(SparqlPHPParser::TK_HAT); }
<YYINITIAL> '?' { return $this->createToken(SparqlPHPParser::TK_QUESTION); }
<YYINITIAL> '+' { return $this->createToken(SparqlPHPParser::TK_PLUS); }
<YYINITIAL> '[' { return $this->createToken(SparqlPHPParser::TK_LBRACKET); }
<YYINITIAL> ']' { return $this->createToken(SparqlPHPParser::TK_RBRACKET); }
<YYINITIAL> '||' { return $this->createToken(SparqlPHPParser::TK_OR); }
<YYINITIAL> '&&' { return $this->createToken(SparqlPHPParser::TK_AND); }
<YYINITIAL> '-' { return $this->createToken(SparqlPHPParser::TK_MINUS); }
<YYINITIAL> '=' { return $this->createToken(SparqlPHPParser::TK_EQUAL); }
<YYINITIAL> '!=' { return $this->createToken(SparqlPHPParser::TK_NEQUAL); }
<YYINITIAL> '<' { return $this->createToken(SparqlPHPParser::TK_SMALLERTHEN); }
<YYINITIAL> '>' { return $this->createToken(SparqlPHPParser::TK_GREATERTHEN); }
<YYINITIAL> '=<' { return $this->createToken(SparqlPHPParser::TK_SMALLERTHENQ); }
<YYINITIAL> '=>' { return $this->createToken(SparqlPHPParser::TK_GREATERTHENQ); }
<YYINITIAL> [Ii][Nn] { return $this->createToken(SparqlPHPParser::TK_IN); }
<YYINITIAL> [Nn][Oo][Tt] { return $this->createToken(SparqlPHPParser::TK_NOT); }
<YYINITIAL> [Ss][Tt][Rr] { return $this->createToken(SparqlPHPParser::TK_STR); }
<YYINITIAL> [Ll][Aa][Nn][Gg] { return $this->createToken(SparqlPHPParser::TK_LANG); }
<YYINITIAL> [Ll][Aa][Nn][Gg][Mm][Aa][Tt][Cc][Hh][Ee][Ss] { return $this->createToken(SparqlPHPParser::TK_LANGMATCHES); }
<YYINITIAL> [Dd][Aa][Tt][Aa][Tt][Yy][Pp][Ee] { return $this->createToken(SparqlPHPParser::TK_DATATYPE); }
<YYINITIAL> [Bb][Oo][Uu][Nn][Dd] { return $this->createToken(SparqlPHPParser::TK_BOUND); }
<YYINITIAL> [Ii][Rr][Ii] { return $this->createToken(SparqlPHPParser::TK_IRI); }
<YYINITIAL> [Uu][Rr][Ii] { return $this->createToken(SparqlPHPParser::TK_URI); }
<YYINITIAL> [Bb][Nn][Oo][Dd][Ee] { return $this->createToken(SparqlPHPParser::TK_BNODE); }
<YYINITIAL> [Rr][Aa][Nn][Dd] { return $this->createToken(SparqlPHPParser::TK_RAND); }
<YYINITIAL> [Aa][Bb][Ss] { return $this->createToken(SparqlPHPParser::TK_ABS); }
<YYINITIAL> [Cc][Ee][Ii][Ll] { return $this->createToken(SparqlPHPParser::TK_CEIL); }
<YYINITIAL> [Ff][Ll][Oo][Oo][Rr] { return $this->createToken(SparqlPHPParser::TK_FLOOR); }
<YYINITIAL> [Rr][Oo][Uu][Nn][Dd] { return $this->createToken(SparqlPHPParser::TK_ROUND); }
<YYINITIAL> [Cc][Oo][Nn][Cc][Aa][Tt] { return $this->createToken(SparqlPHPParser::TK_CONCAT); }
<YYINITIAL> [Ss][Tt][Rr][Ll][Ee][Nn] { return $this->createToken(SparqlPHPParser::TK_STRLEN); }
<YYINITIAL> [Uu][Cc][Aa][Ss][Ee] { return $this->createToken(SparqlPHPParser::TK_UCASE); }
<YYINITIAL> [Ll][Cc][Aa][Ss][Ee] { return $this->createToken(SparqlPHPParser::TK_LCASE); }
<YYINITIAL> [Ee][Nn][Cc][Oo][Dd][Ee]'_'[Ff][Oo][Rr]'_'[Uu][Rr][Ii] { return $this->createToken(SparqlPHPParser::TK_ENCODE_FOR_URI); }
<YYINITIAL> [Cc][Oo][Nn][Tt][Aa][Ii][Nn][Ss] { return $this->createToken(SparqlPHPParser::TK_CONTAINS); }
<YYINITIAL> [Ss][Tt][Rr][Ss][Tt][Aa][Rr][Tt][Ss] { return $this->createToken(SparqlPHPParser::TK_STRSTARTS); }
<YYINITIAL> [Ss][Tt][Rr][Ee][Nn][Dd][Ss] { return $this->createToken(SparqlPHPParser::TK_STRENDS); }
<YYINITIAL> [Ss][Tt][Rr][Bb][Ee][Ff][Oo][Rr][Ee] { return $this->createToken(SparqlPHPParser::TK_STRBEFORE); }
<YYINITIAL> [Ss][Tt][Rr][Aa][Ff][Tt][Ee][Rr] { return $this->createToken(SparqlPHPParser::TK_STRAFTER); }
<YYINITIAL> [Yy][Ee][Aa][Rr] { return $this->createToken(SparqlPHPParser::TK_YEAR); }
<YYINITIAL> [Mm][Oo][Nn][Tt][Hh] { return $this->createToken(SparqlPHPParser::TK_MONTH); }
<YYINITIAL> [Dd][Aa][Yy] { return $this->createToken(SparqlPHPParser::TK_DAY); }
<YYINITIAL> [Hh][Oo][Uu][Rr][Ss] { return $this->createToken(SparqlPHPParser::TK_HOURS); }
<YYINITIAL> [Mm][Ii][Nn][Uu][Tt][Ee][Ss] { return $this->createToken(SparqlPHPParser::TK_MINUTES); }
<YYINITIAL> [Ss][Ee][Cc][Oo][Nn][Dd][Ss] { return $this->createToken(SparqlPHPParser::TK_SECONDS); }
<YYINITIAL> [Tt][Ii][Mm][Ee][Zz][Oo][Nn][Ee] { return $this->createToken(SparqlPHPParser::TK_TIMEZONE); }
<YYINITIAL> [Tt][Zz] { return $this->createToken(SparqlPHPParser::TK_TZ); }
<YYINITIAL> [Nn][Oo][Ww] { return $this->createToken(SparqlPHPParser::TK_NOW); }
<YYINITIAL> [Uu][Uu][Ii][Dd] { return $this->createToken(SparqlPHPParser::TK_UUID); }
<YYINITIAL> [Ss][Tt][Rr][Uu][Uu][Ii][Dd] { return $this->createToken(SparqlPHPParser::TK_STRUUID); }
<YYINITIAL> [Mm][Dd]'5' { return $this->createToken(SparqlPHPParser::TK_MD5); }
<YYINITIAL> [Ss][Hh][Aa]'1' { return $this->createToken(SparqlPHPParser::TK_SHA1); }
<YYINITIAL> [Ss][Hh][Aa]'256' { return $this->createToken(SparqlPHPParser::TK_SHA256); }
<YYINITIAL> [Ss][Hh][Aa]'384' { return $this->createToken(SparqlPHPParser::TK_SHA384); }
<YYINITIAL> [Ss][Hh][Aa]'512' { return $this->createToken(SparqlPHPParser::TK_SHA512); }
<YYINITIAL> [Cc][Oo][Aa][Ll][Ee][Ss][Cc][Ee] { return $this->createToken(SparqlPHPParser::TK_COALESCE); }
<YYINITIAL> [Ii][Ff] { return $this->createToken(SparqlPHPParser::TK_IF); }
<YYINITIAL> [Ss][Tt][Rr][Ll][Aa][Nn][Gg] { return $this->createToken(SparqlPHPParser::TK_STRLANG); }
<YYINITIAL> [Ss][Tt][Rr][Dd][Tt] { return $this->createToken(SparqlPHPParser::TK_STRDT); }
<YYINITIAL> [Ss][Aa][Mm][Ee][Tt][Ee][Rr][Mm] { return $this->createToken(SparqlPHPParser::TK_SAMETERM); }
<YYINITIAL> [Ii][Ss][Ii][Rr][Ii] { return $this->createToken(SparqlPHPParser::TK_ISIRI); }
<YYINITIAL> [Ii][Ss][Uu][Rr][Ii] { return $this->createToken(SparqlPHPParser::TK_ISURI); }
<YYINITIAL> [Ii][Ss][Bb][Ll][Aa][Nn][Kk] { return $this->createToken(SparqlPHPParser::TK_ISBLANK); }
<YYINITIAL> [Ii][Ss][Ll][Ii][Tt][Ee][Rr][Aa][Ll] { return $this->createToken(SparqlPHPParser::TK_ISLITERAL); }
<YYINITIAL> [Ii][Ss][Nn][Uu][Mm][Ee][Rr][Ii][Cc] { return $this->createToken(SparqlPHPParser::TK_ISNUMERIC); }
<YYINITIAL> [Rr][Ee][Gg][Ee][Xx] { return $this->createToken(SparqlPHPParser::TK_REGEX); }
<YYINITIAL> [Ss][Uu][Bb][Ss][Tt][Rr] { return $this->createToken(SparqlPHPParser::TK_SUBSTR); }
<YYINITIAL> [Rr][Ee][Pp][Ll][Aa][Cc][Ee] { return $this->createToken(SparqlPHPParser::TK_REPLACE); }
<YYINITIAL> [Ee][Xx][Ii][Ss][Tt][Ss] { return $this->createToken(SparqlPHPParser::TK_EXISTS); }
<YYINITIAL> [Cc][Oo][Uu][Nn][Tt] { return $this->createToken(SparqlPHPParser::TK_COUNT); }
<YYINITIAL> [Ss][Uu][Mm] { return $this->createToken(SparqlPHPParser::TK_SUM); }
<YYINITIAL> [Mm][Ii][Nn] { return $this->createToken(SparqlPHPParser::TK_MIN); }
<YYINITIAL> [Mm][Aa][Xx] { return $this->createToken(SparqlPHPParser::TK_MAX); }
<YYINITIAL> [Aa][Vv][Gg] { return $this->createToken(SparqlPHPParser::TK_AVG); }
<YYINITIAL> [Ss][Aa][Mm][Pp][Ll][Ee] { return $this->createToken(SparqlPHPParser::TK_SAMPLE); }
<YYINITIAL> [Gg][Rr][Oo][Uu][Pp]'_'[Cc][Oo][Nn][Cc][Aa][Tt] { return $this->createToken(SparqlPHPParser::TK_GROUP_CONCAT); }
<YYINITIAL> [Ss][Ee][Pp][Aa][Rr][Aa][Tt][Oo][Rr] { return $this->createToken(SparqlPHPParser::TK_SEPARATOR); }
<YYINITIAL> '^^' { return $this->createToken(SparqlPHPParser::TK_DHAT); }
<YYINITIAL> [Tt][Rr][Uu][Ee] { return $this->createToken(SparqlPHPParser::TK_TRUE); }
<YYINITIAL> [Ff][Aa][Ll][Ss][Ee] { return $this->createToken(SparqlPHPParser::TK_FALSE); }
<YYINITIAL> [Ii][Nn][Ss][Ee][Rr][Tt]([\t\r\n]|'#'[^\r\n]+)+[Dd][Aa][Tt][Aa] { return $this->createToken(SparqlPHPParser::TK_INSERTDATA); }
<YYINITIAL> [Dd][Ee][Ll][Ee][Tt][Ee]([\t\r\n]|'#'[^\r\n]+)+[Dd][Aa][Tt][Aa] { return $this->createToken(SparqlPHPParser::TK_DELETEDATA); }
<YYINITIAL> [Dd][Ee][Ll][Ee][Tt][Ee]([\t\r\n]|'#'[^\r\n]+)+[Ww][Hh][Ee][Rr][Ee] { return $this->createToken(SparqlPHPParser::TK_DELETEWHERE); }

<YYINITIAL> "/*"			{ 
								$this->commentTok = $this->createToken(CParser::TK_COMMENT);
								$this->yybegin(self::COMMENT);
						    }
<YYINITIAL> //[^\r\n]*      { return $this->createToken(CParser::TK_COMMENT); }
<COMMENT>   "*/"            { 
								$this->commentTok->value .= $this->yytext();
							    $this->yybegin(self::YYINITIAL); 
							    return $this->commentTok;
							}
<COMMENT>   (.|[\r\n])      { $this->commentTok->value .= $this->yytext(); }
<YYINITIAL> #[^\r\n]*       { return $this->createToken(CParser::TK_PRAGMA); }
<YYINITIAL> "auto"			{ return $this->createToken(CParser::TK_AUTO); }
<YYINITIAL> "break"			{ return $this->createToken(CParser::TK_BREAK); }
<YYINITIAL> "case"			{ return $this->createToken(CParser::TK_CASE); }
<YYINITIAL> "char"			{ return $this->createToken(CParser::TK_CHAR); }
<YYINITIAL> "const"			{ return $this->createToken(CParser::TK_CONST); }
<YYINITIAL> "continue"		{ return $this->createToken(CParser::TK_CONTINUE); }
<YYINITIAL> "default"		{ return $this->createToken(CParser::TK_DEFAULT); }
<YYINITIAL> "do"			{ return $this->createToken(CParser::TK_DO); }
<YYINITIAL> "double"		{ return $this->createToken(CParser::TK_DOUBLE); }
<YYINITIAL> "else"			{ return $this->createToken(CParser::TK_ELSE); }
<YYINITIAL> "enum"			{ return $this->createToken(CParser::TK_ENUM); }
<YYINITIAL> "extern"		{ return $this->createToken(CParser::TK_EXTERN); }
<YYINITIAL> "float"			{ return $this->createToken(CParser::TK_FLOAT); }
<YYINITIAL> "for"			{ return $this->createToken(CParser::TK_FOR); }
<YYINITIAL> "goto"			{ return $this->createToken(CParser::TK_GOTO); }
<YYINITIAL> "if"			{ return $this->createToken(CParser::TK_IF); }
<YYINITIAL> "int"			{ return $this->createToken(CParser::TK_INT); }
<YYINITIAL> "long"			{ return $this->createToken(CParser::TK_LONG); }
<YYINITIAL> "register"		{ return $this->createToken(CParser::TK_REGISTER); }
<YYINITIAL> "return"		{ return $this->createToken(CParser::TK_RETURN); }
<YYINITIAL> "short"			{ return $this->createToken(CParser::TK_SHORT); }
<YYINITIAL> "signed"		{ return $this->createToken(CParser::TK_SIGNED); }
<YYINITIAL> "sizeof"		{ return $this->createToken(CParser::TK_SIZEOF); }
<YYINITIAL> "static"		{ return $this->createToken(CParser::TK_STATIC); }
<YYINITIAL> "struct"		{ return $this->createToken(CParser::TK_STRUCT); }
<YYINITIAL> "switch"		{ return $this->createToken(CParser::TK_SWITCH); }
<YYINITIAL> "typedef"		{ return $this->createToken(CParser::TK_TYPEDEF); }
<YYINITIAL> "union"			{ return $this->createToken(CParser::TK_UNION); }
<YYINITIAL> "unsigned"		{ return $this->createToken(CParser::TK_UNSIGNED); }
<YYINITIAL> "void"			{ return $this->createToken(CParser::TK_VOID); }
<YYINITIAL> "volatile"		{ return $this->createToken(CParser::TK_VOLATILE); }
<YYINITIAL> "while"			{ return $this->createToken(CParser::TK_WHILE); }
<YYINITIAL> {L}({L}|{D})*		{ return $this->createToken(CParser::TK_IDENTIFIER); }
<YYINITIAL> 0[xX]{H}+{IS}?		{ return $this->createToken(CParser::TK_CONSTANT); }
<YYINITIAL> 0{D}+{IS}?		{ return $this->createToken(CParser::TK_CONSTANT); }
<YYINITIAL> {D}+{IS}?		{ return $this->createToken(CParser::TK_CONSTANT); }
<YYINITIAL> L?"'"(\\.|[^\\"'"])+"'"	{ return $this->createToken(CParser::TK_CONSTANT); }
<YYINITIAL> {D}+{E}{FS}?		{ return $this->createToken(CParser::TK_CONSTANT); }
<YYINITIAL> {D}*"."{D}+({E})?{FS}?	{ return $this->createToken(CParser::TK_CONSTANT); }
<YYINITIAL> {D}+"."{D}*({E})?{FS}?	{ return $this->createToken(CParser::TK_CONSTANT); }
<YYINITIAL> L?'"'(\\.|[^\\'"'])*'"' 	{ return $this->createToken(CParser::TK_STRING_LITERAL); }
<YYINITIAL> "..."			{ return $this->createToken(CParser::TK_ELLIPSIS); }
<YYINITIAL> ">>="			{ return $this->createToken(CParser::TK_RIGHT_ASSIGN); }
<YYINITIAL> "<<="			{ return $this->createToken(CParser::TK_LEFT_ASSIGN); }
<YYINITIAL> "+="			{ return $this->createToken(CParser::TK_ADD_ASSIGN); }
<YYINITIAL> "-="			{ return $this->createToken(CParser::TK_SUB_ASSIGN); }
<YYINITIAL> "*="			{ return $this->createToken(CParser::TK_MUL_ASSIGN); }
<YYINITIAL> "/="			{ return $this->createToken(CParser::TK_DIV_ASSIGN); }
<YYINITIAL> "%="			{ return $this->createToken(CParser::TK_MOD_ASSIGN); }
<YYINITIAL> "&="			{ return $this->createToken(CParser::TK_AND_ASSIGN); }
<YYINITIAL> "^="			{ return $this->createToken(CParser::TK_XOR_ASSIGN); }
<YYINITIAL> "|="			{ return $this->createToken(CParser::TK_OR_ASSIGN); }
<YYINITIAL> ">>"			{ return $this->createToken(CParser::TK_RIGHT_OP); }
<YYINITIAL> "<<"			{ return $this->createToken(CParser::TK_LEFT_OP); }
<YYINITIAL> "++"			{ return $this->createToken(CParser::TK_INC_OP); }
<YYINITIAL> "--"			{ return $this->createToken(CParser::TK_DEC_OP); }
<YYINITIAL> "->"			{ return $this->createToken(CParser::TK_PTR_OP); }
<YYINITIAL> "&&"			{ return $this->createToken(CParser::TK_AND_OP); }
<YYINITIAL> "||"			{ return $this->createToken(CParser::TK_OR_OP); }
<YYINITIAL> "<="			{ return $this->createToken(CParser::TK_LE_OP); }
<YYINITIAL> ">="			{ return $this->createToken(CParser::TK_GE_OP); }
<YYINITIAL> "=="			{ return $this->createToken(CParser::TK_EQ_OP); }
<YYINITIAL> "!="			{ return $this->createToken(CParser::TK_NE_OP); }
<YYINITIAL> ";"			{ return $this->createToken(CParser::TK_SEMIC); }
<YYINITIAL> ("{"|"<%")		{ return $this->createToken(CParser::TK_LCURLY); }
<YYINITIAL> ("}"|"%>")		{ return $this->createToken(CParser::TK_RCURLY); }
<YYINITIAL> ","			{ return $this->createToken(CParser::TK_COMMA); }
<YYINITIAL> ":"			{ return $this->createToken(CParser::TK_COLON); }
<YYINITIAL> "="			{ return $this->createToken(CParser::TK_EQUALS); }
<YYINITIAL> "("			{ return $this->createToken(CParser::TK_LPAREN); }
<YYINITIAL> ")"			{ return $this->createToken(CParser::TK_RPAREN); }
<YYINITIAL> ("["|"<:")		{ return $this->createToken(CParser::TK_LSQUARE); }
<YYINITIAL> ("]"|":>")		{ return $this->createToken(CParser::TK_RSQUARE); }
<YYINITIAL> "."			{ return $this->createToken(CParser::TK_PERIOD); }
<YYINITIAL> "&"			{ return $this->createToken(CParser::TK_AMP); }
<YYINITIAL> "!"			{ return $this->createToken(CParser::TK_EXCLAM); }
<YYINITIAL> "~"			{ return $this->createToken(CParser::TK_TILDE); }
<YYINITIAL> "-"			{ return $this->createToken(CParser::TK_MINUS); }
<YYINITIAL> "+"			{ return $this->createToken(CParser::TK_PLUS); }
<YYINITIAL> "*"			{ return $this->createToken(CParser::TK_STAR); }
<YYINITIAL> "/"			{ return $this->createToken(CParser::TK_SLASH); }
<YYINITIAL> "%"			{ return $this->createToken(CParser::TK_PERCENT); }
<YYINITIAL> "<"			{ return $this->createToken(CParser::TK_LANGLE); }
<YYINITIAL> ">"			{ return $this->createToken(CParser::TK_RANGLE); }
<YYINITIAL> "^"			{ return $this->createToken(CParser::TK_CARET); }
<YYINITIAL> "|"			{ return $this->createToken(CParser::TK_PIPE); }
<YYINITIAL> "?"			{ return $this->createToken(CParser::TK_QUESTION); }
<YYINITIAL> [ \t\v\n\f] { }
.			{ /* ignore bad characters */ }
