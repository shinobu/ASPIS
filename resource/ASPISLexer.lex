<?php
namespace ASPIS\lib;
include 'jlex.php';
use \JLexBase;
use \JLexToken;
%%
%{
	/* blah */
%}
%function nextToken
%unicode
%line
%char
%class ASPISLexer
D	=	[0-9]
EXPONENT = [eE][+-]?[0-9]+
PN_LOCAL_ESC = \\("_"|"~"|"."|"-"|"!"|"$"|"&"|"'"|"("|")"|"*"|"+"|","|";"|"="|"/"|"?"|"#"|"@"|"%")
HEX = [0-9]|[A-F]|[a-f]
PERCENT = "%"[a-fA-F0-9][a-fA-F0-9]
PLX = ("%"[a-fA-F0-9][a-fA-F0-9])|(\\("_"|"~"|"."|"-"|"!"|"$"|"&"|"'"|"("|")"|"*"|"+"|","|";"|"="|"/"|"?"|"#"|"@"|"%"))
ECHAR = \\[tbnrf\""'"]
PN_CHARS_BASE = [A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]
PN_CHARS_U = [A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"
VARNAME = ([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|[0-9])([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040])*
PN_CHARS = [A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|"-"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040]
PN_PREFIX = ([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD])(([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|"-"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040]|".")*([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|"-"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040]))?
PN_LOCAL = ([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|":"|[0-9]|("%"[a-fA-F0-9][a-fA-F0-9])|(\\("_"|"~"|"."|"-"|"!"|"$"|"&"|"'"|"("|")"|"*"|"+"|","|";"|"="|"/"|"?"|"#"|"@"|"%")))(([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|"-"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040]|"."|":"|("%"[a-fA-F0-9][a-fA-F0-9])|(\\("_"|"~"|"."|"-"|"!"|"$"|"&"|"'"|"("|")"|"*"|"+"|","|";"|"="|"/"|"?"|"#"|"@"|"%")))*([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|"-"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040]|":"|("%"[a-fA-F0-9][a-fA-F0-9])|(\\("_"|"~"|"."|"-"|"!"|"$"|"&"|"'"|"("|")"|"*"|"+"|","|";"|"="|"/"|"?"|"#"|"@"|"%"))))?
WS = \x20|\x09|\x0D|\x0A
%%

<YYINITIAL> "<"([^\x00-\x20<>\""{""}""|""^""`"\\])*">" { return $this->createToken(ASPISParser::TK_IRIREF); }
<YYINITIAL> (([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD])(([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|"-"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040]|".")*([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|"-"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040]))?)?":" { return $this->createToken(ASPISParser::TK_PNAME_NS); }
<YYINITIAL> (([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD])(([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|"-"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040]|".")*([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|"-"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040]))?)?":"(([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|":"|[0-9]|("%"[a-fA-F0-9][a-fA-F0-9])|(\\("_"|"~"|"."|"-"|"!"|"$"|"&"|"'"|"("|")"|"*"|"+"|","|";"|"="|"/"|"?"|"#"|"@"|"%")))(([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|"-"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040]|"."|":"|("%"[a-fA-F0-9][a-fA-F0-9])|(\\("_"|"~"|"."|"-"|"!"|"$"|"&"|"'"|"("|")"|"*"|"+"|","|";"|"="|"/"|"?"|"#"|"@"|"%")))*([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|"-"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040]|":"|("%"[a-fA-F0-9][a-fA-F0-9])|(\\("_"|"~"|"."|"-"|"!"|"$"|"&"|"'"|"("|")"|"*"|"+"|","|";"|"="|"/"|"?"|"#"|"@"|"%"))))?) { return $this->createToken(ASPISParser::TK_PNAME_LN); }
<YYINITIAL> "_:"([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|[0-9])(([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|"-"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040]|".")*([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|"-"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040]))?	{ return $this->createToken(ASPISParser::TK_BLANK_NODE_LABEL); }
<YYINITIAL> "?"([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|[0-9])([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040])*  { return $this->createToken(ASPISParser::TK_VAR1); }
<YYINITIAL> "$"([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|[0-9])([A-Z]|[a-z]|[\u00C0-\u00D6]|[\u00D8-\u00F6]|[\u00F8-\u02FF]|[\u0370-\u037D]|[\u037F-\u1FFF]|[\u200C-\u200D]|[\u2070-\u218F]|[\u2C00-\u2FEF]|[\u3001-\uD7FF]|[\uF900-\uFDCF]|[\uFDF0-\uFFFD]|"_"|[0-9]|[\u00B7]|[\u0300-\u036F]|[\u203F-\u2040])*  { return $this->createToken(ASPISParser::TK_VAR2); }

<YYINITIAL> ("@")?[Bb][Aa][Ss][Ee] { return $this->createToken(ASPISParser::TK_BASE); }
<YYINITIAL> ("@")?[Pp][Rr][Ee][Ff][Ii][Xx] { return $this->createToken(ASPISParser::TK_PREFIX); }

<YYINITIAL> "@"[a-zA-Z]+("-"[a-zA-Z0-9]+)* 	{ return $this->createToken(ASPISParser::TK_LANGTAG); }
<YYINITIAL> [0-9]+ 	{ return $this->createToken(ASPISParser::TK_INTEGER); }
<YYINITIAL> [0-9]*"."[0-9]+ 	{ return $this->createToken(ASPISParser::TK_DECIMAL); }
<YYINITIAL> ([0-9]+"."[0-9]*[eE][+-]?[0-9]+)|("."[0-9]+[eE][+-]?[0-9]+)|([0-9]+[eE][+-]?[0-9]+) 	{ return $this->createToken(ASPISParser::TK_DOUBLE); }
<YYINITIAL> "+"[0-9]+ 	{ return $this->createToken(ASPISParser::TK_INTEGER_POSITIVE); }
<YYINITIAL> "+"[0-9]*"."[0-9]+ 	{ return $this->createToken(ASPISParser::TK_DECIMAL_POSITIVE); }
<YYINITIAL> ("+"[0-9]+"."[0-9]*[eE][+-]?[0-9]+)|("."[0-9]+[eE][+-]?[0-9]+)|([0-9]+[eE][+-]?[0-9]+) 	{ return $this->createToken(ASPISParser::TK_DOUBLE_POSITIVE); }
<YYINITIAL> "-"[0-9]+ 	{ return $this->createToken(ASPISParser::TK_INTEGER_NEGATIVE); }
<YYINITIAL> "-"[0-9]*"."[0-9]+ 	{ return $this->createToken(ASPISParser::TK_DECIMAL_NEGATIVE); }
<YYINITIAL> ("-"[0-9]+"."[0-9]*[eE][+-]?[0-9]+)|("."[0-9]+[eE][+-]?[0-9]+)|([0-9]+[eE][+-]?[0-9]+) 	{ return $this->createToken(ASPISParser::TK_DOUBLE_NEGATIVE); }
<YYINITIAL> "'"(([^\x27\x5C\x0A\x0D])|(\\[tbnrf\""'"]))*"'" 	{ return $this->createToken(ASPISParser::TK_STRING_LITERAL1); }
<YYINITIAL> \"(([^\x22\x5C\x0A\x0D])|(\\[tbnrf\""'"]))*\" 	{ return $this->createToken(ASPISParser::TK_STRING_LITERAL2); }
<YYINITIAL> "'''"(("'"|"''")?([^"'"\\]|(\\[tbnrf\""'"])))*"'''" 	{ return $this->createToken(ASPISParser::TK_STRING_LITERAL_LONG1); }
<YYINITIAL> \"\"\"((\"|\"\")?([^\"\\]|(\\[tbnrf\""'"])))*\"\"\" 	{ return $this->createToken(ASPISParser::TK_STRING_LITERAL_LONG2); }
<YYINITIAL> "("(\x20|\x09|\x0D|\x0A)*")" 	{ return $this->createToken(ASPISParser::TK_NIL); }
<YYINITIAL> "["(\x20|\x09|\x0D|\x0A)*"]" 	{ return $this->createToken(ASPISParser::TK_ANON); } 

<YYINITIAL> [Ss][Ee][Ll][Ee][Cc][Tt] { return $this->createToken(ASPISParser::TK_SELECT); }
<YYINITIAL> [Dd][Ii][Ss][Tt][Ii][Nn][Cc][Tt] { return $this->createToken(ASPISParser::TK_DISTINCT); }
<YYINITIAL> [Rr][Ee][Dd][Uu][Cc][Ee][Dd] { return $this->createToken(ASPISParser::TK_REDUCED); }
<YYINITIAL> "(" { return $this->createToken(ASPISParser::TK_LPARENTHESE); }
<YYINITIAL> ")" { return $this->createToken(ASPISParser::TK_RPARENTHESE); }
<YYINITIAL> [Aa][Ss] { return $this->createToken(ASPISParser::TK_AS); }
<YYINITIAL> "*" { return $this->createToken(ASPISParser::TK_STAR); }
<YYINITIAL> [Cc][Oo][Nn][Ss][Tt][Rr][Uu][Cc][Tt] { return $this->createToken(ASPISParser::TK_CONSTRUCT); }
<YYINITIAL> [Dd][Ee][Ss][Cc][Rr][Ii][Bb][Ee] { return $this->createToken(ASPISParser::TK_DESCRIBE); }
<YYINITIAL> [Aa][Ss][Kk] { return $this->createToken(ASPISParser::TK_ASK); }
<YYINITIAL> [Ff][Rr][Oo][Mm] { return $this->createToken(ASPISParser::TK_FROM); }
<YYINITIAL> [Nn][Aa][Mm][Ee][Dd] { return $this->createToken(ASPISParser::TK_NAMED); }
<YYINITIAL> [Gg][Rr][Oo][Uu][Pp] { return $this->createToken(ASPISParser::TK_GROUP); }
<YYINITIAL> [Bb][Yy] { return $this->createToken(ASPISParser::TK_BY); }
<YYINITIAL> [Hh][Aa][Vv][Ii][Nn][Gg] { return $this->createToken(ASPISParser::TK_HAVING); }
<YYINITIAL> [Oo][Rr][Dd][Ee][Rr] { return $this->createToken(ASPISParser::TK_ORDER); }
<YYINITIAL> [Aa][Ss][Cc] { return $this->createToken(ASPISParser::TK_ASC); }
<YYINITIAL> [Dd][Ee][Ss][Cc] { return $this->createToken(ASPISParser::TK_DESC); }
<YYINITIAL> [Ll][Ii][Mm][Ii][Tt] { return $this->createToken(ASPISParser::TK_LIMIT); }
<YYINITIAL> [Oo][Ff][Ff][Ss][Ee][Tt] { return $this->createToken(ASPISParser::TK_OFFSET); }
<YYINITIAL> [Vv][Aa][Ll][Uu][Ee][Ss] { return $this->createToken(ASPISParser::TK_VALUES); }
<YYINITIAL> ";" { return $this->createToken(ASPISParser::TK_SEMICOLON); }
<YYINITIAL> [Ll][Oo][Aa][Dd] { return $this->createToken(ASPISParser::TK_LOAD); }
<YYINITIAL> [Ss][Ii][Ll][Ee][Nn][Tt] { return $this->createToken(ASPISParser::TK_SILENT); }
<YYINITIAL> [Ii][Nn][Tt][Oo] { return $this->createToken(ASPISParser::TK_INTO); }
<YYINITIAL> [Cc][Ll][Ee][Aa][Rr] { return $this->createToken(ASPISParser::TK_CLEAR); }
<YYINITIAL> [Dd][Rr][Oo][Pp] { return $this->createToken(ASPISParser::TK_DROP); }
<YYINITIAL> [Cc][Rr][Ee][Aa][Tt][Ee] { return $this->createToken(ASPISParser::TK_CREATE); }
<YYINITIAL> [Aa][Dd][Dd] { return $this->createToken(ASPISParser::TK_ADD); }
<YYINITIAL> [Tt][Oo] { return $this->createToken(ASPISParser::TK_TO); }
<YYINITIAL> [Mm][Oo][Vv][Ee] { return $this->createToken(ASPISParser::TK_MOVE); }
<YYINITIAL> [Cc][Oo][Pp][Yy] { return $this->createToken(ASPISParser::TK_COPY); }
<YYINITIAL> [Ww][Ii][Tt][Hh] { return $this->createToken(ASPISParser::TK_WITH); }
<YYINITIAL> [Ww][Hh][Ee][Rr][Ee] { return $this->createToken(ASPISParser::TK_WHERE); }
<YYINITIAL> [Dd][Ee][Ll][Ee][Tt][Ee] { return $this->createToken(ASPISParser::TK_DELETE); }
<YYINITIAL> [Ii][Nn][Ss][Ee][Rr][Tt] { return $this->createToken(ASPISParser::TK_INSERT); }
<YYINITIAL> [Uu][Ss][Ii][Nn][Gg] { return $this->createToken(ASPISParser::TK_USING); }
<YYINITIAL> [Nn][Aa][Mm][Ee][Dd] { return $this->createToken(ASPISParser::TK_NAMED); }
<YYINITIAL> [Dd][Ee][Ff][Aa][Uu][Ll][Tt] { return $this->createToken(ASPISParser::TK_DEFAULT); }
<YYINITIAL> [Gg][Rr][Aa][Pp][Hh] { return $this->createToken(ASPISParser::TK_GRAPH); }
<YYINITIAL> [Aa][Ll][Ll] { return $this->createToken(ASPISParser::TK_ALL); }
<YYINITIAL> "{" { return $this->createToken(ASPISParser::TK_LBRACE); }
<YYINITIAL> "}" { return $this->createToken(ASPISParser::TK_RBRACE); }
<YYINITIAL> "." { return $this->createToken(ASPISParser::TK_DOT); }
<YYINITIAL> [Oo][Pp][Tt][Ii][Oo][Nn][Aa][Ll] { return $this->createToken(ASPISParser::TK_OPTIONAL); }
<YYINITIAL> [Ss][Ee][Rr][Vv][Ii][Cc][Ee] { return $this->createToken(ASPISParser::TK_SERVICE); }
<YYINITIAL> [Bb][Ii][Nn][Dd] { return $this->createToken(ASPISParser::TK_BIND); }
<YYINITIAL> [Uu][Nn][Dd][Ee][Ff] { return $this->createToken(ASPISParser::TK_UNDEF); }
<YYINITIAL> [Mm][Ii][Nn][Uu][Ss] { return $this->createToken(ASPISParser::TK_SMINUS); }
<YYINITIAL> [Uu][Nn][Ii][Oo][Nn] { return $this->createToken(ASPISParser::TK_UNION); }
<YYINITIAL> [Ff][Ii][Ll][Tt][Ee][Rr] { return $this->createToken(ASPISParser::TK_FILTER); }
<YYINITIAL> "," { return $this->createToken(ASPISParser::TK_COMMA); }
<YYINITIAL> "a" { return $this->createToken(ASPISParser::TK_A); }
<YYINITIAL> "|" { return $this->createToken(ASPISParser::TK_VBAR); }
<YYINITIAL> "/" { return $this->createToken(ASPISParser::TK_SLASH); }
<YYINITIAL> "^" { return $this->createToken(ASPISParser::TK_HAT); }
<YYINITIAL> "?" { return $this->createToken(ASPISParser::TK_QUESTION); }
<YYINITIAL> "!" { return $this->createToken(ASPISParser::TK_EXCLAMATION); }
<YYINITIAL> "+" { return $this->createToken(ASPISParser::TK_PLUS); }
<YYINITIAL> "[" { return $this->createToken(ASPISParser::TK_LBRACKET); }
<YYINITIAL> "]" { return $this->createToken(ASPISParser::TK_RBRACKET); }
<YYINITIAL> "||" { return $this->createToken(ASPISParser::TK_OR); }
<YYINITIAL> "&&" { return $this->createToken(ASPISParser::TK_AND); }
<YYINITIAL> "-" { return $this->createToken(ASPISParser::TK_MINUS); }
<YYINITIAL> "=" { return $this->createToken(ASPISParser::TK_EQUAL); }
<YYINITIAL> "!=" { return $this->createToken(ASPISParser::TK_NEQUAL); }
<YYINITIAL> "<" { return $this->createToken(ASPISParser::TK_SMALLERTHEN); }
<YYINITIAL> ">" { return $this->createToken(ASPISParser::TK_GREATERTHEN); }
<YYINITIAL> "<=" { return $this->createToken(ASPISParser::TK_SMALLERTHENQ); }
<YYINITIAL> ">=" { return $this->createToken(ASPISParser::TK_GREATERTHENQ); }
<YYINITIAL> [Ii][Nn] { return $this->createToken(ASPISParser::TK_IN); }
<YYINITIAL> [Nn][Oo][Tt] { return $this->createToken(ASPISParser::TK_NOT); }
<YYINITIAL> [Ss][Tt][Rr] { return $this->createToken(ASPISParser::TK_STR); }
<YYINITIAL> [Ll][Aa][Nn][Gg] { return $this->createToken(ASPISParser::TK_LANG); }
<YYINITIAL> [Ll][Aa][Nn][Gg][Mm][Aa][Tt][Cc][Hh][Ee][Ss] { return $this->createToken(ASPISParser::TK_LANGMATCHES); }
<YYINITIAL> [Dd][Aa][Tt][Aa][Tt][Yy][Pp][Ee] { return $this->createToken(ASPISParser::TK_DATATYPE); }
<YYINITIAL> [Bb][Oo][Uu][Nn][Dd] { return $this->createToken(ASPISParser::TK_BOUND); }
<YYINITIAL> [Ii][Rr][Ii] { return $this->createToken(ASPISParser::TK_IRI); }
<YYINITIAL> [Uu][Rr][Ii] { return $this->createToken(ASPISParser::TK_URI); }
<YYINITIAL> [Bb][Nn][Oo][Dd][Ee] { return $this->createToken(ASPISParser::TK_BNODE); }
<YYINITIAL> [Rr][Aa][Nn][Dd] { return $this->createToken(ASPISParser::TK_RAND); }
<YYINITIAL> [Aa][Bb][Ss] { return $this->createToken(ASPISParser::TK_ABS); }
<YYINITIAL> [Cc][Ee][Ii][Ll] { return $this->createToken(ASPISParser::TK_CEIL); }
<YYINITIAL> [Ff][Ll][Oo][Oo][Rr] { return $this->createToken(ASPISParser::TK_FLOOR); }
<YYINITIAL> [Rr][Oo][Uu][Nn][Dd] { return $this->createToken(ASPISParser::TK_ROUND); }
<YYINITIAL> [Cc][Oo][Nn][Cc][Aa][Tt] { return $this->createToken(ASPISParser::TK_CONCAT); }
<YYINITIAL> [Ss][Tt][Rr][Ll][Ee][Nn] { return $this->createToken(ASPISParser::TK_STRLEN); }
<YYINITIAL> [Uu][Cc][Aa][Ss][Ee] { return $this->createToken(ASPISParser::TK_UCASE); }
<YYINITIAL> [Ll][Cc][Aa][Ss][Ee] { return $this->createToken(ASPISParser::TK_LCASE); }
<YYINITIAL> [Ee][Nn][Cc][Oo][Dd][Ee]"_"[Ff][Oo][Rr]"_"[Uu][Rr][Ii] { return $this->createToken(ASPISParser::TK_ENCODE_FOR_URI); }
<YYINITIAL> [Cc][Oo][Nn][Tt][Aa][Ii][Nn][Ss] { return $this->createToken(ASPISParser::TK_CONTAINS); }
<YYINITIAL> [Ss][Tt][Rr][Ss][Tt][Aa][Rr][Tt][Ss] { return $this->createToken(ASPISParser::TK_STRSTARTS); }
<YYINITIAL> [Ss][Tt][Rr][Ee][Nn][Dd][Ss] { return $this->createToken(ASPISParser::TK_STRENDS); }
<YYINITIAL> [Ss][Tt][Rr][Bb][Ee][Ff][Oo][Rr][Ee] { return $this->createToken(ASPISParser::TK_STRBEFORE); }
<YYINITIAL> [Ss][Tt][Rr][Aa][Ff][Tt][Ee][Rr] { return $this->createToken(ASPISParser::TK_STRAFTER); }
<YYINITIAL> [Yy][Ee][Aa][Rr] { return $this->createToken(ASPISParser::TK_YEAR); }
<YYINITIAL> [Mm][Oo][Nn][Tt][Hh] { return $this->createToken(ASPISParser::TK_MONTH); }
<YYINITIAL> [Dd][Aa][Yy] { return $this->createToken(ASPISParser::TK_DAY); }
<YYINITIAL> [Hh][Oo][Uu][Rr][Ss] { return $this->createToken(ASPISParser::TK_HOURS); }
<YYINITIAL> [Mm][Ii][Nn][Uu][Tt][Ee][Ss] { return $this->createToken(ASPISParser::TK_MINUTES); }
<YYINITIAL> [Ss][Ee][Cc][Oo][Nn][Dd][Ss] { return $this->createToken(ASPISParser::TK_SECONDS); }
<YYINITIAL> [Tt][Ii][Mm][Ee][Zz][Oo][Nn][Ee] { return $this->createToken(ASPISParser::TK_TIMEZONE); }
<YYINITIAL> [Tt][Zz] { return $this->createToken(ASPISParser::TK_TZ); }
<YYINITIAL> [Nn][Oo][Ww] { return $this->createToken(ASPISParser::TK_NOW); }
<YYINITIAL> [Uu][Uu][Ii][Dd] { return $this->createToken(ASPISParser::TK_UUID); }
<YYINITIAL> [Ss][Tt][Rr][Uu][Uu][Ii][Dd] { return $this->createToken(ASPISParser::TK_STRUUID); }
<YYINITIAL> [Mm][Dd]"5" { return $this->createToken(ASPISParser::TK_MD5); }
<YYINITIAL> [Ss][Hh][Aa]"1" { return $this->createToken(ASPISParser::TK_SHA1); }
<YYINITIAL> [Ss][Hh][Aa]"256" { return $this->createToken(ASPISParser::TK_SHA256); }
<YYINITIAL> [Ss][Hh][Aa]"384" { return $this->createToken(ASPISParser::TK_SHA384); }
<YYINITIAL> [Ss][Hh][Aa]"512" { return $this->createToken(ASPISParser::TK_SHA512); }
<YYINITIAL> [Cc][Oo][Aa][Ll][Ee][Ss][Cc][Ee] { return $this->createToken(ASPISParser::TK_COALESCE); }
<YYINITIAL> [Ii][Ff] { return $this->createToken(ASPISParser::TK_IF); }
<YYINITIAL> [Ss][Tt][Rr][Ll][Aa][Nn][Gg] { return $this->createToken(ASPISParser::TK_STRLANG); }
<YYINITIAL> [Ss][Tt][Rr][Dd][Tt] { return $this->createToken(ASPISParser::TK_STRDT); }
<YYINITIAL> [Ss][Aa][Mm][Ee][Tt][Ee][Rr][Mm] { return $this->createToken(ASPISParser::TK_SAMETERM); }
<YYINITIAL> [Ii][Ss][Ii][Rr][Ii] { return $this->createToken(ASPISParser::TK_ISIRI); }
<YYINITIAL> [Ii][Ss][Uu][Rr][Ii] { return $this->createToken(ASPISParser::TK_ISURI); }
<YYINITIAL> [Ii][Ss][Bb][Ll][Aa][Nn][Kk] { return $this->createToken(ASPISParser::TK_ISBLANK); }
<YYINITIAL> [Ii][Ss][Ll][Ii][Tt][Ee][Rr][Aa][Ll] { return $this->createToken(ASPISParser::TK_ISLITERAL); }
<YYINITIAL> [Ii][Ss][Nn][Uu][Mm][Ee][Rr][Ii][Cc] { return $this->createToken(ASPISParser::TK_ISNUMERIC); }
<YYINITIAL> [Rr][Ee][Gg][Ee][Xx] { return $this->createToken(ASPISParser::TK_REGEX); }
<YYINITIAL> [Ss][Uu][Bb][Ss][Tt][Rr] { return $this->createToken(ASPISParser::TK_SUBSTR); }
<YYINITIAL> [Rr][Ee][Pp][Ll][Aa][Cc][Ee] { return $this->createToken(ASPISParser::TK_REPLACE); }
<YYINITIAL> [Ee][Xx][Ii][Ss][Tt][Ss] { return $this->createToken(ASPISParser::TK_EXISTS); }
<YYINITIAL> [Cc][Oo][Uu][Nn][Tt] { return $this->createToken(ASPISParser::TK_COUNT); }
<YYINITIAL> [Ss][Uu][Mm] { return $this->createToken(ASPISParser::TK_SUM); }
<YYINITIAL> [Mm][Ii][Nn] { return $this->createToken(ASPISParser::TK_MIN); }
<YYINITIAL> [Mm][Aa][Xx] { return $this->createToken(ASPISParser::TK_MAX); }
<YYINITIAL> [Aa][Vv][Gg] { return $this->createToken(ASPISParser::TK_AVG); }
<YYINITIAL> [Ss][Aa][Mm][Pp][Ll][Ee] { return $this->createToken(ASPISParser::TK_SAMPLE); }
<YYINITIAL> [Gg][Rr][Oo][Uu][Pp]"_"[Cc][Oo][Nn][Cc][Aa][Tt] { return $this->createToken(ASPISParser::TK_GROUP_CONCAT); }
<YYINITIAL> [Ss][Ee][Pp][Aa][Rr][Aa][Tt][Oo][Rr] { return $this->createToken(ASPISParser::TK_SEPARATOR); }
<YYINITIAL> "^^" { return $this->createToken(ASPISParser::TK_DHAT); }
<YYINITIAL> [Tt][Rr][Uu][Ee] { return $this->createToken(ASPISParser::TK_TRUE); }
<YYINITIAL> [Ff][Aa][Ll][Ss][Ee] { return $this->createToken(ASPISParser::TK_FALSE); }
<YYINITIAL> [Ii][Nn][Ss][Ee][Rr][Tt](\x20|\x09|\x0D|\x0A|("#"([^\x0D\x0A])*[\x0D\x0A]))+[Dd][Aa][Tt][Aa] { $tmp = $this->createToken(ASPISParser::TK_INSERTDATA); $tmp->value = "INSERT DATA"; return $tmp; }
<YYINITIAL> [Dd][Ee][Ll][Ee][Tt][Ee](\x20|\x09|\x0D|\x0A|("#"([^\x0D\x0A])*[\x0D\x0A]))+[Dd][Aa][Tt][Aa] { $tmp = $this->createToken(ASPISParser::TK_DELETEDATA); $tmp->value = "DELETE DATA"; return $tmp; }
<YYINITIAL> [Dd][Ee][Ll][Ee][Tt][Ee](\x20|\x09|\x0D|\x0A|("#"([^\x0D\x0A])*[\x0D\x0A]))+[Ww][Hh][Ee][Rr][Ee] { $tmp = $this->createToken(ASPISParser::TK_DELETEWHERE); $tmp->value = "DELETE WHERE"; return $tmp; }
<YYINITIAL> [^\x20|\x09|\x0D|\x0A] { /* unmatchable Character */ return $this->createToken(-1); }
<YYINITIAL> [\x20|\x09|\x0D|\x0A]|("#"([^\x0D\x0A])*[\x0D\x0A]) { /* ignore Whitespace between 2 Tokens and comments */}
