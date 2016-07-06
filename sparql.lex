<?php
include 'jlex.php';

/*todo make a list of all Terminals to tokenize, make makros of things like echar, make extra tokens for all keywords
/* TerminalTokens: IRIREF PNAME_NS PNAME_LN BLANK_NODE_LABEL VAR1 VAR2 LANGTAG INTEGER DECIMAL DOUBLE INTEGER_POSITIVE 
DECIMAL POSITIVE DOUBLE_POSITIVE INTEGER_NEGATIVE DECIMAL_NEGATIVE STRING LITERAL1 STRING_LITERAL2 STRING_LITERAL_LONG1 
STRING_LITERAL_LONG2 NIL WS ANON 
/*need to check if unicode with more then 4 digits is allowed
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
