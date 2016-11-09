<?php # vim:ts=2:sw=2:et:
/* Driver template for the LEMON parser generator.
** The author disclaims copyright to this source code.
*/
/* First off, code is included which follows the "include" declaration
** in the input file. */

#line 49 "sparql.y"
 /* this will be copied blindly */

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
#line 71 "sparql.php"

/* The following structure represents a single element of the
** parser's stack.  Information stored includes:
**
**   +  The state number for the parser at this level of the stack.
**
**   +  The value of the token stored at this level of the stack.
**      (In other words, the "major" token.)
**
**   +  The semantic value stored at this level of the stack.  This is
**      the information used by the action routines in the grammar.
**      It is sometimes called the "minor" token.
*/
class SparqlPHPyyStackEntry {
  var /* int */ $stateno;       /* The state-number */
  var /* int */ $major;         /* The major token value.  This is the code
                     ** number for the token at this stack level */
  var $minor; /* The user-supplied minor token value.  This
                     ** is the value of the token  */
};

/* The state of the parser is completely contained in an instance of
** the following structure */
class SparqlPHPParser {
  var /* int */ $yyidx = -1;                    /* Index of top element in stack */
  var /* int */ $yyerrcnt;                 /* Shifts left before out of the error */
  // SparqlPHPARG_SDECL                /* A place to hold %extra_argument */
  var /* yyStackEntry */ $yystack = array(
  	/* of YYSTACKDEPTH elements */
	);  /* The parser's stack */

  var $yyTraceFILE = null;
  var $yyTracePrompt = null;
  
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



/* Next is all token values, in a form suitable for use by makeheaders.
** This section will be null unless lemon is run with the -m switch.
*/
/* 
** These constants (all generated automatically by the parser generator)
** specify the various kinds of tokens (terminals) that the parser
** understands. 
**
** Each symbol here is a terminal symbol in the grammar.
*/
  const TK_PRAGMA =  1;
  const TK_BASE =  2;
  const TK_IRIREF =  3;
  const TK_DOT =  4;
  const TK_PREFIX =  5;
  const TK_PNAME_NS =  6;
  const TK_SELECT =  7;
  const TK_DISTINCT =  8;
  const TK_REDUCED =  9;
  const TK_STAR = 10;
  const TK_LPARENTHESE = 11;
  const TK_AS = 12;
  const TK_RPARENTHESE = 13;
  const TK_CONSTRUCT = 14;
  const TK_LBRACE = 15;
  const TK_RBRACE = 16;
  const TK_WHERE = 17;
  const TK_DESCRIBE = 18;
  const TK_ASK = 19;
  const TK_FROM = 20;
  const TK_NAMED = 21;
  const TK_GROUP = 22;
  const TK_BY = 23;
  const TK_HAVING = 24;
  const TK_ORDER = 25;
  const TK_ASC = 26;
  const TK_DESC = 27;
  const TK_LIMIT = 28;
  const TK_INTEGER = 29;
  const TK_OFFSET = 30;
  const TK_VALUES = 31;
  const TK_SEMICOLON = 32;
  const TK_LOAD = 33;
  const TK_SILENT = 34;
  const TK_INTO = 35;
  const TK_CLEAR = 36;
  const TK_DROP = 37;
  const TK_CREATE = 38;
  const TK_ADD = 39;
  const TK_TO = 40;
  const TK_MOVE = 41;
  const TK_COPY = 42;
  const TK_INSERTDATA = 43;
  const TK_DELETEDATA = 44;
  const TK_DELETEWHERE = 45;
  const TK_WITH = 46;
  const TK_DELETE = 47;
  const TK_INSERT = 48;
  const TK_USING = 49;
  const TK_GRAPH = 50;
  const TK_DEFAULT = 51;
  const TK_ALL = 52;
  const TK_OPTIONAL = 53;
  const TK_SERVICE = 54;
  const TK_BIND = 55;
  const TK_NIL = 56;
  const TK_UNDEF = 57;
  const TK_SMINUS = 58;
  const TK_UNION = 59;
  const TK_GroupGraphPattern = 60;
  const TK_FILTER = 61;
  const TK_COMMA = 62;
  const TK_A = 63;
  const TK_VBAR = 64;
  const TK_SLASH = 65;
  const TK_HAT = 66;
  const TK_PLUS = 67;
  const TK_QUESTION = 68;
  const TK_EXCLAMATION = 69;
  const TK_LBRACKET = 70;
  const TK_RBRACKET = 71;
  const TK_VAR1 = 72;
  const TK_VAR2 = 73;
  const TK_OR = 74;
  const TK_AND = 75;
  const TK_EQUAL = 76;
  const TK_NEQUAL = 77;
  const TK_SMALLERTHEN = 78;
  const TK_GREATERTHEN = 79;
  const TK_SMALLERTHENQ = 80;
  const TK_GREATERTHENQ = 81;
  const TK_IN = 82;
  const TK_NOT = 83;
  const TK_MINUS = 84;
  const TK_STR = 85;
  const TK_LANG = 86;
  const TK_LANGMATCHES = 87;
  const TK_DATATYPE = 88;
  const TK_BOUND = 89;
  const TK_URI = 90;
  const TK_BNODE = 91;
  const TK_RAND = 92;
  const TK_ABS = 93;
  const TK_CEIL = 94;
  const TK_FLOOR = 95;
  const TK_ROUND = 96;
  const TK_CONCAT = 97;
  const TK_STRLEN = 98;
  const TK_UCASE = 99;
  const TK_LCASE = 100;
  const TK_ENCODE_FOR_URI = 101;
  const TK_CONTAINS = 102;
  const TK_STRSTARTS = 103;
  const TK_STRENDS = 104;
  const TK_STBEFORE = 105;
  const TK_STRAFTER = 106;
  const TK_YEAR = 107;
  const TK_MONTH = 108;
  const TK_DAY = 109;
  const TK_HOURS = 110;
  const TK_MINUTES = 111;
  const TK_SECONDS = 112;
  const TK_TIMEZONE = 113;
  const TK_TZ = 114;
  const TK_NOW = 115;
  const TK_UUID = 116;
  const TK_STRUUID = 117;
  const TK_MD5 = 118;
  const TK_SHA1 = 119;
  const TK_SHA256 = 120;
  const TK_SHA384 = 121;
  const TK_SHA512 = 122;
  const TK_COALESCE = 123;
  const TK_IF = 124;
  const TK_STRLANG = 125;
  const TK_STRDT = 126;
  const TK_SAMETERM = 127;
  const TK_ISIRI = 128;
  const TK_ISURI = 129;
  const TK_ISBLANK = 130;
  const TK_ISLITERAL = 131;
  const TK_ISNUMERIC = 132;
  const TK_REGEX = 133;
  const TK_SUBSTR = 134;
  const TK_REPLACE = 135;
  const TK_EXISTS = 136;
  const TK_COUNT = 137;
  const TK_SUM = 138;
  const TK_MIN = 139;
  const TK_MAX = 140;
  const TK_AVG = 141;
  const TK_SAMPLE = 142;
  const TK_GROUP_CONCAT = 143;
  const TK_SEPARATOR = 144;
  const TK_LANGTAG = 145;
  const TK_DHAT = 146;
  const TK_DECIMAL = 147;
  const TK_DOUBLE = 148;
  const TK_INTEGER_POSITIVE = 149;
  const TK_DECIMAL_POSITIVE = 150;
  const TK_DOUBLE_POSITIVE = 151;
  const TK_INTEGER_NEGATIVE = 152;
  const TK_DECIMAL_NEGATIVE = 153;
  const TK_DOUBLE_NEGATIVE = 154;
  const TK_TRUE = 155;
  const TK_FALSE = 156;
  const TK_STRING_LITERAL1 = 157;
  const TK_STRING_LITERAL2 = 158;
  const TK_STRING_LITERAL_LONG1 = 159;
  const TK_STRING_LITERAL_LONG2 = 160;
  const TK_PNAME_LN = 161;
  const TK_BLANK_NODE_LABEL = 162;
  const TK_ANON = 163;
/* The next thing included is series of defines which control
** various aspects of the generated parser.
**    YYCODETYPE         is the data type used for storing terminal
**                       and nonterminal numbers.  "unsigned char" is
**                       used if there are fewer than 250 terminals
**                       and nonterminals.  "int" is used otherwise.
**    YYNOCODE           is a number of type YYCODETYPE which corresponds
**                       to no legal terminal or nonterminal number.  This
**                       number is used to fill in empty slots of the hash 
**                       table.
**    YYFALLBACK         If defined, this indicates that one or more tokens
**                       have fall-back values which should be used if the
**                       original value of the token will not parse.
**    YYACTIONTYPE       is the data type used for storing terminal
**                       and nonterminal numbers.  "unsigned char" is
**                       used if there are fewer than 250 rules and
**                       states combined.  "int" is used otherwise.
**    SparqlPHPTOKENTYPE     is the data type used for minor tokens given 
**                       directly to the parser from the tokenizer.
**    YYMINORTYPE        is the data type used for all minor tokens.
**                       This is typically a union of many types, one of
**                       which is SparqlPHPTOKENTYPE.  The entry in the union
**                       for base tokens is called "yy0".
**    YYSTACKDEPTH       is the maximum depth of the parser's stack.
**    SparqlPHPARG_SDECL     A static variable declaration for the %extra_argument
**    SparqlPHPARG_PDECL     A parameter declaration for the %extra_argument
**    SparqlPHPARG_STORE     Code to store %extra_argument into yypParser
**    SparqlPHPARG_FETCH     Code to extract %extra_argument from yypParser
**    YYNSTATE           the combined number of states.
**    YYNRULE            the number of rules in the grammar
**    YYERRORSYMBOL      is the code number of the error symbol.  If not
**                       defined, then do no error processing.
*/
  const YYNOCODE = 314;
#define SparqlPHPTOKENTYPE void*
  const YYSTACKDEPTH = 100;
  const YYNSTATE = 1036;
  const YYNRULE = 554;
  const YYERRORSYMBOL = 164;

  /* since we cant use expressions to initialize these as class
   * constants, we do so during parser init. */
  var $YY_NO_ACTION;
  var $YY_ACCEPT_ACTION;
  var $YY_ERROR_ACTION;

/* Next are that tables used to determine what action to take based on the
** current state and lookahead token.  These tables are used to implement
** functions that take a state number and lookahead value and return an
** action integer.  
**
** Suppose the action integer is N.  Then the action is determined as
** follows
**
**   0 <= N < YYNSTATE                  Shift N.  That is, push the lookahead
**                                      token onto the stack and goto state N.
**
**   YYNSTATE <= N < YYNSTATE+YYNRULE   Reduce by rule N-YYNSTATE.
**
**   N == YYNSTATE+YYNRULE              A syntax error has occurred.
**
**   N == YYNSTATE+YYNRULE+1            The parser accepts its input.
**
**   N == YYNSTATE+YYNRULE+2            No such action.  Denotes unused
**                                      slots in the yy_action[] table.
**
** The action table is constructed as a single large table named yy_action[].
** Given state S and lookahead X, the action is computed as
**
**      yy_action[ yy_shift_ofst[S] + X ]
**
** If the index value yy_shift_ofst[S]+X is out of range or if the value
** yy_lookahead[yy_shift_ofst[S]+X] is not equal to X or if yy_shift_ofst[S]
** is equal to YY_SHIFT_USE_DFLT, it means that the action is not in the table
** and that yy_default[S] should be used instead.  
**
** The formula above is for computing the action when the lookahead is
** a terminal symbol.  If the lookahead is a non-terminal (as occurs after
** a reduce action) then the yy_reduce_ofst[] array is used in place of
** the yy_shift_ofst[] array and YY_REDUCE_USE_DFLT is used in place of
** YY_SHIFT_USE_DFLT.
**
** The following are the tables generated in this section:
**
**  yy_action[]        A single table containing all actions.
**  yy_lookahead[]     A table containing the lookahead for each entry in
**                     yy_action.  Used to detect hash collisions.
**  yy_shift_ofst[]    For each state, the offset into yy_action for
**                     shifting terminals.
**  yy_reduce_ofst[]   For each state, the offset into yy_action for
**                     shifting non-terminals after a reduce.
**  yy_default[]       Default action for each state.
*/
static $yy_action = array(
 /*     0 */   618,  588,  360,  621,  585,    4,  115,  544,   14,  310,
 /*    10 */   168,  402,  937,  268,  401,  585,  400,  215,  230,  222,
 /*    20 */   257,  306,  516,  307,  168,  402,  625,  344,  401,  672,
 /*    30 */   400,  223,  262,  361,  265,  258,  259,  311,  233,  653,
 /*    40 */   234,  235,  352,  355,  356,  272,  364,  361,   99,  100,
 /*    50 */   101,  102,  103,  104,  308,  573,  683,  678,  680,  681,
 /*    60 */   682,  679,  981,  985,  119,  292,  118,  179,  130,  648,
 /*    70 */   649,  879,  880,  881,  882,  883,  884,  885,  886,  654,
 /*    80 */   518,  120,  407,  408,  410,  413,  415,  417,  381,  420,
 /*    90 */   421,  423,  425,  427,  296,  429,  431,  433,  435,  437,
 /*   100 */   440,  443,  446,  449,  452,  454,  456,  458,  460,  462,
 /*   110 */   464,  466,  468,  469,  470,  471,  473,  475,  477,  479,
 /*   120 */   297,  483,  487,  490,  493,  496,  498,  500,  502,  504,
 /*   130 */   506,  509,  512,  328,  519,  522,  524,  526,  528,  530,
 /*   140 */   532,  278,  313, 1017,  626,  627,  628,  629,  630,  631,
 /*   150 */   632,  633,  634,  635,  636,  637,  638,  639,  620,  618,
 /*   160 */   402,  983,  621,  401,   12,  400,  673,   14,  231,  401,
 /*   170 */   623,  400,  624,  294,  689,  684,  685,  686,  687,  703,
 /*   180 */   705,  376,  622,  619,  618,  625,  171,  621,  253,  664,
 /*   190 */   270,  982,  984,  588,  322,  323,  585,  640,  584,  966,
 /*   200 */   967,  968,  969,  970,  971,  972,  973,  974,  975,  976,
 /*   210 */   625,  636,  637,  638,  639,  252,  281,    1,  293,  331,
 /*   220 */   305,  188,  261,  119,  516,  118,  168,  402,  648,  649,
 /*   230 */   401,  646,  400,  855,  280,  316, 1017,  787,  615,  518,
 /*   240 */   120,  407,  408,  410,  413,  415,  417,  381,  420,  421,
 /*   250 */   423,  425,  427,  296,  429,  431,  433,  435,  437,  440,
 /*   260 */   443,  446,  449,  452,  454,  456,  458,  460,  462,  464,
 /*   270 */   466,  468,  469,  470,  471,  473,  475,  477,  479,  297,
 /*   280 */   483,  487,  490,  493,  496,  498,  500,  502,  504,  506,
 /*   290 */   509,  512,  328,  519,  522,  524,  526,  528,  530,  532,
 /*   300 */   981,  987,  856,  626,  627,  628,  629,  630,  631,  632,
 /*   310 */   633,  634,  635,  636,  637,  638,  639,  620,  618,  849,
 /*   320 */   859,  621,    1,  113,  331,  520,   14,  261,  626,  627,
 /*   330 */   628,  629,  630,  631,  632,  633,  634,  635,  636,  637,
 /*   340 */   638,  639,  620,  618,  625,  344,  621,  181,  201,  953,
 /*   350 */   937,  619,  833,  237,  833,  190,  609,  933,  535,  162,
 /*   360 */   959,  834,  954,  834,  787,  216,  227,  255,  749,  625,
 /*   370 */   659,  787,  538,  322,  323,  322,  323,  516,  114,  168,
 /*   380 */   402,  647,  119,  401,  118,  400,  129,  648,  649,  879,
 /*   390 */   880,  881,  882,  883,  884,  885,  886,  615,  518,  120,
 /*   400 */   407,  408,  410,  413,  415,  417,  381,  420,  421,  423,
 /*   410 */   425,  427,  296,  429,  431,  433,  435,  437,  440,  443,
 /*   420 */   446,  449,  452,  454,  456,  458,  460,  462,  464,  466,
 /*   430 */   468,  469,  470,  471,  473,  475,  477,  479,  297,  483,
 /*   440 */   487,  490,  493,  496,  498,  500,  502,  504,  506,  509,
 /*   450 */   512,  328,  519,  522,  524,  526,  528,  530,  532,  981,
 /*   460 */   980,    3,  626,  627,  628,  629,  630,  631,  632,  633,
 /*   470 */   634,  635,  636,  637,  638,  639,  620,  618,  746,  619,
 /*   480 */   621,  619,   80,  322,  323,   14,  842,  626,  627,  628,
 /*   490 */   629,  630,  631,  632,  633,  634,  635,  636,  637,  638,
 /*   500 */   639,  620,  618,  625,  983,  621,  774,  368,  618,  375,
 /*   510 */   262,  621,  643,  258,  259,  311,  233,  263,  234,  235,
 /*   520 */   352,  355,  356,  272,  364,  361,  267,  852,  625,  226,
 /*   530 */   256,  932,  667,  270,  982,  984,  322,  323,  361,  265,
 /*   540 */   377,  119,  833,  118,  379,  935,  648,  649,  254,  747,
 /*   550 */   831,  834,  591,  380,  322,  323,  615,  518,  120,  407,
 /*   560 */   408,  410,  413,  415,  417,  381,  420,  421,  423,  425,
 /*   570 */   427,  296,  429,  431,  433,  435,  437,  440,  443,  446,
 /*   580 */   449,  452,  454,  456,  458,  460,  462,  464,  466,  468,
 /*   590 */   469,  470,  471,  473,  475,  477,  479,  297,  483,  487,
 /*   600 */   490,  493,  496,  498,  500,  502,  504,  506,  509,  512,
 /*   610 */   328,  519,  522,  524,  526,  528,  530,  532,  142,  397,
 /*   620 */   398,  626,  627,  628,  629,  630,  631,  632,  633,  634,
 /*   630 */   635,  636,  637,  638,  639,  620,  618,  748,  416,  621,
 /*   640 */   606,   81,  322,  323,   14,  619,  626,  627,  628,  629,
 /*   650 */   630,  631,  632,  633,  634,  635,  636,  637,  638,  639,
 /*   660 */   620,  618,  625,  619,  621,  618,  620,  905,  621,  619,
 /*   670 */   619,  645,  182,  203,  958,  937,  731,  833,  931,  648,
 /*   680 */   649,  607,  608,  322,  323,  342,  834,  625,  517,  787,
 /*   690 */   216,  227,  255,  749,  247,  191,  238,  937,  322,  323,
 /*   700 */   119,    1,  118,  331,  618,  648,  649,  621,  981,  986,
 /*   710 */   546,  787,  271,  992,  855,  615,  518,  120,  407,  408,
 /*   720 */   410,  413,  415,  417,  381,  420,  421,  423,  425,  427,
 /*   730 */   296,  429,  431,  433,  435,  437,  440,  443,  446,  449,
 /*   740 */   452,  454,  456,  458,  460,  462,  464,  466,  468,  469,
 /*   750 */   470,  471,  473,  475,  477,  479,  297,  483,  487,  490,
 /*   760 */   493,  496,  498,  500,  502,  504,  506,  509,  512,  328,
 /*   770 */   519,  522,  524,  526,  528,  530,  532,  274,  397,   26,
 /*   780 */   626,  627,  628,  629,  630,  631,  632,  633,  634,  635,
 /*   790 */   636,  637,  638,  639,  620,  618,  648,  649,  621,  892,
 /*   800 */    82,  303,  549,   14,  619,  626,  627,  628,  629,  630,
 /*   810 */   631,  632,  633,  634,  635,  636,  637,  638,  639,  620,
 /*   820 */  1015,  625,  399,  620,  481,  618,  248,  195,  621,  937,
 /*   830 */   364,  361,  619,  249,  197,  194,  937,  933,  648,  649,
 /*   840 */   607,  608,  128,  787,  803,  799,  800,  801,  802,  804,
 /*   850 */   787,  787,  550,  299,  250,  205,  241,  937,  833,  119,
 /*   860 */   833,  118,  620,  392,  648,  649,  340,  834,  831,  834,
 /*   870 */   567,  787,  271,  992,  393,  518,  120,  407,  408,  410,
 /*   880 */   413,  415,  417,  381,  420,  421,  423,  425,  427,  296,
 /*   890 */   429,  431,  433,  435,  437,  440,  443,  446,  449,  452,
 /*   900 */   454,  456,  458,  460,  462,  464,  466,  468,  469,  470,
 /*   910 */   471,  473,  475,  477,  479,  297,  483,  487,  490,  493,
 /*   920 */   496,  498,  500,  502,  504,  506,  509,  512,  328,  519,
 /*   930 */   522,  524,  526,  528,  530,  532,  144,  394,  619,  626,
 /*   940 */   627,  628,  629,  630,  631,  632,  633,  634,  635,  636,
 /*   950 */   637,  638,  639,  620,  618,  650,  843,  621,  623,   83,
 /*   960 */   624,  358,   14,  684,  685,  686,  687,  703,  705,  376,
 /*   970 */   622,  619,  200,  951,  933,  282,  962,  170,  618,  363,
 /*   980 */   625,  621,  642,  620,  351,  619,  983,  619,  787,  216,
 /*   990 */   227,  255,  749,  265,  196,  395,  933,  322,  323,  264,
 /*  1000 */   270,  125,  993,  803,  799,  800,  801,  802,  804,  244,
 /*  1010 */   787,  265,  299,  844,  845,  270,  982,  984,  119,  920,
 /*  1020 */   118,  288,  644,  648,  649,  271,  992,  618,  855,  593,
 /*  1030 */   621,  251,  279,  921,  518,  120,  407,  408,  410,  413,
 /*  1040 */   415,  417,  381,  420,  421,  423,  425,  427,  296,  429,
 /*  1050 */   431,  433,  435,  437,  440,  443,  446,  449,  452,  454,
 /*  1060 */   456,  458,  460,  462,  464,  466,  468,  469,  470,  471,
 /*  1070 */   473,  475,  477,  479,  297,  483,  487,  490,  493,  496,
 /*  1080 */   498,  500,  502,  504,  506,  509,  512,  328,  519,  522,
 /*  1090 */   524,  526,  528,  530,  532,  761,  648,  649,  626,  627,
 /*  1100 */   628,  629,  630,  631,  632,  633,  634,  635,  636,  637,
 /*  1110 */   638,  639,  620,  618,  533,  851,  621,  623,   84,  624,
 /*  1120 */   619,   14,  684,  685,  686,  687,  703,  705,  376,  622,
 /*  1130 */   619,  115,  989,  202,  956,  933,  620,  993,  268,  625,
 /*  1140 */   312, 1017,  215,  230,  314, 1017,  619,   21,  366,  787,
 /*  1150 */   216,  227,  255,  749,  315, 1017,  370,  262,  322,  323,
 /*  1160 */   258,  259,  311,  233,  595,  234,  235,  352,  355,  356,
 /*  1170 */   272,  364,  361,  933,  204,  617,  933,  119,  833,  118,
 /*  1180 */   265,  934,  648,  649,  590,  620,  341,  834,  265,  347,
 /*  1190 */   787,  964,  906,  518,  120,  407,  408,  410,  413,  415,
 /*  1200 */   417,  381,  420,  421,  423,  425,  427,  296,  429,  431,
 /*  1210 */   433,  435,  437,  440,  443,  446,  449,  452,  454,  456,
 /*  1220 */   458,  460,  462,  464,  466,  468,  469,  470,  471,  473,
 /*  1230 */   475,  477,  479,  297,  483,  487,  490,  493,  496,  498,
 /*  1240 */   500,  502,  504,  506,  509,  512,  328,  519,  522,  524,
 /*  1250 */   526,  528,  530,  532,  348,  619,  964,  626,  627,  628,
 /*  1260 */   629,  630,  631,  632,  633,  634,  635,  636,  637,  638,
 /*  1270 */   639,  620,  618,  588, 1013,  621,  585,   85,  317, 1017,
 /*  1280 */    14,  850,  353,  136,  618,  223,  833,  621,  618,  357,
 /*  1290 */   668,  621,  189,  619,  599,  834,  745,  978,  625,  619,
 /*  1300 */   577,  763,  619,  261,  262,  619,  329,  258,  259,  311,
 /*  1310 */   233,  359,  234,  235,  352,  355,  356,  272,  364,  361,
 /*  1320 */   536,  265,  216,  227,  255,  749,  991,  605,  929,  927,
 /*  1330 */   322,  323,  236,  928,  616,  266,  119,  299,  118,   13,
 /*  1340 */   655,  648,  649,  265,  860,  165,  930,  217,  854,  656,
 /*  1350 */   218,  260,  518,  120,  407,  408,  410,  413,  415,  417,
 /*  1360 */   381,  420,  421,  423,  425,  427,  296,  429,  431,  433,
 /*  1370 */   435,  437,  440,  443,  446,  449,  452,  454,  456,  458,
 /*  1380 */   460,  462,  464,  466,  468,  469,  470,  471,  473,  475,
 /*  1390 */   477,  479,  297,  483,  487,  490,  493,  496,  498,  500,
 /*  1400 */   502,  504,  506,  509,  512,  328,  519,  522,  524,  526,
 /*  1410 */   528,  530,  532,  619,  701,  619,  626,  627,  628,  629,
 /*  1420 */   630,  631,  632,  633,  634,  635,  636,  637,  638,  639,
 /*  1430 */   620,  618,  657,  318,  621,  319,  320,  321,  362,   14,
 /*  1440 */   400,  225,  620,  658,  619,  651,  620,  684,  685,  686,
 /*  1450 */   687,  703,  705,  618,  277,  619,  621,  625,  660,  216,
 /*  1460 */   227,  255,  749,   13,  132,  401,  582,  322,  323,  261,
 /*  1470 */   265,  584,  966,  967,  968,  969,  970,  971,  972,  973,
 /*  1480 */   974,  975,  976,  662,  269,  652,   27,  855,  252,  281,
 /*  1490 */   378, 1014,  298,  751,   96,  119,  405,  118,  773,  771,
 /*  1500 */   648,  649,   98,  772,  300,  776,  406,  299,  301,  789,
 /*  1510 */     1,  518,  120,  407,  408,  410,  413,  415,  417,  381,
 /*  1520 */   420,  421,  423,  425,  427,  296,  429,  431,  433,  435,
 /*  1530 */   437,  440,  443,  446,  449,  452,  454,  456,  458,  460,
 /*  1540 */   462,  464,  466,  468,  469,  470,  471,  473,  475,  477,
 /*  1550 */   479,  297,  483,  487,  490,  493,  496,  498,  500,  502,
 /*  1560 */   504,  506,  509,  512,  328,  519,  522,  524,  526,  528,
 /*  1570 */   530,  532,  619,  382,  857,  626,  627,  628,  629,  630,
 /*  1580 */   631,  632,  633,  634,  635,  636,  637,  638,  639,  620,
 /*  1590 */   618,  901,  365,  621,  752,  116,  117,  121,   90, 1030,
 /*  1600 */   163,  618,  786,  111,  621,  619,  276,  283,  964,  619,
 /*  1610 */   936,  620,  302,  798,  744,  187,  625,  684,  685,  686,
 /*  1620 */   687,  703,  705,  367,  265,  619,  216,  227,  255,  749,
 /*  1630 */   555,  158,  556,  618,  322,  323,  621,  369,  557,  602,
 /*  1640 */   966,  967,  968,  969,  970,  971,  972,  973,  974,  975,
 /*  1650 */   976,  273,  207,  214,  559,  265,  252,  281,  112,  648,
 /*  1660 */   649,  853,  794,  790,  791,  792,  793,  795,  212,  265,
 /*  1670 */   518,  299,  407,  408,  410,  413,  415,  417,  381,  420,
 /*  1680 */   421,  423,  425,  427,  296,  429,  431,  433,  435,  437,
 /*  1690 */   440,  443,  446,  449,  452,  454,  456,  458,  460,  462,
 /*  1700 */   464,  466,  468,  469,  470,  471,  473,  475,  477,  479,
 /*  1710 */   297,  483,  487,  490,  493,  496,  498,  500,  502,  504,
 /*  1720 */   506,  509,  512,  328,  519,  522,  524,  526,  528,  530,
 /*  1730 */   532,  904,  560,  160,  626,  627,  628,  629,  630,  631,
 /*  1740 */   632,  633,  634,  635,  636,  637,  638,  639,  620,  618,
 /*  1750 */   562,  618,  621,  903,  621,  563,  796,   90,  887,  620,
 /*  1760 */   888, 1591,  603,  604,  122,  371,  902,  372,  373,  374,
 /*  1770 */   276,  283,  964,  225,  618,  625,  623,  621,  624,  889,
 /*  1780 */    71,  684,  685,  686,  687,  703,  705,  376,  622,  619,
 /*  1790 */   890,  620,  893,  569,  568,  396,  993,  270,  271,  992,
 /*  1800 */   625,  962,   74,  602,  966,  967,  968,  969,  970,  971,
 /*  1810 */   972,  973,  974,  975,  976,   78,  109,  894,  648,  649,
 /*  1820 */   252,  281,  134,  597,  977,  110,  979,  988,  615,  518,
 /*  1830 */  1012,  407,  408,  410,  413,  415,  417,  381,  420,  421,
 /*  1840 */   423,  425,  427,  296,  429,  431,  433,  435,  437,  440,
 /*  1850 */   443,  446,  449,  452,  454,  456,  458,  460,  462,  464,
 /*  1860 */   466,  468,  469,  470,  471,  473,  475,  477,  479,  297,
 /*  1870 */   483,  487,  490,  493,  496,  498,  500,  502,  504,  506,
 /*  1880 */   509,  512,  328,  519,  522,  524,  526,  528,  530,  532,
 /*  1890 */   924,  999, 1008,  626,  627,  628,  629,  630,  631,  632,
 /*  1900 */   633,  634,  635,  636,  637,  638,  639,  620,  618,  620,
 /*  1910 */   618,  621, 1009,  621,  619,  805,   90, 1016,  626,  627,
 /*  1920 */   628,  629,  630,  631,  632,  633,  634,  635,  636,  637,
 /*  1930 */   638,  639,  620, 1018,  625, 1020, 1019, 1021, 1022,   13,
 /*  1940 */  1023,  169,  290, 1032, 1024, 1025, 1026, 1027, 1033, 1028,
 /*  1950 */  1029, 1034,  291, 1035,  993,  126,  164,  803,  799,  800,
 /*  1960 */   801,  802,  804,  661,  663,   11,  299,  929,  927,  666,
 /*  1970 */   832,   95,  928,   97,   15,  833,  299,  648,  649,  648,
 /*  1980 */   649,  592,   16,  831,  834,  665,  690,   17,  518,   19,
 /*  1990 */   407,  408,  410,  413,  415,  417,  381,  420,  421,  423,
 /*  2000 */   425,  427,  296,  429,  431,  433,  435,  437,  440,  443,
 /*  2010 */   446,  449,  452,  454,  456,  458,  460,  462,  464,  466,
 /*  2020 */   468,  469,  470,  471,  473,  475,  477,  479,  297,  483,
 /*  2030 */   487,  490,  493,  496,  498,  500,  502,  504,  506,  509,
 /*  2040 */   512,  328,  519,  522,  524,  526,  528,  530,  532,  558,
 /*  2050 */    18,  141,  626,  627,  628,  629,  630,  631,  632,  633,
 /*  2060 */   634,  635,  636,  637,  638,  639,  620,  618,  620,    1,
 /*  2070 */   621,  623,  619,  624,  691,   14,  684,  685,  686,  687,
 /*  2080 */   703,  705,  376,  622,  619,  224,  684,  685,  686,  687,
 /*  2090 */   703,  705,  692,  625,  619,  295,  693,  696,   20,   33,
 /*  2100 */   938,  694,  619,  695,  220,   22,  697,  339,  219,  565,
 /*  2110 */   939,  698,  343,   23,   24,  175,  216,  227,  255,  749,
 /*  2120 */   699,   25,  700,   28,  322,  323,  216,  227,  255,  749,
 /*  2130 */   704,   29,  706,   30,  322,  323,  648,  649,  707,  618,
 /*  2140 */    31,  708,  621,   32,  709,   34,  173,  518,  710,  407,
 /*  2150 */   408,  410,  413,  415,  417,  381,  420,  421,  423,  425,
 /*  2160 */   427,  296,  429,  431,  433,  435,  437,  440,  443,  446,
 /*  2170 */   449,  452,  454,  456,  458,  460,  462,  464,  466,  468,
 /*  2180 */   469,  470,  471,  473,  475,  477,  479,  297,  483,  487,
 /*  2190 */   490,  493,  496,  498,  500,  502,  504,  506,  509,  512,
 /*  2200 */   328,  519,  522,  524,  526,  528,  530,  532,  648,  649,
 /*  2210 */    35,  626,  627,  628,  629,  630,  631,  632,  633,  634,
 /*  2220 */   635,  636,  637,  638,  639,  620,  618,   36,   37,  621,
 /*  2230 */  1031,  163,  711,   38,   90,   39,   40,  276,  283,  964,
 /*  2240 */   944,  712,   41,  722,  618,  713,   42,  621,   43,  714,
 /*  2250 */    44,  723,  625,  715,  858,  716,  216,  227,  255,  749,
 /*  2260 */    45,  717,   46,  718,  322,  323,  945,   47,  719,   48,
 /*  2270 */   602,  966,  967,  968,  969,  970,  971,  972,  973,  974,
 /*  2280 */   975,  976,  216,  227,  255,  749,  720,  252,  281,   49,
 /*  2290 */   322,  323,  721,  833,   50,  648,  649,  620,  725,  724,
 /*  2300 */    51,  831,  834,  726,  854,   52,  518,  260,  407,  408,
 /*  2310 */   410,  413,  415,  417,  381,  420,  421,  423,  425,  427,
 /*  2320 */   296,  429,  431,  433,  435,  437,  440,  443,  446,  449,
 /*  2330 */   452,  454,  456,  458,  460,  462,  464,  466,  468,  469,
 /*  2340 */   470,  471,  473,  475,  477,  479,  297,  483,  487,  490,
 /*  2350 */   493,  496,  498,  500,  502,  504,  506,  509,  512,  328,
 /*  2360 */   519,  522,  524,  526,  528,  530,  532,  941,  727,  141,
 /*  2370 */   626,  627,  628,  629,  630,  631,  632,  633,  634,  635,
 /*  2380 */   636,  637,  638,  639,  620,  618,   53,  618,  621,  728,
 /*  2390 */   621,  618,   54,   89,  621,  482,  729,   55,   56,    1,
 /*  2400 */   946,  331,  620,  730,  261,   57,  516,  732,  168,  402,
 /*  2410 */   947,  625,  401,   58,  400,   59,  216,  227,  255,  749,
 /*  2420 */   619,  733,  221,   61,  322,  323,  216,  227,  255,  749,
 /*  2430 */    60,  734,  993,   62,  322,  323,   63,  735,  779,  777,
 /*  2440 */    64,  736,   65,  778,   66,  737,  166,  299,  738,   67,
 /*  2450 */   739,   68,  740,  167,  648,  649,  648,  649,  781,  990,
 /*  2460 */   648,  649,  782,   69,  741,  518,  299,  407,  408,  410,
 /*  2470 */   413,  415,  417,  381,  420,  421,  423,  425,  427,  296,
 /*  2480 */   429,  431,  433,  435,  437,  440,  443,  446,  449,  452,
 /*  2490 */   454,  456,  458,  460,  462,  464,  466,  468,  469,  470,
 /*  2500 */   471,  473,  475,  477,  479,  297,  483,  487,  490,  493,
 /*  2510 */   496,  498,  500,  502,  504,  506,  509,  512,  328,  519,
 /*  2520 */   522,  524,  526,  528,  530,  532,   70,   72,   73,  626,
 /*  2530 */   627,  628,  629,  630,  631,  632,  633,  634,  635,  636,
 /*  2540 */   637,  638,  639,  620,  618,  620,  742,  621,   75,  620,
 /*  2550 */   619,   76,   94,   77,  534,  743,  750,  684,  685,  686,
 /*  2560 */   687,  703,  705,  330,    2,  619,  286,  403,  574,  948,
 /*  2570 */   753,  754,    5,  755,    6,  756,  684,  685,  686,  687,
 /*  2580 */   703,  705,    7,  757,  619,  216,  227,  255,  749,    8,
 /*  2590 */   758,  949,    9,  322,  323,  759,  545,  683,  678,  680,
 /*  2600 */   681,  682,  679,   10,  760,  537,  292,  216,  227,  255,
 /*  2610 */   749,  287,  762,  648,  649,  322,  323,  764,  765,  766,
 /*  2620 */   767,  768,  769,  770,  518,  775,  407,  408,  410,  413,
 /*  2630 */   415,  417,  381,  420,  421,  423,  425,  427,  296,  429,
 /*  2640 */   431,  433,  435,  437,  440,  443,  446,  449,  452,  454,
 /*  2650 */   456,  458,  460,  462,  464,  466,  468,  469,  470,  471,
 /*  2660 */   473,  475,  477,  479,  297,  483,  487,  490,  493,  496,
 /*  2670 */   498,  500,  502,  504,  506,  509,  512,  328,  519,  522,
 /*  2680 */   524,  526,  528,  530,  532,  618,  780,  618,  621,  783,
 /*  2690 */   621,  788,  797,   86,  138,  189,  806,  807,  156,  186,
 /*  2700 */   157,  213,  620,  325,  836,  326,  206,  285,  211,  231,
 /*  2710 */   848,  623,  159,  624,  294,  689,  684,  685,  686,  687,
 /*  2720 */   703,  705,  376,  622,  619,  874,   91,  891,  304,  346,
 /*  2730 */   683,  678,  680,  681,  682,  679,  345,  896,  907,  292,
 /*  2740 */   910,  309,   93,  895,  861,  925,  926,  860,  151,  131,
 /*  2750 */   217,  192,  161,  218,  648,  649,  648,  649,  228,  198,
 /*  2760 */   133,  123,  586,  587,  589,  518,  963,  407,  408,  410,
 /*  2770 */   413,  415,  417,  381,  420,  421,  423,  425,  427,  296,
 /*  2780 */   429,  431,  433,  435,  437,  440,  443,  446,  449,  452,
 /*  2790 */   454,  456,  458,  460,  462,  464,  466,  468,  469,  470,
 /*  2800 */   471,  473,  475,  477,  479,  297,  483,  487,  490,  493,
 /*  2810 */   496,  498,  500,  502,  504,  506,  509,  512,  328,  519,
 /*  2820 */   522,  524,  526,  528,  530,  532,  618,  846,  289,  621,
 /*  2830 */   349,  350,  965,  239,   79,  135,  325,  240,  326,  242,
 /*  2840 */   285,  243,  231,  620,  623,  620,  624,  294,  689,  684,
 /*  2850 */   685,  686,  687,  703,  705,  376,  622,  619,  245,  246,
 /*  2860 */  1000, 1004,  619, 1010,  993,  950,  124,  869,  869,  952,
 /*  2870 */   521,  683,  678,  680,  681,  682,  679,  869,  869,  869,
 /*  2880 */   292,  216,  227,  255,  749,  216,  227,  255,  749,  322,
 /*  2890 */   323,  994,  869,  322,  323,  648,  649,  869,  869,  869,
 /*  2900 */   869,  869,  869,  869,  869,  869,  518,  869,  407,  408,
 /*  2910 */   410,  413,  415,  417,  381,  420,  421,  423,  425,  427,
 /*  2920 */   296,  429,  431,  433,  435,  437,  440,  443,  446,  449,
 /*  2930 */   452,  454,  456,  458,  460,  462,  464,  466,  468,  469,
 /*  2940 */   470,  471,  473,  475,  477,  479,  297,  483,  487,  490,
 /*  2950 */   493,  496,  498,  500,  502,  504,  506,  509,  512,  328,
 /*  2960 */   519,  522,  524,  526,  528,  530,  532,  618,  869,  869,
 /*  2970 */   621,  869,  869,  869,  869,   88,  869,  325,  869,  326,
 /*  2980 */   869,  285,  619,  231,  620,  623,  869,  624,  294,  689,
 /*  2990 */   684,  685,  686,  687,  703,  705,  376,  622,  619,  993,
 /*  3000 */   869,  993,  869,  869,  869,  993,  955,  869,  869,  869,
 /*  3010 */   869,  543,  683,  678,  680,  681,  682,  679,  869,  869,
 /*  3020 */   869,  292,  216,  227,  255,  749,  594,  869,  995,  861,
 /*  3030 */   322,  323,  996,  542,  683,  678,  680,  681,  682,  679,
 /*  3040 */   869,  869,  869,  292,  869,  869,  869,  518,  869,  407,
 /*  3050 */   408,  410,  413,  415,  417,  381,  420,  421,  423,  425,
 /*  3060 */   427,  296,  429,  431,  433,  435,  437,  440,  443,  446,
 /*  3070 */   449,  452,  454,  456,  458,  460,  462,  464,  466,  468,
 /*  3080 */   469,  470,  471,  473,  475,  477,  479,  297,  483,  487,
 /*  3090 */   490,  493,  496,  498,  500,  502,  504,  506,  509,  512,
 /*  3100 */   328,  519,  522,  524,  526,  528,  530,  532,  618,  869,
 /*  3110 */   841,  621,  847,  289,  869,  869,   87,  619,  325,  619,
 /*  3120 */   326,  869,  285,  619,  231,  620,  623,  869,  624,  294,
 /*  3130 */   689,  684,  685,  686,  687,  703,  705,  376,  622,  619,
 /*  3140 */   325,  897,  326,  869,  285,  898,  231,  619,  623,  299,
 /*  3150 */   624,  294,  689,  684,  685,  686,  687,  703,  705,  376,
 /*  3160 */   622,  619,  541,  683,  678,  680,  681,  682,  679,  869,
 /*  3170 */   869,  869,  292,  869,  869,  869,  869,  869,  869,  869,
 /*  3180 */   683,  678,  680,  681,  682,  679,  869,  869,  518,  292,
 /*  3190 */   407,  408,  410,  413,  415,  417,  381,  420,  421,  423,
 /*  3200 */   425,  427,  296,  429,  431,  433,  435,  437,  440,  443,
 /*  3210 */   446,  449,  452,  454,  456,  458,  460,  462,  464,  466,
 /*  3220 */   468,  469,  470,  471,  473,  475,  477,  479,  297,  483,
 /*  3230 */   487,  490,  493,  496,  498,  500,  502,  504,  506,  509,
 /*  3240 */   512,  328,  519,  522,  524,  526,  528,  530,  532,  618,
 /*  3250 */   869,  869,  621,  869,  869,  869,  869,   92,  869,  684,
 /*  3260 */   685,  686,  687,  703,  705,  869,  620,  619,  869,  325,
 /*  3270 */   869,  326,  869,  285,  869,  231,  869,  623,  869,  624,
 /*  3280 */   294,  689,  684,  685,  686,  687,  703,  705,  376,  622,
 /*  3290 */   619,  869,  911,  993,  623,  993,  624,  294,  689,  684,
 /*  3300 */   685,  686,  687,  703,  705,  376,  622,  619,  683,  678,
 /*  3310 */   680,  681,  682,  679,  869,  869,  869,  292,  869,  869,
 /*  3320 */   596,  869,  997,  869,  869,  869,  869,  869,  869,  518,
 /*  3330 */   869,  407,  408,  410,  413,  415,  417,  381,  420,  421,
 /*  3340 */   423,  425,  427,  296,  429,  431,  433,  435,  437,  440,
 /*  3350 */   443,  446,  449,  452,  454,  456,  458,  460,  462,  464,
 /*  3360 */   466,  468,  469,  470,  471,  473,  475,  477,  479,  297,
 /*  3370 */   483,  487,  490,  493,  496,  498,  500,  502,  504,  506,
 /*  3380 */   509,  512,  328,  519,  522,  524,  526,  528,  530,  532,
 /*  3390 */   618,  861,  869,  621,  115,  869,  993,  869,  149,  869,
 /*  3400 */   107,  869,    1,  808,  869,  869,  820,  620,  823,  824,
 /*  3410 */   825,  619,  284,  619,  869,  822,  625,  108,  224,  869,
 /*  3420 */   912,  869,  623,  998,  624,  294,  689,  684,  685,  686,
 /*  3430 */   687,  703,  705,  376,  622,  619,  869,  220,  869,  869,
 /*  3440 */   339,  219,  565,  827,  869,  343,  869,  869,  175,  598,
 /*  3450 */   354,  136,  579,  618,  869,  869,  621,  184,  869,  648,
 /*  3460 */   649,  232,  869,  618,  869,  561,  621,  869,  869,  869,
 /*  3470 */   335,  189,  336,  957,  847,  289,  869,  960,  869,  209,
 /*  3480 */   869,  210,  628,  629,  630,  631,  632,  633,  869,  216,
 /*  3490 */   227,  255,  749,  216,  227,  255,  749,  322,  323,  145,
 /*  3500 */   861,  322,  323,  869,  813,  814,  869,  275,  861,  619,
 /*  3510 */   821,  826,  552,  854,  619,  820,  260,  823,  824,  825,
 /*  3520 */   623,  869,  624,  860,  822,  344,  869,  869,  869,  218,
 /*  3530 */   869,  376,  622,  619,  626,  627,  628,  629,  630,  631,
 /*  3540 */   632,  633,  634,  635,  636,  637,  638,  639,  620,  828,
 /*  3550 */   829,  127,  869,  803,  799,  800,  801,  802,  804,  869,
 /*  3560 */   869,  869,  299,  551,  172,  180,  130,  553,  869,  879,
 /*  3570 */   880,  881,  882,  883,  884,  885,  886,  618,  869,  840,
 /*  3580 */   621,  336,  140,  847,  289,  143,  869,  335,  183,  336,
 /*  3590 */  1001,  847,  289,  869,  869,  869,  869,  185,  869,  869,
 /*  3600 */   105,  618,  869,  625,  621,  869,  869,  869,  869,  143,
 /*  3610 */   869,  620,  869,  869, 1011,  867,  868,  106,  619,  821,
 /*  3620 */   826,  620,  869,  869,  222,  869,  619,  625,  869,  623,
 /*  3630 */   827,  624,  869,  961,  869,  618,  137,  869,  621,  869,
 /*  3640 */   376,  622,  619,  149,  208,  869,  648,  649,  222,  216,
 /*  3650 */   227,  255,  749,  869,  827,  869,  869,  322,  323,  869,
 /*  3660 */   861,  625,  869,  869,  869,  869,  869,  623,  208,  624,
 /*  3670 */   648,  649,  684,  685,  686,  687,  703,  705,  376,  622,
 /*  3680 */   619,  869,  628,  629,  630,  631,  632,  633,  827,  869,
 /*  3690 */   869,  683,  678,  680,  681,  682,  679,  869,  869,  869,
 /*  3700 */   292,  869,  184,  869,  648,  649,  869,  612,  613,  614,
 /*  3710 */   869,  869,  869,  869,  611,  869,  869,  861,  869,  869,
 /*  3720 */   869,  626,  627,  628,  629,  630,  631,  632,  633,  634,
 /*  3730 */   635,  636,  637,  638,  639,  620,  828,  829,  869,  863,
 /*  3740 */   869,  336,  869,  847,  289,  626,  627,  628,  629,  630,
 /*  3750 */   631,  632,  633,  634,  635,  636,  637,  638,  639,  620,
 /*  3760 */   828,  829,  869,  869,  612,  613,  614,  833,  869,  176,
 /*  3770 */   641,  611,  869,  869,  869,  831,  834,  869,  619,  626,
 /*  3780 */   627,  628,  629,  630,  631,  632,  633,  634,  635,  636,
 /*  3790 */   637,  638,  639,  620,  828,  829,  618,  150,  862,  621,
 /*  3800 */   847,  289,  869,  869,  149,  623,  869,  624,  674,  689,
 /*  3810 */   684,  685,  686,  687,  703,  705,  376,  622,  619,  623,
 /*  3820 */   869,  624,  625,  869,  869,  869,  618,  610,  869,  621,
 /*  3830 */   376,  622,  619,  869,  143,  619,  869,  869,  869,  193,
 /*  3840 */   869,  942,  869,  141,  869,  869,  869,  869,  869,  827,
 /*  3850 */   869,  869,  625,  869,  869,  869,  618,  869,  869,  621,
 /*  3860 */   869,  869,  869,  184,  143,  648,  649,  869,  869,  229,
 /*  3870 */   869,  869,  869,  869,  869,  869,  623,  869,  624,  827,
 /*  3880 */   869,  869,  625,  869,  869,  869,  869,  376,  622,  619,
 /*  3890 */   869,  869,  869,  208,  619,  648,  649,  869,  869,  869,
 /*  3900 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  827,
 /*  3910 */   869,  869,  869,  869,  869,  683,  678,  680,  681,  682,
 /*  3920 */   679,  869,  869,  208,  292,  648,  649,  869,  869,  869,
 /*  3930 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  3940 */   626,  627,  628,  629,  630,  631,  632,  633,  634,  635,
 /*  3950 */   636,  637,  638,  639,  620,  828,  829,  869,  869,  869,
 /*  3960 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  3970 */   626,  627,  628,  629,  630,  631,  632,  633,  634,  635,
 /*  3980 */   636,  637,  638,  639,  620,  828,  829,  869,  869,  869,
 /*  3990 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4000 */   626,  627,  628,  629,  630,  631,  632,  633,  634,  635,
 /*  4010 */   636,  637,  638,  639,  620,  828,  829,  618,  869,  869,
 /*  4020 */   621,  869,  869,  869,  869,  143,  869,  913,  869,  623,
 /*  4030 */   199,  624,  294,  689,  684,  685,  686,  687,  703,  705,
 /*  4040 */   376,  622,  619,  625,  869,  869,  869,  618,  152,  869,
 /*  4050 */   621,  869,  869,  869,  869,  143,  869,  869,  869,  869,
 /*  4060 */   869,  869,  148,  869,  869,  869,  869,  869,  869,  869,
 /*  4070 */   827,  861,  869,  625,  869,  869,  869,  618,  869,  869,
 /*  4080 */   621,  869,  869,  869,  208,  143,  648,  649,  869,  869,
 /*  4090 */  1005,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4100 */   827,  869,  869,  625,  869,  869,  869,  869,  869,  869,
 /*  4110 */   869,  869,  869,  869,  208,  869,  648,  649,  869,  869,
 /*  4120 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4130 */   827,  869,  869,  683,  678,  680,  681,  682,  679,  869,
 /*  4140 */   869,  869,  292,  811,  208,  139,  648,  649,  869,  869,
 /*  4150 */   335,  869,  336,  869,  847,  289,  869,  869,  869,  869,
 /*  4160 */   869,  626,  627,  628,  629,  630,  631,  632,  633,  634,
 /*  4170 */   635,  636,  637,  638,  639,  620,  828,  829,  869,  869,
 /*  4180 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  619,
 /*  4190 */   869,  626,  627,  628,  629,  630,  631,  632,  633,  634,
 /*  4200 */   635,  636,  637,  638,  639,  620,  828,  829,  869,  869,
 /*  4210 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4220 */   869,  626,  627,  628,  629,  630,  631,  632,  633,  634,
 /*  4230 */   635,  636,  637,  638,  639,  620,  828,  829,  618,  153,
 /*  4240 */   869,  621,  869,  915,  869,  231,  143,  623,  869,  624,
 /*  4250 */   294,  689,  684,  685,  686,  687,  703,  705,  376,  622,
 /*  4260 */   619,  869,  869,  869,  625,  869,  869,  869,  618,  869,
 /*  4270 */   869,  621,  869,  869,  869,  869,  143,  869,  816,  869,
 /*  4280 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4290 */   869,  827,  869,  869,  625,  869,  869,  869,  869,  869,
 /*  4300 */   869,  869,  869,  869,  869,  208,  869,  648,  649,  869,
 /*  4310 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4320 */   869,  827,  869,  869,  683,  678,  680,  681,  682,  679,
 /*  4330 */   869,  869,  869,  292,  869,  208,  869,  648,  649,  869,
 /*  4340 */   869,  869,  869,  869,  869,  869,  869,  540,  683,  678,
 /*  4350 */   680,  681,  682,  679,  869,  869,  869,  292,  784,  869,
 /*  4360 */   869,  869,  785,  869,  869,  869,  299,  869,  869,  869,
 /*  4370 */   869,  869,  869,  174,  869,  869,  869,  869,  869,  869,
 /*  4380 */   869,  869,  626,  627,  628,  629,  630,  631,  632,  633,
 /*  4390 */   634,  635,  636,  637,  638,  639,  620,  828,  829,  869,
 /*  4400 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4410 */   869,  869,  626,  627,  628,  629,  630,  631,  632,  633,
 /*  4420 */   634,  635,  636,  637,  638,  639,  620,  828,  829,  618,
 /*  4430 */   869,  869,  621,  869,  916,  869,  231,  149,  623,  869,
 /*  4440 */   624,  294,  689,  684,  685,  686,  687,  703,  705,  376,
 /*  4450 */   622,  619,  869,  869,  325,  625,  326,  869,  285,  869,
 /*  4460 */   231,  869,  623,  869,  624,  294,  689,  684,  685,  686,
 /*  4470 */   687,  703,  705,  376,  622,  619,  684,  685,  686,  687,
 /*  4480 */   703,  705,  827,  869,  619,  869,  869,  869,  869,  869,
 /*  4490 */   869,  869,  869,  869,  869,  869,  184,  869,  648,  649,
 /*  4500 */   869,  869,  869,  869,  869,  869,  539,  683,  678,  680,
 /*  4510 */   681,  682,  679,  869,  869,  869,  292,  869,  869,  869,
 /*  4520 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4530 */   869,  869,  388,  683,  678,  680,  681,  682,  679,  869,
 /*  4540 */   869,  869,  292,  869,  869,  869,  869,  869,  869,  869,
 /*  4550 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4560 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4570 */   869,  869,  869,  626,  627,  628,  629,  630,  631,  632,
 /*  4580 */   633,  634,  635,  636,  637,  638,  639,  620,  828,  829,
 /*  4590 */   869,  869,  869,  869,  869,  869,  869,  404,  683,  678,
 /*  4600 */   680,  681,  682,  679,  869,  869,  869,  292,  869,  869,
 /*  4610 */   869,  869,  869,  325,  869,  326,  869,  285,  869,  231,
 /*  4620 */   869,  623,  869,  624,  294,  689,  684,  685,  686,  687,
 /*  4630 */   703,  705,  376,  622,  619,  869,  869,  869,  869,  325,
 /*  4640 */   869,  326,  869,  285,  869,  231,  869,  623,  869,  624,
 /*  4650 */   294,  689,  684,  685,  686,  687,  703,  705,  376,  622,
 /*  4660 */   619,  869,  869,  869,  869,  869,  869,  324,  683,  678,
 /*  4670 */   680,  681,  682,  679,  869,  869,  869,  292,  869,  869,
 /*  4680 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4690 */   869,  669,  683,  678,  680,  681,  682,  679,  869,  869,
 /*  4700 */   869,  292,  869,  869,  325,  869,  326,  869,  285,  869,
 /*  4710 */   231,  869,  623,  869,  624,  294,  689,  684,  685,  686,
 /*  4720 */   687,  703,  705,  376,  622,  619,  869,  572,  683,  678,
 /*  4730 */   680,  681,  682,  679,  869,  869,  869,  292,  869,  869,
 /*  4740 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4750 */   869,  869,  869,  869,  869,  869,  869,  869,  571,  683,
 /*  4760 */   678,  680,  681,  682,  679,  869,  869,  869,  292,  869,
 /*  4770 */   869,  869,  869,  869,  325,  869,  326,  869,  285,  869,
 /*  4780 */   231,  869,  623,  869,  624,  294,  689,  684,  685,  686,
 /*  4790 */   687,  703,  705,  376,  622,  619,  869,  869,  325,  869,
 /*  4800 */   326,  869,  285,  869,  231,  869,  623,  869,  624,  294,
 /*  4810 */   689,  684,  685,  686,  687,  703,  705,  376,  622,  619,
 /*  4820 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4830 */   869,  869,  869,  869,  325,  869,  326,  869,  285,  869,
 /*  4840 */   231,  869,  623,  869,  624,  294,  689,  684,  685,  686,
 /*  4850 */   687,  703,  705,  376,  622,  619,  409,  683,  678,  680,
 /*  4860 */   681,  682,  679,  869,  869,  325,  292,  326,  869,  285,
 /*  4870 */   869,  231,  869,  623,  869,  624,  294,  689,  684,  685,
 /*  4880 */   686,  687,  703,  705,  376,  622,  619,  869,  869,  411,
 /*  4890 */   683,  678,  680,  681,  682,  679,  869,  869,  869,  292,
 /*  4900 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4910 */   869,  869,  412,  683,  678,  680,  681,  682,  679,  869,
 /*  4920 */   869,  869,  292,  869,  869,  869,  869,  869,  869,  869,
 /*  4930 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  4940 */   869,  869,  869,  414,  683,  678,  680,  681,  682,  679,
 /*  4950 */   869,  869,  869,  292,  869,  869,  869,  869,  869,  869,
 /*  4960 */   869,  869,  869,  325,  869,  326,  869,  285,  869,  231,
 /*  4970 */   869,  623,  869,  624,  294,  689,  684,  685,  686,  687,
 /*  4980 */   703,  705,  376,  622,  619,  418,  683,  678,  680,  681,
 /*  4990 */   682,  679,  869,  869,  869,  292,  325,  869,  326,  869,
 /*  5000 */   285,  869,  231,  869,  623,  869,  624,  294,  689,  684,
 /*  5010 */   685,  686,  687,  703,  705,  376,  622,  619,  869,  325,
 /*  5020 */   869,  326,  869,  285,  869,  231,  869,  623,  869,  624,
 /*  5030 */   294,  689,  684,  685,  686,  687,  703,  705,  376,  622,
 /*  5040 */   619,  419,  683,  678,  680,  681,  682,  679,  869,  869,
 /*  5050 */   325,  292,  326,  869,  285,  869,  231,  869,  623,  869,
 /*  5060 */   624,  294,  689,  684,  685,  686,  687,  703,  705,  376,
 /*  5070 */   622,  619,  869,  869,  422,  683,  678,  680,  681,  682,
 /*  5080 */   679,  869,  869,  869,  292,  869,  869,  869,  869,  869,
 /*  5090 */   869,  869,  325,  869,  326,  869,  285,  869,  231,  869,
 /*  5100 */   623,  869,  624,  294,  689,  684,  685,  686,  687,  703,
 /*  5110 */   705,  376,  622,  619,  869,  869,  869,  869,  869,  869,
 /*  5120 */   869,  869,  869,  869,  869,  869,  869,  869,  424,  683,
 /*  5130 */   678,  680,  681,  682,  679,  869,  869,  869,  292,  869,
 /*  5140 */   869,  869,  869,  869,  869,  869,  869,  869,  325,  869,
 /*  5150 */   326,  869,  285,  869,  231,  869,  623,  869,  624,  294,
 /*  5160 */   689,  684,  685,  686,  687,  703,  705,  376,  622,  619,
 /*  5170 */   426,  683,  678,  680,  681,  682,  679,  869,  869,  869,
 /*  5180 */   292,  325,  869,  326,  869,  285,  869,  231,  869,  623,
 /*  5190 */   869,  624,  294,  689,  684,  685,  686,  687,  703,  705,
 /*  5200 */   376,  622,  619,  869,  428,  683,  678,  680,  681,  682,
 /*  5210 */   679,  869,  869,  869,  292,  869,  869,  869,  869,  869,
 /*  5220 */   869,  869,  869,  869,  869,  869,  327,  683,  678,  680,
 /*  5230 */   681,  682,  679,  869,  869,  325,  292,  326,  869,  285,
 /*  5240 */   869,  231,  869,  623,  869,  624,  294,  689,  684,  685,
 /*  5250 */   686,  687,  703,  705,  376,  622,  619,  869,  869,  702,
 /*  5260 */   683,  678,  680,  681,  682,  679,  869,  869,  869,  292,
 /*  5270 */   869,  869,  869,  869,  869,  869,  869,  325,  869,  326,
 /*  5280 */   869,  285,  869,  231,  869,  623,  869,  624,  294,  689,
 /*  5290 */   684,  685,  686,  687,  703,  705,  376,  622,  619,  869,
 /*  5300 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  5310 */   869,  325,  869,  326,  869,  285,  869,  231,  869,  623,
 /*  5320 */   869,  624,  294,  689,  684,  685,  686,  687,  703,  705,
 /*  5330 */   376,  622,  619,  325,  869,  326,  869,  285,  869,  231,
 /*  5340 */   869,  623,  869,  624,  294,  689,  684,  685,  686,  687,
 /*  5350 */   703,  705,  376,  622,  619,  430,  683,  678,  680,  681,
 /*  5360 */   682,  679,  147,  869,  869,  292,  325,  869,  326,  869,
 /*  5370 */   285,  861,  231,  869,  623,  869,  624,  294,  689,  684,
 /*  5380 */   685,  686,  687,  703,  705,  376,  622,  619,  869,  432,
 /*  5390 */   683,  678,  680,  681,  682,  679,  869,  869,  869,  292,
 /*  5400 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  5410 */   869,  434,  683,  678,  680,  681,  682,  679,  869,  869,
 /*  5420 */   869,  292,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  5430 */   869,  869,  869,  436,  683,  678,  680,  681,  682,  679,
 /*  5440 */   869,  869,  869,  292,  869,  146,  869,  869,  869,  869,
 /*  5450 */   335,  869,  336,  869,  847,  289,  869,  869,  869,  869,
 /*  5460 */   869,  869,  325,  869,  326,  869,  285,  869,  231,  869,
 /*  5470 */   623,  869,  624,  294,  689,  684,  685,  686,  687,  703,
 /*  5480 */   705,  376,  622,  619,  869,  869,  869,  869,  869,  619,
 /*  5490 */   869,  869,  869,  869,  869,  869,  325,  869,  326,  869,
 /*  5500 */   285,  869,  231,  869,  623,  869,  624,  294,  689,  684,
 /*  5510 */   685,  686,  687,  703,  705,  376,  622,  619,  325,  869,
 /*  5520 */   326,  869,  285,  869,  231,  869,  623,  869,  624,  294,
 /*  5530 */   689,  684,  685,  686,  687,  703,  705,  376,  622,  619,
 /*  5540 */   325,  869,  326,  869,  285,  869,  231,  869,  623,  869,
 /*  5550 */   624,  294,  689,  684,  685,  686,  687,  703,  705,  376,
 /*  5560 */   622,  619,  438,  683,  678,  680,  681,  682,  679,  869,
 /*  5570 */   869,  869,  292,  869,  869,  869,  869,  869,  869,  869,
 /*  5580 */   869,  869,  869,  869,  439,  683,  678,  680,  681,  682,
 /*  5590 */   679,  869,  869,  869,  292,  869,  869,  869,  869,  869,
 /*  5600 */   869,  869,  869,  869,  869,  869,  441,  683,  678,  680,
 /*  5610 */   681,  682,  679,  869,  869,  869,  292,  869,  869,  869,
 /*  5620 */   869,  869,  869,  869,  869,  869,  869,  869,  442,  683,
 /*  5630 */   678,  680,  681,  682,  679,  869,  869,  869,  292,  869,
 /*  5640 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  5650 */   869,  444,  683,  678,  680,  681,  682,  679,  869,  869,
 /*  5660 */   869,  292,  869,  869,  869,  869,  869,  869,  869,  325,
 /*  5670 */   869,  326,  869,  285,  869,  231,  869,  623,  869,  624,
 /*  5680 */   294,  689,  684,  685,  686,  687,  703,  705,  376,  622,
 /*  5690 */   619,  325,  869,  326,  869,  285,  869,  231,  869,  623,
 /*  5700 */   869,  624,  294,  689,  684,  685,  686,  687,  703,  705,
 /*  5710 */   376,  622,  619,  325,  869,  326,  869,  285,  869,  231,
 /*  5720 */   869,  623,  869,  624,  294,  689,  684,  685,  686,  687,
 /*  5730 */   703,  705,  376,  622,  619,  325,  869,  326,  869,  285,
 /*  5740 */   869,  231,  869,  623,  869,  624,  294,  689,  684,  685,
 /*  5750 */   686,  687,  703,  705,  376,  622,  619,  869,  325,  869,
 /*  5760 */   326,  869,  285,  869,  231,  869,  623,  869,  624,  294,
 /*  5770 */   689,  684,  685,  686,  687,  703,  705,  376,  622,  619,
 /*  5780 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  5790 */   869,  445,  683,  678,  680,  681,  682,  679,  869,  869,
 /*  5800 */   869,  292,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  5810 */   869,  869,  869,  447,  683,  678,  680,  681,  682,  679,
 /*  5820 */   869,  869,  869,  292,  869,  869,  869,  869,  869,  869,
 /*  5830 */   869,  869,  869,  869,  869,  869,  448,  683,  678,  680,
 /*  5840 */   681,  682,  679,  869,  869,  869,  292,  869,  869,  869,
 /*  5850 */   869,  869,  869,  869,  869,  869,  869,  869,  450,  683,
 /*  5860 */   678,  680,  681,  682,  679,  869,  869,  869,  292,  869,
 /*  5870 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  5880 */   451,  683,  678,  680,  681,  682,  679,  869,  869,  869,
 /*  5890 */   292,  869,  869,  869,  869,  869,  869,  869,  325,  869,
 /*  5900 */   326,  869,  285,  869,  231,  869,  623,  869,  624,  294,
 /*  5910 */   689,  684,  685,  686,  687,  703,  705,  376,  622,  619,
 /*  5920 */   325,  869,  326,  869,  285,  869,  231,  869,  623,  869,
 /*  5930 */   624,  294,  689,  684,  685,  686,  687,  703,  705,  376,
 /*  5940 */   622,  619,  869,  325,  869,  326,  869,  285,  869,  231,
 /*  5950 */   869,  623,  869,  624,  294,  689,  684,  685,  686,  687,
 /*  5960 */   703,  705,  376,  622,  619,  325,  869,  326,  869,  285,
 /*  5970 */   869,  231,  869,  623,  869,  624,  294,  689,  684,  685,
 /*  5980 */   686,  687,  703,  705,  376,  622,  619,  325,  869,  326,
 /*  5990 */   869,  285,  869,  231,  869,  623,  869,  624,  294,  689,
 /*  6000 */   684,  685,  686,  687,  703,  705,  376,  622,  619,  869,
 /*  6010 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  6020 */   869,  453,  683,  678,  680,  681,  682,  679,  869,  869,
 /*  6030 */   869,  292,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  6040 */   869,  869,  869,  455,  683,  678,  680,  681,  682,  679,
 /*  6050 */   869,  869,  869,  292,  869,  869,  869,  869,  869,  869,
 /*  6060 */   869,  869,  869,  869,  869,  457,  683,  678,  680,  681,
 /*  6070 */   682,  679,  869,  869,  869,  292,  869,  869,  869,  869,
 /*  6080 */   869,  869,  869,  869,  869,  869,  869,  459,  683,  678,
 /*  6090 */   680,  681,  682,  679,  869,  869,  869,  292,  869,  869,
 /*  6100 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  461,
 /*  6110 */   683,  678,  680,  681,  682,  679,  869,  869,  869,  292,
 /*  6120 */   869,  869,  869,  869,  869,  869,  869,  869,  325,  869,
 /*  6130 */   326,  869,  285,  869,  231,  869,  623,  869,  624,  294,
 /*  6140 */   689,  684,  685,  686,  687,  703,  705,  376,  622,  619,
 /*  6150 */   325,  869,  326,  869,  285,  869,  231,  869,  623,  869,
 /*  6160 */   624,  294,  689,  684,  685,  686,  687,  703,  705,  376,
 /*  6170 */   622,  619,  325,  869,  326,  869,  285,  869,  231,  869,
 /*  6180 */   623,  869,  624,  294,  689,  684,  685,  686,  687,  703,
 /*  6190 */   705,  376,  622,  619,  325,  869,  326,  869,  285,  869,
 /*  6200 */   231,  869,  623,  869,  624,  294,  689,  684,  685,  686,
 /*  6210 */   687,  703,  705,  376,  622,  619,  325,  869,  326,  869,
 /*  6220 */   285,  869,  231,  869,  623,  869,  624,  294,  689,  684,
 /*  6230 */   685,  686,  687,  703,  705,  376,  622,  619,  463,  683,
 /*  6240 */   678,  680,  681,  682,  679,  869,  869,  869,  292,  869,
 /*  6250 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  6260 */   465,  683,  678,  680,  681,  682,  679,  869,  869,  869,
 /*  6270 */   292,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  6280 */   869,  869,  467,  683,  678,  680,  681,  682,  679,  869,
 /*  6290 */   869,  869,  292,  869,  869,  869,  869,  869,  869,  869,
 /*  6300 */   869,  869,  869,  869,  472,  683,  678,  680,  681,  682,
 /*  6310 */   679,  869,  869,  869,  292,  869,  869,  869,  869,  869,
 /*  6320 */   869,  869,  869,  869,  869,  869,  474,  683,  678,  680,
 /*  6330 */   681,  682,  679,  869,  869,  869,  292,  869,  869,  869,
 /*  6340 */   869,  869,  869,  869,  869,  325,  869,  326,  869,  285,
 /*  6350 */   869,  231,  869,  623,  869,  624,  294,  689,  684,  685,
 /*  6360 */   686,  687,  703,  705,  376,  622,  619,  325,  869,  326,
 /*  6370 */   869,  285,  869,  231,  869,  623,  869,  624,  294,  689,
 /*  6380 */   684,  685,  686,  687,  703,  705,  376,  622,  619,  325,
 /*  6390 */   869,  326,  869,  285,  869,  231,  869,  623,  869,  624,
 /*  6400 */   294,  689,  684,  685,  686,  687,  703,  705,  376,  622,
 /*  6410 */   619,  325,  869,  326,  869,  285,  869,  231,  869,  623,
 /*  6420 */   869,  624,  294,  689,  684,  685,  686,  687,  703,  705,
 /*  6430 */   376,  622,  619,  325,  869,  326,  869,  285,  869,  231,
 /*  6440 */   869,  623,  869,  624,  294,  689,  684,  685,  686,  687,
 /*  6450 */   703,  705,  376,  622,  619,  476,  683,  678,  680,  681,
 /*  6460 */   682,  679,  869,  869,  869,  292,  869,  869,  869,  869,
 /*  6470 */   869,  869,  869,  869,  869,  869,  869,  478,  683,  678,
 /*  6480 */   680,  681,  682,  679,  869,  869,  869,  292,  869,  869,
 /*  6490 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  480,
 /*  6500 */   683,  678,  680,  681,  682,  679,  869,  869,  869,  292,
 /*  6510 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  6520 */   869,  484,  683,  678,  680,  681,  682,  679,  869,  869,
 /*  6530 */   869,  292,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  6540 */   869,  869,  869,  485,  683,  678,  680,  681,  682,  679,
 /*  6550 */   869,  869,  869,  292,  869,  869,  869,  869,  869,  869,
 /*  6560 */   869,  869,  325,  869,  326,  869,  285,  869,  231,  869,
 /*  6570 */   623,  869,  624,  294,  689,  684,  685,  686,  687,  703,
 /*  6580 */   705,  376,  622,  619,  325,  869,  326,  869,  285,  869,
 /*  6590 */   231,  869,  623,  869,  624,  294,  689,  684,  685,  686,
 /*  6600 */   687,  703,  705,  376,  622,  619,  325,  869,  326,  869,
 /*  6610 */   285,  869,  231,  869,  623,  869,  624,  294,  689,  684,
 /*  6620 */   685,  686,  687,  703,  705,  376,  622,  619,  325,  869,
 /*  6630 */   326,  869,  285,  869,  231,  869,  623,  869,  624,  294,
 /*  6640 */   689,  684,  685,  686,  687,  703,  705,  376,  622,  619,
 /*  6650 */   325,  869,  326,  869,  285,  869,  231,  869,  623,  869,
 /*  6660 */   624,  294,  689,  684,  685,  686,  687,  703,  705,  376,
 /*  6670 */   622,  619,  486,  683,  678,  680,  681,  682,  679,  869,
 /*  6680 */   869,  869,  292,  869,  869,  869,  869,  869,  869,  869,
 /*  6690 */   869,  869,  869,  869,  488,  683,  678,  680,  681,  682,
 /*  6700 */   679,  869,  869,  869,  292,  869,  869,  869,  869,  869,
 /*  6710 */   869,  869,  869,  869,  869,  869,  489,  683,  678,  680,
 /*  6720 */   681,  682,  679,  869,  869,  869,  292,  869,  869,  869,
 /*  6730 */   869,  869,  869,  869,  869,  869,  869,  869,  491,  683,
 /*  6740 */   678,  680,  681,  682,  679,  869,  869,  869,  292,  869,
 /*  6750 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  6760 */   492,  683,  678,  680,  681,  682,  679,  869,  869,  869,
 /*  6770 */   292,  869,  869,  869,  869,  869,  869,  869,  869,  325,
 /*  6780 */   869,  326,  869,  285,  869,  231,  869,  623,  869,  624,
 /*  6790 */   294,  689,  684,  685,  686,  687,  703,  705,  376,  622,
 /*  6800 */   619,  325,  869,  326,  869,  285,  869,  231,  869,  623,
 /*  6810 */   869,  624,  294,  689,  684,  685,  686,  687,  703,  705,
 /*  6820 */   376,  622,  619,  325,  869,  326,  869,  285,  869,  231,
 /*  6830 */   869,  623,  869,  624,  294,  689,  684,  685,  686,  687,
 /*  6840 */   703,  705,  376,  622,  619,  325,  869,  326,  869,  285,
 /*  6850 */   869,  231,  869,  623,  869,  624,  294,  689,  684,  685,
 /*  6860 */   686,  687,  703,  705,  376,  622,  619,  325,  869,  326,
 /*  6870 */   869,  285,  869,  231,  869,  623,  869,  624,  294,  689,
 /*  6880 */   684,  685,  686,  687,  703,  705,  376,  622,  619,  494,
 /*  6890 */   683,  678,  680,  681,  682,  679,  869,  869,  869,  292,
 /*  6900 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  6910 */   869,  495,  683,  678,  680,  681,  682,  679,  869,  869,
 /*  6920 */   869,  292,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  6930 */   869,  869,  869,  497,  683,  678,  680,  681,  682,  679,
 /*  6940 */   869,  869,  869,  292,  869,  869,  869,  869,  869,  869,
 /*  6950 */   869,  869,  869,  869,  869,  499,  683,  678,  680,  681,
 /*  6960 */   682,  679,  869,  869,  869,  292,  869,  869,  869,  869,
 /*  6970 */   869,  869,  869,  869,  869,  869,  869,  501,  683,  678,
 /*  6980 */   680,  681,  682,  679,  869,  869,  869,  292,  869,  869,
 /*  6990 */   869,  869,  869,  869,  869,  869,  325,  869,  326,  869,
 /*  7000 */   285,  869,  231,  869,  623,  869,  624,  294,  689,  684,
 /*  7010 */   685,  686,  687,  703,  705,  376,  622,  619,  325,  869,
 /*  7020 */   326,  869,  285,  869,  231,  869,  623,  869,  624,  294,
 /*  7030 */   689,  684,  685,  686,  687,  703,  705,  376,  622,  619,
 /*  7040 */   325,  869,  326,  869,  285,  869,  231,  869,  623,  869,
 /*  7050 */   624,  294,  689,  684,  685,  686,  687,  703,  705,  376,
 /*  7060 */   622,  619,  325,  869,  326,  869,  285,  869,  231,  869,
 /*  7070 */   623,  869,  624,  294,  689,  684,  685,  686,  687,  703,
 /*  7080 */   705,  376,  622,  619,  325,  869,  326,  869,  285,  869,
 /*  7090 */   231,  869,  623,  869,  624,  294,  689,  684,  685,  686,
 /*  7100 */   687,  703,  705,  376,  622,  619,  503,  683,  678,  680,
 /*  7110 */   681,  682,  679,  869,  869,  869,  292,  869,  869,  869,
 /*  7120 */   869,  869,  869,  869,  869,  869,  869,  869,  505,  683,
 /*  7130 */   678,  680,  681,  682,  679,  869,  869,  869,  292,  869,
 /*  7140 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  7150 */   507,  683,  678,  680,  681,  682,  679,  869,  869,  869,
 /*  7160 */   292,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  7170 */   869,  869,  383,  683,  678,  680,  681,  682,  679,  869,
 /*  7180 */   869,  869,  292,  869,  869,  869,  869,  869,  869,  869,
 /*  7190 */   869,  869,  869,  869,  508,  683,  678,  680,  681,  682,
 /*  7200 */   679,  869,  869,  869,  292,  869,  869,  869,  869,  869,
 /*  7210 */   869,  869,  869,  325,  869,  326,  869,  285,  869,  231,
 /*  7220 */   869,  623,  869,  624,  294,  689,  684,  685,  686,  687,
 /*  7230 */   703,  705,  376,  622,  619,  325,  869,  326,  869,  285,
 /*  7240 */   869,  231,  869,  623,  869,  624,  294,  689,  684,  685,
 /*  7250 */   686,  687,  703,  705,  376,  622,  619,  325,  869,  326,
 /*  7260 */   869,  285,  869,  231,  869,  623,  869,  624,  294,  689,
 /*  7270 */   684,  685,  686,  687,  703,  705,  376,  622,  619,  325,
 /*  7280 */   869,  326,  869,  285,  869,  231,  869,  623,  869,  624,
 /*  7290 */   294,  689,  684,  685,  686,  687,  703,  705,  376,  622,
 /*  7300 */   619,  325,  869,  326,  869,  285,  869,  231,  869,  623,
 /*  7310 */   869,  624,  294,  689,  684,  685,  686,  687,  703,  705,
 /*  7320 */   376,  622,  619,  510,  683,  678,  680,  681,  682,  679,
 /*  7330 */   869,  869,  869,  292,  869,  869,  869,  869,  869,  869,
 /*  7340 */   869,  869,  869,  869,  869,  384,  683,  678,  680,  681,
 /*  7350 */   682,  679,  869,  869,  869,  292,  869,  869,  869,  869,
 /*  7360 */   869,  869,  869,  869,  869,  869,  869,  511,  683,  678,
 /*  7370 */   680,  681,  682,  679,  869,  869,  869,  292,  869,  869,
 /*  7380 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  513,
 /*  7390 */   683,  678,  680,  681,  682,  679,  869,  869,  869,  292,
 /*  7400 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  7410 */   869,  514,  683,  678,  680,  681,  682,  679,  869,  869,
 /*  7420 */   869,  292,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  7430 */   325,  869,  326,  869,  285,  869,  231,  869,  623,  869,
 /*  7440 */   624,  294,  689,  684,  685,  686,  687,  703,  705,  376,
 /*  7450 */   622,  619,  325,  869,  326,  869,  285,  869,  231,  869,
 /*  7460 */   623,  869,  624,  294,  689,  684,  685,  686,  687,  703,
 /*  7470 */   705,  376,  622,  619,  325,  869,  326,  869,  285,  869,
 /*  7480 */   231,  869,  623,  869,  624,  294,  689,  684,  685,  686,
 /*  7490 */   687,  703,  705,  376,  622,  619,  325,  869,  326,  869,
 /*  7500 */   285,  869,  231,  869,  623,  869,  624,  294,  689,  684,
 /*  7510 */   685,  686,  687,  703,  705,  376,  622,  619,  325,  869,
 /*  7520 */   326,  869,  285,  869,  231,  869,  623,  869,  624,  294,
 /*  7530 */   689,  684,  685,  686,  687,  703,  705,  376,  622,  619,
 /*  7540 */   385,  683,  678,  680,  681,  682,  679,  869,  869,  869,
 /*  7550 */   292,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  7560 */   869,  869,  515,  683,  678,  680,  681,  682,  679,  869,
 /*  7570 */   869,  869,  292,  869,  869,  869,  869,  869,  869,  869,
 /*  7580 */   869,  869,  869,  869,  386,  683,  678,  680,  681,  682,
 /*  7590 */   679,  869,  869,  869,  292,  869,  869,  869,  869,  869,
 /*  7600 */   869,  869,  869,  869,  869,  869,  523,  683,  678,  680,
 /*  7610 */   681,  682,  679,  869,  869,  869,  292,  869,  869,  869,
 /*  7620 */   869,  869,  869,  869,  869,  869,  869,  869,  525,  683,
 /*  7630 */   678,  680,  681,  682,  679,  869,  869,  869,  292,  869,
 /*  7640 */   869,  869,  869,  869,  869,  869,  869,  325,  869,  326,
 /*  7650 */   869,  285,  869,  231,  869,  623,  869,  624,  294,  689,
 /*  7660 */   684,  685,  686,  687,  703,  705,  376,  622,  619,  325,
 /*  7670 */   869,  326,  869,  285,  869,  231,  869,  623,  869,  624,
 /*  7680 */   294,  689,  684,  685,  686,  687,  703,  705,  376,  622,
 /*  7690 */   619,  325,  869,  326,  869,  285,  869,  231,  869,  623,
 /*  7700 */   869,  624,  294,  689,  684,  685,  686,  687,  703,  705,
 /*  7710 */   376,  622,  619,  325,  869,  326,  869,  285,  869,  231,
 /*  7720 */   869,  623,  869,  624,  294,  689,  684,  685,  686,  687,
 /*  7730 */   703,  705,  376,  622,  619,  325,  869,  326,  869,  285,
 /*  7740 */   869,  231,  869,  623,  869,  624,  294,  689,  684,  685,
 /*  7750 */   686,  687,  703,  705,  376,  622,  619,  527,  683,  678,
 /*  7760 */   680,  681,  682,  679,  869,  869,  869,  292,  869,  869,
 /*  7770 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  529,
 /*  7780 */   683,  678,  680,  681,  682,  679,  869,  869,  869,  292,
 /*  7790 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  7800 */   869,  531,  683,  678,  680,  681,  682,  679,  869,  869,
 /*  7810 */   869,  292,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  7820 */   869,  869,  869,  387,  683,  678,  680,  681,  682,  679,
 /*  7830 */   869,  869,  869,  292,  869,  869,  869,  869,  869,  869,
 /*  7840 */   869,  869,  869,  869,  869,  389,  683,  678,  680,  681,
 /*  7850 */   682,  679,  869,  869,  869,  292,  869,  869,  869,  869,
 /*  7860 */   869,  869,  869,  869,  325,  869,  326,  869,  285,  869,
 /*  7870 */   231,  869,  623,  869,  624,  294,  689,  684,  685,  686,
 /*  7880 */   687,  703,  705,  376,  622,  619,  325,  869,  326,  869,
 /*  7890 */   285,  869,  231,  869,  623,  869,  624,  294,  689,  684,
 /*  7900 */   685,  686,  687,  703,  705,  376,  622,  619,  325,  869,
 /*  7910 */   326,  869,  285,  869,  231,  869,  623,  869,  624,  294,
 /*  7920 */   689,  684,  685,  686,  687,  703,  705,  376,  622,  619,
 /*  7930 */   325,  869,  326,  869,  285,  869,  231,  869,  623,  869,
 /*  7940 */   624,  294,  689,  684,  685,  686,  687,  703,  705,  376,
 /*  7950 */   622,  619,  325,  869,  326,  869,  285,  869,  231,  869,
 /*  7960 */   623,  869,  624,  294,  689,  684,  685,  686,  687,  703,
 /*  7970 */   705,  376,  622,  619,  547,  683,  678,  680,  681,  682,
 /*  7980 */   679,  869,  869,  869,  292,  869,  869,  869,  869,  869,
 /*  7990 */   869,  869,  869,  869,  869,  869,  548,  683,  678,  680,
 /*  8000 */   681,  682,  679,  869,  869,  869,  292,  869,  869,  869,
 /*  8010 */   869,  869,  869,  869,  869,  869,  869,  869,  390,  683,
 /*  8020 */   678,  680,  681,  682,  679,  869,  869,  869,  292,  869,
 /*  8030 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  8040 */   391,  683,  678,  680,  681,  682,  679,  869,  869,  869,
 /*  8050 */   292,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  8060 */   869,  869,  566,  683,  678,  680,  681,  682,  679,  869,
 /*  8070 */   869,  869,  292,  869,  869,  869,  869,  869,  869,  869,
 /*  8080 */   869,  325,  869,  326,  869,  285,  869,  231,  869,  623,
 /*  8090 */   869,  624,  294,  689,  684,  685,  686,  687,  703,  705,
 /*  8100 */   376,  622,  619,  325,  869,  326,  869,  285,  869,  231,
 /*  8110 */   869,  623,  869,  624,  294,  689,  684,  685,  686,  687,
 /*  8120 */   703,  705,  376,  622,  619,  325,  869,  326,  869,  285,
 /*  8130 */   869,  231,  869,  623,  869,  624,  294,  689,  684,  685,
 /*  8140 */   686,  687,  703,  705,  376,  622,  619,  325,  869,  326,
 /*  8150 */   869,  285,  869,  231,  869,  623,  869,  624,  294,  689,
 /*  8160 */   684,  685,  686,  687,  703,  705,  376,  622,  619,  325,
 /*  8170 */   869,  326,  869,  285,  869,  231,  869,  623,  869,  624,
 /*  8180 */   294,  689,  684,  685,  686,  687,  703,  705,  376,  622,
 /*  8190 */   619,  570,  683,  678,  680,  681,  682,  679,  869,  869,
 /*  8200 */   869,  292,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  8210 */   869,  869,  869,  575,  683,  678,  680,  681,  682,  679,
 /*  8220 */   869,  618,  869,  292,  621,  869,  869,  869,  869,  149,
 /*  8230 */   869,  869,  869,  869,  869,  576,  683,  678,  680,  681,
 /*  8240 */   682,  679,  869,  869,  869,  292,  869,  625,  869,  869,
 /*  8250 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  8260 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  8270 */   869,  869,  869,  869,  827,  869,  869,  683,  678,  680,
 /*  8280 */   681,  682,  679,  869,  869,  869,  292,  869,  184,  869,
 /*  8290 */   648,  649,  869,  869,  869,  869,  869,  869,  325,  869,
 /*  8300 */   326,  869,  285,  869,  231,  869,  623,  869,  624,  294,
 /*  8310 */   689,  684,  685,  686,  687,  703,  705,  376,  622,  619,
 /*  8320 */   325,  869,  326,  869,  285,  869,  231,  869,  623,  869,
 /*  8330 */   624,  294,  689,  684,  685,  686,  687,  703,  705,  376,
 /*  8340 */   622,  619,  325,  869,  326,  869,  285,  869,  231,  869,
 /*  8350 */   623,  869,  624,  294,  689,  684,  685,  686,  687,  703,
 /*  8360 */   705,  376,  622,  619,  869,  626,  627,  628,  629,  630,
 /*  8370 */   631,  632,  633,  634,  635,  636,  637,  638,  639,  620,
 /*  8380 */   828,  829,  618,  869,  869,  621,  869,  917,  869,  231,
 /*  8390 */   143,  623,  869,  624,  294,  689,  684,  685,  686,  687,
 /*  8400 */   703,  705,  376,  622,  619,  869,  869,  869,  625,  869,
 /*  8410 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  8420 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  8430 */   869,  148,  869,  869,  869,  827,  869,  869,  869,  869,
 /*  8440 */   861,  869,  869,  869,  869,  869,  869,  869,  869,  208,
 /*  8450 */   869,  648,  649,  869,  869,  869,  869,  869,  869,  869,
 /*  8460 */   683,  678,  680,  681,  682,  679,  869,  869,  869,  292,
 /*  8470 */   869,  869,  148,  869,  869,  869,  869,  869,  869,  869,
 /*  8480 */   869,  861,  869,  869,  683,  678,  680,  681,  682,  679,
 /*  8490 */   869,  869,  869,  292,  869,  869,  869,  869,  869,  869,
 /*  8500 */   869,  869,  869,  869,  683,  678,  680,  681,  682,  679,
 /*  8510 */   869,  869,  564,  292,  139,  869,  869,  869,  869,  335,
 /*  8520 */   869,  336,  869,  847,  289,  869,  626,  627,  628,  629,
 /*  8530 */   630,  631,  632,  633,  634,  635,  636,  637,  638,  639,
 /*  8540 */   620,  828,  829,  683,  678,  680,  681,  682,  679,  869,
 /*  8550 */   869,  869,  292,  876,  869,  139,  869,  869,  619,  869,
 /*  8560 */   335,  869,  336,  869,  847,  289,  670,  869,  326,  869,
 /*  8570 */   285,  869,  231,  869,  623,  869,  624,  294,  689,  684,
 /*  8580 */   685,  686,  687,  703,  705,  376,  622,  619,  869,  869,
 /*  8590 */   923,  869,  326,  869,  285,  869,  231,  869,  623,  619,
 /*  8600 */   624,  294,  689,  684,  685,  686,  687,  703,  705,  376,
 /*  8610 */   622,  619,  671,  869,  285,  869,  231,  869,  623,  869,
 /*  8620 */   624,  294,  689,  684,  685,  686,  687,  703,  705,  376,
 /*  8630 */   622,  619,  869,  869,  869,  683,  678,  680,  681,  682,
 /*  8640 */   679,  869,  869,  869,  292,  869,  869,  869,  869,  869,
 /*  8650 */   869,  922,  869,  285,  869,  231,  869,  623,  869,  624,
 /*  8660 */   294,  689,  684,  685,  686,  687,  703,  705,  376,  622,
 /*  8670 */   619,  683,  678,  680,  681,  682,  679,  869,  869,  869,
 /*  8680 */   292,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  8690 */   683,  678,  680,  681,  682,  679,  869,  869,  869,  292,
 /*  8700 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  8710 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  8720 */   869,  869,  869,  869,  869,  869,  820,  869,  823,  824,
 /*  8730 */   825,  869,  284,  869,  869,  822,  869,  869,  869,  869,
 /*  8740 */   869,  869,  869,  869,  869,  918,  869,  231,  869,  623,
 /*  8750 */   869,  624,  294,  689,  684,  685,  686,  687,  703,  705,
 /*  8760 */   376,  622,  619,  869,  869,  869,  869,  869,  869,  601,
 /*  8770 */   354,  136,  579,  683,  678,  680,  681,  682,  679,  869,
 /*  8780 */   869,  919,  292,  231,  869,  623,  869,  624,  294,  689,
 /*  8790 */   684,  685,  686,  687,  703,  705,  376,  622,  619,  209,
 /*  8800 */   869,  210,  914,  869,  623,  869,  624,  294,  689,  684,
 /*  8810 */   685,  686,  687,  703,  705,  376,  622,  619,  869,  869,
 /*  8820 */   869,  869,  869,  869,  813,  814,  869,  869,  869,  869,
 /*  8830 */   821,  826,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  8840 */   623,  869,  624,  869,  869,  683,  678,  680,  681,  682,
 /*  8850 */   679,  376,  622,  619,  292,  869,  869,  869,  869,  683,
 /*  8860 */   678,  680,  681,  682,  679,  869,  869,  869,  292,  869,
 /*  8870 */   869,  869,  869,  869,  869,  869,  683,  678,  680,  681,
 /*  8880 */   682,  679,  869,  869,  869,  292,  869,  623,  869,  624,
 /*  8890 */   676,  689,  684,  685,  686,  687,  703,  705,  376,  622,
 /*  8900 */   619,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  8910 */   869,  869,  683,  678,  680,  681,  682,  679,  869,  869,
 /*  8920 */   869,  292,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  8930 */   869,  683,  678,  680,  681,  682,  679,  869,  869,  869,
 /*  8940 */   292,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  8950 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  623,
 /*  8960 */   869,  624,  908,  689,  684,  685,  686,  687,  703,  705,
 /*  8970 */   376,  622,  619,  623,  869,  624,  909,  689,  684,  685,
 /*  8980 */   686,  687,  703,  705,  376,  622,  619,  869,  869,  869,
 /*  8990 */   623,  869,  624,  869,  675,  684,  685,  686,  687,  703,
 /*  9000 */   705,  376,  622,  619,  869,  869,  869,  869,  869,  869,
 /*  9010 */   820,  869,  823,  824,  825,  869,  869,  869,  869,  822,
 /*  9020 */   869,  869,  869,  869,  869,  869,  623,  869,  624,  869,
 /*  9030 */   677,  684,  685,  686,  687,  703,  705,  376,  622,  619,
 /*  9040 */   869,  869,  869,  869,  869,  623,  869,  624,  869,  688,
 /*  9050 */   684,  685,  686,  687,  703,  705,  376,  622,  619,  878,
 /*  9060 */   869,  869,  553,  869,  869,  869,  869,  820,  869,  823,
 /*  9070 */   824,  825,  869,  869,  869,  820,  822,  823,  824,  825,
 /*  9080 */   869,  578,  869,  183,  822,  869,  869,  869,  869,  869,
 /*  9090 */   869,  869,  185,  869,  869,  869,  869,  869,  869,  869,
 /*  9100 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  9110 */   867,  868,  869,  869,  821,  826,  900,  869,  869,  553,
 /*  9120 */   869,  579,  869,  869,  623,  869,  624,  869,  869,  869,
 /*  9130 */   869,  869,  869,  869,  869,  376,  622,  619,  869,  869,
 /*  9140 */   183,  869,  869,  869,  869,  869,  869,  869,  209,  185,
 /*  9150 */   210,  820,  869,  823,  824,  825,  869,  581,  869,  869,
 /*  9160 */   822,  869,  869,  869,  869,  869,  869,  867,  868,  869,
 /*  9170 */   869,  821,  826,  813,  814,  869,  869,  869,  869,  821,
 /*  9180 */   826,  623,  869,  624,  869,  869,  869,  869,  869,  623,
 /*  9190 */   869,  624,  376,  622,  619,  869,  869,  579,  869,  869,
 /*  9200 */   376,  622,  619,  869,  869,  869,  869,  869,  869,  869,
 /*  9210 */   869,  869,  820,  869,  823,  824,  825,  869,  583,  869,
 /*  9220 */   869,  822,  869,  869,  209,  869,  210,  869,  869,  869,
 /*  9230 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  9240 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  813,
 /*  9250 */   814,  869,  869,  869,  869,  821,  826,  820,  579,  823,
 /*  9260 */   824,  825,  869, 1003,  869,  623,  822,  624,  869,  869,
 /*  9270 */   869,  869,  869,  869,  869,  869,  376,  622,  619,  869,
 /*  9280 */   869,  869,  869,  869,  869,  209,  869,  210,  869,  869,
 /*  9290 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  9300 */   869,  869,  869,  579,  869,  820,  869,  823,  824,  825,
 /*  9310 */   813,  814,  869,  869,  822,  869,  821,  826,  869,  869,
 /*  9320 */   869,  869,  869,  869,  869,  869,  623,  869,  624,  869,
 /*  9330 */   209,  869,  210,  869,  869,  869,  869,  376,  622,  619,
 /*  9340 */   820,  869,  823,  824,  825,  869,  600,  869,  869,  822,
 /*  9350 */   869,  943,  580,  869,  869,  813,  814,  869,  869,  869,
 /*  9360 */   869,  821,  826,  869,  869,  869,  869,  869,  869,  869,
 /*  9370 */   869,  623,  869,  624,  869,  869,  869,  869,  209,  869,
 /*  9380 */   210,  869,  376,  622,  619,  869,  579,  820,  869,  823,
 /*  9390 */   824,  825,  869, 1007,  869,  869,  822,  869,  869,  869,
 /*  9400 */   869,  869,  869,  813,  814,  869,  869,  869,  869,  821,
 /*  9410 */   826,  869,  869,  209,  869,  210,  869,  869,  869,  623,
 /*  9420 */   869,  624,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  9430 */   376,  622,  619,  579,  869,  869,  869,  869,  813,  814,
 /*  9440 */   869,  869,  869,  869,  821,  826,  820,  869,  823,  824,
 /*  9450 */   825,  869,  869,  869,  623,  822,  624,  869,  869,  869,
 /*  9460 */   209,  869,  210,  869,  869,  376,  622,  619,  869,  869,
 /*  9470 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  9480 */   869,  869,  869,  869,  869,  813,  814,  869,  869,  869,
 /*  9490 */   869,  821,  826,  869,  869,  809,  869,  869,  553,  869,
 /*  9500 */   869,  623,  820,  624,  823,  824,  825,  869,  869,  869,
 /*  9510 */   869,  822,  376,  622,  619,  869,  869,  869,  869,  183,
 /*  9520 */   612,  613,  614,  869,  869,  869,  869,  611,  185,  869,
 /*  9530 */   869,  869,  869,  869,  869,  820,  869,  823,  824,  825,
 /*  9540 */   869,  869,  869,  869,  822,  869,  867,  868,  869,  869,
 /*  9550 */   821,  826,  869,  869,  877,  554,  869,  869,  869,  869,
 /*  9560 */   623,  869,  624,  869,  869,  869,  869,  869,  869,  869,
 /*  9570 */   869,  376,  622,  619,  869,  183,  869,  820,  869,  823,
 /*  9580 */   824,  825,  177,  641,  185,  869,  822,  869,  869,  869,
 /*  9590 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  9600 */   869,  869,  867,  868,  869,  869,  821,  826,  871,  869,
 /*  9610 */   869,  869,  869,  869,  869,  869,  623,  872,  624,  332,
 /*  9620 */   869,  337,  869,  869,  869,  869,  869,  376,  622,  619,
 /*  9630 */   869,  869,  623,  869,  624,  867,  868,  869,  869,  821,
 /*  9640 */   826,  869,  869,  376,  622,  619,  869,  869,  869,  623,
 /*  9650 */   818,  624,  819,  869,  838,  869,  333,  869,  869,  869,
 /*  9660 */   376,  622,  619,  869,  869,  869,  869,  869,  869,  869,
 /*  9670 */   869,  869,  869,  869,  869,  813,  814,  869,  869,  869,
 /*  9680 */   869,  821,  826,  869,  869,  869,  869,  869,  869,  869,
 /*  9690 */   869,  623,  820,  624,  823,  824,  825,  869,  869,  869,
 /*  9700 */   869,  822,  376,  622,  619,  869,  869,  869,  869,  869,
 /*  9710 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  9720 */   869,  869,  869,  869,  869,  820,  869,  823,  824,  825,
 /*  9730 */   869,  869,  869,  869,  822,  869,  869,  869,  869,  869,
 /*  9740 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  9750 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  820,
 /*  9760 */   869,  823,  824,  825,  869,  818,  869,  819,  822,  334,
 /*  9770 */   869,  333,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  9780 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  9790 */   813,  814,  869,  869,  869,  869,  821,  826,  818,  869,
 /*  9800 */   819,  869,  815,  869,  333,  869,  623,  869,  624,  869,
 /*  9810 */   869,  869,  869,  869,  869,  869,  869,  376,  622,  619,
 /*  9820 */   869,  869,  869,  813,  814,  869,  869,  869,  869,  821,
 /*  9830 */   826,  869,  818,  869,  819,  869,  869,  869,  830,  623,
 /*  9840 */   820,  624,  823,  824,  825,  869,  869,  869,  869,  822,
 /*  9850 */   376,  622,  619,  869,  869,  869,  869,  813,  814,  869,
 /*  9860 */   869,  154,  869,  821,  826,  869,  869,  869,  869,  869,
 /*  9870 */   869,  869,  869,  623,  869,  624,  869,  869,  820,  869,
 /*  9880 */   823,  824,  825,  869,  376,  622,  619,  822,  869,  869,
 /*  9890 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  9900 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /*  9910 */   869,  869,  869,  818,  869,  819,  869,  835,  869,  333,
 /*  9920 */   820,  869,  823,  824,  825,  869,  869,  869,  869,  822,
 /*  9930 */   869,  869,  869,  869,  869,  869,  869,  869,  813,  814,
 /*  9940 */   869,  869,  869,  869,  821,  826,  869,  869,  869,  869,
 /*  9950 */   869,  818,  869,  819,  623,  839,  624,  333,  869,  869,
 /*  9960 */   869,  869,  869,  869,  869,  376,  622,  619,  869,  869,
 /*  9970 */   869,  869,  869,  869,  869,  869,  813,  814,  869,  869,
 /*  9980 */   869,  869,  821,  826,  869,  869,  869,  869,  869,  869,
 /*  9990 */   869,  869,  623,  818,  624,  819,  869,  864,  869,  333,
 /* 10000 */   869,  869,  869,  376,  622,  619,  869,  869,  869,  869,
 /* 10010 */   869,  869,  869,  869,  869,  869,  869,  869,  813,  814,
 /* 10020 */   869,  869,  869,  869,  821,  826,  820,  869,  823,  824,
 /* 10030 */   825,  869,  869,  869,  623,  822,  624,  869,  869,  869,
 /* 10040 */   869,  869,  869,  869,  869,  376,  622,  619,  869,  869,
 /* 10050 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  820,
 /* 10060 */   869,  823,  824,  825,  869,  869,  869,  869,  822,  869,
 /* 10070 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /* 10080 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /* 10090 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  818,
 /* 10100 */   869,  819,  869,  865,  869,  333,  820,  869,  823,  824,
 /* 10110 */   825,  869,  869,  869,  869,  822,  869,  869,  869,  869,
 /* 10120 */   869,  869,  869,  869,  813,  814,  869,  869,  869,  869,
 /* 10130 */   821,  826,  871,  869,  869,  869,  869,  869,  869,  869,
 /* 10140 */   623,  872,  624,  338,  869,  337,  869,  869,  869,  869,
 /* 10150 */   869,  376,  622,  619,  869,  869,  869,  869,  869,  867,
 /* 10160 */   868,  869,  869,  821,  826,  869,  869,  869,  869,  869,
 /* 10170 */   869,  869,  869,  623,  869,  624,  869,  869,  820,  871,
 /* 10180 */   823,  824,  825,  869,  376,  622,  619,  822,  872,  869,
 /* 10190 */   869,  869,  873,  869,  869,  869,  869,  869,  869,  869,
 /* 10200 */   869,  869,  869,  869,  869,  869,  867,  868,  869,  155,
 /* 10210 */   821,  826,  820,  869,  823,  824,  825,  869, 1002,  869,
 /* 10220 */   623,  822,  624,  869,  869,  869,  869,  899,  869,  869,
 /* 10230 */   553,  376,  622,  619,  612,  613,  614,  869,  869,  869,
 /* 10240 */   869,  611,  869,  869,  869,  869,  869,  869,  869,  869,
 /* 10250 */   869,  183,  869,  869,  869,  869,  869,  869,  579,  869,
 /* 10260 */   185,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /* 10270 */   869,  869,  869,  869,  869,  869,  869,  869,  867,  868,
 /* 10280 */   869,  869,  821,  826,  869,  209,  869,  210,  869,  869,
 /* 10290 */   869,  869,  623,  869,  624,  869,  178,  641,  869,  869,
 /* 10300 */   869,  869,  869,  376,  622,  619,  869,  869,  869,  869,
 /* 10310 */   813,  814,  869,  869,  869,  869,  821,  826,  820,  869,
 /* 10320 */   823,  824,  825,  869, 1006,  869,  623,  822,  624,  869,
 /* 10330 */   869,  869,  869,  869,  869,  869,  869,  376,  622,  619,
 /* 10340 */   869,  869,  869,  869,  869,  869,  623,  869,  624,  869,
 /* 10350 */   869,  869,  869,  869,  869,  869,  869,  376,  622,  619,
 /* 10360 */   869,  869,  869,  869,  579,  869,  869,  820,  869,  823,
 /* 10370 */   824,  825,  869,  869,  869,  869,  822,  869,  869,  869,
 /* 10380 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /* 10390 */   869,  209,  869,  210,  869,  869,  820,  869,  823,  824,
 /* 10400 */   825,  869,  869,  869,  820,  822,  823,  824,  825,  869,
 /* 10410 */   869,  869,  869,  822,  869,  869,  813,  814,  869,  869,
 /* 10420 */   869,  869,  821,  826,  869,  869,  869,  869,  869,  869,
 /* 10430 */   869,  869,  623,  869,  624,  869,  869,  869,  869,  869,
 /* 10440 */   818,  869,  819,  376,  622,  619,  817,  869,  869,  869,
 /* 10450 */   869,  869,  869,  869,  869,  869,  810,  869,  869,  869,
 /* 10460 */   869,  869,  869,  869,  869,  813,  814,  869,  869,  871,
 /* 10470 */   869,  821,  826,  869,  869,  869,  869,  183,  872,  869,
 /* 10480 */   869,  623,  870,  624,  869,  869,  185,  869,  869,  869,
 /* 10490 */   869,  869,  376,  622,  619,  869,  867,  868,  869,  869,
 /* 10500 */   821,  826,  869,  869,  867,  868,  869,  869,  821,  826,
 /* 10510 */   623,  869,  624,  869,  869,  869,  869,  869,  623,  869,
 /* 10520 */   624,  376,  622,  619,  820,  869,  823,  824,  825,  376,
 /* 10530 */   622,  619,  869,  822,  869,  869,  869,  869,  869,  869,
 /* 10540 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /* 10550 */   869,  869,  869,  869,  869,  869,  869,  820,  869,  823,
 /* 10560 */   824,  825,  869,  869,  869,  869,  822,  869,  869,  869,
 /* 10570 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /* 10580 */   869,  869,  869,  869,  869,  869,  820,  869,  823,  824,
 /* 10590 */   825,  869,  869,  869,  869,  822,  869,  818,  869,  819,
 /* 10600 */   869,  869,  869,  812,  869,  869,  869,  869,  869,  869,
 /* 10610 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /* 10620 */   869,  869,  813,  814,  869,  869,  869,  869,  821,  826,
 /* 10630 */   818,  869,  819,  869,  869,  869,  837,  869,  623,  869,
 /* 10640 */   624,  869,  869,  869,  869,  869,  869,  869,  869,  376,
 /* 10650 */   622,  619,  869,  869,  869,  813,  814,  869,  869,  871,
 /* 10660 */   869,  821,  826,  869,  869,  869,  869,  869,  872,  869,
 /* 10670 */   869,  623,  866,  624,  869,  869,  869,  869,  869,  869,
 /* 10680 */   869,  869,  376,  622,  619,  869,  867,  868,  869,  869,
 /* 10690 */   821,  826,  869,  869,  820,  869,  823,  824,  825,  869,
 /* 10700 */   623,  869,  624,  822,  869,  869,  869,  869,  869,  869,
 /* 10710 */   869,  376,  622,  619,  869,  869,  869,  869,  869,  869,
 /* 10720 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /* 10730 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /* 10740 */   869,  869,  869,  820,  869,  823,  824,  825,  869,  869,
 /* 10750 */   869,  869,  822,  869,  869,  869,  869,  869,  869,  869,
 /* 10760 */   869,  869,  869,  869,  869,  869,  869,  871,  869,  869,
 /* 10770 */   869,  869,  869,  869,  869,  869,  872,  869,  869,  869,
 /* 10780 */   875,  869,  869,  869,  869,  869,  869,  869,  869,  940,
 /* 10790 */   869,  869,  869,  869,  867,  868,  869,  869,  821,  826,
 /* 10800 */   869,  869,  869,  869,  869,  869,  869,  869,  623,  869,
 /* 10810 */   624,  869,  869,  869,  869,  869,  209,  869,  210,  376,
 /* 10820 */   622,  619,  869,  869,  869,  869,  869,  869,  869,  869,
 /* 10830 */   869,  869,  869,  869,  869,  869,  869,  869,  869,  869,
 /* 10840 */   869,  813,  814,  869,  869,  869,  869,  821,  826,  869,
 /* 10850 */   869,  869,  869,  869,  869,  869,  869,  623,  869,  624,
 /* 10860 */   869,  869,  869,  869,  869,  869,  869,  869,  376,  622,
 /* 10870 */   619,
);
static $yy_lookahead = array(
 /*     0 */     3,    2,   17,    6,    5,    8,    7,   10,   11,  178,
 /*    10 */    24,   25,  181,   14,   28,    5,   30,   18,   19,   50,
 /*    20 */   298,  299,   22,  301,   24,   25,   29,  195,   28,  296,
 /*    30 */    30,   31,   33,   48,   49,   36,   37,   38,   39,   16,
 /*    40 */    41,   42,   43,   44,   45,   46,   47,   48,   76,   77,
 /*    50 */    78,   79,   80,   81,   82,   83,  185,  186,  187,  188,
 /*    60 */   189,  190,  219,  220,   67,  194,   69,  235,  236,   72,
 /*    70 */    73,  239,  240,  241,  242,  243,  244,  245,  246,   56,
 /*    80 */    83,   84,   85,   86,   87,   88,   89,   90,   91,   92,
 /*    90 */    93,   94,   95,   96,   97,   98,   99,  100,  101,  102,
 /*   100 */   103,  104,  105,  106,  107,  108,  109,  110,  111,  112,
 /*   110 */   113,  114,  115,  116,  117,  118,  119,  120,  121,  122,
 /*   120 */   123,  124,  125,  126,  127,  128,  129,  130,  131,  132,
 /*   130 */   133,  134,  135,  136,  137,  138,  139,  140,  141,  142,
 /*   140 */   143,  225,  226,  227,  147,  148,  149,  150,  151,  152,
 /*   150 */   153,  154,  155,  156,  157,  158,  159,  160,  161,    3,
 /*   160 */    25,   21,    6,   28,    8,   30,  295,   11,  297,   28,
 /*   170 */   299,   30,  301,  302,  303,  304,  305,  306,  307,  308,
 /*   180 */   309,  310,  311,  312,    3,   29,   11,    6,  198,  199,
 /*   190 */    50,   51,   52,    2,  204,  205,    5,   16,  207,  208,
 /*   200 */   209,  210,  211,  212,  213,  214,  215,  216,  217,  218,
 /*   210 */    29,  157,  158,  159,  160,  224,  225,   15,  299,   17,
 /*   220 */   301,  179,   20,   67,   22,   69,   24,   25,   72,   73,
 /*   230 */    28,   56,   30,  194,  225,  226,  227,  195,   57,   83,
 /*   240 */    84,   85,   86,   87,   88,   89,   90,   91,   92,   93,
 /*   250 */    94,   95,   96,   97,   98,   99,  100,  101,  102,  103,
 /*   260 */   104,  105,  106,  107,  108,  109,  110,  111,  112,  113,
 /*   270 */   114,  115,  116,  117,  118,  119,  120,  121,  122,  123,
 /*   280 */   124,  125,  126,  127,  128,  129,  130,  131,  132,  133,
 /*   290 */   134,  135,  136,  137,  138,  139,  140,  141,  142,  143,
 /*   300 */   219,  220,   13,  147,  148,  149,  150,  151,  152,  153,
 /*   310 */   154,  155,  156,  157,  158,  159,  160,  161,    3,  280,
 /*   320 */   281,    6,   15,   10,   17,   10,   11,   20,  147,  148,
 /*   330 */   149,  150,  151,  152,  153,  154,  155,  156,  157,  158,
 /*   340 */   159,  160,  161,    3,   29,  195,    6,  178,  179,  180,
 /*   350 */   181,  312,  185,   64,  185,  179,   16,  181,  310,  192,
 /*   360 */   193,  194,  193,  194,  195,  196,  197,  198,  199,   29,
 /*   370 */   199,  195,  310,  204,  205,  204,  205,   22,   65,   24,
 /*   380 */    25,  185,   67,   28,   69,   30,  236,   72,   73,  239,
 /*   390 */   240,  241,  242,  243,  244,  245,  246,   57,   83,   84,
 /*   400 */    85,   86,   87,   88,   89,   90,   91,   92,   93,   94,
 /*   410 */    95,   96,   97,   98,   99,  100,  101,  102,  103,  104,
 /*   420 */   105,  106,  107,  108,  109,  110,  111,  112,  113,  114,
 /*   430 */   115,  116,  117,  118,  119,  120,  121,  122,  123,  124,
 /*   440 */   125,  126,  127,  128,  129,  130,  131,  132,  133,  134,
 /*   450 */   135,  136,  137,  138,  139,  140,  141,  142,  143,  219,
 /*   460 */   220,   11,  147,  148,  149,  150,  151,  152,  153,  154,
 /*   470 */   155,  156,  157,  158,  159,  160,  161,    3,  199,  312,
 /*   480 */     6,  312,    8,  204,  205,   11,  279,  147,  148,  149,
 /*   490 */   150,  151,  152,  153,  154,  155,  156,  157,  158,  159,
 /*   500 */   160,  161,    3,   29,   21,    6,   56,   17,    3,  252,
 /*   510 */    33,    6,   13,   36,   37,   38,   39,   34,   41,   42,
 /*   520 */    43,   44,   45,   46,   47,   48,   21,  194,   29,  197,
 /*   530 */   198,  199,  255,   50,   51,   52,  204,  205,   48,   49,
 /*   540 */   253,   67,  185,   69,  300,  194,   72,   73,  198,  199,
 /*   550 */   193,  194,  194,  300,  204,  205,   57,   83,   84,   85,
 /*   560 */    86,   87,   88,   89,   90,   91,   92,   93,   94,   95,
 /*   570 */    96,   97,   98,   99,  100,  101,  102,  103,  104,  105,
 /*   580 */   106,  107,  108,  109,  110,  111,  112,  113,  114,  115,
 /*   590 */   116,  117,  118,  119,  120,  121,  122,  123,  124,  125,
 /*   600 */   126,  127,  128,  129,  130,  131,  132,  133,  134,  135,
 /*   610 */   136,  137,  138,  139,  140,  141,  142,  143,  261,  185,
 /*   620 */    13,  147,  148,  149,  150,  151,  152,  153,  154,  155,
 /*   630 */   156,  157,  158,  159,  160,  161,    3,  199,  185,    6,
 /*   640 */   206,    8,  204,  205,   11,  312,  147,  148,  149,  150,
 /*   650 */   151,  152,  153,  154,  155,  156,  157,  158,  159,  160,
 /*   660 */   161,    3,   29,  312,    6,    3,  161,  257,    6,  312,
 /*   670 */   312,   13,  178,  179,  180,  181,  257,  185,  199,   72,
 /*   680 */    73,  247,  248,  204,  205,  193,  194,   29,  185,  195,
 /*   690 */   196,  197,  198,  199,  178,  179,   34,  181,  204,  205,
 /*   700 */    67,   15,   69,   17,    3,   72,   73,    6,  219,  220,
 /*   710 */   185,  195,   50,   51,  194,   57,   83,   84,   85,   86,
 /*   720 */    87,   88,   89,   90,   91,   92,   93,   94,   95,   96,
 /*   730 */    97,   98,   99,  100,  101,  102,  103,  104,  105,  106,
 /*   740 */   107,  108,  109,  110,  111,  112,  113,  114,  115,  116,
 /*   750 */   117,  118,  119,  120,  121,  122,  123,  124,  125,  126,
 /*   760 */   127,  128,  129,  130,  131,  132,  133,  134,  135,  136,
 /*   770 */   137,  138,  139,  140,  141,  142,  143,   11,  185,   11,
 /*   780 */   147,  148,  149,  150,  151,  152,  153,  154,  155,  156,
 /*   790 */   157,  158,  159,  160,  161,    3,   72,   73,    6,  206,
 /*   800 */     8,  281,  185,   11,  312,  147,  148,  149,  150,  151,
 /*   810 */   152,  153,  154,  155,  156,  157,  158,  159,  160,  161,
 /*   820 */   194,   29,   56,  161,   56,    3,  178,  179,    6,  181,
 /*   830 */    47,   48,  312,  178,  179,  179,  181,  181,   72,   73,
 /*   840 */   247,  248,  183,  195,  185,  186,  187,  188,  189,  190,
 /*   850 */   195,  195,  185,  194,  178,  179,   34,  181,  185,   67,
 /*   860 */   185,   69,  161,  282,   72,   73,  193,  194,  193,  194,
 /*   870 */   185,  195,   50,   51,  300,   83,   84,   85,   86,   87,
 /*   880 */    88,   89,   90,   91,   92,   93,   94,   95,   96,   97,
 /*   890 */    98,   99,  100,  101,  102,  103,  104,  105,  106,  107,
 /*   900 */   108,  109,  110,  111,  112,  113,  114,  115,  116,  117,
 /*   910 */   118,  119,  120,  121,  122,  123,  124,  125,  126,  127,
 /*   920 */   128,  129,  130,  131,  132,  133,  134,  135,  136,  137,
 /*   930 */   138,  139,  140,  141,  142,  143,  261,  300,  312,  147,
 /*   940 */   148,  149,  150,  151,  152,  153,  154,  155,  156,  157,
 /*   950 */   158,  159,  160,  161,    3,  185,   10,    6,  299,    8,
 /*   960 */   301,   17,   11,  304,  305,  306,  307,  308,  309,  310,
 /*   970 */   311,  312,  179,  180,  181,  175,  176,   11,    3,   17,
 /*   980 */    29,    6,   16,  161,   34,  312,   21,  312,  195,  196,
 /*   990 */   197,  198,  199,   49,  179,  300,  181,  204,  205,   34,
 /*  1000 */    50,  183,  194,  185,  186,  187,  188,  189,  190,   34,
 /*  1010 */   195,   49,  194,   67,   68,   50,   51,   52,   67,  257,
 /*  1020 */    69,  251,   56,   72,   73,   50,   51,    3,  194,  221,
 /*  1030 */     6,  224,  225,  257,   83,   84,   85,   86,   87,   88,
 /*  1040 */    89,   90,   91,   92,   93,   94,   95,   96,   97,   98,
 /*  1050 */    99,  100,  101,  102,  103,  104,  105,  106,  107,  108,
 /*  1060 */   109,  110,  111,  112,  113,  114,  115,  116,  117,  118,
 /*  1070 */   119,  120,  121,  122,  123,  124,  125,  126,  127,  128,
 /*  1080 */   129,  130,  131,  132,  133,  134,  135,  136,  137,  138,
 /*  1090 */   139,  140,  141,  142,  143,   13,   72,   73,  147,  148,
 /*  1100 */   149,  150,  151,  152,  153,  154,  155,  156,  157,  158,
 /*  1110 */   159,  160,  161,    3,   32,  281,    6,  299,    8,  301,
 /*  1120 */   312,   11,  304,  305,  306,  307,  308,  309,  310,  311,
 /*  1130 */   312,    7,  219,  179,  180,  181,  161,  194,   14,   29,
 /*  1140 */   226,  227,   18,   19,  226,  227,  312,   11,   17,  195,
 /*  1150 */   196,  197,  198,  199,  226,  227,   17,   33,  204,  205,
 /*  1160 */    36,   37,   38,   39,  221,   41,   42,   43,   44,   45,
 /*  1170 */    46,   47,   48,  181,  179,  194,  181,   67,  185,   69,
 /*  1180 */    49,  194,   72,   73,  194,  161,  193,  194,   49,  174,
 /*  1190 */   195,  176,   56,   83,   84,   85,   86,   87,   88,   89,
 /*  1200 */    90,   91,   92,   93,   94,   95,   96,   97,   98,   99,
 /*  1210 */   100,  101,  102,  103,  104,  105,  106,  107,  108,  109,
 /*  1220 */   110,  111,  112,  113,  114,  115,  116,  117,  118,  119,
 /*  1230 */   120,  121,  122,  123,  124,  125,  126,  127,  128,  129,
 /*  1240 */   130,  131,  132,  133,  134,  135,  136,  137,  138,  139,
 /*  1250 */   140,  141,  142,  143,  174,  312,  176,  147,  148,  149,
 /*  1260 */   150,  151,  152,  153,  154,  155,  156,  157,  158,  159,
 /*  1270 */   160,  161,    3,    2,  227,    6,    5,    8,  226,  227,
 /*  1280 */    11,   13,  229,  230,    3,   31,  185,    6,    3,   17,
 /*  1290 */    13,    6,   11,  312,  193,  194,  170,  194,   29,  312,
 /*  1300 */    17,   13,  312,   20,   33,  312,  180,   36,   37,   38,
 /*  1310 */    39,   17,   41,   42,   43,   44,   45,   46,   47,   48,
 /*  1320 */    32,   49,  196,  197,  198,  199,  194,  170,  185,  186,
 /*  1330 */   204,  205,   64,  190,  145,  146,   67,  194,   69,   62,
 /*  1340 */   170,   72,   73,   49,   63,  202,  203,   66,   63,  170,
 /*  1350 */    69,   66,   83,   84,   85,   86,   87,   88,   89,   90,
 /*  1360 */    91,   92,   93,   94,   95,   96,   97,   98,   99,  100,
 /*  1370 */   101,  102,  103,  104,  105,  106,  107,  108,  109,  110,
 /*  1380 */   111,  112,  113,  114,  115,  116,  117,  118,  119,  120,
 /*  1390 */   121,  122,  123,  124,  125,  126,  127,  128,  129,  130,
 /*  1400 */   131,  132,  133,  134,  135,  136,  137,  138,  139,  140,
 /*  1410 */   141,  142,  143,  312,   13,  312,  147,  148,  149,  150,
 /*  1420 */   151,  152,  153,  154,  155,  156,  157,  158,  159,  160,
 /*  1430 */   161,    3,  170,  169,    6,  171,  172,  173,   17,   11,
 /*  1440 */    30,  177,  161,  180,  312,   16,  161,  304,  305,  306,
 /*  1450 */   307,  308,  309,    3,  194,  312,    6,   29,  205,  196,
 /*  1460 */   197,  198,  199,   62,   15,   28,   17,  204,  205,   20,
 /*  1470 */    49,  207,  208,  209,  210,  211,  212,  213,  214,  215,
 /*  1480 */   216,  217,  218,  204,   34,   56,   62,  194,  224,  225,
 /*  1490 */   256,  194,   12,   13,   74,   67,  292,   69,  185,  186,
 /*  1500 */    72,   73,   75,  190,   12,   13,  294,  194,   12,   13,
 /*  1510 */    15,   83,   84,   85,   86,   87,   88,   89,   90,   91,
 /*  1520 */    92,   93,   94,   95,   96,   97,   98,   99,  100,  101,
 /*  1530 */   102,  103,  104,  105,  106,  107,  108,  109,  110,  111,
 /*  1540 */   112,  113,  114,  115,  116,  117,  118,  119,  120,  121,
 /*  1550 */   122,  123,  124,  125,  126,  127,  128,  129,  130,  131,
 /*  1560 */   132,  133,  134,  135,  136,  137,  138,  139,  140,  141,
 /*  1570 */   142,  143,  312,  256,  281,  147,  148,  149,  150,  151,
 /*  1580 */   152,  153,  154,  155,  156,  157,  158,  159,  160,  161,
 /*  1590 */     3,  195,   17,    6,  195,    8,    9,   10,   11,  167,
 /*  1600 */   168,    3,  195,   10,    6,  312,  174,  175,  176,  312,
 /*  1610 */   180,  161,   12,   13,  170,   32,   29,  304,  305,  306,
 /*  1620 */   307,  308,  309,   17,   49,  312,  196,  197,  198,  199,
 /*  1630 */   270,   62,  265,    3,  204,  205,    6,   17,  263,  207,
 /*  1640 */   208,  209,  210,  211,  212,  213,  214,  215,  216,  217,
 /*  1650 */   218,   21,   64,   32,  274,   49,  224,  225,   65,   72,
 /*  1660 */    73,   63,  185,  186,  187,  188,  189,  190,   65,   49,
 /*  1670 */    83,  194,   85,   86,   87,   88,   89,   90,   91,   92,
 /*  1680 */    93,   94,   95,   96,   97,   98,   99,  100,  101,  102,
 /*  1690 */   103,  104,  105,  106,  107,  108,  109,  110,  111,  112,
 /*  1700 */   113,  114,  115,  116,  117,  118,  119,  120,  121,  122,
 /*  1710 */   123,  124,  125,  126,  127,  128,  129,  130,  131,  132,
 /*  1720 */   133,  134,  135,  136,  137,  138,  139,  140,  141,  142,
 /*  1730 */   143,   13,  276,   62,  147,  148,  149,  150,  151,  152,
 /*  1740 */   153,  154,  155,  156,  157,  158,  159,  160,  161,    3,
 /*  1750 */   272,    3,    6,   13,    6,  270,   10,   11,  195,  161,
 /*  1760 */   195,  165,  166,  167,  168,  169,   13,  171,  172,  173,
 /*  1770 */   174,  175,  176,  177,    3,   29,  299,    6,  301,  195,
 /*  1780 */    62,  304,  305,  306,  307,  308,  309,  310,  311,  312,
 /*  1790 */   195,  161,  195,   59,  254,  256,  194,   50,   50,   51,
 /*  1800 */    29,  176,   62,  207,  208,  209,  210,  211,  212,  213,
 /*  1810 */   214,  215,  216,  217,  218,   62,   15,  195,   72,   73,
 /*  1820 */   224,  225,  230,  221,  219,   15,  219,  219,   57,   83,
 /*  1830 */   195,   85,   86,   87,   88,   89,   90,   91,   92,   93,
 /*  1840 */    94,   95,   96,   97,   98,   99,  100,  101,  102,  103,
 /*  1850 */   104,  105,  106,  107,  108,  109,  110,  111,  112,  113,
 /*  1860 */   114,  115,  116,  117,  118,  119,  120,  121,  122,  123,
 /*  1870 */   124,  125,  126,  127,  128,  129,  130,  131,  132,  133,
 /*  1880 */   134,  135,  136,  137,  138,  139,  140,  141,  142,  143,
 /*  1890 */    13,  222,  222,  147,  148,  149,  150,  151,  152,  153,
 /*  1900 */   154,  155,  156,  157,  158,  159,  160,  161,    3,  161,
 /*  1910 */     3,    6,  223,    6,  312,   10,   11,  195,  147,  148,
 /*  1920 */   149,  150,  151,  152,  153,  154,  155,  156,  157,  158,
 /*  1930 */   159,  160,  161,  195,   29,  223,  195,  195,  195,   62,
 /*  1940 */   223,   15,   15,  170,  195,  195,  195,  195,  170,  195,
 /*  1950 */   195,  170,   15,  170,  194,  183,   23,  185,  186,  187,
 /*  1960 */   188,  189,  190,   29,   29,   11,  194,  185,  186,   13,
 /*  1970 */    63,   74,  190,   75,   11,  185,  194,   72,   73,   72,
 /*  1980 */    73,  221,   11,  193,  194,  203,   13,   11,   83,   11,
 /*  1990 */    85,   86,   87,   88,   89,   90,   91,   92,   93,   94,
 /*  2000 */    95,   96,   97,   98,   99,  100,  101,  102,  103,  104,
 /*  2010 */   105,  106,  107,  108,  109,  110,  111,  112,  113,  114,
 /*  2020 */   115,  116,  117,  118,  119,  120,  121,  122,  123,  124,
 /*  2030 */   125,  126,  127,  128,  129,  130,  131,  132,  133,  134,
 /*  2040 */   135,  136,  137,  138,  139,  140,  141,  142,  143,  259,
 /*  2050 */    62,  261,  147,  148,  149,  150,  151,  152,  153,  154,
 /*  2060 */   155,  156,  157,  158,  159,  160,  161,    3,  161,   15,
 /*  2070 */     6,  299,  312,  301,   13,   11,  304,  305,  306,  307,
 /*  2080 */   308,  309,  310,  311,  312,   31,  304,  305,  306,  307,
 /*  2090 */   308,  309,   13,   29,  312,   11,   13,   56,   11,   62,
 /*  2100 */   180,   13,  312,   13,   50,   11,   13,   53,   54,   55,
 /*  2110 */   180,   13,   58,   11,   11,   61,  196,  197,  198,  199,
 /*  2120 */    13,   11,   13,   11,  204,  205,  196,  197,  198,  199,
 /*  2130 */    13,   11,   13,   11,  204,  205,   72,   73,   13,    3,
 /*  2140 */    11,   13,    6,   11,   13,   11,   10,   83,   13,   85,
 /*  2150 */    86,   87,   88,   89,   90,   91,   92,   93,   94,   95,
 /*  2160 */    96,   97,   98,   99,  100,  101,  102,  103,  104,  105,
 /*  2170 */   106,  107,  108,  109,  110,  111,  112,  113,  114,  115,
 /*  2180 */   116,  117,  118,  119,  120,  121,  122,  123,  124,  125,
 /*  2190 */   126,  127,  128,  129,  130,  131,  132,  133,  134,  135,
 /*  2200 */   136,  137,  138,  139,  140,  141,  142,  143,   72,   73,
 /*  2210 */    62,  147,  148,  149,  150,  151,  152,  153,  154,  155,
 /*  2220 */   156,  157,  158,  159,  160,  161,    3,   11,   62,    6,
 /*  2230 */   167,  168,   13,   11,   11,   62,   11,  174,  175,  176,
 /*  2240 */   180,   13,   62,   56,    3,   13,   11,    6,   11,   13,
 /*  2250 */    11,   56,   29,   13,   13,   13,  196,  197,  198,  199,
 /*  2260 */    11,   13,   11,   13,  204,  205,  180,   11,   13,   11,
 /*  2270 */   207,  208,  209,  210,  211,  212,  213,  214,  215,  216,
 /*  2280 */   217,  218,  196,  197,  198,  199,   13,  224,  225,   11,
 /*  2290 */   204,  205,   13,  185,   11,   72,   73,  161,   13,   56,
 /*  2300 */    11,  193,  194,   13,   63,   11,   83,   66,   85,   86,
 /*  2310 */    87,   88,   89,   90,   91,   92,   93,   94,   95,   96,
 /*  2320 */    97,   98,   99,  100,  101,  102,  103,  104,  105,  106,
 /*  2330 */   107,  108,  109,  110,  111,  112,  113,  114,  115,  116,
 /*  2340 */   117,  118,  119,  120,  121,  122,  123,  124,  125,  126,
 /*  2350 */   127,  128,  129,  130,  131,  132,  133,  134,  135,  136,
 /*  2360 */   137,  138,  139,  140,  141,  142,  143,  259,   13,  261,
 /*  2370 */   147,  148,  149,  150,  151,  152,  153,  154,  155,  156,
 /*  2380 */   157,  158,  159,  160,  161,    3,   11,    3,    6,   13,
 /*  2390 */     6,    3,   11,   11,    6,   15,   13,   11,   62,   15,
 /*  2400 */   180,   17,  161,   16,   20,   62,   22,   13,   24,   25,
 /*  2410 */   180,   29,   28,   11,   30,   62,  196,  197,  198,  199,
 /*  2420 */   312,   13,   34,   62,  204,  205,  196,  197,  198,  199,
 /*  2430 */    11,   13,  194,   11,  204,  205,   62,   13,  185,  186,
 /*  2440 */    11,   13,   11,  190,   11,   13,   23,  194,   13,   11,
 /*  2450 */    13,   11,   13,  200,   72,   73,   72,   73,  186,  221,
 /*  2460 */    72,   73,  190,   11,   13,   83,  194,   85,   86,   87,
 /*  2470 */    88,   89,   90,   91,   92,   93,   94,   95,   96,   97,
 /*  2480 */    98,   99,  100,  101,  102,  103,  104,  105,  106,  107,
 /*  2490 */   108,  109,  110,  111,  112,  113,  114,  115,  116,  117,
 /*  2500 */   118,  119,  120,  121,  122,  123,  124,  125,  126,  127,
 /*  2510 */   128,  129,  130,  131,  132,  133,  134,  135,  136,  137,
 /*  2520 */   138,  139,  140,  141,  142,  143,   62,   11,   62,  147,
 /*  2530 */   148,  149,  150,  151,  152,  153,  154,  155,  156,  157,
 /*  2540 */   158,  159,  160,  161,    3,  161,   13,    6,   11,  161,
 /*  2550 */   312,   62,   11,   62,  144,   13,   13,  304,  305,  306,
 /*  2560 */   307,  308,  309,  136,   11,  312,   76,   26,   27,  180,
 /*  2570 */    13,   13,   11,   13,   11,   13,  304,  305,  306,  307,
 /*  2580 */   308,  309,   11,   13,  312,  196,  197,  198,  199,   11,
 /*  2590 */    13,  180,   11,  204,  205,   13,  184,  185,  186,  187,
 /*  2600 */   188,  189,  190,   11,   13,  144,  194,  196,  197,  198,
 /*  2610 */   199,   76,   13,   72,   73,  204,  205,   13,   13,   13,
 /*  2620 */    13,   13,   13,   13,   83,   13,   85,   86,   87,   88,
 /*  2630 */    89,   90,   91,   92,   93,   94,   95,   96,   97,   98,
 /*  2640 */    99,  100,  101,  102,  103,  104,  105,  106,  107,  108,
 /*  2650 */   109,  110,  111,  112,  113,  114,  115,  116,  117,  118,
 /*  2660 */   119,  120,  121,  122,  123,  124,  125,  126,  127,  128,
 /*  2670 */   129,  130,  131,  132,  133,  134,  135,  136,  137,  138,
 /*  2680 */   139,  140,  141,  142,  143,    3,   13,    3,    6,   13,
 /*  2690 */     6,   13,   13,   11,    4,   11,   16,   16,    4,   32,
 /*  2700 */    62,   32,  161,  291,   71,  293,   64,  295,   65,  297,
 /*  2710 */    13,  299,   62,  301,  302,  303,  304,  305,  306,  307,
 /*  2720 */   308,  309,  310,  311,  312,   71,   11,   13,   12,  184,
 /*  2730 */   185,  186,  187,  188,  189,  190,   59,   13,   13,  194,
 /*  2740 */    13,   82,   11,   60,  194,   13,   13,   63,    4,   15,
 /*  2750 */    66,   16,    4,   69,   72,   73,   72,   73,   16,   16,
 /*  2760 */    15,   32,    6,    3,    3,   83,    4,   85,   86,   87,
 /*  2770 */    88,   89,   90,   91,   92,   93,   94,   95,   96,   97,
 /*  2780 */    98,   99,  100,  101,  102,  103,  104,  105,  106,  107,
 /*  2790 */   108,  109,  110,  111,  112,  113,  114,  115,  116,  117,
 /*  2800 */   118,  119,  120,  121,  122,  123,  124,  125,  126,  127,
 /*  2810 */   128,  129,  130,  131,  132,  133,  134,  135,  136,  137,
 /*  2820 */   138,  139,  140,  141,  142,  143,    3,  277,  278,    6,
 /*  2830 */    35,   35,    4,   40,   11,   15,  291,   40,  293,   40,
 /*  2840 */   295,   40,  297,  161,  299,  161,  301,  302,  303,  304,
 /*  2850 */   305,  306,  307,  308,  309,  310,  311,  312,   40,   40,
 /*  2860 */    16,   16,  312,   16,  194,  180,   32,  313,  313,  180,
 /*  2870 */   184,  185,  186,  187,  188,  189,  190,  313,  313,  313,
 /*  2880 */   194,  196,  197,  198,  199,  196,  197,  198,  199,  204,
 /*  2890 */   205,  221,  313,  204,  205,   72,   73,  313,  313,  313,
 /*  2900 */   313,  313,  313,  313,  313,  313,   83,  313,   85,   86,
 /*  2910 */    87,   88,   89,   90,   91,   92,   93,   94,   95,   96,
 /*  2920 */    97,   98,   99,  100,  101,  102,  103,  104,  105,  106,
 /*  2930 */   107,  108,  109,  110,  111,  112,  113,  114,  115,  116,
 /*  2940 */   117,  118,  119,  120,  121,  122,  123,  124,  125,  126,
 /*  2950 */   127,  128,  129,  130,  131,  132,  133,  134,  135,  136,
 /*  2960 */   137,  138,  139,  140,  141,  142,  143,    3,  313,  313,
 /*  2970 */     6,  313,  313,  313,  313,   11,  313,  291,  313,  293,
 /*  2980 */   313,  295,  312,  297,  161,  299,  313,  301,  302,  303,
 /*  2990 */   304,  305,  306,  307,  308,  309,  310,  311,  312,  194,
 /*  3000 */   313,  194,  313,  313,  313,  194,  180,  313,  313,  313,
 /*  3010 */   313,  184,  185,  186,  187,  188,  189,  190,  313,  313,
 /*  3020 */   313,  194,  196,  197,  198,  199,  221,  313,  221,  194,
 /*  3030 */   204,  205,  221,  184,  185,  186,  187,  188,  189,  190,
 /*  3040 */   313,  313,  313,  194,  313,  313,  313,   83,  313,   85,
 /*  3050 */    86,   87,   88,   89,   90,   91,   92,   93,   94,   95,
 /*  3060 */    96,   97,   98,   99,  100,  101,  102,  103,  104,  105,
 /*  3070 */   106,  107,  108,  109,  110,  111,  112,  113,  114,  115,
 /*  3080 */   116,  117,  118,  119,  120,  121,  122,  123,  124,  125,
 /*  3090 */   126,  127,  128,  129,  130,  131,  132,  133,  134,  135,
 /*  3100 */   136,  137,  138,  139,  140,  141,  142,  143,    3,  313,
 /*  3110 */   275,    6,  277,  278,  313,  313,   11,  312,  291,  312,
 /*  3120 */   293,  313,  295,  312,  297,  161,  299,  313,  301,  302,
 /*  3130 */   303,  304,  305,  306,  307,  308,  309,  310,  311,  312,
 /*  3140 */   291,  186,  293,  313,  295,  190,  297,  312,  299,  194,
 /*  3150 */   301,  302,  303,  304,  305,  306,  307,  308,  309,  310,
 /*  3160 */   311,  312,  184,  185,  186,  187,  188,  189,  190,  313,
 /*  3170 */   313,  313,  194,  313,  313,  313,  313,  313,  313,  313,
 /*  3180 */   185,  186,  187,  188,  189,  190,  313,  313,   83,  194,
 /*  3190 */    85,   86,   87,   88,   89,   90,   91,   92,   93,   94,
 /*  3200 */    95,   96,   97,   98,   99,  100,  101,  102,  103,  104,
 /*  3210 */   105,  106,  107,  108,  109,  110,  111,  112,  113,  114,
 /*  3220 */   115,  116,  117,  118,  119,  120,  121,  122,  123,  124,
 /*  3230 */   125,  126,  127,  128,  129,  130,  131,  132,  133,  134,
 /*  3240 */   135,  136,  137,  138,  139,  140,  141,  142,  143,    3,
 /*  3250 */   313,  313,    6,  313,  313,  313,  313,   11,  313,  304,
 /*  3260 */   305,  306,  307,  308,  309,  313,  161,  312,  313,  291,
 /*  3270 */   313,  293,  313,  295,  313,  297,  313,  299,  313,  301,
 /*  3280 */   302,  303,  304,  305,  306,  307,  308,  309,  310,  311,
 /*  3290 */   312,  313,  297,  194,  299,  194,  301,  302,  303,  304,
 /*  3300 */   305,  306,  307,  308,  309,  310,  311,  312,  185,  186,
 /*  3310 */   187,  188,  189,  190,  313,  313,  313,  194,  313,  313,
 /*  3320 */   221,  313,  221,  313,  313,  313,  313,  313,  313,   83,
 /*  3330 */   313,   85,   86,   87,   88,   89,   90,   91,   92,   93,
 /*  3340 */    94,   95,   96,   97,   98,   99,  100,  101,  102,  103,
 /*  3350 */   104,  105,  106,  107,  108,  109,  110,  111,  112,  113,
 /*  3360 */   114,  115,  116,  117,  118,  119,  120,  121,  122,  123,
 /*  3370 */   124,  125,  126,  127,  128,  129,  130,  131,  132,  133,
 /*  3380 */   134,  135,  136,  137,  138,  139,  140,  141,  142,  143,
 /*  3390 */     3,  194,  313,    6,    7,  313,  194,  313,   11,  313,
 /*  3400 */    67,  313,   15,   16,  313,  313,  185,  161,  187,  188,
 /*  3410 */   189,  312,  191,  312,  313,  194,   29,   84,   31,  313,
 /*  3420 */   297,  313,  299,  221,  301,  302,  303,  304,  305,  306,
 /*  3430 */   307,  308,  309,  310,  311,  312,  313,   50,  313,  313,
 /*  3440 */    53,   54,   55,   56,  313,   58,  313,  313,   61,  228,
 /*  3450 */   229,  230,  231,    3,  313,  313,    6,   70,  313,   72,
 /*  3460 */    73,   11,  313,    3,  313,  268,    6,  313,  313,  313,
 /*  3470 */   273,   11,  275,  180,  277,  278,  313,  180,  313,  258,
 /*  3480 */   313,  260,  149,  150,  151,  152,  153,  154,  313,  196,
 /*  3490 */   197,  198,  199,  196,  197,  198,  199,  204,  205,  185,
 /*  3500 */   194,  204,  205,  313,  283,  284,  313,  177,  194,  312,
 /*  3510 */   289,  290,  182,   63,  312,  185,   66,  187,  188,  189,
 /*  3520 */   299,  313,  301,   63,  194,  195,  313,  313,  313,   69,
 /*  3530 */   313,  310,  311,  312,  147,  148,  149,  150,  151,  152,
 /*  3540 */   153,  154,  155,  156,  157,  158,  159,  160,  161,  162,
 /*  3550 */   163,  183,  313,  185,  186,  187,  188,  189,  190,  313,
 /*  3560 */   313,  313,  194,  233,  234,  235,  236,  237,  313,  239,
 /*  3570 */   240,  241,  242,  243,  244,  245,  246,    3,  313,  273,
 /*  3580 */     6,  275,  268,  277,  278,   11,  313,  273,  258,  275,
 /*  3590 */    16,  277,  278,  313,  313,  313,  313,  267,  313,  313,
 /*  3600 */    67,    3,  313,   29,    6,  313,  313,  313,  313,   11,
 /*  3610 */   313,  161,  313,  313,   16,  285,  286,   84,  312,  289,
 /*  3620 */   290,  161,  313,  313,   50,  313,  312,   29,  313,  299,
 /*  3630 */    56,  301,  313,  180,  313,    3,    4,  313,    6,  313,
 /*  3640 */   310,  311,  312,   11,   70,  313,   72,   73,   50,  196,
 /*  3650 */   197,  198,  199,  313,   56,  313,  313,  204,  205,  313,
 /*  3660 */   194,   29,  313,  313,  313,  313,  313,  299,   70,  301,
 /*  3670 */    72,   73,  304,  305,  306,  307,  308,  309,  310,  311,
 /*  3680 */   312,  313,  149,  150,  151,  152,  153,  154,   56,  313,
 /*  3690 */   313,  185,  186,  187,  188,  189,  190,  313,  313,  313,
 /*  3700 */   194,  313,   70,  313,   72,   73,  313,  187,  188,  189,
 /*  3710 */   313,  313,  313,  313,  194,  313,  313,  194,  313,  313,
 /*  3720 */   313,  147,  148,  149,  150,  151,  152,  153,  154,  155,
 /*  3730 */   156,  157,  158,  159,  160,  161,  162,  163,  313,  273,
 /*  3740 */   313,  275,  313,  277,  278,  147,  148,  149,  150,  151,
 /*  3750 */   152,  153,  154,  155,  156,  157,  158,  159,  160,  161,
 /*  3760 */   162,  163,  313,  313,  187,  188,  189,  185,  313,  249,
 /*  3770 */   250,  194,  313,  313,  313,  193,  194,  313,  312,  147,
 /*  3780 */   148,  149,  150,  151,  152,  153,  154,  155,  156,  157,
 /*  3790 */   158,  159,  160,  161,  162,  163,    3,    4,  275,    6,
 /*  3800 */   277,  278,  313,  313,   11,  299,  313,  301,  302,  303,
 /*  3810 */   304,  305,  306,  307,  308,  309,  310,  311,  312,  299,
 /*  3820 */   313,  301,   29,  313,  313,  313,    3,  250,  313,    6,
 /*  3830 */   310,  311,  312,  313,   11,  312,  313,  313,  313,   16,
 /*  3840 */   313,  259,  313,  261,  313,  313,  313,  313,  313,   56,
 /*  3850 */   313,  313,   29,  313,  313,  313,    3,  313,  313,    6,
 /*  3860 */   313,  313,  313,   70,   11,   72,   73,  313,  313,   16,
 /*  3870 */   313,  313,  313,  313,  313,  313,  299,  313,  301,   56,
 /*  3880 */   313,  313,   29,  313,  313,  313,  313,  310,  311,  312,
 /*  3890 */   313,  313,  313,   70,  312,   72,   73,  313,  313,  313,
 /*  3900 */   313,  313,  313,  313,  313,  313,  313,  313,  313,   56,
 /*  3910 */   313,  313,  313,  313,  313,  185,  186,  187,  188,  189,
 /*  3920 */   190,  313,  313,   70,  194,   72,   73,  313,  313,  313,
 /*  3930 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  3940 */   147,  148,  149,  150,  151,  152,  153,  154,  155,  156,
 /*  3950 */   157,  158,  159,  160,  161,  162,  163,  313,  313,  313,
 /*  3960 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  3970 */   147,  148,  149,  150,  151,  152,  153,  154,  155,  156,
 /*  3980 */   157,  158,  159,  160,  161,  162,  163,  313,  313,  313,
 /*  3990 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4000 */   147,  148,  149,  150,  151,  152,  153,  154,  155,  156,
 /*  4010 */   157,  158,  159,  160,  161,  162,  163,    3,  313,  313,
 /*  4020 */     6,  313,  313,  313,  313,   11,  313,  297,  313,  299,
 /*  4030 */    16,  301,  302,  303,  304,  305,  306,  307,  308,  309,
 /*  4040 */   310,  311,  312,   29,  313,  313,  313,    3,    4,  313,
 /*  4050 */     6,  313,  313,  313,  313,   11,  313,  313,  313,  313,
 /*  4060 */   313,  313,  185,  313,  313,  313,  313,  313,  313,  313,
 /*  4070 */    56,  194,  313,   29,  313,  313,  313,    3,  313,  313,
 /*  4080 */     6,  313,  313,  313,   70,   11,   72,   73,  313,  313,
 /*  4090 */    16,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4100 */    56,  313,  313,   29,  313,  313,  313,  313,  313,  313,
 /*  4110 */   313,  313,  313,  313,   70,  313,   72,   73,  313,  313,
 /*  4120 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4130 */    56,  313,  313,  185,  186,  187,  188,  189,  190,  313,
 /*  4140 */   313,  313,  194,  266,   70,  268,   72,   73,  313,  313,
 /*  4150 */   273,  313,  275,  313,  277,  278,  313,  313,  313,  313,
 /*  4160 */   313,  147,  148,  149,  150,  151,  152,  153,  154,  155,
 /*  4170 */   156,  157,  158,  159,  160,  161,  162,  163,  313,  313,
 /*  4180 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  312,
 /*  4190 */   313,  147,  148,  149,  150,  151,  152,  153,  154,  155,
 /*  4200 */   156,  157,  158,  159,  160,  161,  162,  163,  313,  313,
 /*  4210 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4220 */   313,  147,  148,  149,  150,  151,  152,  153,  154,  155,
 /*  4230 */   156,  157,  158,  159,  160,  161,  162,  163,    3,    4,
 /*  4240 */   313,    6,  313,  295,  313,  297,   11,  299,  313,  301,
 /*  4250 */   302,  303,  304,  305,  306,  307,  308,  309,  310,  311,
 /*  4260 */   312,  313,  313,  313,   29,  313,  313,  313,    3,  313,
 /*  4270 */   313,    6,  313,  313,  313,  313,   11,  313,   13,  313,
 /*  4280 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4290 */   313,   56,  313,  313,   29,  313,  313,  313,  313,  313,
 /*  4300 */   313,  313,  313,  313,  313,   70,  313,   72,   73,  313,
 /*  4310 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4320 */   313,   56,  313,  313,  185,  186,  187,  188,  189,  190,
 /*  4330 */   313,  313,  313,  194,  313,   70,  313,   72,   73,  313,
 /*  4340 */   313,  313,  313,  313,  313,  313,  313,  184,  185,  186,
 /*  4350 */   187,  188,  189,  190,  313,  313,  313,  194,  186,  313,
 /*  4360 */   313,  313,  190,  313,  313,  313,  194,  313,  313,  313,
 /*  4370 */   313,  313,  313,  201,  313,  313,  313,  313,  313,  313,
 /*  4380 */   313,  313,  147,  148,  149,  150,  151,  152,  153,  154,
 /*  4390 */   155,  156,  157,  158,  159,  160,  161,  162,  163,  313,
 /*  4400 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4410 */   313,  313,  147,  148,  149,  150,  151,  152,  153,  154,
 /*  4420 */   155,  156,  157,  158,  159,  160,  161,  162,  163,    3,
 /*  4430 */   313,  313,    6,  313,  295,  313,  297,   11,  299,   13,
 /*  4440 */   301,  302,  303,  304,  305,  306,  307,  308,  309,  310,
 /*  4450 */   311,  312,  313,  313,  291,   29,  293,  313,  295,  313,
 /*  4460 */   297,  313,  299,  313,  301,  302,  303,  304,  305,  306,
 /*  4470 */   307,  308,  309,  310,  311,  312,  304,  305,  306,  307,
 /*  4480 */   308,  309,   56,  313,  312,  313,  313,  313,  313,  313,
 /*  4490 */   313,  313,  313,  313,  313,  313,   70,  313,   72,   73,
 /*  4500 */   313,  313,  313,  313,  313,  313,  184,  185,  186,  187,
 /*  4510 */   188,  189,  190,  313,  313,  313,  194,  313,  313,  313,
 /*  4520 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4530 */   313,  313,  184,  185,  186,  187,  188,  189,  190,  313,
 /*  4540 */   313,  313,  194,  313,  313,  313,  313,  313,  313,  313,
 /*  4550 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4560 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4570 */   313,  313,  313,  147,  148,  149,  150,  151,  152,  153,
 /*  4580 */   154,  155,  156,  157,  158,  159,  160,  161,  162,  163,
 /*  4590 */   313,  313,  313,  313,  313,  313,  313,  184,  185,  186,
 /*  4600 */   187,  188,  189,  190,  313,  313,  313,  194,  313,  313,
 /*  4610 */   313,  313,  313,  291,  313,  293,  313,  295,  313,  297,
 /*  4620 */   313,  299,  313,  301,  302,  303,  304,  305,  306,  307,
 /*  4630 */   308,  309,  310,  311,  312,  313,  313,  313,  313,  291,
 /*  4640 */   313,  293,  313,  295,  313,  297,  313,  299,  313,  301,
 /*  4650 */   302,  303,  304,  305,  306,  307,  308,  309,  310,  311,
 /*  4660 */   312,  313,  313,  313,  313,  313,  313,  184,  185,  186,
 /*  4670 */   187,  188,  189,  190,  313,  313,  313,  194,  313,  313,
 /*  4680 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4690 */   313,  184,  185,  186,  187,  188,  189,  190,  313,  313,
 /*  4700 */   313,  194,  313,  313,  291,  313,  293,  313,  295,  313,
 /*  4710 */   297,  313,  299,  313,  301,  302,  303,  304,  305,  306,
 /*  4720 */   307,  308,  309,  310,  311,  312,  313,  184,  185,  186,
 /*  4730 */   187,  188,  189,  190,  313,  313,  313,  194,  313,  313,
 /*  4740 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4750 */   313,  313,  313,  313,  313,  313,  313,  313,  184,  185,
 /*  4760 */   186,  187,  188,  189,  190,  313,  313,  313,  194,  313,
 /*  4770 */   313,  313,  313,  313,  291,  313,  293,  313,  295,  313,
 /*  4780 */   297,  313,  299,  313,  301,  302,  303,  304,  305,  306,
 /*  4790 */   307,  308,  309,  310,  311,  312,  313,  313,  291,  313,
 /*  4800 */   293,  313,  295,  313,  297,  313,  299,  313,  301,  302,
 /*  4810 */   303,  304,  305,  306,  307,  308,  309,  310,  311,  312,
 /*  4820 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4830 */   313,  313,  313,  313,  291,  313,  293,  313,  295,  313,
 /*  4840 */   297,  313,  299,  313,  301,  302,  303,  304,  305,  306,
 /*  4850 */   307,  308,  309,  310,  311,  312,  184,  185,  186,  187,
 /*  4860 */   188,  189,  190,  313,  313,  291,  194,  293,  313,  295,
 /*  4870 */   313,  297,  313,  299,  313,  301,  302,  303,  304,  305,
 /*  4880 */   306,  307,  308,  309,  310,  311,  312,  313,  313,  184,
 /*  4890 */   185,  186,  187,  188,  189,  190,  313,  313,  313,  194,
 /*  4900 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4910 */   313,  313,  184,  185,  186,  187,  188,  189,  190,  313,
 /*  4920 */   313,  313,  194,  313,  313,  313,  313,  313,  313,  313,
 /*  4930 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  4940 */   313,  313,  313,  184,  185,  186,  187,  188,  189,  190,
 /*  4950 */   313,  313,  313,  194,  313,  313,  313,  313,  313,  313,
 /*  4960 */   313,  313,  313,  291,  313,  293,  313,  295,  313,  297,
 /*  4970 */   313,  299,  313,  301,  302,  303,  304,  305,  306,  307,
 /*  4980 */   308,  309,  310,  311,  312,  184,  185,  186,  187,  188,
 /*  4990 */   189,  190,  313,  313,  313,  194,  291,  313,  293,  313,
 /*  5000 */   295,  313,  297,  313,  299,  313,  301,  302,  303,  304,
 /*  5010 */   305,  306,  307,  308,  309,  310,  311,  312,  313,  291,
 /*  5020 */   313,  293,  313,  295,  313,  297,  313,  299,  313,  301,
 /*  5030 */   302,  303,  304,  305,  306,  307,  308,  309,  310,  311,
 /*  5040 */   312,  184,  185,  186,  187,  188,  189,  190,  313,  313,
 /*  5050 */   291,  194,  293,  313,  295,  313,  297,  313,  299,  313,
 /*  5060 */   301,  302,  303,  304,  305,  306,  307,  308,  309,  310,
 /*  5070 */   311,  312,  313,  313,  184,  185,  186,  187,  188,  189,
 /*  5080 */   190,  313,  313,  313,  194,  313,  313,  313,  313,  313,
 /*  5090 */   313,  313,  291,  313,  293,  313,  295,  313,  297,  313,
 /*  5100 */   299,  313,  301,  302,  303,  304,  305,  306,  307,  308,
 /*  5110 */   309,  310,  311,  312,  313,  313,  313,  313,  313,  313,
 /*  5120 */   313,  313,  313,  313,  313,  313,  313,  313,  184,  185,
 /*  5130 */   186,  187,  188,  189,  190,  313,  313,  313,  194,  313,
 /*  5140 */   313,  313,  313,  313,  313,  313,  313,  313,  291,  313,
 /*  5150 */   293,  313,  295,  313,  297,  313,  299,  313,  301,  302,
 /*  5160 */   303,  304,  305,  306,  307,  308,  309,  310,  311,  312,
 /*  5170 */   184,  185,  186,  187,  188,  189,  190,  313,  313,  313,
 /*  5180 */   194,  291,  313,  293,  313,  295,  313,  297,  313,  299,
 /*  5190 */   313,  301,  302,  303,  304,  305,  306,  307,  308,  309,
 /*  5200 */   310,  311,  312,  313,  184,  185,  186,  187,  188,  189,
 /*  5210 */   190,  313,  313,  313,  194,  313,  313,  313,  313,  313,
 /*  5220 */   313,  313,  313,  313,  313,  313,  184,  185,  186,  187,
 /*  5230 */   188,  189,  190,  313,  313,  291,  194,  293,  313,  295,
 /*  5240 */   313,  297,  313,  299,  313,  301,  302,  303,  304,  305,
 /*  5250 */   306,  307,  308,  309,  310,  311,  312,  313,  313,  184,
 /*  5260 */   185,  186,  187,  188,  189,  190,  313,  313,  313,  194,
 /*  5270 */   313,  313,  313,  313,  313,  313,  313,  291,  313,  293,
 /*  5280 */   313,  295,  313,  297,  313,  299,  313,  301,  302,  303,
 /*  5290 */   304,  305,  306,  307,  308,  309,  310,  311,  312,  313,
 /*  5300 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  5310 */   313,  291,  313,  293,  313,  295,  313,  297,  313,  299,
 /*  5320 */   313,  301,  302,  303,  304,  305,  306,  307,  308,  309,
 /*  5330 */   310,  311,  312,  291,  313,  293,  313,  295,  313,  297,
 /*  5340 */   313,  299,  313,  301,  302,  303,  304,  305,  306,  307,
 /*  5350 */   308,  309,  310,  311,  312,  184,  185,  186,  187,  188,
 /*  5360 */   189,  190,  185,  313,  313,  194,  291,  313,  293,  313,
 /*  5370 */   295,  194,  297,  313,  299,  313,  301,  302,  303,  304,
 /*  5380 */   305,  306,  307,  308,  309,  310,  311,  312,  313,  184,
 /*  5390 */   185,  186,  187,  188,  189,  190,  313,  313,  313,  194,
 /*  5400 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  5410 */   313,  184,  185,  186,  187,  188,  189,  190,  313,  313,
 /*  5420 */   313,  194,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  5430 */   313,  313,  313,  184,  185,  186,  187,  188,  189,  190,
 /*  5440 */   313,  313,  313,  194,  313,  268,  313,  313,  313,  313,
 /*  5450 */   273,  313,  275,  313,  277,  278,  313,  313,  313,  313,
 /*  5460 */   313,  313,  291,  313,  293,  313,  295,  313,  297,  313,
 /*  5470 */   299,  313,  301,  302,  303,  304,  305,  306,  307,  308,
 /*  5480 */   309,  310,  311,  312,  313,  313,  313,  313,  313,  312,
 /*  5490 */   313,  313,  313,  313,  313,  313,  291,  313,  293,  313,
 /*  5500 */   295,  313,  297,  313,  299,  313,  301,  302,  303,  304,
 /*  5510 */   305,  306,  307,  308,  309,  310,  311,  312,  291,  313,
 /*  5520 */   293,  313,  295,  313,  297,  313,  299,  313,  301,  302,
 /*  5530 */   303,  304,  305,  306,  307,  308,  309,  310,  311,  312,
 /*  5540 */   291,  313,  293,  313,  295,  313,  297,  313,  299,  313,
 /*  5550 */   301,  302,  303,  304,  305,  306,  307,  308,  309,  310,
 /*  5560 */   311,  312,  184,  185,  186,  187,  188,  189,  190,  313,
 /*  5570 */   313,  313,  194,  313,  313,  313,  313,  313,  313,  313,
 /*  5580 */   313,  313,  313,  313,  184,  185,  186,  187,  188,  189,
 /*  5590 */   190,  313,  313,  313,  194,  313,  313,  313,  313,  313,
 /*  5600 */   313,  313,  313,  313,  313,  313,  184,  185,  186,  187,
 /*  5610 */   188,  189,  190,  313,  313,  313,  194,  313,  313,  313,
 /*  5620 */   313,  313,  313,  313,  313,  313,  313,  313,  184,  185,
 /*  5630 */   186,  187,  188,  189,  190,  313,  313,  313,  194,  313,
 /*  5640 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  5650 */   313,  184,  185,  186,  187,  188,  189,  190,  313,  313,
 /*  5660 */   313,  194,  313,  313,  313,  313,  313,  313,  313,  291,
 /*  5670 */   313,  293,  313,  295,  313,  297,  313,  299,  313,  301,
 /*  5680 */   302,  303,  304,  305,  306,  307,  308,  309,  310,  311,
 /*  5690 */   312,  291,  313,  293,  313,  295,  313,  297,  313,  299,
 /*  5700 */   313,  301,  302,  303,  304,  305,  306,  307,  308,  309,
 /*  5710 */   310,  311,  312,  291,  313,  293,  313,  295,  313,  297,
 /*  5720 */   313,  299,  313,  301,  302,  303,  304,  305,  306,  307,
 /*  5730 */   308,  309,  310,  311,  312,  291,  313,  293,  313,  295,
 /*  5740 */   313,  297,  313,  299,  313,  301,  302,  303,  304,  305,
 /*  5750 */   306,  307,  308,  309,  310,  311,  312,  313,  291,  313,
 /*  5760 */   293,  313,  295,  313,  297,  313,  299,  313,  301,  302,
 /*  5770 */   303,  304,  305,  306,  307,  308,  309,  310,  311,  312,
 /*  5780 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  5790 */   313,  184,  185,  186,  187,  188,  189,  190,  313,  313,
 /*  5800 */   313,  194,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  5810 */   313,  313,  313,  184,  185,  186,  187,  188,  189,  190,
 /*  5820 */   313,  313,  313,  194,  313,  313,  313,  313,  313,  313,
 /*  5830 */   313,  313,  313,  313,  313,  313,  184,  185,  186,  187,
 /*  5840 */   188,  189,  190,  313,  313,  313,  194,  313,  313,  313,
 /*  5850 */   313,  313,  313,  313,  313,  313,  313,  313,  184,  185,
 /*  5860 */   186,  187,  188,  189,  190,  313,  313,  313,  194,  313,
 /*  5870 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  5880 */   184,  185,  186,  187,  188,  189,  190,  313,  313,  313,
 /*  5890 */   194,  313,  313,  313,  313,  313,  313,  313,  291,  313,
 /*  5900 */   293,  313,  295,  313,  297,  313,  299,  313,  301,  302,
 /*  5910 */   303,  304,  305,  306,  307,  308,  309,  310,  311,  312,
 /*  5920 */   291,  313,  293,  313,  295,  313,  297,  313,  299,  313,
 /*  5930 */   301,  302,  303,  304,  305,  306,  307,  308,  309,  310,
 /*  5940 */   311,  312,  313,  291,  313,  293,  313,  295,  313,  297,
 /*  5950 */   313,  299,  313,  301,  302,  303,  304,  305,  306,  307,
 /*  5960 */   308,  309,  310,  311,  312,  291,  313,  293,  313,  295,
 /*  5970 */   313,  297,  313,  299,  313,  301,  302,  303,  304,  305,
 /*  5980 */   306,  307,  308,  309,  310,  311,  312,  291,  313,  293,
 /*  5990 */   313,  295,  313,  297,  313,  299,  313,  301,  302,  303,
 /*  6000 */   304,  305,  306,  307,  308,  309,  310,  311,  312,  313,
 /*  6010 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  6020 */   313,  184,  185,  186,  187,  188,  189,  190,  313,  313,
 /*  6030 */   313,  194,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  6040 */   313,  313,  313,  184,  185,  186,  187,  188,  189,  190,
 /*  6050 */   313,  313,  313,  194,  313,  313,  313,  313,  313,  313,
 /*  6060 */   313,  313,  313,  313,  313,  184,  185,  186,  187,  188,
 /*  6070 */   189,  190,  313,  313,  313,  194,  313,  313,  313,  313,
 /*  6080 */   313,  313,  313,  313,  313,  313,  313,  184,  185,  186,
 /*  6090 */   187,  188,  189,  190,  313,  313,  313,  194,  313,  313,
 /*  6100 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  184,
 /*  6110 */   185,  186,  187,  188,  189,  190,  313,  313,  313,  194,
 /*  6120 */   313,  313,  313,  313,  313,  313,  313,  313,  291,  313,
 /*  6130 */   293,  313,  295,  313,  297,  313,  299,  313,  301,  302,
 /*  6140 */   303,  304,  305,  306,  307,  308,  309,  310,  311,  312,
 /*  6150 */   291,  313,  293,  313,  295,  313,  297,  313,  299,  313,
 /*  6160 */   301,  302,  303,  304,  305,  306,  307,  308,  309,  310,
 /*  6170 */   311,  312,  291,  313,  293,  313,  295,  313,  297,  313,
 /*  6180 */   299,  313,  301,  302,  303,  304,  305,  306,  307,  308,
 /*  6190 */   309,  310,  311,  312,  291,  313,  293,  313,  295,  313,
 /*  6200 */   297,  313,  299,  313,  301,  302,  303,  304,  305,  306,
 /*  6210 */   307,  308,  309,  310,  311,  312,  291,  313,  293,  313,
 /*  6220 */   295,  313,  297,  313,  299,  313,  301,  302,  303,  304,
 /*  6230 */   305,  306,  307,  308,  309,  310,  311,  312,  184,  185,
 /*  6240 */   186,  187,  188,  189,  190,  313,  313,  313,  194,  313,
 /*  6250 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  6260 */   184,  185,  186,  187,  188,  189,  190,  313,  313,  313,
 /*  6270 */   194,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  6280 */   313,  313,  184,  185,  186,  187,  188,  189,  190,  313,
 /*  6290 */   313,  313,  194,  313,  313,  313,  313,  313,  313,  313,
 /*  6300 */   313,  313,  313,  313,  184,  185,  186,  187,  188,  189,
 /*  6310 */   190,  313,  313,  313,  194,  313,  313,  313,  313,  313,
 /*  6320 */   313,  313,  313,  313,  313,  313,  184,  185,  186,  187,
 /*  6330 */   188,  189,  190,  313,  313,  313,  194,  313,  313,  313,
 /*  6340 */   313,  313,  313,  313,  313,  291,  313,  293,  313,  295,
 /*  6350 */   313,  297,  313,  299,  313,  301,  302,  303,  304,  305,
 /*  6360 */   306,  307,  308,  309,  310,  311,  312,  291,  313,  293,
 /*  6370 */   313,  295,  313,  297,  313,  299,  313,  301,  302,  303,
 /*  6380 */   304,  305,  306,  307,  308,  309,  310,  311,  312,  291,
 /*  6390 */   313,  293,  313,  295,  313,  297,  313,  299,  313,  301,
 /*  6400 */   302,  303,  304,  305,  306,  307,  308,  309,  310,  311,
 /*  6410 */   312,  291,  313,  293,  313,  295,  313,  297,  313,  299,
 /*  6420 */   313,  301,  302,  303,  304,  305,  306,  307,  308,  309,
 /*  6430 */   310,  311,  312,  291,  313,  293,  313,  295,  313,  297,
 /*  6440 */   313,  299,  313,  301,  302,  303,  304,  305,  306,  307,
 /*  6450 */   308,  309,  310,  311,  312,  184,  185,  186,  187,  188,
 /*  6460 */   189,  190,  313,  313,  313,  194,  313,  313,  313,  313,
 /*  6470 */   313,  313,  313,  313,  313,  313,  313,  184,  185,  186,
 /*  6480 */   187,  188,  189,  190,  313,  313,  313,  194,  313,  313,
 /*  6490 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  184,
 /*  6500 */   185,  186,  187,  188,  189,  190,  313,  313,  313,  194,
 /*  6510 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  6520 */   313,  184,  185,  186,  187,  188,  189,  190,  313,  313,
 /*  6530 */   313,  194,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  6540 */   313,  313,  313,  184,  185,  186,  187,  188,  189,  190,
 /*  6550 */   313,  313,  313,  194,  313,  313,  313,  313,  313,  313,
 /*  6560 */   313,  313,  291,  313,  293,  313,  295,  313,  297,  313,
 /*  6570 */   299,  313,  301,  302,  303,  304,  305,  306,  307,  308,
 /*  6580 */   309,  310,  311,  312,  291,  313,  293,  313,  295,  313,
 /*  6590 */   297,  313,  299,  313,  301,  302,  303,  304,  305,  306,
 /*  6600 */   307,  308,  309,  310,  311,  312,  291,  313,  293,  313,
 /*  6610 */   295,  313,  297,  313,  299,  313,  301,  302,  303,  304,
 /*  6620 */   305,  306,  307,  308,  309,  310,  311,  312,  291,  313,
 /*  6630 */   293,  313,  295,  313,  297,  313,  299,  313,  301,  302,
 /*  6640 */   303,  304,  305,  306,  307,  308,  309,  310,  311,  312,
 /*  6650 */   291,  313,  293,  313,  295,  313,  297,  313,  299,  313,
 /*  6660 */   301,  302,  303,  304,  305,  306,  307,  308,  309,  310,
 /*  6670 */   311,  312,  184,  185,  186,  187,  188,  189,  190,  313,
 /*  6680 */   313,  313,  194,  313,  313,  313,  313,  313,  313,  313,
 /*  6690 */   313,  313,  313,  313,  184,  185,  186,  187,  188,  189,
 /*  6700 */   190,  313,  313,  313,  194,  313,  313,  313,  313,  313,
 /*  6710 */   313,  313,  313,  313,  313,  313,  184,  185,  186,  187,
 /*  6720 */   188,  189,  190,  313,  313,  313,  194,  313,  313,  313,
 /*  6730 */   313,  313,  313,  313,  313,  313,  313,  313,  184,  185,
 /*  6740 */   186,  187,  188,  189,  190,  313,  313,  313,  194,  313,
 /*  6750 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  6760 */   184,  185,  186,  187,  188,  189,  190,  313,  313,  313,
 /*  6770 */   194,  313,  313,  313,  313,  313,  313,  313,  313,  291,
 /*  6780 */   313,  293,  313,  295,  313,  297,  313,  299,  313,  301,
 /*  6790 */   302,  303,  304,  305,  306,  307,  308,  309,  310,  311,
 /*  6800 */   312,  291,  313,  293,  313,  295,  313,  297,  313,  299,
 /*  6810 */   313,  301,  302,  303,  304,  305,  306,  307,  308,  309,
 /*  6820 */   310,  311,  312,  291,  313,  293,  313,  295,  313,  297,
 /*  6830 */   313,  299,  313,  301,  302,  303,  304,  305,  306,  307,
 /*  6840 */   308,  309,  310,  311,  312,  291,  313,  293,  313,  295,
 /*  6850 */   313,  297,  313,  299,  313,  301,  302,  303,  304,  305,
 /*  6860 */   306,  307,  308,  309,  310,  311,  312,  291,  313,  293,
 /*  6870 */   313,  295,  313,  297,  313,  299,  313,  301,  302,  303,
 /*  6880 */   304,  305,  306,  307,  308,  309,  310,  311,  312,  184,
 /*  6890 */   185,  186,  187,  188,  189,  190,  313,  313,  313,  194,
 /*  6900 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  6910 */   313,  184,  185,  186,  187,  188,  189,  190,  313,  313,
 /*  6920 */   313,  194,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  6930 */   313,  313,  313,  184,  185,  186,  187,  188,  189,  190,
 /*  6940 */   313,  313,  313,  194,  313,  313,  313,  313,  313,  313,
 /*  6950 */   313,  313,  313,  313,  313,  184,  185,  186,  187,  188,
 /*  6960 */   189,  190,  313,  313,  313,  194,  313,  313,  313,  313,
 /*  6970 */   313,  313,  313,  313,  313,  313,  313,  184,  185,  186,
 /*  6980 */   187,  188,  189,  190,  313,  313,  313,  194,  313,  313,
 /*  6990 */   313,  313,  313,  313,  313,  313,  291,  313,  293,  313,
 /*  7000 */   295,  313,  297,  313,  299,  313,  301,  302,  303,  304,
 /*  7010 */   305,  306,  307,  308,  309,  310,  311,  312,  291,  313,
 /*  7020 */   293,  313,  295,  313,  297,  313,  299,  313,  301,  302,
 /*  7030 */   303,  304,  305,  306,  307,  308,  309,  310,  311,  312,
 /*  7040 */   291,  313,  293,  313,  295,  313,  297,  313,  299,  313,
 /*  7050 */   301,  302,  303,  304,  305,  306,  307,  308,  309,  310,
 /*  7060 */   311,  312,  291,  313,  293,  313,  295,  313,  297,  313,
 /*  7070 */   299,  313,  301,  302,  303,  304,  305,  306,  307,  308,
 /*  7080 */   309,  310,  311,  312,  291,  313,  293,  313,  295,  313,
 /*  7090 */   297,  313,  299,  313,  301,  302,  303,  304,  305,  306,
 /*  7100 */   307,  308,  309,  310,  311,  312,  184,  185,  186,  187,
 /*  7110 */   188,  189,  190,  313,  313,  313,  194,  313,  313,  313,
 /*  7120 */   313,  313,  313,  313,  313,  313,  313,  313,  184,  185,
 /*  7130 */   186,  187,  188,  189,  190,  313,  313,  313,  194,  313,
 /*  7140 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  7150 */   184,  185,  186,  187,  188,  189,  190,  313,  313,  313,
 /*  7160 */   194,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  7170 */   313,  313,  184,  185,  186,  187,  188,  189,  190,  313,
 /*  7180 */   313,  313,  194,  313,  313,  313,  313,  313,  313,  313,
 /*  7190 */   313,  313,  313,  313,  184,  185,  186,  187,  188,  189,
 /*  7200 */   190,  313,  313,  313,  194,  313,  313,  313,  313,  313,
 /*  7210 */   313,  313,  313,  291,  313,  293,  313,  295,  313,  297,
 /*  7220 */   313,  299,  313,  301,  302,  303,  304,  305,  306,  307,
 /*  7230 */   308,  309,  310,  311,  312,  291,  313,  293,  313,  295,
 /*  7240 */   313,  297,  313,  299,  313,  301,  302,  303,  304,  305,
 /*  7250 */   306,  307,  308,  309,  310,  311,  312,  291,  313,  293,
 /*  7260 */   313,  295,  313,  297,  313,  299,  313,  301,  302,  303,
 /*  7270 */   304,  305,  306,  307,  308,  309,  310,  311,  312,  291,
 /*  7280 */   313,  293,  313,  295,  313,  297,  313,  299,  313,  301,
 /*  7290 */   302,  303,  304,  305,  306,  307,  308,  309,  310,  311,
 /*  7300 */   312,  291,  313,  293,  313,  295,  313,  297,  313,  299,
 /*  7310 */   313,  301,  302,  303,  304,  305,  306,  307,  308,  309,
 /*  7320 */   310,  311,  312,  184,  185,  186,  187,  188,  189,  190,
 /*  7330 */   313,  313,  313,  194,  313,  313,  313,  313,  313,  313,
 /*  7340 */   313,  313,  313,  313,  313,  184,  185,  186,  187,  188,
 /*  7350 */   189,  190,  313,  313,  313,  194,  313,  313,  313,  313,
 /*  7360 */   313,  313,  313,  313,  313,  313,  313,  184,  185,  186,
 /*  7370 */   187,  188,  189,  190,  313,  313,  313,  194,  313,  313,
 /*  7380 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  184,
 /*  7390 */   185,  186,  187,  188,  189,  190,  313,  313,  313,  194,
 /*  7400 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  7410 */   313,  184,  185,  186,  187,  188,  189,  190,  313,  313,
 /*  7420 */   313,  194,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  7430 */   291,  313,  293,  313,  295,  313,  297,  313,  299,  313,
 /*  7440 */   301,  302,  303,  304,  305,  306,  307,  308,  309,  310,
 /*  7450 */   311,  312,  291,  313,  293,  313,  295,  313,  297,  313,
 /*  7460 */   299,  313,  301,  302,  303,  304,  305,  306,  307,  308,
 /*  7470 */   309,  310,  311,  312,  291,  313,  293,  313,  295,  313,
 /*  7480 */   297,  313,  299,  313,  301,  302,  303,  304,  305,  306,
 /*  7490 */   307,  308,  309,  310,  311,  312,  291,  313,  293,  313,
 /*  7500 */   295,  313,  297,  313,  299,  313,  301,  302,  303,  304,
 /*  7510 */   305,  306,  307,  308,  309,  310,  311,  312,  291,  313,
 /*  7520 */   293,  313,  295,  313,  297,  313,  299,  313,  301,  302,
 /*  7530 */   303,  304,  305,  306,  307,  308,  309,  310,  311,  312,
 /*  7540 */   184,  185,  186,  187,  188,  189,  190,  313,  313,  313,
 /*  7550 */   194,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  7560 */   313,  313,  184,  185,  186,  187,  188,  189,  190,  313,
 /*  7570 */   313,  313,  194,  313,  313,  313,  313,  313,  313,  313,
 /*  7580 */   313,  313,  313,  313,  184,  185,  186,  187,  188,  189,
 /*  7590 */   190,  313,  313,  313,  194,  313,  313,  313,  313,  313,
 /*  7600 */   313,  313,  313,  313,  313,  313,  184,  185,  186,  187,
 /*  7610 */   188,  189,  190,  313,  313,  313,  194,  313,  313,  313,
 /*  7620 */   313,  313,  313,  313,  313,  313,  313,  313,  184,  185,
 /*  7630 */   186,  187,  188,  189,  190,  313,  313,  313,  194,  313,
 /*  7640 */   313,  313,  313,  313,  313,  313,  313,  291,  313,  293,
 /*  7650 */   313,  295,  313,  297,  313,  299,  313,  301,  302,  303,
 /*  7660 */   304,  305,  306,  307,  308,  309,  310,  311,  312,  291,
 /*  7670 */   313,  293,  313,  295,  313,  297,  313,  299,  313,  301,
 /*  7680 */   302,  303,  304,  305,  306,  307,  308,  309,  310,  311,
 /*  7690 */   312,  291,  313,  293,  313,  295,  313,  297,  313,  299,
 /*  7700 */   313,  301,  302,  303,  304,  305,  306,  307,  308,  309,
 /*  7710 */   310,  311,  312,  291,  313,  293,  313,  295,  313,  297,
 /*  7720 */   313,  299,  313,  301,  302,  303,  304,  305,  306,  307,
 /*  7730 */   308,  309,  310,  311,  312,  291,  313,  293,  313,  295,
 /*  7740 */   313,  297,  313,  299,  313,  301,  302,  303,  304,  305,
 /*  7750 */   306,  307,  308,  309,  310,  311,  312,  184,  185,  186,
 /*  7760 */   187,  188,  189,  190,  313,  313,  313,  194,  313,  313,
 /*  7770 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  184,
 /*  7780 */   185,  186,  187,  188,  189,  190,  313,  313,  313,  194,
 /*  7790 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  7800 */   313,  184,  185,  186,  187,  188,  189,  190,  313,  313,
 /*  7810 */   313,  194,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  7820 */   313,  313,  313,  184,  185,  186,  187,  188,  189,  190,
 /*  7830 */   313,  313,  313,  194,  313,  313,  313,  313,  313,  313,
 /*  7840 */   313,  313,  313,  313,  313,  184,  185,  186,  187,  188,
 /*  7850 */   189,  190,  313,  313,  313,  194,  313,  313,  313,  313,
 /*  7860 */   313,  313,  313,  313,  291,  313,  293,  313,  295,  313,
 /*  7870 */   297,  313,  299,  313,  301,  302,  303,  304,  305,  306,
 /*  7880 */   307,  308,  309,  310,  311,  312,  291,  313,  293,  313,
 /*  7890 */   295,  313,  297,  313,  299,  313,  301,  302,  303,  304,
 /*  7900 */   305,  306,  307,  308,  309,  310,  311,  312,  291,  313,
 /*  7910 */   293,  313,  295,  313,  297,  313,  299,  313,  301,  302,
 /*  7920 */   303,  304,  305,  306,  307,  308,  309,  310,  311,  312,
 /*  7930 */   291,  313,  293,  313,  295,  313,  297,  313,  299,  313,
 /*  7940 */   301,  302,  303,  304,  305,  306,  307,  308,  309,  310,
 /*  7950 */   311,  312,  291,  313,  293,  313,  295,  313,  297,  313,
 /*  7960 */   299,  313,  301,  302,  303,  304,  305,  306,  307,  308,
 /*  7970 */   309,  310,  311,  312,  184,  185,  186,  187,  188,  189,
 /*  7980 */   190,  313,  313,  313,  194,  313,  313,  313,  313,  313,
 /*  7990 */   313,  313,  313,  313,  313,  313,  184,  185,  186,  187,
 /*  8000 */   188,  189,  190,  313,  313,  313,  194,  313,  313,  313,
 /*  8010 */   313,  313,  313,  313,  313,  313,  313,  313,  184,  185,
 /*  8020 */   186,  187,  188,  189,  190,  313,  313,  313,  194,  313,
 /*  8030 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  8040 */   184,  185,  186,  187,  188,  189,  190,  313,  313,  313,
 /*  8050 */   194,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  8060 */   313,  313,  184,  185,  186,  187,  188,  189,  190,  313,
 /*  8070 */   313,  313,  194,  313,  313,  313,  313,  313,  313,  313,
 /*  8080 */   313,  291,  313,  293,  313,  295,  313,  297,  313,  299,
 /*  8090 */   313,  301,  302,  303,  304,  305,  306,  307,  308,  309,
 /*  8100 */   310,  311,  312,  291,  313,  293,  313,  295,  313,  297,
 /*  8110 */   313,  299,  313,  301,  302,  303,  304,  305,  306,  307,
 /*  8120 */   308,  309,  310,  311,  312,  291,  313,  293,  313,  295,
 /*  8130 */   313,  297,  313,  299,  313,  301,  302,  303,  304,  305,
 /*  8140 */   306,  307,  308,  309,  310,  311,  312,  291,  313,  293,
 /*  8150 */   313,  295,  313,  297,  313,  299,  313,  301,  302,  303,
 /*  8160 */   304,  305,  306,  307,  308,  309,  310,  311,  312,  291,
 /*  8170 */   313,  293,  313,  295,  313,  297,  313,  299,  313,  301,
 /*  8180 */   302,  303,  304,  305,  306,  307,  308,  309,  310,  311,
 /*  8190 */   312,  184,  185,  186,  187,  188,  189,  190,  313,  313,
 /*  8200 */   313,  194,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  8210 */   313,  313,  313,  184,  185,  186,  187,  188,  189,  190,
 /*  8220 */   313,    3,  313,  194,    6,  313,  313,  313,  313,   11,
 /*  8230 */   313,  313,  313,  313,  313,  184,  185,  186,  187,  188,
 /*  8240 */   189,  190,  313,  313,  313,  194,  313,   29,  313,  313,
 /*  8250 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  8260 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  8270 */   313,  313,  313,  313,   56,  313,  313,  185,  186,  187,
 /*  8280 */   188,  189,  190,  313,  313,  313,  194,  313,   70,  313,
 /*  8290 */    72,   73,  313,  313,  313,  313,  313,  313,  291,  313,
 /*  8300 */   293,  313,  295,  313,  297,  313,  299,  313,  301,  302,
 /*  8310 */   303,  304,  305,  306,  307,  308,  309,  310,  311,  312,
 /*  8320 */   291,  313,  293,  313,  295,  313,  297,  313,  299,  313,
 /*  8330 */   301,  302,  303,  304,  305,  306,  307,  308,  309,  310,
 /*  8340 */   311,  312,  291,  313,  293,  313,  295,  313,  297,  313,
 /*  8350 */   299,  313,  301,  302,  303,  304,  305,  306,  307,  308,
 /*  8360 */   309,  310,  311,  312,  313,  147,  148,  149,  150,  151,
 /*  8370 */   152,  153,  154,  155,  156,  157,  158,  159,  160,  161,
 /*  8380 */   162,  163,    3,  313,  313,    6,  313,  295,  313,  297,
 /*  8390 */    11,  299,  313,  301,  302,  303,  304,  305,  306,  307,
 /*  8400 */   308,  309,  310,  311,  312,  313,  313,  313,   29,  313,
 /*  8410 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  8420 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  8430 */   313,  185,  313,  313,  313,   56,  313,  313,  313,  313,
 /*  8440 */   194,  313,  313,  313,  313,  313,  313,  313,  313,   70,
 /*  8450 */   313,   72,   73,  313,  313,  313,  313,  313,  313,  313,
 /*  8460 */   185,  186,  187,  188,  189,  190,  313,  313,  313,  194,
 /*  8470 */   313,  313,  185,  313,  313,  313,  313,  313,  313,  313,
 /*  8480 */   313,  194,  313,  313,  185,  186,  187,  188,  189,  190,
 /*  8490 */   313,  313,  313,  194,  313,  313,  313,  313,  313,  313,
 /*  8500 */   313,  313,  313,  313,  185,  186,  187,  188,  189,  190,
 /*  8510 */   313,  313,  266,  194,  268,  313,  313,  313,  313,  273,
 /*  8520 */   313,  275,  313,  277,  278,  313,  147,  148,  149,  150,
 /*  8530 */   151,  152,  153,  154,  155,  156,  157,  158,  159,  160,
 /*  8540 */   161,  162,  163,  185,  186,  187,  188,  189,  190,  313,
 /*  8550 */   313,  313,  194,  266,  313,  268,  313,  313,  312,  313,
 /*  8560 */   273,  313,  275,  313,  277,  278,  291,  313,  293,  313,
 /*  8570 */   295,  313,  297,  313,  299,  313,  301,  302,  303,  304,
 /*  8580 */   305,  306,  307,  308,  309,  310,  311,  312,  313,  313,
 /*  8590 */   291,  313,  293,  313,  295,  313,  297,  313,  299,  312,
 /*  8600 */   301,  302,  303,  304,  305,  306,  307,  308,  309,  310,
 /*  8610 */   311,  312,  293,  313,  295,  313,  297,  313,  299,  313,
 /*  8620 */   301,  302,  303,  304,  305,  306,  307,  308,  309,  310,
 /*  8630 */   311,  312,  313,  313,  313,  185,  186,  187,  188,  189,
 /*  8640 */   190,  313,  313,  313,  194,  313,  313,  313,  313,  313,
 /*  8650 */   313,  293,  313,  295,  313,  297,  313,  299,  313,  301,
 /*  8660 */   302,  303,  304,  305,  306,  307,  308,  309,  310,  311,
 /*  8670 */   312,  185,  186,  187,  188,  189,  190,  313,  313,  313,
 /*  8680 */   194,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  8690 */   185,  186,  187,  188,  189,  190,  313,  313,  313,  194,
 /*  8700 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  8710 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  8720 */   313,  313,  313,  313,  313,  313,  185,  313,  187,  188,
 /*  8730 */   189,  313,  191,  313,  313,  194,  313,  313,  313,  313,
 /*  8740 */   313,  313,  313,  313,  313,  295,  313,  297,  313,  299,
 /*  8750 */   313,  301,  302,  303,  304,  305,  306,  307,  308,  309,
 /*  8760 */   310,  311,  312,  313,  313,  313,  313,  313,  313,  228,
 /*  8770 */   229,  230,  231,  185,  186,  187,  188,  189,  190,  313,
 /*  8780 */   313,  295,  194,  297,  313,  299,  313,  301,  302,  303,
 /*  8790 */   304,  305,  306,  307,  308,  309,  310,  311,  312,  258,
 /*  8800 */   313,  260,  297,  313,  299,  313,  301,  302,  303,  304,
 /*  8810 */   305,  306,  307,  308,  309,  310,  311,  312,  313,  313,
 /*  8820 */   313,  313,  313,  313,  283,  284,  313,  313,  313,  313,
 /*  8830 */   289,  290,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  8840 */   299,  313,  301,  313,  313,  185,  186,  187,  188,  189,
 /*  8850 */   190,  310,  311,  312,  194,  313,  313,  313,  313,  185,
 /*  8860 */   186,  187,  188,  189,  190,  313,  313,  313,  194,  313,
 /*  8870 */   313,  313,  313,  313,  313,  313,  185,  186,  187,  188,
 /*  8880 */   189,  190,  313,  313,  313,  194,  313,  299,  313,  301,
 /*  8890 */   302,  303,  304,  305,  306,  307,  308,  309,  310,  311,
 /*  8900 */   312,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  8910 */   313,  313,  185,  186,  187,  188,  189,  190,  313,  313,
 /*  8920 */   313,  194,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  8930 */   313,  185,  186,  187,  188,  189,  190,  313,  313,  313,
 /*  8940 */   194,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  8950 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  299,
 /*  8960 */   313,  301,  302,  303,  304,  305,  306,  307,  308,  309,
 /*  8970 */   310,  311,  312,  299,  313,  301,  302,  303,  304,  305,
 /*  8980 */   306,  307,  308,  309,  310,  311,  312,  313,  313,  313,
 /*  8990 */   299,  313,  301,  313,  303,  304,  305,  306,  307,  308,
 /*  9000 */   309,  310,  311,  312,  313,  313,  313,  313,  313,  313,
 /*  9010 */   185,  313,  187,  188,  189,  313,  313,  313,  313,  194,
 /*  9020 */   313,  313,  313,  313,  313,  313,  299,  313,  301,  313,
 /*  9030 */   303,  304,  305,  306,  307,  308,  309,  310,  311,  312,
 /*  9040 */   313,  313,  313,  313,  313,  299,  313,  301,  313,  303,
 /*  9050 */   304,  305,  306,  307,  308,  309,  310,  311,  312,  234,
 /*  9060 */   313,  313,  237,  313,  313,  313,  313,  185,  313,  187,
 /*  9070 */   188,  189,  313,  313,  313,  185,  194,  187,  188,  189,
 /*  9080 */   313,  191,  313,  258,  194,  313,  313,  313,  313,  313,
 /*  9090 */   313,  313,  267,  313,  313,  313,  313,  313,  313,  313,
 /*  9100 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  9110 */   285,  286,  313,  313,  289,  290,  234,  313,  313,  237,
 /*  9120 */   313,  231,  313,  313,  299,  313,  301,  313,  313,  313,
 /*  9130 */   313,  313,  313,  313,  313,  310,  311,  312,  313,  313,
 /*  9140 */   258,  313,  313,  313,  313,  313,  313,  313,  258,  267,
 /*  9150 */   260,  185,  313,  187,  188,  189,  313,  191,  313,  313,
 /*  9160 */   194,  313,  313,  313,  313,  313,  313,  285,  286,  313,
 /*  9170 */   313,  289,  290,  283,  284,  313,  313,  313,  313,  289,
 /*  9180 */   290,  299,  313,  301,  313,  313,  313,  313,  313,  299,
 /*  9190 */   313,  301,  310,  311,  312,  313,  313,  231,  313,  313,
 /*  9200 */   310,  311,  312,  313,  313,  313,  313,  313,  313,  313,
 /*  9210 */   313,  313,  185,  313,  187,  188,  189,  313,  191,  313,
 /*  9220 */   313,  194,  313,  313,  258,  313,  260,  313,  313,  313,
 /*  9230 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  9240 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  283,
 /*  9250 */   284,  313,  313,  313,  313,  289,  290,  185,  231,  187,
 /*  9260 */   188,  189,  313,  191,  313,  299,  194,  301,  313,  313,
 /*  9270 */   313,  313,  313,  313,  313,  313,  310,  311,  312,  313,
 /*  9280 */   313,  313,  313,  313,  313,  258,  313,  260,  313,  313,
 /*  9290 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  9300 */   313,  313,  313,  231,  313,  185,  313,  187,  188,  189,
 /*  9310 */   283,  284,  313,  313,  194,  313,  289,  290,  313,  313,
 /*  9320 */   313,  313,  313,  313,  313,  313,  299,  313,  301,  313,
 /*  9330 */   258,  313,  260,  313,  313,  313,  313,  310,  311,  312,
 /*  9340 */   185,  313,  187,  188,  189,  313,  191,  313,  313,  194,
 /*  9350 */   313,  231,  232,  313,  313,  283,  284,  313,  313,  313,
 /*  9360 */   313,  289,  290,  313,  313,  313,  313,  313,  313,  313,
 /*  9370 */   313,  299,  313,  301,  313,  313,  313,  313,  258,  313,
 /*  9380 */   260,  313,  310,  311,  312,  313,  231,  185,  313,  187,
 /*  9390 */   188,  189,  313,  191,  313,  313,  194,  313,  313,  313,
 /*  9400 */   313,  313,  313,  283,  284,  313,  313,  313,  313,  289,
 /*  9410 */   290,  313,  313,  258,  313,  260,  313,  313,  313,  299,
 /*  9420 */   313,  301,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  9430 */   310,  311,  312,  231,  313,  313,  313,  313,  283,  284,
 /*  9440 */   313,  313,  313,  313,  289,  290,  185,  313,  187,  188,
 /*  9450 */   189,  313,  313,  313,  299,  194,  301,  313,  313,  313,
 /*  9460 */   258,  313,  260,  313,  313,  310,  311,  312,  313,  313,
 /*  9470 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  9480 */   313,  313,  313,  313,  313,  283,  284,  313,  313,  313,
 /*  9490 */   313,  289,  290,  313,  313,  234,  313,  313,  237,  313,
 /*  9500 */   313,  299,  185,  301,  187,  188,  189,  313,  313,  313,
 /*  9510 */   313,  194,  310,  311,  312,  313,  313,  313,  313,  258,
 /*  9520 */   187,  188,  189,  313,  313,  313,  313,  194,  267,  313,
 /*  9530 */   313,  313,  313,  313,  313,  185,  313,  187,  188,  189,
 /*  9540 */   313,  313,  313,  313,  194,  313,  285,  286,  313,  313,
 /*  9550 */   289,  290,  313,  313,  237,  238,  313,  313,  313,  313,
 /*  9560 */   299,  313,  301,  313,  313,  313,  313,  313,  313,  313,
 /*  9570 */   313,  310,  311,  312,  313,  258,  313,  185,  313,  187,
 /*  9580 */   188,  189,  249,  250,  267,  313,  194,  313,  313,  313,
 /*  9590 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  9600 */   313,  313,  285,  286,  313,  313,  289,  290,  258,  313,
 /*  9610 */   313,  313,  313,  313,  313,  313,  299,  267,  301,  269,
 /*  9620 */   313,  271,  313,  313,  313,  313,  313,  310,  311,  312,
 /*  9630 */   313,  313,  299,  313,  301,  285,  286,  313,  313,  289,
 /*  9640 */   290,  313,  313,  310,  311,  312,  313,  313,  313,  299,
 /*  9650 */   258,  301,  260,  313,  262,  313,  264,  313,  313,  313,
 /*  9660 */   310,  311,  312,  313,  313,  313,  313,  313,  313,  313,
 /*  9670 */   313,  313,  313,  313,  313,  283,  284,  313,  313,  313,
 /*  9680 */   313,  289,  290,  313,  313,  313,  313,  313,  313,  313,
 /*  9690 */   313,  299,  185,  301,  187,  188,  189,  313,  313,  313,
 /*  9700 */   313,  194,  310,  311,  312,  313,  313,  313,  313,  313,
 /*  9710 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  9720 */   313,  313,  313,  313,  313,  185,  313,  187,  188,  189,
 /*  9730 */   313,  313,  313,  313,  194,  313,  313,  313,  313,  313,
 /*  9740 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  9750 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  185,
 /*  9760 */   313,  187,  188,  189,  313,  258,  313,  260,  194,  262,
 /*  9770 */   313,  264,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  9780 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  9790 */   283,  284,  313,  313,  313,  313,  289,  290,  258,  313,
 /*  9800 */   260,  313,  262,  313,  264,  313,  299,  313,  301,  313,
 /*  9810 */   313,  313,  313,  313,  313,  313,  313,  310,  311,  312,
 /*  9820 */   313,  313,  313,  283,  284,  313,  313,  313,  313,  289,
 /*  9830 */   290,  313,  258,  313,  260,  313,  313,  313,  264,  299,
 /*  9840 */   185,  301,  187,  188,  189,  313,  313,  313,  313,  194,
 /*  9850 */   310,  311,  312,  313,  313,  313,  313,  283,  284,  313,
 /*  9860 */   313,  287,  313,  289,  290,  313,  313,  313,  313,  313,
 /*  9870 */   313,  313,  313,  299,  313,  301,  313,  313,  185,  313,
 /*  9880 */   187,  188,  189,  313,  310,  311,  312,  194,  313,  313,
 /*  9890 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  9900 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /*  9910 */   313,  313,  313,  258,  313,  260,  313,  262,  313,  264,
 /*  9920 */   185,  313,  187,  188,  189,  313,  313,  313,  313,  194,
 /*  9930 */   313,  313,  313,  313,  313,  313,  313,  313,  283,  284,
 /*  9940 */   313,  313,  313,  313,  289,  290,  313,  313,  313,  313,
 /*  9950 */   313,  258,  313,  260,  299,  262,  301,  264,  313,  313,
 /*  9960 */   313,  313,  313,  313,  313,  310,  311,  312,  313,  313,
 /*  9970 */   313,  313,  313,  313,  313,  313,  283,  284,  313,  313,
 /*  9980 */   313,  313,  289,  290,  313,  313,  313,  313,  313,  313,
 /*  9990 */   313,  313,  299,  258,  301,  260,  313,  262,  313,  264,
 /* 10000 */   313,  313,  313,  310,  311,  312,  313,  313,  313,  313,
 /* 10010 */   313,  313,  313,  313,  313,  313,  313,  313,  283,  284,
 /* 10020 */   313,  313,  313,  313,  289,  290,  185,  313,  187,  188,
 /* 10030 */   189,  313,  313,  313,  299,  194,  301,  313,  313,  313,
 /* 10040 */   313,  313,  313,  313,  313,  310,  311,  312,  313,  313,
 /* 10050 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  185,
 /* 10060 */   313,  187,  188,  189,  313,  313,  313,  313,  194,  313,
 /* 10070 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /* 10080 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /* 10090 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  258,
 /* 10100 */   313,  260,  313,  262,  313,  264,  185,  313,  187,  188,
 /* 10110 */   189,  313,  313,  313,  313,  194,  313,  313,  313,  313,
 /* 10120 */   313,  313,  313,  313,  283,  284,  313,  313,  313,  313,
 /* 10130 */   289,  290,  258,  313,  313,  313,  313,  313,  313,  313,
 /* 10140 */   299,  267,  301,  269,  313,  271,  313,  313,  313,  313,
 /* 10150 */   313,  310,  311,  312,  313,  313,  313,  313,  313,  285,
 /* 10160 */   286,  313,  313,  289,  290,  313,  313,  313,  313,  313,
 /* 10170 */   313,  313,  313,  299,  313,  301,  313,  313,  185,  258,
 /* 10180 */   187,  188,  189,  313,  310,  311,  312,  194,  267,  313,
 /* 10190 */   313,  313,  271,  313,  313,  313,  313,  313,  313,  313,
 /* 10200 */   313,  313,  313,  313,  313,  313,  285,  286,  313,  288,
 /* 10210 */   289,  290,  185,  313,  187,  188,  189,  313,  191,  313,
 /* 10220 */   299,  194,  301,  313,  313,  313,  313,  234,  313,  313,
 /* 10230 */   237,  310,  311,  312,  187,  188,  189,  313,  313,  313,
 /* 10240 */   313,  194,  313,  313,  313,  313,  313,  313,  313,  313,
 /* 10250 */   313,  258,  313,  313,  313,  313,  313,  313,  231,  313,
 /* 10260 */   267,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /* 10270 */   313,  313,  313,  313,  313,  313,  313,  313,  285,  286,
 /* 10280 */   313,  313,  289,  290,  313,  258,  313,  260,  313,  313,
 /* 10290 */   313,  313,  299,  313,  301,  313,  249,  250,  313,  313,
 /* 10300 */   313,  313,  313,  310,  311,  312,  313,  313,  313,  313,
 /* 10310 */   283,  284,  313,  313,  313,  313,  289,  290,  185,  313,
 /* 10320 */   187,  188,  189,  313,  191,  313,  299,  194,  301,  313,
 /* 10330 */   313,  313,  313,  313,  313,  313,  313,  310,  311,  312,
 /* 10340 */   313,  313,  313,  313,  313,  313,  299,  313,  301,  313,
 /* 10350 */   313,  313,  313,  313,  313,  313,  313,  310,  311,  312,
 /* 10360 */   313,  313,  313,  313,  231,  313,  313,  185,  313,  187,
 /* 10370 */   188,  189,  313,  313,  313,  313,  194,  313,  313,  313,
 /* 10380 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /* 10390 */   313,  258,  313,  260,  313,  313,  185,  313,  187,  188,
 /* 10400 */   189,  313,  313,  313,  185,  194,  187,  188,  189,  313,
 /* 10410 */   313,  313,  313,  194,  313,  313,  283,  284,  313,  313,
 /* 10420 */   313,  313,  289,  290,  313,  313,  313,  313,  313,  313,
 /* 10430 */   313,  313,  299,  313,  301,  313,  313,  313,  313,  313,
 /* 10440 */   258,  313,  260,  310,  311,  312,  264,  313,  313,  313,
 /* 10450 */   313,  313,  313,  313,  313,  313,  237,  313,  313,  313,
 /* 10460 */   313,  313,  313,  313,  313,  283,  284,  313,  313,  258,
 /* 10470 */   313,  289,  290,  313,  313,  313,  313,  258,  267,  313,
 /* 10480 */   313,  299,  271,  301,  313,  313,  267,  313,  313,  313,
 /* 10490 */   313,  313,  310,  311,  312,  313,  285,  286,  313,  313,
 /* 10500 */   289,  290,  313,  313,  285,  286,  313,  313,  289,  290,
 /* 10510 */   299,  313,  301,  313,  313,  313,  313,  313,  299,  313,
 /* 10520 */   301,  310,  311,  312,  185,  313,  187,  188,  189,  310,
 /* 10530 */   311,  312,  313,  194,  313,  313,  313,  313,  313,  313,
 /* 10540 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /* 10550 */   313,  313,  313,  313,  313,  313,  313,  185,  313,  187,
 /* 10560 */   188,  189,  313,  313,  313,  313,  194,  313,  313,  313,
 /* 10570 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /* 10580 */   313,  313,  313,  313,  313,  313,  185,  313,  187,  188,
 /* 10590 */   189,  313,  313,  313,  313,  194,  313,  258,  313,  260,
 /* 10600 */   313,  313,  313,  264,  313,  313,  313,  313,  313,  313,
 /* 10610 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /* 10620 */   313,  313,  283,  284,  313,  313,  313,  313,  289,  290,
 /* 10630 */   258,  313,  260,  313,  313,  313,  264,  313,  299,  313,
 /* 10640 */   301,  313,  313,  313,  313,  313,  313,  313,  313,  310,
 /* 10650 */   311,  312,  313,  313,  313,  283,  284,  313,  313,  258,
 /* 10660 */   313,  289,  290,  313,  313,  313,  313,  313,  267,  313,
 /* 10670 */   313,  299,  271,  301,  313,  313,  313,  313,  313,  313,
 /* 10680 */   313,  313,  310,  311,  312,  313,  285,  286,  313,  313,
 /* 10690 */   289,  290,  313,  313,  185,  313,  187,  188,  189,  313,
 /* 10700 */   299,  313,  301,  194,  313,  313,  313,  313,  313,  313,
 /* 10710 */   313,  310,  311,  312,  313,  313,  313,  313,  313,  313,
 /* 10720 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /* 10730 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /* 10740 */   313,  313,  313,  185,  313,  187,  188,  189,  313,  313,
 /* 10750 */   313,  313,  194,  313,  313,  313,  313,  313,  313,  313,
 /* 10760 */   313,  313,  313,  313,  313,  313,  313,  258,  313,  313,
 /* 10770 */   313,  313,  313,  313,  313,  313,  267,  313,  313,  313,
 /* 10780 */   271,  313,  313,  313,  313,  313,  313,  313,  313,  231,
 /* 10790 */   313,  313,  313,  313,  285,  286,  313,  313,  289,  290,
 /* 10800 */   313,  313,  313,  313,  313,  313,  313,  313,  299,  313,
 /* 10810 */   301,  313,  313,  313,  313,  313,  258,  313,  260,  310,
 /* 10820 */   311,  312,  313,  313,  313,  313,  313,  313,  313,  313,
 /* 10830 */   313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
 /* 10840 */   313,  283,  284,  313,  313,  313,  313,  289,  290,  313,
 /* 10850 */   313,  313,  313,  313,  313,  313,  313,  299,  313,  301,
 /* 10860 */   313,  313,  313,  313,  313,  313,  313,  313,  310,  311,
 /* 10870 */   312,
);
  const YY_SHIFT_USE_DFLT = -32;
  const YY_SHIFT_MAX = 602;
static $yy_shift_ofst = array(
 /*     0 */    -1, 3387,   -3,  156,  315,  474,  633,  792,  951, 1110,
 /*    10 */  1269, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428,
 /*    20 */  1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428,
 /*    30 */  1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428,
 /*    40 */  1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428,
 /*    50 */  1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428,
 /*    60 */  1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428,
 /*    70 */  1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428,
 /*    80 */  1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428,
 /*    90 */  1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428,
 /*   100 */  1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 1428, 3574,
 /*   110 */  3598, 1428, 1428, 1428, 1428, 1587, 1746, 1905, 2064, 2064,
 /*   120 */  2064, 2223, 1124, 1271, 1271, 2382, 2382, 2382, 2382, 3632,
 /*   130 */  3793, 3823, 3853, 4014, 4044, 4074, 4235, 8218, 8218, 8218,
 /*   140 */  8379, 8379, 8379, 8379, 8379, 8379, 8379, 8379, 8218, 8218,
 /*   150 */  8218, 8379, 8379, 8379, 4265, 4426, 8218, 8379, 8379, 8218,
 /*   160 */  8218, 8379, 2384,  477, 2541, 2541, 2682, 2823, 2964,  181,
 /*   170 */  1771, 1771, 2054,  202, 3105, 3246,  340,  499,  658, 2054,
 /*   180 */  2054,  202,  202, 2684, 2684, 2684, 2684, 2684,    0, 1281,
 /*   190 */   355,  355,  355,  355,  355,  355,  355,  355,  355,  355,
 /*   200 */   355,  355,  355,  355,  355,  355, 1281, 1281, 1907, 1907,
 /*   210 */  1907, 1281, 1281, 1907, 1907, 2136,  -14, 3460, 3450, 2388,
 /*   220 */  1024, 1024, 1024,  766,  766,  307,  135,  135,  307,  307,
 /*   230 */   307, 3333, 2241,  662,  822,  975, 1285, 1285, 1748, 1748,
 /*   240 */  1748, 1748, 1748, 1748, 1748, 1748, 1748,  307,  307,  307,
 /*   250 */   307,  -15,  490,  141,  141,  141,  141, 3533,  483,  965,
 /*   260 */  1598,  505, 1450,  140,  140, 1630,  701,  701, 1449,  701,
 /*   270 */   701,  701,  701,  701,  724,  686,  191,  783,  944,  962,
 /*   280 */  1131, 1139,   10,   10,  -31,  -28,   54,   54,  607,  946,
 /*   290 */   175,   23,  450,  313,  313,  724,  768,  768,  724,  450,
 /*   300 */   724,  724,  724,  289,  724,  313,  313,  313,  768,  768,
 /*   310 */  1283,  950, 1272, 1294, 1421, 1575, 1606, 1620, 1254, 1254,
 /*   320 */  1254, 1254, 1410, 1437, 1424, 1420, 1427, 1424, 1495, 1254,
 /*   330 */  1495, 1495, 1583, 1569, 1621, 1588, 1603, 1671, 1583, 1495,
 /*   340 */  1495, 1495, 1495, 1495, 1734, 1495, 1424,   10,   10, 1747,
 /*   350 */  1747, 1747, 1801,  -31,  -31, 1801, 1810, 1495, 1495, 1495,
 /*   360 */  1495, 1810, 1495, 1495, 1810, 1495, 1495, 1495, 1495, 1495,
 /*   370 */  1495, 1254, 1254, 1254, 1254,  966, 1189, 1429, 1277, 1593,
 /*   380 */  1593, 1136, 1401, 1718, 1740, 1753, 1480, 1082, 1288, 1492,
 /*   390 */  1496, 1600, 1268, 1593, 1593, 1593, 1877, 1926, 1927, 1937,
 /*   400 */  1934, 1935, 1933, 1954, 1956, 1897, 1898, 1963, 1971, 1973,
 /*   410 */  1976, 1988, 2061, 1978, 2079, 2084, 2083, 2087, 2088, 2090,
 /*   420 */  2041, 2094, 2093, 2102, 2098, 2103, 2107, 2110, 2109, 2112,
 /*   430 */  2117, 2120, 2119, 2122, 2125, 2129, 2128, 2132, 2037, 2131,
 /*   440 */  2134, 2148, 2135, 2216, 2166, 2219, 2222, 2173, 2228, 2225,
 /*   450 */  2180, 2232, 2235, 2236, 2237, 2240, 2239, 2242, 2249, 2248,
 /*   460 */  2251, 2250, 2256, 2255, 2258, 2273, 2278, 2279, 2187, 2195,
 /*   470 */  2243, 2283, 2285, 2289, 2290, 2294, 2355, 2375, 2376, 2381,
 /*   480 */  2383, 2380, 2387, 2386, 2336, 2343, 2394, 2402, 2353, 2408,
 /*   490 */  2419, 2361, 2418, 2422, 2374, 2424, 2429, 2428, 2431, 2432,
 /*   500 */  2433, 2435, 2438, 2437, 2440, 2439, 2452, 2464, 2451, 2516,
 /*   510 */  2466, 2533, 2537, 2489, 2491, 2542, 2423, 2543, 2427, 2553,
 /*   520 */  2557, 2558, 2561, 2560, 2563, 2562, 2571, 2570, 2578, 2577,
 /*   530 */  2581, 2582, 2592, 2410, 2490, 2591, 2461, 2535, 2599, 2604,
 /*   540 */  2605, 2606, 2607, 2608, 2609, 2610, 2612, 2673, 2676, 2678,
 /*   550 */  2679, 2680, 2681, 2690, 2694, 2667, 2638, 2669, 2633, 2642,
 /*   560 */  2643, 2697, 2650, 2667, 2654, 2715, 2716, 2714, 2677, 2683,
 /*   570 */  2724, 2725, 2727, 2659, 2731, 2732, 2733, 2734, 2735, 2744,
 /*   580 */  2748, 2742, 2745, 2743, 2729, 2756, 2760, 2762, 2761, 2828,
 /*   590 */  2795, 2796, 2793, 2797, 2799, 2801, 2818, 2819, 2844, 2820,
 /*   600 */  2845, 2847, 2834,
);
  const YY_REDUCE_USE_DFLT = -279;
  const YY_REDUCE_MAX = 374;
static $yy_reduce_ofst = array(
 /*     0 */  1596, 3330, 2412, 2545, 2686, 2827, 2849, 2978, 4163, 4322,
 /*    10 */  4348, 4413, 4483, 4507, 4543, 4574, 4672, 4705, 4728, 4759,
 /*    20 */  4801, 4857, 4890, 4944, 4986, 5020, 5042, 5075, 5171, 5205,
 /*    30 */  5227, 5249, 5378, 5400, 5422, 5444, 5467, 5607, 5629, 5652,
 /*    40 */  5674, 5696, 5837, 5859, 5881, 5903, 5925, 6054, 6076, 6098,
 /*    50 */  6120, 6142, 6271, 6293, 6315, 6337, 6359, 6488, 6510, 6532,
 /*    60 */  6554, 6576, 6705, 6727, 6749, 6771, 6793, 6922, 6944, 6966,
 /*    70 */  6988, 7010, 7139, 7161, 7183, 7205, 7227, 7356, 7378, 7400,
 /*    80 */  7422, 7444, 7573, 7595, 7617, 7639, 7661, 7790, 7812, 7834,
 /*    90 */  7856, 7878, 8007, 8029, 8051, 8275, 8299, 8319, 8358, -129,
 /*   100 */  3948, 4139, 8092, 8450, 8486, 2995, 3123, 3730, 8505, 3221,
 /*   110 */  8541, 3506, 8588, 8660, 8674,  659,  818, 1772, 8691, 8727,
 /*   120 */  8746, 3368, 1264, 1432, 2063, 1477, 1477, 1477, 1477, 8825,
 /*   130 */  8882, 8890, 8966, 9027, 9072, 9155, 9202, 9261, 9317, 9350,
 /*   140 */  9392, 9507, 9540, 9574, 9655, 9693, 9735, 9841, 9874, 9921,
 /*   150 */  9993, 9120, 10027, 10133, 10182, 10211, 10219, 10339, 10372, 10401,
 /*   160 */  10509, 10558,  169,   -9, 1143, 1782, 2253, 1313, 4172, 3520,
 /*   170 */  9333, 10047, -168,  494, 2272, 2955, 3577, 3577, 3577,  150,
 /*   180 */   150,  793,  954, 3877, 8246, 8287, 3314, 5177, 1126, 3197,
 /*   190 */  1263, 1430, 1920, 1930, 2060, 2086, 2220, 2230, 2389, 2411,
 /*   200 */  2685, 2689, 2826, 3293, 3297, 3453, 3306, 3466, 1790, 2108,
 /*   210 */  3582, 2835, 3523,  357,  675,  167,  332, 2550,   39,  492,
 /*   220 */   673,  993, 1101,  434,  593,  516,  -10,  350,  648,  655,
 /*   230 */   676, -278,  520,  808,  943, 1602,  834, 1293, 1760, 2238,
 /*   240 */  2670, 2805, 2807, 2811, 3099, 3101, 3202,  176,  656,  815,
 /*   250 */   995,  -84,    9,  171,  279,  438,  479,  -81, -157,   81,
 /*   260 */   333,  351,  358,  240,  489,  626,  981,  987, -169,  990,
 /*   270 */  1103, 1132, 1260, 1297,  770,   42,  800,  807,  914,  918,
 /*   280 */   928, 1052, 1015, 1080, 1053, -267,   48,   62,  196,  207,
 /*   290 */   257,  287,  277,  244,  253,  453,  410,  419,  503,  277,
 /*   300 */   525,  617,  667,  581,  685,  574,  637,  695,  762,  776,
 /*   310 */   992,  913, 1047, 1047, 1047, 1047, 1047, 1047, 1157, 1170,
 /*   320 */  1179, 1262, 1253, 1279, 1234, 1204, 1212, 1317, 1396, 1444,
 /*   330 */  1399, 1407, 1360, 1367, 1375, 1380, 1456, 1478, 1485, 1563,
 /*   340 */  1565, 1584, 1595, 1597, 1540, 1622, 1539, 1625, 1625, 1605,
 /*   350 */  1607, 1608, 1669, 1592, 1592, 1670, 1689, 1635, 1722, 1738,
 /*   360 */  1741, 1712, 1742, 1743, 1717, 1749, 1750, 1751, 1752, 1754,
 /*   370 */  1755, 1773, 1778, 1781, 1783,
);
static $yy_default = array(
 /*     0 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*    10 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*    20 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*    30 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*    40 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*    50 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*    60 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*    70 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*    80 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*    90 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   100 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   110 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   120 */  1590, 1080, 1590, 1590, 1590, 1074, 1075, 1076, 1079, 1280,
 /*   130 */  1284, 1590, 1590, 1590, 1258, 1590, 1262, 1279, 1287, 1590,
 /*   140 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   150 */  1283, 1267, 1257, 1261, 1590, 1590, 1285, 1590, 1590, 1590,
 /*   160 */  1590, 1265, 1120, 1590, 1590, 1172, 1590, 1154, 1590, 1590,
 /*   170 */  1590, 1590, 1275, 1128, 1165, 1590, 1590, 1590, 1590, 1274,
 /*   180 */  1276, 1119, 1127, 1590, 1590, 1360, 1367, 1370, 1073, 1590,
 /*   190 */  1065, 1067, 1107, 1108, 1105, 1103, 1106, 1104, 1111, 1112,
 /*   200 */  1116, 1118, 1124, 1126, 1132, 1134, 1590, 1590, 1590, 1590,
 /*   210 */  1345, 1590, 1590, 1349, 1351, 1590, 1150, 1590, 1590, 1590,
 /*   220 */  1590, 1590, 1590, 1590, 1590, 1590, 1144, 1151, 1590, 1590,
 /*   230 */  1590, 1451, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   240 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   250 */  1590, 1590, 1590, 1143, 1149, 1152, 1145, 1450, 1590, 1590,
 /*   260 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   270 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   280 */  1590, 1590, 1056, 1057, 1253, 1441, 1590, 1590, 1590, 1384,
 /*   290 */  1590, 1590, 1476, 1454, 1469, 1590, 1590, 1590, 1590, 1590,
 /*   300 */  1590, 1590, 1590, 1590, 1590, 1455, 1460, 1461, 1590, 1590,
 /*   310 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1046, 1047,
 /*   320 */  1048, 1049, 1183, 1184, 1590, 1433, 1437, 1590, 1590, 1072,
 /*   330 */  1590, 1590, 1363, 1355, 1347, 1376, 1380, 1372, 1364, 1590,
 /*   340 */  1590, 1590, 1590, 1590, 1329, 1590, 1590, 1054, 1055, 1590,
 /*   350 */  1590, 1590, 1590, 1252, 1254, 1590, 1590, 1590, 1590, 1590,
 /*   360 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   370 */  1590, 1050, 1051, 1052, 1053, 1590, 1565, 1590, 1590, 1452,
 /*   380 */  1468, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   390 */  1590, 1590, 1590, 1453, 1458, 1459, 1590, 1590, 1590, 1590,
 /*   400 */  1590, 1590, 1590, 1590, 1590, 1432, 1436, 1590, 1590, 1590,
 /*   410 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   420 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   430 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   440 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   450 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   460 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   470 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   480 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   490 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   500 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   510 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   520 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   530 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   540 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   550 */  1590, 1590, 1590, 1288, 1286, 1361, 1354, 1346, 1590, 1375,
 /*   560 */  1379, 1590, 1371, 1362, 1590, 1590, 1590, 1590, 1328, 1590,
 /*   570 */  1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1268,
 /*   580 */  1266, 1590, 1590, 1590, 1190, 1590, 1590, 1063, 1590, 1061,
 /*   590 */  1205, 1206, 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590,
 /*   600 */  1590, 1590, 1191, 1036, 1037, 1038, 1187, 1305, 1306, 1307,
 /*   610 */  1309, 1322, 1323, 1324, 1325, 1326, 1563, 1564, 1584, 1585,
 /*   620 */  1586, 1587, 1566, 1567, 1568, 1569, 1570, 1571, 1572, 1573,
 /*   630 */  1574, 1575, 1576, 1577, 1578, 1579, 1580, 1581, 1582, 1583,
 /*   640 */  1308, 1310, 1311, 1318, 1319, 1320, 1321, 1316, 1424, 1425,
 /*   650 */  1317, 1312, 1314, 1313, 1315, 1039, 1040, 1041, 1064, 1139,
 /*   660 */  1181, 1186, 1182, 1185, 1142, 1173, 1175, 1335, 1336, 1339,
 /*   670 */  1434, 1438, 1440, 1442, 1464, 1470, 1465, 1471, 1475, 1477,
 /*   680 */  1478, 1479, 1480, 1481, 1482, 1483, 1484, 1485, 1472, 1473,
 /*   690 */  1487, 1488, 1489, 1490, 1491, 1492, 1494, 1495, 1496, 1497,
 /*   700 */  1498, 1341, 1340, 1500, 1501, 1502, 1503, 1504, 1505, 1506,
 /*   710 */  1507, 1508, 1509, 1510, 1511, 1512, 1513, 1514, 1515, 1516,
 /*   720 */  1517, 1518, 1519, 1520, 1521, 1522, 1523, 1524, 1525, 1526,
 /*   730 */  1342, 1527, 1528, 1529, 1530, 1531, 1532, 1533, 1534, 1535,
 /*   740 */  1536, 1537, 1539, 1541, 1070, 1071, 1140, 1148, 1147, 1153,
 /*   750 */  1155, 1158, 1544, 1545, 1546, 1549, 1550, 1551, 1552, 1553,
 /*   760 */  1559, 1560, 1561, 1562, 1558, 1557, 1556, 1555, 1554, 1547,
 /*   770 */  1548, 1156, 1157, 1159, 1338, 1160, 1163, 1161, 1162, 1164,
 /*   780 */  1166, 1167, 1168, 1169, 1170, 1171, 1137, 1138, 1081, 1082,
 /*   790 */  1083, 1084, 1085, 1086, 1087, 1088, 1077, 1089, 1090, 1091,
 /*   800 */  1092, 1093, 1094, 1095, 1096, 1078, 1271, 1272, 1273, 1277,
 /*   810 */  1289, 1358, 1356, 1404, 1405, 1348, 1410, 1411, 1416, 1417,
 /*   820 */  1420, 1421, 1426, 1427, 1428, 1429, 1430, 1431, 1588, 1589,
 /*   830 */  1412, 1352, 1353, 1422, 1423, 1350, 1406, 1357, 1365, 1366,
 /*   840 */  1377, 1381, 1383, 1387, 1388, 1389, 1385, 1386, 1390, 1391,
 /*   850 */  1394, 1398, 1400, 1401, 1402, 1403, 1395, 1399, 1396, 1397,
 /*   860 */  1392, 1393, 1382, 1378, 1368, 1369, 1373, 1407, 1408, 1413,
 /*   870 */  1414, 1418, 1419, 1415, 1409, 1374, 1359, 1290, 1278, 1291,
 /*   880 */  1292, 1293, 1294, 1295, 1296, 1297, 1298, 1299, 1300, 1301,
 /*   890 */  1302, 1303, 1304, 1327, 1330, 1331, 1332, 1333, 1334, 1281,
 /*   900 */  1282, 1543, 1542, 1540, 1538, 1499, 1493, 1486, 1466, 1467,
 /*   910 */  1474, 1456, 1457, 1462, 1463, 1443, 1444, 1445, 1446, 1447,
 /*   920 */  1448, 1449, 1439, 1435, 1337, 1176, 1177, 1178, 1179, 1180,
 /*   930 */  1174, 1141, 1146, 1068, 1135, 1136, 1066, 1069, 1099, 1100,
 /*   940 */  1269, 1343, 1344, 1270, 1097, 1101, 1098, 1102, 1109, 1110,
 /*   950 */  1113, 1115, 1114, 1117, 1129, 1121, 1123, 1122, 1125, 1130,
 /*   960 */  1131, 1133, 1058, 1062, 1059, 1060, 1192, 1193, 1194, 1195,
 /*   970 */  1196, 1197, 1198, 1199, 1200, 1201, 1202, 1203, 1243, 1204,
 /*   980 */  1207, 1244, 1245, 1246, 1247, 1208, 1209, 1210, 1211, 1212,
 /*   990 */  1213, 1240, 1241, 1242, 1214, 1215, 1216, 1217, 1218, 1219,
 /*  1000 */  1250, 1251, 1255, 1256, 1263, 1264, 1259, 1260, 1220, 1221,
 /*  1010 */  1248, 1249, 1222, 1234, 1238, 1239, 1225, 1235, 1223, 1226,
 /*  1020 */  1237, 1224, 1227, 1236, 1228, 1231, 1229, 1232, 1230, 1233,
 /*  1030 */  1188, 1189, 1042, 1043, 1044, 1045,
);

/* The next table maps tokens into fallback tokens.  If a construct
** like the following:
** 
**      %fallback ID X Y Z.
**
** appears in the grammer, then ID becomes a fallback token for X, Y,
** and Z.  Whenever one of the tokens X, Y, or Z is input to the parser
** but it does not parse, the type of the token is changed to ID and
** the parse is retried before an error is thrown.
*/
static $yyFallback = array(
);

/* 
** Turn parser tracing on by giving a stream to which to write the trace
** and a prompt to preface each trace message.  Tracing is turned off
** by making either argument NULL 
**
** Inputs:
** <ul>
** <li> A FILE* to which trace output should be written.
**      If NULL, then tracing is turned off.
** <li> A prefix string written at the beginning of every
**      line of trace output.  If NULL, then tracing is
**      turned off.
** </ul>
**
** Outputs:
** None.
*/
function SparqlPHPTrace(/* stream */ $TraceFILE, /* string */ $zTracePrompt){
  $this->yyTraceFILE = $TraceFILE;
  $this->yyTracePrompt = $zTracePrompt;
  if( $this->yyTraceFILE===null ) $this->yyTracePrompt = null;
  else if( $this->yyTracePrompt===null ) $this->yyTraceFILE = null;
}

/* For tracing shifts, the names of all terminals and nonterminals
** are required.  The following table supplies these names */
static $yyTokenName = array( 
  '$',             'PRAGMA',        'BASE',          'IRIREF',      
  'DOT',           'PREFIX',        'PNAME_NS',      'SELECT',      
  'DISTINCT',      'REDUCED',       'STAR',          'LPARENTHESE', 
  'AS',            'RPARENTHESE',   'CONSTRUCT',     'LBRACE',      
  'RBRACE',        'WHERE',         'DESCRIBE',      'ASK',         
  'FROM',          'NAMED',         'GROUP',         'BY',          
  'HAVING',        'ORDER',         'ASC',           'DESC',        
  'LIMIT',         'INTEGER',       'OFFSET',        'VALUES',      
  'SEMICOLON',     'LOAD',          'SILENT',        'INTO',        
  'CLEAR',         'DROP',          'CREATE',        'ADD',         
  'TO',            'MOVE',          'COPY',          'INSERTDATA',  
  'DELETEDATA',    'DELETEWHERE',   'WITH',          'DELETE',      
  'INSERT',        'USING',         'GRAPH',         'DEFAULT',     
  'ALL',           'OPTIONAL',      'SERVICE',       'BIND',        
  'NIL',           'UNDEF',         'SMINUS',        'UNION',       
  'GroupGraphPattern',  'FILTER',        'COMMA',         'A',           
  'VBAR',          'SLASH',         'HAT',           'PLUS',        
  'QUESTION',      'EXCLAMATION',   'LBRACKET',      'RBRACKET',    
  'VAR1',          'VAR2',          'OR',            'AND',         
  'EQUAL',         'NEQUAL',        'SMALLERTHEN',   'GREATERTHEN', 
  'SMALLERTHENQ',  'GREATERTHENQ',  'IN',            'NOT',         
  'MINUS',         'STR',           'LANG',          'LANGMATCHES', 
  'DATATYPE',      'BOUND',         'URI',           'BNODE',       
  'RAND',          'ABS',           'CEIL',          'FLOOR',       
  'ROUND',         'CONCAT',        'STRLEN',        'UCASE',       
  'LCASE',         'ENCODE_FOR_URI',  'CONTAINS',      'STRSTARTS',   
  'STRENDS',       'STBEFORE',      'STRAFTER',      'YEAR',        
  'MONTH',         'DAY',           'HOURS',         'MINUTES',     
  'SECONDS',       'TIMEZONE',      'TZ',            'NOW',         
  'UUID',          'STRUUID',       'MD5',           'SHA1',        
  'SHA256',        'SHA384',        'SHA512',        'COALESCE',    
  'IF',            'STRLANG',       'STRDT',         'SAMETERM',    
  'ISIRI',         'ISURI',         'ISBLANK',       'ISLITERAL',   
  'ISNUMERIC',     'REGEX',         'SUBSTR',        'REPLACE',     
  'EXISTS',        'COUNT',         'SUM',           'MIN',         
  'MAX',           'AVG',           'SAMPLE',        'GROUP_CONCAT',
  'SEPARATOR',     'LANGTAG',       'DHAT',          'DECIMAL',     
  'DOUBLE',        'INTEGER_POSITIVE',  'DECIMAL_POSITIVE',  'DOUBLE_POSITIVE',
  'INTEGER_NEGATIVE',  'DECIMAL_NEGATIVE',  'DOUBLE_NEGATIVE',  'TRUE',        
  'FALSE',         'STRING_LITERAL1',  'STRING_LITERAL2',  'STRING_LITERAL_LONG1',
  'STRING_LITERAL_LONG2',  'PNAME_LN',      'BLANK_NODE_LABEL',  'ANON',        
  'error',         'start',         'query',         'update',      
  'prologue',      'selectQuery',   'valuesClause',  'constructQuery',
  'describeQuery',  'askQuery',      'prefixDeclX',   'baseDecl',    
  'prefixDecl',    'selectClause',  'datasetClauseX',  'whereclause', 
  'solutionModifier',  'datasetClause',  'subSelect',     'selectClauseX',
  'expression',    'var',           'builtInCall',   'rdfLiteral',  
  'numericLiteral',  'booleanLiteral',  'functionCall',  'triplesTemplate',
  'varOrIriX',     'varOrIri',      'iri',           'groupGraphPattern',
  'groupClause',   'havingClause',  'orderClause',   'limitOffsetClauses',
  'groupConditionX',  'constraintX',   'orderConditionX',  'orderCondition',
  'limitClause',   'offsetClause',  'dataBlock',     'update1',     
  'load',          'clear',         'drop',          'add',         
  'move',          'copy',          'create',        'insertData',  
  'deleteData',    'deletewhere',   'modify',        'graphRef',    
  'graphRefAll',   'graphOrDefault',  'quadData',      'quadPattern', 
  'deleteClause',  'insertClause',  'usingClauseX',  'usingClause', 
  'quads',         'quadsX',        'quadsNotTriples',  'triplesSameSubject',
  'triplesTemplateX',  'groupGraphPatternSub',  'triplesBlock',  'groupGraphPatternSubX',
  'graphPatternNotTriples',  'triplesSameSubjectPath',  'triplesBlockX',  'groupOrUnionGraphPattern',
  'optionalGraphPattern',  'minusGraphPattern',  'graphGraphPattern',  'serviceGraphPattern',
  'filter',        'bind',          'inlineData',    'inlineDataOneVar',
  'inlineDataFull',  'dataBlockValueX',  'dataBlockValue',  'varX',        
  'inlineDataFullX',  'nilX',          'groupOrUnionGraphPatternX',  'argList',     
  'argListX',      'expressionList',  'varOrTerm',     'propertyListNotEmpty',
  'triplesNode',   'verb',          'objectList',    'propertyListNotEmptyX',
  'graphNode',     'objectListX',   'propertyListPathNotEmpty',  'triplesNodePath',
  'pathAlternative',  'objectListPath',  'propertyListPathNotEmptyX',  'graphNodePath',
  'objectListPathX',  'pathSequence',  'pathAlternativeX',  'pathEltOrInverse',
  'pathSequenceX',  'pathElt',       'pathPrimary',   'pathMod',     
  'pathNegatedPropertySet',  'pathOneInPropertySet',  'pathNegatedPropertySetX',  'collection',  
  'blankNodePropertyList',  'collectionPath',  'blankNodePropertyListPath',  'graphNodeX',  
  'graphNodePathX',  'graphTerm',     'blankNode',     'conditionalAndExpression',
  'conditionalOrExpressionX',  'relationalExpression',  'conditionalAndExpressionX',  'additiveExpression',
  'relationalExpressionX',  'multiplicativeExpression',  'additiveExpressionX',  'numericLiteralPositive',
  'additiveExpressionY',  'numericLiteralNegative',  'unaryExpression',  'primaryExpression',
  'aggregate',     'regexExpression',  'existsFunc',    'notExistsFunc',
  'subStringExpression',  'strReplaceExpression',  'string',        'numericLiteralUnsigned',
  'prefixedName',
);

/* For tracing reduce actions, the names of all rules are required.
*/
static $yyRuleName = array(
 /*   0 */ "start ::= query",
 /*   1 */ "start ::= update",
 /*   2 */ "query ::= prologue selectQuery valuesClause",
 /*   3 */ "query ::= prologue constructQuery valuesClause",
 /*   4 */ "query ::= prologue describeQuery valuesClause",
 /*   5 */ "query ::= prologue askQuery valuesClause",
 /*   6 */ "query ::= selectQuery valuesClause",
 /*   7 */ "query ::= constructQuery valuesClause",
 /*   8 */ "query ::= describeQuery valuesClause",
 /*   9 */ "query ::= askQuery valuesClause",
 /*  10 */ "query ::= prologue selectQuery",
 /*  11 */ "query ::= prologue constructQuery",
 /*  12 */ "query ::= prologue describeQuery",
 /*  13 */ "query ::= prologue askQuery",
 /*  14 */ "query ::= selectQuery",
 /*  15 */ "query ::= constructQuery",
 /*  16 */ "query ::= describeQuery",
 /*  17 */ "query ::= askQuery",
 /*  18 */ "prologue ::= prefixDeclX baseDecl prefixDeclX",
 /*  19 */ "prologue ::= baseDecl prefixDeclX",
 /*  20 */ "prologue ::= prefixDeclX baseDecl",
 /*  21 */ "prologue ::= baseDecl",
 /*  22 */ "prefixDeclX ::= prefixDeclX prefixDecl",
 /*  23 */ "prefixDeclX ::= prefixDecl",
 /*  24 */ "baseDecl ::= BASE IRIREF DOT",
 /*  25 */ "baseDecl ::= BASE IRIREF",
 /*  26 */ "prefixDecl ::= PREFIX PNAME_NS IRIREF DOT",
 /*  27 */ "prefixDecl ::= PREFIX PNAME_NS IRIREF",
 /*  28 */ "selectQuery ::= selectClause datasetClauseX whereclause solutionModifier",
 /*  29 */ "selectQuery ::= selectClause datasetClauseX whereclause",
 /*  30 */ "selectQuery ::= selectClause whereclause solutionModifier",
 /*  31 */ "selectQuery ::= selectClause whereclause",
 /*  32 */ "datasetClauseX ::= datasetClauseX datasetClause",
 /*  33 */ "datasetClauseX ::= datasetClause",
 /*  34 */ "subSelect ::= selectClause whereclause solutionModifier valuesClause",
 /*  35 */ "subSelect ::= selectClause whereclause valuesClause",
 /*  36 */ "subSelect ::= selectClause whereclause solutionModifier",
 /*  37 */ "subSelect ::= selectClause whereclause",
 /*  38 */ "selectClause ::= SELECT DISTINCT selectClauseX",
 /*  39 */ "selectClause ::= SELECT REDUCED selectClauseX",
 /*  40 */ "selectClause ::= SELECT STAR selectClauseX",
 /*  41 */ "selectClause ::= SELECT DISTINCT STAR",
 /*  42 */ "selectClause ::= SELECT REDUCED STAR",
 /*  43 */ "selectClause ::= SELECT selectClauseX",
 /*  44 */ "selectClause ::= SELECT STAR",
 /*  45 */ "selectClauseX ::= selectClauseX LPARENTHESE expression AS var RPARENTHESE",
 /*  46 */ "selectClauseX ::= selectClauseX LPARENTHESE expression RPARENTHESE",
 /*  47 */ "selectClauseX ::= selectClauseX builtInCall",
 /*  48 */ "selectClauseX ::= selectClauseX rdfLiteral",
 /*  49 */ "selectClauseX ::= selectClauseX numericLiteral",
 /*  50 */ "selectClauseX ::= selectClauseX booleanLiteral",
 /*  51 */ "selectClauseX ::= selectClauseX var",
 /*  52 */ "selectClauseX ::= selectClauseX functionCall",
 /*  53 */ "selectClauseX ::= LPARENTHESE expression AS var RPARENTHESE",
 /*  54 */ "selectClauseX ::= LPARENTHESE expression RPARENTHESE",
 /*  55 */ "selectClauseX ::= builtInCall",
 /*  56 */ "selectClauseX ::= rdfLiteral",
 /*  57 */ "selectClauseX ::= numericLiteral",
 /*  58 */ "selectClauseX ::= booleanLiteral",
 /*  59 */ "selectClauseX ::= var",
 /*  60 */ "selectClauseX ::= functionCall",
 /*  61 */ "constructQuery ::= CONSTRUCT LBRACE triplesTemplate RBRACE datasetClauseX whereclause solutionModifier",
 /*  62 */ "constructQuery ::= CONSTRUCT LBRACE RBRACE datasetClauseX whereclause solutionModifier",
 /*  63 */ "constructQuery ::= CONSTRUCT datasetClauseX WHERE LBRACE triplesTemplate RBRACE solutionModifier",
 /*  64 */ "constructQuery ::= CONSTRUCT datasetClauseX WHERE LBRACE RBRACE solutionModifier",
 /*  65 */ "constructQuery ::= CONSTRUCT LBRACE triplesTemplate RBRACE whereclause solutionModifier",
 /*  66 */ "constructQuery ::= CONSTRUCT LBRACE RBRACE whereclause solutionModifier",
 /*  67 */ "constructQuery ::= CONSTRUCT LBRACE triplesTemplate RBRACE whereclause",
 /*  68 */ "constructQuery ::= CONSTRUCT LBRACE RBRACE whereclause",
 /*  69 */ "constructQuery ::= CONSTRUCT LBRACE triplesTemplate RBRACE datasetClauseX whereclause",
 /*  70 */ "constructQuery ::= CONSTRUCT LBRACE RBRACE datasetClauseX whereclause",
 /*  71 */ "constructQuery ::= CONSTRUCT datasetClauseX WHERE LBRACE triplesTemplate RBRACE",
 /*  72 */ "constructQuery ::= CONSTRUCT datasetClauseX WHERE LBRACE RBRACE",
 /*  73 */ "constructQuery ::= CONSTRUCT WHERE LBRACE triplesTemplate RBRACE solutionModifier",
 /*  74 */ "constructQuery ::= CONSTRUCT WHERE LBRACE RBRACE solutionModifier",
 /*  75 */ "constructQuery ::= CONSTRUCT WHERE LBRACE triplesTemplate RBRACE",
 /*  76 */ "constructQuery ::= CONSTRUCT WHERE LBRACE RBRACE",
 /*  77 */ "describeQuery ::= DESCRIBE varOrIriX datasetClauseX whereclause solutionModifier",
 /*  78 */ "describeQuery ::= DESCRIBE varOrIriX whereclause solutionModifier",
 /*  79 */ "describeQuery ::= DESCRIBE varOrIriX datasetClauseX solutionModifier",
 /*  80 */ "describeQuery ::= DESCRIBE varOrIriX datasetClauseX whereclause",
 /*  81 */ "describeQuery ::= DESCRIBE varOrIriX solutionModifier",
 /*  82 */ "describeQuery ::= DESCRIBE varOrIriX whereclause",
 /*  83 */ "describeQuery ::= DESCRIBE varOrIriX datasetClauseX",
 /*  84 */ "describeQuery ::= DESCRIBE varOrIriX",
 /*  85 */ "describeQuery ::= DESCRIBE STAR datasetClauseX whereclause solutionModifier",
 /*  86 */ "describeQuery ::= DESCRIBE STAR whereclause solutionModifier",
 /*  87 */ "describeQuery ::= DESCRIBE STAR datasetClauseX solutionModifier",
 /*  88 */ "describeQuery ::= DESCRIBE STAR datasetClauseX whereclause",
 /*  89 */ "describeQuery ::= DESCRIBE STAR solutionModifier",
 /*  90 */ "describeQuery ::= DESCRIBE STAR whereclause",
 /*  91 */ "describeQuery ::= DESCRIBE STAR datasetClauseX",
 /*  92 */ "describeQuery ::= DESCRIBE STAR",
 /*  93 */ "varOrIriX ::= varOrIriX varOrIri",
 /*  94 */ "varOrIriX ::= varOrIri",
 /*  95 */ "askQuery ::= ASK datasetClauseX whereclause solutionModifier",
 /*  96 */ "askQuery ::= ASK datasetClauseX whereclause",
 /*  97 */ "askQuery ::= ASK whereclause solutionModifier",
 /*  98 */ "askQuery ::= ASK whereclause",
 /*  99 */ "datasetClause ::= FROM NAMED iri",
 /* 100 */ "datasetClause ::= FROM iri",
 /* 101 */ "whereclause ::= WHERE groupGraphPattern",
 /* 102 */ "whereclause ::= groupGraphPattern",
 /* 103 */ "solutionModifier ::= groupClause havingClause orderClause limitOffsetClauses",
 /* 104 */ "solutionModifier ::= havingClause orderClause limitOffsetClauses",
 /* 105 */ "solutionModifier ::= groupClause orderClause limitOffsetClauses",
 /* 106 */ "solutionModifier ::= groupClause havingClause limitOffsetClauses",
 /* 107 */ "solutionModifier ::= groupClause havingClause orderClause",
 /* 108 */ "solutionModifier ::= groupClause havingClause",
 /* 109 */ "solutionModifier ::= groupClause orderClause",
 /* 110 */ "solutionModifier ::= groupClause limitOffsetClauses",
 /* 111 */ "solutionModifier ::= orderClause limitOffsetClauses",
 /* 112 */ "solutionModifier ::= havingClause limitOffsetClauses",
 /* 113 */ "solutionModifier ::= havingClause orderClause",
 /* 114 */ "solutionModifier ::= groupClause",
 /* 115 */ "solutionModifier ::= havingClause",
 /* 116 */ "solutionModifier ::= orderClause",
 /* 117 */ "solutionModifier ::= limitOffsetClauses",
 /* 118 */ "groupClause ::= GROUP BY groupConditionX",
 /* 119 */ "groupConditionX ::= groupConditionX LPARENTHESE expression AS var RPARENTHESE",
 /* 120 */ "groupConditionX ::= groupConditionX builtInCall",
 /* 121 */ "groupConditionX ::= groupConditionX functionCall",
 /* 122 */ "groupConditionX ::= groupConditionX LPARENTHESE expression RPARENTHESE",
 /* 123 */ "groupConditionX ::= groupConditionX var",
 /* 124 */ "groupConditionX ::= LPARENTHESE expression AS var RPARENTHESE",
 /* 125 */ "groupConditionX ::= builtInCall",
 /* 126 */ "groupConditionX ::= functionCall",
 /* 127 */ "groupConditionX ::= LPARENTHESE expression RPARENTHESE",
 /* 128 */ "groupConditionX ::= var",
 /* 129 */ "havingClause ::= HAVING constraintX",
 /* 130 */ "constraintX ::= constraintX LPARENTHESE expression RPARENTHESE",
 /* 131 */ "constraintX ::= constraintX builtInCall",
 /* 132 */ "constraintX ::= constraintX functionCall",
 /* 133 */ "constraintX ::= LPARENTHESE expression RPARENTHESE",
 /* 134 */ "constraintX ::= builtInCall",
 /* 135 */ "constraintX ::= functionCall",
 /* 136 */ "orderClause ::= ORDER BY orderConditionX",
 /* 137 */ "orderConditionX ::= orderConditionX orderCondition",
 /* 138 */ "orderConditionX ::= orderCondition",
 /* 139 */ "orderCondition ::= ASC LPARENTHESE expression RPARENTHESE",
 /* 140 */ "orderCondition ::= DESC LPARENTHESE expression RPARENTHESE",
 /* 141 */ "orderCondition ::= LPARENTHESE expression RPARENTHESE",
 /* 142 */ "orderCondition ::= builtInCall",
 /* 143 */ "orderCondition ::= functionCall",
 /* 144 */ "orderCondition ::= var",
 /* 145 */ "limitOffsetClauses ::= limitClause offsetClause",
 /* 146 */ "limitOffsetClauses ::= offsetClause limitClause",
 /* 147 */ "limitOffsetClauses ::= limitClause",
 /* 148 */ "limitOffsetClauses ::= offsetClause",
 /* 149 */ "limitClause ::= LIMIT INTEGER",
 /* 150 */ "offsetClause ::= OFFSET INTEGER",
 /* 151 */ "valuesClause ::= VALUES dataBlock",
 /* 152 */ "update ::= prologue update1 SEMICOLON update",
 /* 153 */ "update ::= update1 SEMICOLON update",
 /* 154 */ "update ::= prologue update1",
 /* 155 */ "update ::= update1",
 /* 156 */ "update1 ::= load",
 /* 157 */ "update1 ::= clear",
 /* 158 */ "update1 ::= drop",
 /* 159 */ "update1 ::= add",
 /* 160 */ "update1 ::= move",
 /* 161 */ "update1 ::= copy",
 /* 162 */ "update1 ::= create",
 /* 163 */ "update1 ::= insertData",
 /* 164 */ "update1 ::= deleteData",
 /* 165 */ "update1 ::= deletewhere",
 /* 166 */ "update1 ::= modify",
 /* 167 */ "load ::= LOAD SILENT iri INTO graphRef",
 /* 168 */ "load ::= LOAD iri INTO graphRef",
 /* 169 */ "load ::= LOAD SILENT iri",
 /* 170 */ "load ::= LOAD iri",
 /* 171 */ "clear ::= CLEAR SILENT graphRefAll",
 /* 172 */ "clear ::= CLEAR graphRefAll",
 /* 173 */ "drop ::= DROP SILENT graphRefAll",
 /* 174 */ "drop ::= DROP graphRefAll",
 /* 175 */ "create ::= CREATE SILENT graphRef",
 /* 176 */ "create ::= CREATE graphRef",
 /* 177 */ "add ::= ADD SILENT graphOrDefault TO graphOrDefault",
 /* 178 */ "add ::= ADD graphOrDefault TO graphOrDefault",
 /* 179 */ "move ::= MOVE SILENT graphOrDefault TO graphOrDefault",
 /* 180 */ "move ::= MOVE graphOrDefault TO graphOrDefault",
 /* 181 */ "copy ::= COPY SILENT graphOrDefault TO graphOrDefault",
 /* 182 */ "copy ::= COPY graphOrDefault TO graphOrDefault",
 /* 183 */ "insertData ::= INSERTDATA quadData",
 /* 184 */ "deleteData ::= DELETEDATA quadData",
 /* 185 */ "deletewhere ::= DELETEWHERE quadPattern",
 /* 186 */ "modify ::= WITH iri deleteClause insertClause usingClauseX WHERE groupGraphPattern",
 /* 187 */ "modify ::= WITH iri deleteClause usingClauseX WHERE groupGraphPattern",
 /* 188 */ "modify ::= WITH iri insertClause usingClauseX WHERE groupGraphPattern",
 /* 189 */ "modify ::= WITH iri deleteClause insertClause WHERE groupGraphPattern",
 /* 190 */ "modify ::= WITH iri deleteClause WHERE groupGraphPattern",
 /* 191 */ "modify ::= WITH iri insertClause WHERE groupGraphPattern",
 /* 192 */ "modify ::= deleteClause insertClause usingClauseX WHERE groupGraphPattern",
 /* 193 */ "modify ::= deleteClause usingClauseX WHERE groupGraphPattern",
 /* 194 */ "modify ::= insertClause usingClauseX WHERE groupGraphPattern",
 /* 195 */ "modify ::= deleteClause insertClause WHERE groupGraphPattern",
 /* 196 */ "modify ::= deleteClause WHERE groupGraphPattern",
 /* 197 */ "modify ::= insertClause WHERE groupGraphPattern",
 /* 198 */ "usingClauseX ::= usingClauseX usingClause",
 /* 199 */ "usingClauseX ::= usingClause",
 /* 200 */ "deleteClause ::= DELETE quadPattern",
 /* 201 */ "insertClause ::= INSERT quadPattern",
 /* 202 */ "usingClause ::= USING NAMED iri",
 /* 203 */ "usingClause ::= USING iri",
 /* 204 */ "graphOrDefault ::= GRAPH iri",
 /* 205 */ "graphOrDefault ::= DEFAULT",
 /* 206 */ "graphOrDefault ::= iri",
 /* 207 */ "graphRef ::= GRAPH iri",
 /* 208 */ "graphRefAll ::= graphRef",
 /* 209 */ "graphRefAll ::= DEFAULT",
 /* 210 */ "graphRefAll ::= NAMED",
 /* 211 */ "graphRefAll ::= ALL",
 /* 212 */ "quadPattern ::= LBRACE quads RBRACE",
 /* 213 */ "quadPattern ::= LBRACE RBRACE",
 /* 214 */ "quadData ::= LBRACE quads RBRACE",
 /* 215 */ "quadData ::= LBRACE RBRACE",
 /* 216 */ "quads ::= triplesTemplate quadsX",
 /* 217 */ "quads ::= triplesTemplate",
 /* 218 */ "quads ::= quadsX",
 /* 219 */ "quadsX ::= quadsX quadsNotTriples DOT triplesTemplate",
 /* 220 */ "quadsX ::= quadsX quadsNotTriples triplesTemplate",
 /* 221 */ "quadsX ::= quadsX quadsNotTriples DOT",
 /* 222 */ "quadsX ::= quadsX quadsNotTriples",
 /* 223 */ "quadsX ::= quadsNotTriples DOT triplesTemplate",
 /* 224 */ "quadsX ::= quadsNotTriples triplesTemplate",
 /* 225 */ "quadsX ::= quadsNotTriples DOT",
 /* 226 */ "quadsX ::= quadsNotTriples",
 /* 227 */ "quadsNotTriples ::= GRAPH varOrIri LBRACE triplesTemplate RBRACE",
 /* 228 */ "quadsNotTriples ::= GRAPH varOrIri LBRACE RBRACE",
 /* 229 */ "triplesTemplate ::= triplesSameSubject DOT triplesTemplateX DOT",
 /* 230 */ "triplesTemplate ::= triplesSameSubject DOT triplesTemplateX",
 /* 231 */ "triplesTemplate ::= triplesSameSubject DOT",
 /* 232 */ "triplesTemplate ::= triplesSameSubject",
 /* 233 */ "triplesTemplateX ::= triplesTemplateX DOT triplesSameSubject",
 /* 234 */ "triplesTemplateX ::= triplesSameSubject",
 /* 235 */ "groupGraphPattern ::= LBRACE groupGraphPatternSub RBRACE",
 /* 236 */ "groupGraphPattern ::= LBRACE subSelect RBRACE",
 /* 237 */ "groupGraphPattern ::= LBRACE RBRACE",
 /* 238 */ "groupGraphPatternSub ::= triplesBlock groupGraphPatternSubX",
 /* 239 */ "groupGraphPatternSub ::= triplesBlock",
 /* 240 */ "groupGraphPatternSub ::= groupGraphPatternSubX",
 /* 241 */ "groupGraphPatternSubX ::= groupGraphPatternSubX graphPatternNotTriples DOT triplesBlock",
 /* 242 */ "groupGraphPatternSubX ::= groupGraphPatternSubX graphPatternNotTriples triplesBlock",
 /* 243 */ "groupGraphPatternSubX ::= groupGraphPatternSubX graphPatternNotTriples DOT",
 /* 244 */ "groupGraphPatternSubX ::= groupGraphPatternSubX graphPatternNotTriples",
 /* 245 */ "groupGraphPatternSubX ::= graphPatternNotTriples DOT triplesBlock",
 /* 246 */ "groupGraphPatternSubX ::= graphPatternNotTriples triplesBlock",
 /* 247 */ "groupGraphPatternSubX ::= graphPatternNotTriples DOT",
 /* 248 */ "groupGraphPatternSubX ::= graphPatternNotTriples",
 /* 249 */ "triplesBlock ::= triplesSameSubjectPath DOT triplesBlockX DOT",
 /* 250 */ "triplesBlock ::= triplesSameSubjectPath DOT triplesBlockX",
 /* 251 */ "triplesBlock ::= triplesSameSubjectPath DOT",
 /* 252 */ "triplesBlock ::= triplesSameSubjectPath",
 /* 253 */ "triplesBlockX ::= triplesBlockX DOT triplesSameSubjectPath",
 /* 254 */ "triplesBlockX ::= triplesSameSubjectPath",
 /* 255 */ "graphPatternNotTriples ::= groupOrUnionGraphPattern",
 /* 256 */ "graphPatternNotTriples ::= optionalGraphPattern",
 /* 257 */ "graphPatternNotTriples ::= minusGraphPattern",
 /* 258 */ "graphPatternNotTriples ::= graphGraphPattern",
 /* 259 */ "graphPatternNotTriples ::= serviceGraphPattern",
 /* 260 */ "graphPatternNotTriples ::= filter",
 /* 261 */ "graphPatternNotTriples ::= bind",
 /* 262 */ "graphPatternNotTriples ::= inlineData",
 /* 263 */ "optionalGraphPattern ::= OPTIONAL groupGraphPattern",
 /* 264 */ "graphGraphPattern ::= GRAPH varOrIri groupGraphPattern",
 /* 265 */ "serviceGraphPattern ::= SERVICE SILENT varOrIri groupGraphPattern",
 /* 266 */ "serviceGraphPattern ::= SERVICE varOrIri groupGraphPattern",
 /* 267 */ "bind ::= BIND LPARENTHESE expression AS var RPARENTHESE",
 /* 268 */ "inlineData ::= VALUES dataBlock",
 /* 269 */ "dataBlock ::= inlineDataOneVar",
 /* 270 */ "dataBlock ::= inlineDataFull",
 /* 271 */ "inlineDataOneVar ::= var LBRACE dataBlockValueX RBRACE",
 /* 272 */ "inlineDataOneVar ::= var LBRACE RBRACE",
 /* 273 */ "dataBlockValueX ::= dataBlockValueX dataBlockValue",
 /* 274 */ "dataBlockValueX ::= dataBlockValue",
 /* 275 */ "inlineDataFull ::= LPARENTHESE varX RPARENTHESE LBRACE inlineDataFullX RBRACE",
 /* 276 */ "inlineDataFull ::= NIL LBRACE nilX RBRACE",
 /* 277 */ "inlineDataFull ::= NIL LBRACE RBRACE",
 /* 278 */ "nilX ::= nilX NIL",
 /* 279 */ "nilX ::= NIL",
 /* 280 */ "varX ::= varX var",
 /* 281 */ "varX ::= var",
 /* 282 */ "inlineDataFullX ::= inlineDataFullX LPARENTHESE dataBlockValueX RPARENTHESE",
 /* 283 */ "inlineDataFullX ::= inlineDataFullX NIL",
 /* 284 */ "inlineDataFullX ::= LPARENTHESE dataBlockValueX RPARENTHESE",
 /* 285 */ "inlineDataFullX ::= NIL",
 /* 286 */ "dataBlockValue ::= iri",
 /* 287 */ "dataBlockValue ::= rdfLiteral",
 /* 288 */ "dataBlockValue ::= numericLiteral",
 /* 289 */ "dataBlockValue ::= booleanLiteral",
 /* 290 */ "dataBlockValue ::= UNDEF",
 /* 291 */ "minusGraphPattern ::= SMINUS groupGraphPattern",
 /* 292 */ "groupOrUnionGraphPattern ::= groupGraphPattern groupOrUnionGraphPatternX",
 /* 293 */ "groupOrUnionGraphPattern ::= groupGraphPattern",
 /* 294 */ "groupOrUnionGraphPatternX ::= groupOrUnionGraphPatternX UNION groupGraphPattern",
 /* 295 */ "groupOrUnionGraphPatternX ::= UNION GroupGraphPattern",
 /* 296 */ "filter ::= FILTER LPARENTHESE expression RPARENTHESE",
 /* 297 */ "filter ::= FILTER builtInCall",
 /* 298 */ "filter ::= FILTER functionCall",
 /* 299 */ "functionCall ::= iri argList",
 /* 300 */ "argList ::= LPARENTHESE DISTINCT expression argListX RPARENTHESE",
 /* 301 */ "argList ::= LPARENTHESE expression argListX RPARENTHESE",
 /* 302 */ "argList ::= NIL",
 /* 303 */ "argListX ::= argListX COMMA expression",
 /* 304 */ "argListX ::= COMMA expression",
 /* 305 */ "expressionList ::= LPARENTHESE expression argListX RPARENTHESE",
 /* 306 */ "expressionList ::= NIL LBRACE RBRACE",
 /* 307 */ "triplesSameSubject ::= varOrTerm propertyListNotEmpty",
 /* 308 */ "triplesSameSubject ::= triplesNode propertyListNotEmpty",
 /* 309 */ "triplesSameSubject ::= triplesNode",
 /* 310 */ "propertyListNotEmpty ::= verb objectList propertyListNotEmptyX",
 /* 311 */ "propertyListNotEmpty ::= verb objectList",
 /* 312 */ "propertyListNotEmptyX ::= propertyListNotEmptyX SEMICOLON verb objectList",
 /* 313 */ "propertyListNotEmptyX ::= propertyListNotEmptyX SEMICOLON",
 /* 314 */ "propertyListNotEmptyX ::= SEMICOLON verb objectList",
 /* 315 */ "propertyListNotEmptyX ::= SEMICOLON",
 /* 316 */ "verb ::= varOrIri",
 /* 317 */ "verb ::= A",
 /* 318 */ "objectList ::= graphNode objectListX",
 /* 319 */ "objectList ::= graphNode",
 /* 320 */ "objectListX ::= objectListX COMMA graphNode",
 /* 321 */ "objectListX ::= COMMA graphNode",
 /* 322 */ "triplesSameSubjectPath ::= varOrTerm propertyListPathNotEmpty",
 /* 323 */ "triplesSameSubjectPath ::= triplesNodePath propertyListPathNotEmpty",
 /* 324 */ "triplesSameSubjectPath ::= triplesNodePath",
 /* 325 */ "propertyListPathNotEmpty ::= pathAlternative objectListPath propertyListPathNotEmptyX",
 /* 326 */ "propertyListPathNotEmpty ::= var objectListPath propertyListPathNotEmptyX",
 /* 327 */ "propertyListPathNotEmpty ::= pathAlternative objectListPath",
 /* 328 */ "propertyListPathNotEmpty ::= var objectListPath",
 /* 329 */ "propertyListPathNotEmptyX ::= propertyListPathNotEmptyX SEMICOLON pathAlternative objectList",
 /* 330 */ "propertyListPathNotEmptyX ::= propertyListPathNotEmptyX SEMICOLON var objectList",
 /* 331 */ "propertyListPathNotEmptyX ::= propertyListPathNotEmptyX SEMICOLON",
 /* 332 */ "propertyListPathNotEmptyX ::= SEMICOLON pathAlternative objectList",
 /* 333 */ "propertyListPathNotEmptyX ::= SEMICOLON var objectList",
 /* 334 */ "propertyListPathNotEmptyX ::= SEMICOLON",
 /* 335 */ "objectListPath ::= graphNodePath objectListPathX",
 /* 336 */ "objectListPath ::= graphNodePath",
 /* 337 */ "objectListPathX ::= objectListPathX COMMA graphNodePath",
 /* 338 */ "objectListPathX ::= COMMA graphNodePath",
 /* 339 */ "pathAlternative ::= pathSequence pathAlternativeX",
 /* 340 */ "pathAlternative ::= pathSequence",
 /* 341 */ "pathAlternativeX ::= pathAlternativeX VBAR pathSequence",
 /* 342 */ "pathAlternativeX ::= VBAR pathSequence",
 /* 343 */ "pathSequence ::= pathEltOrInverse pathSequenceX",
 /* 344 */ "pathSequence ::= pathEltOrInverse",
 /* 345 */ "pathSequenceX ::= pathSequenceX SLASH pathEltOrInverse",
 /* 346 */ "pathSequenceX ::= SLASH pathEltOrInverse",
 /* 347 */ "pathElt ::= pathPrimary pathMod",
 /* 348 */ "pathElt ::= pathPrimary",
 /* 349 */ "pathEltOrInverse ::= HAT pathElt",
 /* 350 */ "pathEltOrInverse ::= pathElt",
 /* 351 */ "pathMod ::= STAR",
 /* 352 */ "pathMod ::= PLUS",
 /* 353 */ "pathMod ::= QUESTION",
 /* 354 */ "pathPrimary ::= LPARENTHESE pathAlternative RPARENTHESE",
 /* 355 */ "pathPrimary ::= EXCLAMATION pathNegatedPropertySet",
 /* 356 */ "pathPrimary ::= A",
 /* 357 */ "pathPrimary ::= iri",
 /* 358 */ "pathNegatedPropertySet ::= LPARENTHESE pathOneInPropertySet pathNegatedPropertySetX RPARENTHESE",
 /* 359 */ "pathNegatedPropertySet ::= LPARENTHESE pathOneInPropertySet RPARENTHESE",
 /* 360 */ "pathNegatedPropertySet ::= LPARENTHESE RPARENTHESE",
 /* 361 */ "pathNegatedPropertySet ::= pathOneInPropertySet",
 /* 362 */ "pathNegatedPropertySetX ::= pathNegatedPropertySetX VBAR pathOneInPropertySet",
 /* 363 */ "pathNegatedPropertySetX ::= VBAR pathOneInPropertySet",
 /* 364 */ "pathOneInPropertySet ::= HAT iri",
 /* 365 */ "pathOneInPropertySet ::= HAT A",
 /* 366 */ "pathOneInPropertySet ::= A",
 /* 367 */ "pathOneInPropertySet ::= iri",
 /* 368 */ "triplesNode ::= collection",
 /* 369 */ "triplesNode ::= blankNodePropertyList",
 /* 370 */ "blankNodePropertyList ::= LBRACKET propertyListNotEmpty RBRACKET",
 /* 371 */ "triplesNodePath ::= collectionPath",
 /* 372 */ "triplesNodePath ::= blankNodePropertyListPath",
 /* 373 */ "blankNodePropertyListPath ::= LBRACKET propertyListPathNotEmpty RBRACKET",
 /* 374 */ "collection ::= LPARENTHESE graphNodeX RPARENTHESE",
 /* 375 */ "graphNodeX ::= graphNodeX graphNode",
 /* 376 */ "graphNodeX ::= graphNode",
 /* 377 */ "collectionPath ::= LPARENTHESE graphNodePathX RPARENTHESE",
 /* 378 */ "graphNodePathX ::= graphNodePathX graphNodePath",
 /* 379 */ "graphNodePathX ::= graphNodePath",
 /* 380 */ "graphNode ::= varOrTerm",
 /* 381 */ "graphNode ::= triplesNode",
 /* 382 */ "graphNodePath ::= varOrTerm",
 /* 383 */ "graphNodePath ::= triplesNodePath",
 /* 384 */ "varOrTerm ::= var",
 /* 385 */ "varOrTerm ::= graphTerm",
 /* 386 */ "varOrIri ::= var",
 /* 387 */ "varOrIri ::= iri",
 /* 388 */ "var ::= VAR1",
 /* 389 */ "var ::= VAR2",
 /* 390 */ "graphTerm ::= iri",
 /* 391 */ "graphTerm ::= rdfLiteral",
 /* 392 */ "graphTerm ::= numericLiteral",
 /* 393 */ "graphTerm ::= booleanLiteral",
 /* 394 */ "graphTerm ::= blankNode",
 /* 395 */ "graphTerm ::= NIL",
 /* 396 */ "expression ::= conditionalAndExpression conditionalOrExpressionX",
 /* 397 */ "expression ::= conditionalAndExpression",
 /* 398 */ "conditionalOrExpressionX ::= conditionalOrExpressionX OR conditionalAndExpression",
 /* 399 */ "conditionalOrExpressionX ::= OR conditionalAndExpression",
 /* 400 */ "conditionalAndExpression ::= relationalExpression conditionalAndExpressionX",
 /* 401 */ "conditionalAndExpression ::= relationalExpression",
 /* 402 */ "conditionalAndExpressionX ::= conditionalAndExpressionX AND relationalExpression",
 /* 403 */ "conditionalAndExpressionX ::= AND relationalExpression",
 /* 404 */ "relationalExpression ::= additiveExpression relationalExpressionX",
 /* 405 */ "relationalExpression ::= additiveExpression",
 /* 406 */ "relationalExpressionX ::= EQUAL additiveExpression",
 /* 407 */ "relationalExpressionX ::= NEQUAL additiveExpression",
 /* 408 */ "relationalExpressionX ::= SMALLERTHEN additiveExpression",
 /* 409 */ "relationalExpressionX ::= GREATERTHEN additiveExpression",
 /* 410 */ "relationalExpressionX ::= SMALLERTHENQ additiveExpression",
 /* 411 */ "relationalExpressionX ::= GREATERTHENQ additiveExpression",
 /* 412 */ "relationalExpressionX ::= IN expressionList",
 /* 413 */ "relationalExpressionX ::= NOT IN expressionList",
 /* 414 */ "additiveExpression ::= multiplicativeExpression additiveExpressionX",
 /* 415 */ "additiveExpression ::= multiplicativeExpression",
 /* 416 */ "additiveExpressionX ::= additiveExpressionX numericLiteralPositive additiveExpressionY",
 /* 417 */ "additiveExpressionX ::= additiveExpressionX numericLiteralNegative additiveExpressionY",
 /* 418 */ "additiveExpressionX ::= additiveExpressionX numericLiteralPositive",
 /* 419 */ "additiveExpressionX ::= additiveExpressionX numericLiteralNegative",
 /* 420 */ "additiveExpressionX ::= additiveExpressionX PLUS multiplicativeExpression",
 /* 421 */ "additiveExpressionX ::= additiveExpressionX MINUS multiplicativeExpression",
 /* 422 */ "additiveExpressionX ::= numericLiteralPositive additiveExpressionY",
 /* 423 */ "additiveExpressionX ::= numericLiteralNegative additiveExpressionY",
 /* 424 */ "additiveExpressionX ::= numericLiteralPositive",
 /* 425 */ "additiveExpressionX ::= numericLiteralNegative",
 /* 426 */ "additiveExpressionX ::= PLUS multiplicativeExpression",
 /* 427 */ "additiveExpressionX ::= MINUS multiplicativeExpression",
 /* 428 */ "additiveExpressionY ::= additiveExpressionY STAR unaryExpression",
 /* 429 */ "additiveExpressionY ::= additiveExpressionY SLASH unaryExpression",
 /* 430 */ "additiveExpressionY ::= STAR unaryExpression",
 /* 431 */ "additiveExpressionY ::= SLASH unaryExpression",
 /* 432 */ "multiplicativeExpression ::= unaryExpression additiveExpressionY",
 /* 433 */ "multiplicativeExpression ::= unaryExpression",
 /* 434 */ "unaryExpression ::= EXCLAMATION primaryExpression",
 /* 435 */ "unaryExpression ::= PLUS primaryExpression",
 /* 436 */ "unaryExpression ::= MINUS primaryExpression",
 /* 437 */ "unaryExpression ::= primaryExpression",
 /* 438 */ "primaryExpression ::= LPARENTHESE expression RPARENTHESE",
 /* 439 */ "primaryExpression ::= builtInCall",
 /* 440 */ "primaryExpression ::= iri",
 /* 441 */ "primaryExpression ::= functionCall",
 /* 442 */ "primaryExpression ::= rdfLiteral",
 /* 443 */ "primaryExpression ::= numericLiteral",
 /* 444 */ "primaryExpression ::= booleanLiteral",
 /* 445 */ "primaryExpression ::= var",
 /* 446 */ "builtInCall ::= aggregate",
 /* 447 */ "builtInCall ::= regexExpression",
 /* 448 */ "builtInCall ::= existsFunc",
 /* 449 */ "builtInCall ::= notExistsFunc",
 /* 450 */ "builtInCall ::= STR LPARENTHESE expression RPARENTHESE",
 /* 451 */ "builtInCall ::= LANG LPARENTHESE expression RPARENTHESE",
 /* 452 */ "builtInCall ::= LANGMATCHES LPARENTHESE expression COMMA expression RPARENTHESE",
 /* 453 */ "builtInCall ::= DATATYPE LPARENTHESE expression RPARENTHESE",
 /* 454 */ "builtInCall ::= BOUND LPARENTHESE var RPARENTHESE",
 /* 455 */ "builtInCall ::= URI LPARENTHESE expression RPARENTHESE",
 /* 456 */ "builtInCall ::= BNODE LPARENTHESE expression RPARENTHESE",
 /* 457 */ "builtInCall ::= BNODE NIL",
 /* 458 */ "builtInCall ::= RAND NIL",
 /* 459 */ "builtInCall ::= ABS LPARENTHESE expression RPARENTHESE",
 /* 460 */ "builtInCall ::= CEIL LPARENTHESE expression RPARENTHESE",
 /* 461 */ "builtInCall ::= FLOOR LPARENTHESE expression RPARENTHESE",
 /* 462 */ "builtInCall ::= ROUND LPARENTHESE expression RPARENTHESE",
 /* 463 */ "builtInCall ::= CONCAT expressionList",
 /* 464 */ "builtInCall ::= subStringExpression",
 /* 465 */ "builtInCall ::= STRLEN LPARENTHESE expression RPARENTHESE",
 /* 466 */ "builtInCall ::= strReplaceExpression",
 /* 467 */ "builtInCall ::= UCASE LPARENTHESE expression RPARENTHESE",
 /* 468 */ "builtInCall ::= LCASE LPARENTHESE expression RPARENTHESE",
 /* 469 */ "builtInCall ::= ENCODE_FOR_URI LPARENTHESE expression RPARENTHESE",
 /* 470 */ "builtInCall ::= CONTAINS LPARENTHESE expression COMMA expression RPARENTHESE",
 /* 471 */ "builtInCall ::= STRSTARTS LPARENTHESE expression COMMA expression RPARENTHESE",
 /* 472 */ "builtInCall ::= STRENDS LPARENTHESE expression COMMA expression RPARENTHESE",
 /* 473 */ "builtInCall ::= STBEFORE LPARENTHESE expression COMMA expression RPARENTHESE",
 /* 474 */ "builtInCall ::= STRAFTER LPARENTHESE expression COMMA expression RPARENTHESE",
 /* 475 */ "builtInCall ::= YEAR LPARENTHESE expression RPARENTHESE",
 /* 476 */ "builtInCall ::= MONTH LPARENTHESE expression RPARENTHESE",
 /* 477 */ "builtInCall ::= DAY LPARENTHESE expression RPARENTHESE",
 /* 478 */ "builtInCall ::= HOURS LPARENTHESE expression RPARENTHESE",
 /* 479 */ "builtInCall ::= MINUTES LPARENTHESE expression RPARENTHESE",
 /* 480 */ "builtInCall ::= SECONDS LPARENTHESE expression RPARENTHESE",
 /* 481 */ "builtInCall ::= TIMEZONE LPARENTHESE expression RPARENTHESE",
 /* 482 */ "builtInCall ::= TZ LPARENTHESE expression RPARENTHESE",
 /* 483 */ "builtInCall ::= NOW NIL",
 /* 484 */ "builtInCall ::= UUID NIL",
 /* 485 */ "builtInCall ::= STRUUID NIL",
 /* 486 */ "builtInCall ::= MD5 LPARENTHESE expression RPARENTHESE",
 /* 487 */ "builtInCall ::= SHA1 LPARENTHESE expression RPARENTHESE",
 /* 488 */ "builtInCall ::= SHA256 LPARENTHESE expression RPARENTHESE",
 /* 489 */ "builtInCall ::= SHA384 LPARENTHESE expression RPARENTHESE",
 /* 490 */ "builtInCall ::= SHA512 LPARENTHESE expression RPARENTHESE",
 /* 491 */ "builtInCall ::= COALESCE expressionList",
 /* 492 */ "builtInCall ::= IF LPARENTHESE expression COMMA expression COMMA expression RPARENTHESE",
 /* 493 */ "builtInCall ::= STRLANG LPARENTHESE expression COMMA expression RPARENTHESE",
 /* 494 */ "builtInCall ::= STRDT LPARENTHESE expression COMMA expression RPARENTHESE",
 /* 495 */ "builtInCall ::= SAMETERM LPARENTHESE expression COMMA expression RPARENTHESE",
 /* 496 */ "builtInCall ::= ISIRI LPARENTHESE expression RPARENTHESE",
 /* 497 */ "builtInCall ::= ISURI LPARENTHESE expression RPARENTHESE",
 /* 498 */ "builtInCall ::= ISBLANK LPARENTHESE expression RPARENTHESE",
 /* 499 */ "builtInCall ::= ISLITERAL LPARENTHESE expression RPARENTHESE",
 /* 500 */ "builtInCall ::= ISNUMERIC LPARENTHESE expression RPARENTHESE",
 /* 501 */ "regexExpression ::= REGEX LPARENTHESE expression COMMA expression COMMA expression RPARENTHESE",
 /* 502 */ "regexExpression ::= REGEX LPARENTHESE expression COMMA expression RPARENTHESE",
 /* 503 */ "subStringExpression ::= SUBSTR LPARENTHESE expression COMMA expression COMMA expression RPARENTHESE",
 /* 504 */ "subStringExpression ::= SUBSTR LPARENTHESE expression COMMA expression RPARENTHESE",
 /* 505 */ "strReplaceExpression ::= REPLACE LPARENTHESE expression COMMA expression COMMA expression COMMA expression RPARENTHESE",
 /* 506 */ "strReplaceExpression ::= REPLACE LPARENTHESE expression COMMA expression COMMA expression RPARENTHESE",
 /* 507 */ "existsFunc ::= EXISTS groupGraphPattern",
 /* 508 */ "notExistsFunc ::= NOT EXISTS groupGraphPattern",
 /* 509 */ "aggregate ::= COUNT LPARENTHESE DISTINCT STAR RPARENTHESE",
 /* 510 */ "aggregate ::= COUNT LPARENTHESE DISTINCT expression RPARENTHESE",
 /* 511 */ "aggregate ::= COUNT LPARENTHESE STAR RPARENTHESE",
 /* 512 */ "aggregate ::= COUNT LPARENTHESE expression RPARENTHESE",
 /* 513 */ "aggregate ::= SUM LPARENTHESE DISTINCT expression RPARENTHESE",
 /* 514 */ "aggregate ::= MIN LPARENTHESE DISTINCT expression RPARENTHESE",
 /* 515 */ "aggregate ::= MAX LPARENTHESE DISTINCT expression RPARENTHESE",
 /* 516 */ "aggregate ::= AVG LPARENTHESE DISTINCT expression RPARENTHESE",
 /* 517 */ "aggregate ::= SAMPLE LPARENTHESE DISTINCT expression RPARENTHESE",
 /* 518 */ "aggregate ::= SUM LPARENTHESE expression RPARENTHESE",
 /* 519 */ "aggregate ::= MIN LPARENTHESE expression RPARENTHESE",
 /* 520 */ "aggregate ::= MAX LPARENTHESE expression RPARENTHESE",
 /* 521 */ "aggregate ::= AVG LPARENTHESE expression RPARENTHESE",
 /* 522 */ "aggregate ::= SAMPLE LPARENTHESE expression RPARENTHESE",
 /* 523 */ "aggregate ::= GROUP_CONCAT LPARENTHESE DISTINCT expression SEMICOLON SEPARATOR EQUAL string RPARENTHESE",
 /* 524 */ "aggregate ::= GROUP_CONCAT LPARENTHESE DISTINCT expression RPARENTHESE",
 /* 525 */ "aggregate ::= GROUP_CONCAT LPARENTHESE expression SEMICOLON SEPARATOR EQUAL string RPARENTHESE",
 /* 526 */ "aggregate ::= GROUP_CONCAT LPARENTHESE expression RPARENTHESE",
 /* 527 */ "rdfLiteral ::= string LANGTAG",
 /* 528 */ "rdfLiteral ::= string DHAT iri",
 /* 529 */ "rdfLiteral ::= string",
 /* 530 */ "numericLiteral ::= numericLiteralUnsigned",
 /* 531 */ "numericLiteral ::= numericLiteralPositive",
 /* 532 */ "numericLiteral ::= numericLiteralNegative",
 /* 533 */ "numericLiteralUnsigned ::= INTEGER",
 /* 534 */ "numericLiteralUnsigned ::= DECIMAL",
 /* 535 */ "numericLiteralUnsigned ::= DOUBLE",
 /* 536 */ "numericLiteralPositive ::= INTEGER_POSITIVE",
 /* 537 */ "numericLiteralPositive ::= DECIMAL_POSITIVE",
 /* 538 */ "numericLiteralPositive ::= DOUBLE_POSITIVE",
 /* 539 */ "numericLiteralNegative ::= INTEGER_NEGATIVE",
 /* 540 */ "numericLiteralNegative ::= DECIMAL_NEGATIVE",
 /* 541 */ "numericLiteralNegative ::= DOUBLE_NEGATIVE",
 /* 542 */ "booleanLiteral ::= TRUE",
 /* 543 */ "booleanLiteral ::= FALSE",
 /* 544 */ "string ::= STRING_LITERAL1",
 /* 545 */ "string ::= STRING_LITERAL2",
 /* 546 */ "string ::= STRING_LITERAL_LONG1",
 /* 547 */ "string ::= STRING_LITERAL_LONG2",
 /* 548 */ "iri ::= IRIREF",
 /* 549 */ "iri ::= prefixedName",
 /* 550 */ "prefixedName ::= PNAME_LN",
 /* 551 */ "prefixedName ::= PNAME_NS",
 /* 552 */ "blankNode ::= BLANK_NODE_LABEL",
 /* 553 */ "blankNode ::= ANON",
);

/*
** This function returns the symbolic name associated with a token
** value.
*/
function SparqlPHPTokenName(/* int */ $tokenType){
  if (isset(self::$yyTokenName[$tokenType]))
    return self::$yyTokenName[$tokenType];
  return "Unknown";
}

/* The following function deletes the value associated with a
** symbol.  The symbol can be either a terminal or nonterminal.
** "yymajor" is the symbol code, and "yypminor" is a pointer to
** the value.
*/
private function yy_destructor($yymajor, $yypminor){
  switch( $yymajor ){
    /* Here is inserted the actions which take place when a
    ** terminal or non-terminal is destroyed.  This can happen
    ** when the symbol is popped from the stack during a
    ** reduce or during error processing or when a parser is 
    ** being destroyed before it is finished parsing.
    **
    ** Note: during a reduce, the only symbols destroyed are those
    ** which appear on the RHS of the rule, but which are not used
    ** inside the C code.
    */
    default:  break;   /* If no destructor action specified: do nothing */
  }
}

/*
** Pop the parser's stack once.
**
** If there is a destructor routine associated with the token which
** is popped from the stack, then call it.
**
** Return the major token number for the symbol popped.
*/
private function yy_pop_parser_stack() {
  if ($this->yyidx < 0) return 0;
  $yytos = $this->yystack[$this->yyidx];
  if( $this->yyTraceFILE ) {
    fprintf($this->yyTraceFILE,"%sPopping %s\n",
      $this->yyTracePrompt,
      self::$yyTokenName[$yytos->major]);
  }
  $this->yy_destructor( $yytos->major, $yytos->minor);
  unset($this->yystack[$this->yyidx]);
  $this->yyidx--;
  return $yytos->major;
}

/* 
** Deallocate and destroy a parser.  Destructors are all called for
** all stack elements before shutting the parser down.
**
** Inputs:
** <ul>
** <li>  A pointer to the parser.  This should be a pointer
**       obtained from SparqlPHPAlloc.
** <li>  A pointer to a function used to reclaim memory obtained
**       from malloc.
** </ul>
*/
function __destruct()
{
  while($this->yyidx >= 0)
    $this->yy_pop_parser_stack();
}

/*
** Find the appropriate action for a parser given the terminal
** look-ahead token iLookAhead.
**
** If the look-ahead token is YYNOCODE, then check to see if the action is
** independent of the look-ahead.  If it is, return the action, otherwise
** return YY_NO_ACTION.
*/
private function yy_find_shift_action(
  $iLookAhead     /* The look-ahead token */
){
  $i = 0;
  $stateno = $this->yystack[$this->yyidx]->stateno;
 
  if( $stateno>self::YY_SHIFT_MAX || 
      ($i = self::$yy_shift_ofst[$stateno])==self::YY_SHIFT_USE_DFLT ){
    return self::$yy_default[$stateno];
  }
  if( $iLookAhead==self::YYNOCODE ){
    return $this->YY_NO_ACTION;
  }
  $i += $iLookAhead;
  if( $i<0 || $i>=count(self::$yy_action) || self::$yy_lookahead[$i]!=$iLookAhead ){
    if( $iLookAhead>0 ){
      if (isset(self::$yyFallback[$iLookAhead]) &&
        ($iFallback = self::$yyFallback[$iLookAhead]) != 0) {
        if( $this->yyTraceFILE ){
          fprintf($this->yyTraceFILE, "%sFALLBACK %s => %s\n",
             $this->yyTracePrompt, self::$yyTokenName[$iLookAhead], 
             self::$yyTokenName[$iFallback]);
        }
        return $this->yy_find_shift_action($iFallback);
      }
      {
        $j = $i - $iLookAhead + self::YYWILDCARD;
        if( $j>=0 && $j<count(self::$yy_action) && self::$yy_lookahead[$j]==self::YYWILDCARD ){
          if( $this->yyTraceFILE ){
            fprintf($this->yyTraceFILE, "%sWILDCARD %s => %s\n",
               $this->yyTracePrompt, self::$yyTokenName[$iLookAhead],
               self::$yyTokenName[self::YYWILDCARD]);
          }
          return self::$yy_action[$j];
        }
      }
    }
    return self::$yy_default[$stateno];
  }else{
    return self::$yy_action[$i];
  }
}

/*
** Find the appropriate action for a parser given the non-terminal
** look-ahead token iLookAhead.
**
** If the look-ahead token is YYNOCODE, then check to see if the action is
** independent of the look-ahead.  If it is, return the action, otherwise
** return YY_NO_ACTION.
*/
private function yy_find_reduce_action(
  $stateno,              /* Current state number */
  $iLookAhead     /* The look-ahead token */
){
  $i = 0;
 
  if( $stateno>self::YY_REDUCE_MAX ||
      ($i = self::$yy_reduce_ofst[$stateno])==self::YY_REDUCE_USE_DFLT ){
    return self::$yy_default[$stateno];
  }
  if( $iLookAhead==self::YYNOCODE ){
    return $this->YY_NO_ACTION;
  }
  $i += $iLookAhead;
  if( $i<0 || $i>=count(self::$yy_action) || self::$yy_lookahead[$i]!=$iLookAhead ){
    return self::$yy_default[$stateno];
  }else{
    return self::$yy_action[$i];
  }
}

/*
** Perform a shift action.
*/
private function yy_shift(
  $yyNewState,               /* The new state to shift in */
  $yyMajor,                  /* The major token to shift in */
  $yypMinor         /* Pointer ot the minor token to shift in */
){
  $this->yyidx++;
  if (isset($this->yystack[$this->yyidx])) {
    $yytos = $this->yystack[$this->yyidx];
  } else {
    $yytos = new SparqlPHPyyStackEntry;
    $this->yystack[$this->yyidx] = $yytos;
  }
  $yytos->stateno = $yyNewState;
  $yytos->major = $yyMajor;
  $yytos->minor = $yypMinor;
  if( $this->yyTraceFILE) {
    fprintf($this->yyTraceFILE,"%sShift %d\n",$this->yyTracePrompt,$yyNewState);
    fprintf($this->yyTraceFILE,"%sStack:",$this->yyTracePrompt);
    for ($i = 1; $i <= $this->yyidx; $i++) {
      $ent = $this->yystack[$i];
      fprintf($this->yyTraceFILE," %s",self::$yyTokenName[$ent->major]);
    }
    fprintf($this->yyTraceFILE,"\n");
  }
}

private function __overflow_dead_code() {
  /* if the stack can overflow (it can't in the PHP implementation)
   * Then the following code would be emitted */
}

/* The following table contains information about every rule that
** is used during the reduce.
** Rather than pollute memory with a large number of arrays,
** we store both data points in the same array, indexing by
** rule number * 2.
static const struct {
  YYCODETYPE lhs;         // Symbol on the left-hand side of the rule 
  unsigned char nrhs;     // Number of right-hand side symbols in the rule
} yyRuleInfo[] = {
*/
static $yyRuleInfo = array(
  165, 1,
  165, 1,
  166, 3,
  166, 3,
  166, 3,
  166, 3,
  166, 2,
  166, 2,
  166, 2,
  166, 2,
  166, 2,
  166, 2,
  166, 2,
  166, 2,
  166, 1,
  166, 1,
  166, 1,
  166, 1,
  168, 3,
  168, 2,
  168, 2,
  168, 1,
  174, 2,
  174, 1,
  175, 3,
  175, 2,
  176, 4,
  176, 3,
  169, 4,
  169, 3,
  169, 3,
  169, 2,
  178, 2,
  178, 1,
  182, 4,
  182, 3,
  182, 3,
  182, 2,
  177, 3,
  177, 3,
  177, 3,
  177, 3,
  177, 3,
  177, 2,
  177, 2,
  183, 6,
  183, 4,
  183, 2,
  183, 2,
  183, 2,
  183, 2,
  183, 2,
  183, 2,
  183, 5,
  183, 3,
  183, 1,
  183, 1,
  183, 1,
  183, 1,
  183, 1,
  183, 1,
  171, 7,
  171, 6,
  171, 7,
  171, 6,
  171, 6,
  171, 5,
  171, 5,
  171, 4,
  171, 6,
  171, 5,
  171, 6,
  171, 5,
  171, 6,
  171, 5,
  171, 5,
  171, 4,
  172, 5,
  172, 4,
  172, 4,
  172, 4,
  172, 3,
  172, 3,
  172, 3,
  172, 2,
  172, 5,
  172, 4,
  172, 4,
  172, 4,
  172, 3,
  172, 3,
  172, 3,
  172, 2,
  192, 2,
  192, 1,
  173, 4,
  173, 3,
  173, 3,
  173, 2,
  181, 3,
  181, 2,
  179, 2,
  179, 1,
  180, 4,
  180, 3,
  180, 3,
  180, 3,
  180, 3,
  180, 2,
  180, 2,
  180, 2,
  180, 2,
  180, 2,
  180, 2,
  180, 1,
  180, 1,
  180, 1,
  180, 1,
  196, 3,
  200, 6,
  200, 2,
  200, 2,
  200, 4,
  200, 2,
  200, 5,
  200, 1,
  200, 1,
  200, 3,
  200, 1,
  197, 2,
  201, 4,
  201, 2,
  201, 2,
  201, 3,
  201, 1,
  201, 1,
  198, 3,
  202, 2,
  202, 1,
  203, 4,
  203, 4,
  203, 3,
  203, 1,
  203, 1,
  203, 1,
  199, 2,
  199, 2,
  199, 1,
  199, 1,
  204, 2,
  205, 2,
  170, 2,
  167, 4,
  167, 3,
  167, 2,
  167, 1,
  207, 1,
  207, 1,
  207, 1,
  207, 1,
  207, 1,
  207, 1,
  207, 1,
  207, 1,
  207, 1,
  207, 1,
  207, 1,
  208, 5,
  208, 4,
  208, 3,
  208, 2,
  209, 3,
  209, 2,
  210, 3,
  210, 2,
  214, 3,
  214, 2,
  211, 5,
  211, 4,
  212, 5,
  212, 4,
  213, 5,
  213, 4,
  215, 2,
  216, 2,
  217, 2,
  218, 7,
  218, 6,
  218, 6,
  218, 6,
  218, 5,
  218, 5,
  218, 5,
  218, 4,
  218, 4,
  218, 4,
  218, 3,
  218, 3,
  226, 2,
  226, 1,
  224, 2,
  225, 2,
  227, 3,
  227, 2,
  221, 2,
  221, 1,
  221, 1,
  219, 2,
  220, 1,
  220, 1,
  220, 1,
  220, 1,
  223, 3,
  223, 2,
  222, 3,
  222, 2,
  228, 2,
  228, 1,
  228, 1,
  229, 4,
  229, 3,
  229, 3,
  229, 2,
  229, 3,
  229, 2,
  229, 2,
  229, 1,
  230, 5,
  230, 4,
  191, 4,
  191, 3,
  191, 2,
  191, 1,
  232, 3,
  232, 1,
  195, 3,
  195, 3,
  195, 2,
  233, 2,
  233, 1,
  233, 1,
  235, 4,
  235, 3,
  235, 3,
  235, 2,
  235, 3,
  235, 2,
  235, 2,
  235, 1,
  234, 4,
  234, 3,
  234, 2,
  234, 1,
  238, 3,
  238, 1,
  236, 1,
  236, 1,
  236, 1,
  236, 1,
  236, 1,
  236, 1,
  236, 1,
  236, 1,
  240, 2,
  242, 3,
  243, 4,
  243, 3,
  245, 6,
  246, 2,
  206, 1,
  206, 1,
  247, 4,
  247, 3,
  249, 2,
  249, 1,
  248, 6,
  248, 4,
  248, 3,
  253, 2,
  253, 1,
  251, 2,
  251, 1,
  252, 4,
  252, 2,
  252, 3,
  252, 1,
  250, 1,
  250, 1,
  250, 1,
  250, 1,
  250, 1,
  241, 2,
  239, 2,
  239, 1,
  254, 3,
  254, 2,
  244, 4,
  244, 2,
  244, 2,
  190, 2,
  255, 5,
  255, 4,
  255, 1,
  256, 3,
  256, 2,
  257, 4,
  257, 3,
  231, 2,
  231, 2,
  231, 1,
  259, 3,
  259, 2,
  263, 4,
  263, 2,
  263, 3,
  263, 1,
  261, 1,
  261, 1,
  262, 2,
  262, 1,
  265, 3,
  265, 2,
  237, 2,
  237, 2,
  237, 1,
  266, 3,
  266, 3,
  266, 2,
  266, 2,
  270, 4,
  270, 4,
  270, 2,
  270, 3,
  270, 3,
  270, 1,
  269, 2,
  269, 1,
  272, 3,
  272, 2,
  268, 2,
  268, 1,
  274, 3,
  274, 2,
  273, 2,
  273, 1,
  276, 3,
  276, 2,
  277, 2,
  277, 1,
  275, 2,
  275, 1,
  279, 1,
  279, 1,
  279, 1,
  278, 3,
  278, 2,
  278, 1,
  278, 1,
  280, 4,
  280, 3,
  280, 2,
  280, 1,
  282, 3,
  282, 2,
  281, 2,
  281, 2,
  281, 1,
  281, 1,
  260, 1,
  260, 1,
  284, 3,
  267, 1,
  267, 1,
  286, 3,
  283, 3,
  287, 2,
  287, 1,
  285, 3,
  288, 2,
  288, 1,
  264, 1,
  264, 1,
  271, 1,
  271, 1,
  258, 1,
  258, 1,
  193, 1,
  193, 1,
  185, 1,
  185, 1,
  289, 1,
  289, 1,
  289, 1,
  289, 1,
  289, 1,
  289, 1,
  184, 2,
  184, 1,
  292, 3,
  292, 2,
  291, 2,
  291, 1,
  294, 3,
  294, 2,
  293, 2,
  293, 1,
  296, 2,
  296, 2,
  296, 2,
  296, 2,
  296, 2,
  296, 2,
  296, 2,
  296, 3,
  295, 2,
  295, 1,
  298, 3,
  298, 3,
  298, 2,
  298, 2,
  298, 3,
  298, 3,
  298, 2,
  298, 2,
  298, 1,
  298, 1,
  298, 2,
  298, 2,
  300, 3,
  300, 3,
  300, 2,
  300, 2,
  297, 2,
  297, 1,
  302, 2,
  302, 2,
  302, 2,
  302, 1,
  303, 3,
  303, 1,
  303, 1,
  303, 1,
  303, 1,
  303, 1,
  303, 1,
  303, 1,
  186, 1,
  186, 1,
  186, 1,
  186, 1,
  186, 4,
  186, 4,
  186, 6,
  186, 4,
  186, 4,
  186, 4,
  186, 4,
  186, 2,
  186, 2,
  186, 4,
  186, 4,
  186, 4,
  186, 4,
  186, 2,
  186, 1,
  186, 4,
  186, 1,
  186, 4,
  186, 4,
  186, 4,
  186, 6,
  186, 6,
  186, 6,
  186, 6,
  186, 6,
  186, 4,
  186, 4,
  186, 4,
  186, 4,
  186, 4,
  186, 4,
  186, 4,
  186, 4,
  186, 2,
  186, 2,
  186, 2,
  186, 4,
  186, 4,
  186, 4,
  186, 4,
  186, 4,
  186, 2,
  186, 8,
  186, 6,
  186, 6,
  186, 6,
  186, 4,
  186, 4,
  186, 4,
  186, 4,
  186, 4,
  305, 8,
  305, 6,
  308, 8,
  308, 6,
  309, 10,
  309, 8,
  306, 2,
  307, 3,
  304, 5,
  304, 5,
  304, 4,
  304, 4,
  304, 5,
  304, 5,
  304, 5,
  304, 5,
  304, 5,
  304, 4,
  304, 4,
  304, 4,
  304, 4,
  304, 4,
  304, 9,
  304, 5,
  304, 8,
  304, 4,
  187, 2,
  187, 3,
  187, 1,
  188, 1,
  188, 1,
  188, 1,
  311, 1,
  311, 1,
  311, 1,
  299, 1,
  299, 1,
  299, 1,
  301, 1,
  301, 1,
  301, 1,
  189, 1,
  189, 1,
  310, 1,
  310, 1,
  310, 1,
  310, 1,
  194, 1,
  194, 1,
  312, 1,
  312, 1,
  290, 1,
  290, 1,
);

/*
** Perform a reduce action and the shift that must immediately
** follow the reduce.
*/
private function yy_reduce(
  $yyruleno                 /* Number of the rule by which to reduce */
){
  $yygoto = 0;                     /* The next state */
  $yyact = 0;                      /* The next action */
  $yygotominor = null;        /* The LHS of the rule reduced */
  $yymsp = null;            /* The top of the parser's stack */
  $yysize = 0;                     /* Amount to pop the stack */
  
  $yymsp = $this->yystack[$this->yyidx];
  if( $this->yyTraceFILE && isset(self::$yyRuleName[$yyruleno])) {
    fprintf($this->yyTraceFILE, "%sReduce [%s].\n", $this->yyTracePrompt,
      self::$yyRuleName[$yyruleno]);
  }

  switch( $yyruleno ){
  /* Beginning here are the reduction cases.  A typical example
  ** follows:
  **   case 0:
  **  #line <lineno> <grammarfile>
  **     { ... }           // User supplied code
  **  #line <lineno> <thisfile>
  **     break;
  */
      case 0:
      case 1:
#line 123 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $this->main = $yygotominor; }
#line 4062 "sparql.php"
        break;
      case 2:
      case 3:
      case 4:
      case 5:
#line 126 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4070 "sparql.php"
        break;
      case 6:
      case 7:
      case 8:
      case 9:
      case 10:
      case 11:
      case 12:
      case 13:
#line 130 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4082 "sparql.php"
        break;
      case 14:
      case 15:
      case 16:
      case 17:
      case 55:
      case 56:
      case 57:
      case 58:
      case 59:
      case 60:
      case 94:
      case 102:
      case 114:
      case 115:
      case 116:
      case 117:
      case 125:
      case 128:
      case 134:
      case 138:
      case 142:
      case 143:
      case 144:
      case 147:
      case 148:
      case 155:
      case 156:
      case 157:
      case 158:
      case 159:
      case 160:
      case 161:
      case 162:
      case 163:
      case 164:
      case 165:
      case 166:
      case 208:
      case 217:
      case 218:
      case 226:
      case 530:
      case 531:
      case 532:
#line 138 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; }
#line 4130 "sparql.php"
        break;
      case 18:
#line 143 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4135 "sparql.php"
        break;
      case 19:
      case 20:
      case 22:
      case 32:
#line 144 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4143 "sparql.php"
        break;
      case 21:
      case 23:
      case 549:
#line 146 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4150 "sparql.php"
        break;
      case 24:
#line 150 "sparql.y"
{ $this->base = $this->yystack[$this->yyidx + -1]->minor->value; $yygotominor = new NTToken(); $yygotominor->query = 'BASE ' . $this->yystack[$this->yyidx + -1]->minor->value . ' .';}
#line 4155 "sparql.php"
        break;
      case 25:
#line 151 "sparql.y"
{ $this->base = $this->yystack[$this->yyidx + 0]->minor->value; $yygotominor = new NTToken(); $yygotominor->query = 'BASE ' . $this->yystack[$this->yyidx + 0]->minor->value;}
#line 4160 "sparql.php"
        break;
      case 26:
#line 153 "sparql.y"
{ $this->addNS($this->yystack[$this->yyidx + -2]->minor->value, $this->yystack[$this->yyidx + -1]->minor->value); $yygotominor = new NTToken(); $yygotominor->query = 'PREFIX ' . $this->yystack[$this->yyidx + -2]->minor->value . $this->yystack[$this->yyidx + -1]->minor->value . ' .';}
#line 4165 "sparql.php"
        break;
      case 27:
#line 154 "sparql.y"
{ $this->addNS($this->yystack[$this->yyidx + -1]->minor->value, $this->yystack[$this->yyidx + 0]->minor->value); $yygotominor = new NTToken(); $yygotominor->query = 'PREFIX ' . $this->yystack[$this->yyidx + -1]->minor->value . $this->yystack[$this->yyidx + 0]->minor->value;}
#line 4170 "sparql.php"
        break;
      case 28:
#line 156 "sparql.y"
{ $tmp = $this->yystack[$this->yyidx + -3]->minor->noDuplicates($this->yystack[$this->yyidx + -3]->minor->ssVars, $this->yystack[$this->yyidx + -1]->minor->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = $this->yystack[$this->yyidx + -3]->minor->noDuplicates($this->yystack[$this->yyidx + -3]->minor->ssVars, $this->yystack[$this->yyidx + 0]->minor->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = $this->yystack[$this->yyidx + -3]->minor->noDuplicates($this->yystack[$this->yyidx + -1]->minor->ssVars, $this->yystack[$this->yyidx + 0]->minor->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -3]->minor->ssVars; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4175 "sparql.php"
        break;
      case 29:
#line 157 "sparql.y"
{ $tmp = $this->yystack[$this->yyidx + -2]->minor->noDuplicates($this->yystack[$this->yyidx + -2]->minor->ssVars, $this->yystack[$this->yyidx + 0]->minor->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4180 "sparql.php"
        break;
      case 30:
      case 35:
      case 36:
#line 158 "sparql.y"
{ $tmp = $this->yystack[$this->yyidx + -2]->minor->noDuplicates($this->yystack[$this->yyidx + -2]->minor->ssVars, $this->yystack[$this->yyidx + -1]->minor->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = $this->yystack[$this->yyidx + -2]->minor->noDuplicates($this->yystack[$this->yyidx + -2]->minor->ssVars, $this->yystack[$this->yyidx + 0]->minor->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = $this->yystack[$this->yyidx + -2]->minor->noDuplicates($this->yystack[$this->yyidx + 0]->minor->ssVars, $this->yystack[$this->yyidx + -1]->minor->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4187 "sparql.php"
        break;
      case 31:
      case 37:
#line 159 "sparql.y"
{ $tmp = $this->yystack[$this->yyidx + -1]->minor->noDuplicates($this->yystack[$this->yyidx + -1]->minor->ssVars, $this->yystack[$this->yyidx + 0]->minor->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4193 "sparql.php"
        break;
      case 33:
#line 161 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor;}
#line 4198 "sparql.php"
        break;
      case 34:
#line 164 "sparql.y"
{ $tmp = $this->yystack[$this->yyidx + -3]->minor->noDuplicates($this->yystack[$this->yyidx + -3]->minor->ssVars, $this->yystack[$this->yyidx + -2]->minor->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = $this->yystack[$this->yyidx + -3]->minor->noDuplicates($this->yystack[$this->yyidx + -3]->minor->ssVars, $this->yystack[$this->yyidx + -1]->minor->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = $this->yystack[$this->yyidx + -3]->minor->noDuplicates($this->yystack[$this->yyidx + -1]->minor->ssVars, $this->yystack[$this->yyidx + -2]->minor->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = $this->yystack[$this->yyidx + -3]->minor->noDuplicates($this->yystack[$this->yyidx + -3]->minor->ssVars, $this->yystack[$this->yyidx + 0]->minor->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = $this->yystack[$this->yyidx + -3]->minor->noDuplicates($this->yystack[$this->yyidx + 0]->minor->ssVars, $this->yystack[$this->yyidx + -2]->minor->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $tmp = $this->yystack[$this->yyidx + -3]->minor->noDuplicates($this->yystack[$this->yyidx + -1]->minor->ssVars, $this->yystack[$this->yyidx + 0]->minor->ssVars); if(isset($tmp)){ throw new Exception('Error, Variable already bound: ' . $tmp, -1);} $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -3]->minor->ssVars; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4203 "sparql.php"
        break;
      case 38:
#line 169 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'SELECT DISTINCT' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4208 "sparql.php"
        break;
      case 39:
#line 170 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'SELECT REDUCED' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4213 "sparql.php"
        break;
      case 40:
#line 171 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'SELECT *' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4218 "sparql.php"
        break;
      case 41:
#line 172 "sparql.y"
{ $yygotominor = B; $yygotominor->query = 'SELECT DISTINCT *'; }
#line 4223 "sparql.php"
        break;
      case 42:
#line 173 "sparql.y"
{ $yygotominor = B; $yygotominor->query = 'SELECT REDUCED *'; }
#line 4228 "sparql.php"
        break;
      case 43:
#line 174 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'SELECT ' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4233 "sparql.php"
        break;
      case 44:
#line 175 "sparql.y"
{ $yygotominor = B; $yygotominor->query = 'SELECT *'; }
#line 4238 "sparql.php"
        break;
      case 45:
#line 176 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -5]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -5]->minor->ssVars + $this->yystack[$this->yyidx + -3]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -5]->minor->vars + $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -5]->minor->bNodes + $this->yystack[$this->yyidx + -3]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -5]->minor->query . '( ' . $this->yystack[$this->yyidx + -3]->minor->query . ' AS ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 4243 "sparql.php"
        break;
      case 46:
#line 177 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -3]->minor->ssVars + $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . '( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 4248 "sparql.php"
        break;
      case 47:
      case 48:
      case 49:
      case 50:
      case 51:
      case 52:
      case 292:
#line 178 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4259 "sparql.php"
        break;
      case 53:
#line 184 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -3]->minor->ssVars + $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = '( ' . $this->yystack[$this->yyidx + -3]->minor->query . ' AS ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 4264 "sparql.php"
        break;
      case 54:
#line 185 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + -1]->minor; $yygotominor->query = '( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 4269 "sparql.php"
        break;
      case 61:
#line 193 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -4]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -4]->minor->ssVars + $this->yystack[$this->yyidx + -2]->minor->ssVars + $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -4]->minor->vars + $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -4]->minor->bNodes + $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'CONSTRUCT' . PHP_EOL . '{' . PHP_EOL . $this->yystack[$this->yyidx + -4]->minor->query . PHP_EOL . '}' . PHP_EOL. $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4274 "sparql.php"
        break;
      case 62:
#line 194 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars + $this->yystack[$this->yyidx + -1]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'CONSTRUCT { }' . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL. $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4279 "sparql.php"
        break;
      case 63:
#line 195 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -5]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -5]->minor->ssVars + $this->yystack[$this->yyidx + -2]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -5]->minor->vars + $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -5]->minor->bNodes + $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'CONSTRUCT' . PHP_EOL . $this->yystack[$this->yyidx + -5]->minor->query . PHP_EOL . 'WHERE' . PHP_EOL . '{' . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . '}' . PHP_EOL. $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4284 "sparql.php"
        break;
      case 64:
#line 196 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -4]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -4]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -4]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -4]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'CONSTRUCT' . PHP_EOL . $this->yystack[$this->yyidx + -4]->minor->query . PHP_EOL . ' WHERE' . PHP_EOL . '{' . PHP_EOL . $this->yystack[$this->yyidx + -4]->minor->query . PHP_EOL . '}' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4289 "sparql.php"
        break;
      case 65:
      case 69:
#line 197 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -3]->minor->ssVars + $this->yystack[$this->yyidx + -1]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'CONSTRUCT {' . PHP_EOL . $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . '}' . PHP_EOL. $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4295 "sparql.php"
        break;
      case 66:
      case 70:
#line 198 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'CONSTRUCT { }' . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4301 "sparql.php"
        break;
      case 67:
#line 199 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'CONSTRUCT {' . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . '}' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4306 "sparql.php"
        break;
      case 68:
#line 200 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'CONSTRUCT { }' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4311 "sparql.php"
        break;
      case 71:
#line 203 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -4]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -4]->minor->ssVars + $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -4]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -4]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'CONSTRUCT' . PHP_EOL . $this->yystack[$this->yyidx + -4]->minor->query . PHP_EOL . 'WHERE {' . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . '}'; }
#line 4316 "sparql.php"
        break;
      case 72:
#line 204 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + -3]->minor; $yygotominor->query = 'CONSTRUCT' . PHP_EOL . $this->yystack[$this->yyidx + -3]->minor->query . 'WHERE { }'; }
#line 4321 "sparql.php"
        break;
      case 73:
#line 205 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'CONSTRUCT WHERE {' . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . '}' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4326 "sparql.php"
        break;
      case 74:
#line 206 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'CONSTRUCT WHERE { }' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4331 "sparql.php"
        break;
      case 75:
#line 207 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + -1]->minor; $yygotominor->query = 'CONSTRUCT WHERE {' . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . '}'; }
#line 4336 "sparql.php"
        break;
      case 76:
#line 208 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = 'CONSTRUCT WHERE { }'; }
#line 4341 "sparql.php"
        break;
      case 77:
#line 210 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -3]->minor->ssVars + $this->yystack[$this->yyidx + -2]->minor->ssVars + $this->yystack[$this->yyidx + -1]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'DESCRIBE ' . $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4346 "sparql.php"
        break;
      case 78:
      case 79:
      case 80:
#line 211 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars + $this->yystack[$this->yyidx + -1]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'DESCRIBE ' . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4353 "sparql.php"
        break;
      case 81:
      case 82:
      case 83:
#line 214 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'DESCRIBE ' . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4360 "sparql.php"
        break;
      case 84:
#line 217 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'DESCRIBE ' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4365 "sparql.php"
        break;
      case 85:
#line 218 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars + $this->yystack[$this->yyidx + -1]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'DESCRIBE *' . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4370 "sparql.php"
        break;
      case 86:
      case 87:
      case 88:
#line 219 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'DESCRIBE *' . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4377 "sparql.php"
        break;
      case 89:
      case 90:
      case 91:
#line 222 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'DESCRIBE *' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4384 "sparql.php"
        break;
      case 92:
#line 225 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = 'DESCRIBE *'; }
#line 4389 "sparql.php"
        break;
      case 93:
      case 111:
      case 112:
      case 113:
      case 154:
      case 222:
      case 224:
#line 226 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4400 "sparql.php"
        break;
      case 95:
#line 229 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars + $this->yystack[$this->yyidx + -1]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'ASK' . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4405 "sparql.php"
        break;
      case 96:
      case 97:
#line 230 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'ASK' . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4411 "sparql.php"
        break;
      case 98:
#line 232 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'ASK ' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4416 "sparql.php"
        break;
      case 99:
#line 234 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'FROM NAMED ' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4421 "sparql.php"
        break;
      case 100:
#line 235 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'FROM ' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4426 "sparql.php"
        break;
      case 101:
#line 237 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'WHERE ' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4431 "sparql.php"
        break;
      case 103:
#line 240 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -3]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4436 "sparql.php"
        break;
      case 104:
#line 241 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4441 "sparql.php"
        break;
      case 105:
      case 106:
      case 107:
#line 242 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4448 "sparql.php"
        break;
      case 108:
      case 109:
      case 110:
      case 246:
#line 245 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4456 "sparql.php"
        break;
      case 118:
#line 256 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'GROUP BY ' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4461 "sparql.php"
        break;
      case 119:
#line 257 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -5]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -5]->minor->ssVars + $this->yystack[$this->yyidx + -1]->minor->query; $yygotominor->vars = $this->yystack[$this->yyidx + -5]->minor->vars + $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -5]->minor->bNodes + $this->yystack[$this->yyidx + -3]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -5]->minor->query . ' (' . $this->yystack[$this->yyidx + -3]->minor->query . ' AS ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )';}
#line 4466 "sparql.php"
        break;
      case 120:
      case 123:
#line 258 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4472 "sparql.php"
        break;
      case 121:
#line 259 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasFNC = true; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4477 "sparql.php"
        break;
      case 122:
#line 260 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -3]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . ' (' . $this->yystack[$this->yyidx + -1]->minor->query . ' )';}
#line 4482 "sparql.php"
        break;
      case 124:
#line 262 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->query; $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = '( ' . $this->yystack[$this->yyidx + -3]->minor->query . ' AS ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )';}
#line 4487 "sparql.php"
        break;
      case 126:
#line 264 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->hasFNC = true; }
#line 4492 "sparql.php"
        break;
      case 127:
      case 133:
      case 141:
#line 265 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + -1]->minor; $yygotominor->query = '( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )';}
#line 4499 "sparql.php"
        break;
      case 129:
#line 268 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'HAVING ' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4504 "sparql.php"
        break;
      case 130:
#line 269 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . ' (' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 4509 "sparql.php"
        break;
      case 131:
      case 137:
      case 307:
      case 308:
      case 311:
      case 318:
      case 322:
      case 323:
      case 327:
      case 375:
      case 378:
#line 270 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4524 "sparql.php"
        break;
      case 132:
#line 271 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasFNC = true; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4529 "sparql.php"
        break;
      case 135:
#line 274 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->hasFNC = true;}
#line 4534 "sparql.php"
        break;
      case 136:
#line 276 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'ORDER BY ' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4539 "sparql.php"
        break;
      case 139:
#line 280 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + -1]->minor; $yygotominor->query = 'ASC( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )';}
#line 4544 "sparql.php"
        break;
      case 140:
#line 281 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + -1]->minor; $yygotominor->query = 'DESC( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )';}
#line 4549 "sparql.php"
        break;
      case 145:
      case 146:
#line 287 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4555 "sparql.php"
        break;
      case 149:
#line 292 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'LIMIT ' . $this->yystack[$this->yyidx + 0]->minor->value; }
#line 4560 "sparql.php"
        break;
      case 150:
#line 294 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'OFFSET ' . $this->yystack[$this->yyidx + 0]->minor->value; }
#line 4565 "sparql.php"
        break;
      case 151:
#line 296 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'VALUES ' . $this->yystack[$this->yyidx + 0]->minor->query;}
#line 4570 "sparql.php"
        break;
      case 152:
#line 298 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . ' ;' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4575 "sparql.php"
        break;
      case 153:
#line 299 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' ;' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4580 "sparql.php"
        break;
      case 167:
#line 315 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'LOAD SILENT ' . $this->yystack[$this->yyidx + -2]->minor->query . ' INTO ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4585 "sparql.php"
        break;
      case 168:
#line 316 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'LOAD ' . $this->yystack[$this->yyidx + -2]->minor->query . ' INTO ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4590 "sparql.php"
        break;
      case 169:
#line 317 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'LOAD SILENT ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4595 "sparql.php"
        break;
      case 170:
#line 318 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'LOAD ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4600 "sparql.php"
        break;
      case 171:
#line 320 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'CLEAR SILENT ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4605 "sparql.php"
        break;
      case 172:
#line 321 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'CLEAR ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4610 "sparql.php"
        break;
      case 173:
#line 323 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'DROP SILENT ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4615 "sparql.php"
        break;
      case 174:
#line 324 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'DROP ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4620 "sparql.php"
        break;
      case 175:
#line 326 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'CREATE SILENT ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4625 "sparql.php"
        break;
      case 176:
#line 327 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'CREATE ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4630 "sparql.php"
        break;
      case 177:
      case 178:
#line 329 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'ADD ' . $this->yystack[$this->yyidx + -2]->minor->query . ' TO ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4636 "sparql.php"
        break;
      case 179:
#line 332 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'MOVE SILENT ' . $this->yystack[$this->yyidx + -2]->minor->query . ' TO ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4641 "sparql.php"
        break;
      case 180:
#line 333 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'MOVE ' . $this->yystack[$this->yyidx + -2]->minor->query . ' TO ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4646 "sparql.php"
        break;
      case 181:
#line 335 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'COPY SILENT ' . $this->yystack[$this->yyidx + -2]->minor->query . ' TO ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4651 "sparql.php"
        break;
      case 182:
#line 336 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'COPY ' . $this->yystack[$this->yyidx + -2]->minor->query . ' TO ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4656 "sparql.php"
        break;
      case 183:
#line 338 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'DELETE DATA ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4661 "sparql.php"
        break;
      case 184:
#line 340 "sparql.y"
{ if($this->yystack[$this->yyidx + 0]->minor->hasBN){ throw new Exception("Deleteclause is not allowed to contain Blanknodesyntax: DELETE DATA" . $this->yystack[$this->yyidx + 0]->minor->query); } $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'DELETE DATA ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4666 "sparql.php"
        break;
      case 185:
#line 342 "sparql.y"
{ if($this->yystack[$this->yyidx + 0]->minor->hasBN){throw new Exception("Deleteclause is not allowed to contain Blanknodesyntax: DELETE WHERE" . $this->yystack[$this->yyidx + 0]->minor->query);} $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'DELETE WHERE ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4671 "sparql.php"
        break;
      case 186:
#line 344 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -5]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -4]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -5]->minor->vars + $this->yystack[$this->yyidx + -4]->minor->vars + $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -5]->minor->bNodes + $this->yystack[$this->yyidx + -4]->minor->bNodes + $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'WITH ' . $this->yystack[$this->yyidx + -5]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -4]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . 'WHERE' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4676 "sparql.php"
        break;
      case 187:
      case 188:
      case 189:
#line 345 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -4]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -4]->minor->vars + $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -4]->minor->bNodes + $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'WITH ' . $this->yystack[$this->yyidx + -4]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . 'WHERE' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4683 "sparql.php"
        break;
      case 190:
      case 191:
#line 348 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'WITH ' . $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . 'WHERE' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4689 "sparql.php"
        break;
      case 192:
#line 350 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -4]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -4]->minor->vars + $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -4]->minor->bNodes + $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -4]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . 'WHERE' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4694 "sparql.php"
        break;
      case 193:
      case 194:
      case 195:
#line 351 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . 'WHERE' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4701 "sparql.php"
        break;
      case 196:
      case 197:
#line 354 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . 'WHERE' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4707 "sparql.php"
        break;
      case 198:
#line 356 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4712 "sparql.php"
        break;
      case 199:
      case 206:
      case 240:
#line 357 "sparql.y"
{$yygotominor = $this->yystack[$this->yyidx + 0]->minor;}
#line 4719 "sparql.php"
        break;
      case 200:
#line 359 "sparql.y"
{ if($this->yystack[$this->yyidx + 0]->minor->hasBN){throw new Exception("Deleteclause is not allowed to contain Blanknodesyntax: DELETE" . $this->yystack[$this->yyidx + 0]->minor->query);} $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'DELETE ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4724 "sparql.php"
        break;
      case 201:
#line 361 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'INSERT ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4729 "sparql.php"
        break;
      case 202:
#line 363 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'USING NAMED ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4734 "sparql.php"
        break;
      case 203:
#line 364 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'USING ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4739 "sparql.php"
        break;
      case 204:
      case 207:
#line 366 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + 0]->minor; $yygotominor->query = 'GRAPH ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4745 "sparql.php"
        break;
      case 205:
      case 209:
#line 367 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = 'DEFAULT';}
#line 4751 "sparql.php"
        break;
      case 210:
#line 374 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = 'NAMED';}
#line 4756 "sparql.php"
        break;
      case 211:
#line 375 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = 'ALL';}
#line 4761 "sparql.php"
        break;
      case 212:
      case 235:
      case 236:
#line 377 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + -1]->minor; $yygotominor->query = '{ ' . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . ' }'; }
#line 4768 "sparql.php"
        break;
      case 213:
      case 215:
      case 237:
#line 378 "sparql.y"
{$yygotominor = new NTToken(); $yygotominor->query = '{ }';}
#line 4775 "sparql.php"
        break;
      case 214:
#line 380 "sparql.y"
{ if(!empty($this->yystack[$this->yyidx + -1]->minor->vars)){throw new Exception("QuadPattern arent allowed to contain variables: " . $this->yystack[$this->yyidx + -1]->minor->query);} $yygotominor = $this->yystack[$this->yyidx + -1]->minor; $yygotominor->query = '{ ' . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . ' }'; }
#line 4780 "sparql.php"
        break;
      case 216:
#line 383 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' .' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4785 "sparql.php"
        break;
      case 219:
#line 386 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . ' .' . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . ' .' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4790 "sparql.php"
        break;
      case 220:
#line 387 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' .' . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4795 "sparql.php"
        break;
      case 221:
#line 388 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' .' . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query; }
#line 4800 "sparql.php"
        break;
      case 223:
      case 230:
      case 233:
      case 250:
      case 253:
#line 390 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' .' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4809 "sparql.php"
        break;
      case 225:
#line 392 "sparql.y"
{ $yygotominor = $this->yystack[$this->yyidx + -1]->minor; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' .';}
#line 4814 "sparql.php"
        break;
      case 227:
#line 395 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes; $yygotominor->query = 'GRAPH ' . $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . ' { ' .  PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . ' }'; }
#line 4819 "sparql.php"
        break;
      case 228:
#line 396 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars; $yygotominor->query = 'GRAPH ' . $this->yystack[$this->yyidx + -2]->minor->query . ' { }'; }
#line 4824 "sparql.php"
        break;
      case 229:
      case 249:
#line 398 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . ' .' . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . ' .'; }
#line 4830 "sparql.php"
        break;
      case 231:
      case 251:
#line 400 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' .'; }
#line 4836 "sparql.php"
        break;
      case 232:
      case 234:
      case 252:
      case 254:
      case 262:
      case 309:
      case 319:
      case 324:
      case 336:
      case 340:
      case 344:
      case 348:
      case 350:
      case 357:
      case 368:
      case 369:
      case 371:
      case 372:
      case 376:
      case 379:
      case 380:
      case 381:
      case 382:
      case 383:
      case 446:
      case 447:
      case 464:
      case 466:
#line 401 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4868 "sparql.php"
        break;
      case 238:
#line 409 "sparql.y"
{ if(!empty($this->yystack[$this->yyidx + 0]->minor->bindVar)){ $tmp = $this->yystack[$this->yyidx + -1]->minor->noDuplicates($this->yystack[$this->yyidx + 0]->minor->bindVar, $this->yystack[$this->yyidx + -1]->minor->vars); if(isset($tmp)){throw new Exception("Bindvariable is already in scope: " . $tmp);}} $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->bindVar = $this->yystack[$this->yyidx + 0]->minor->bindVar; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4873 "sparql.php"
        break;
      case 239:
#line 410 "sparql.y"
{$yygotominor = $this->yystack[$this->yyidx + 0]->minor;}
#line 4878 "sparql.php"
        break;
      case 241:
#line 412 "sparql.y"
{ $tmp = $this->yystack[$this->yyidx + -3]->minor->noDuplicates($this->yystack[$this->yyidx + -2]->minor->ssVars, $this->yystack[$this->yyidx + -3]->minor->ssVars); if(isset($tmp)){throw new Exception("Variable is already in scope: " . $tmp);} else if(!empty($this->yystack[$this->yyidx + -2]->minor->bindVar)){ $tmp = $this->yystack[$this->yyidx + -3]->minor->noDuplicates($this->yystack[$this->yyidx + -2]->minor->bindVar, $this->yystack[$this->yyidx + -3]->minor->vars); if(isset($tmp)){throw new Exception("Bindvariable is already in scope: " . $tmp);}} $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -3]->minor->ssVars + $this->yystack[$this->yyidx + -2]->minor->ssVars; $yygotominor->bindVar = $this->yystack[$this->yyidx + -3]->minor->bindVar + $this->yystack[$this->yyidx + -2]->minor->bindVar; $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -2]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -2]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -2]->minor->query . ' .' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4883 "sparql.php"
        break;
      case 242:
#line 413 "sparql.y"
{ $tmp = $this->yystack[$this->yyidx + -2]->minor->noDuplicates($this->yystack[$this->yyidx + -1]->minor->ssVars, $this->yystack[$this->yyidx + -2]->minor->ssVars); if(isset($tmp)){throw new Exception("Variable is already in scope: " . $tmp);} else if(!empty($this->yystack[$this->yyidx + -1]->minor->bindVar)){ $tmp = $this->yystack[$this->yyidx + -2]->minor->noDuplicates($this->yystack[$this->yyidx + -1]->minor->bindVar, $this->yystack[$this->yyidx + -2]->minor->vars); if(isset($tmp)){throw new Exception("Bindvariable is already in scope: " . $tmp);}} $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars + $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->bindVar = $this->yystack[$this->yyidx + -2]->minor->bindVar + $this->yystack[$this->yyidx + -1]->minor->bindVar; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4888 "sparql.php"
        break;
      case 243:
#line 414 "sparql.y"
{ $tmp = $this->yystack[$this->yyidx + -2]->minor->noDuplicates($this->yystack[$this->yyidx + -1]->minor->ssVars, $this->yystack[$this->yyidx + -2]->minor->ssVars); if(isset($tmp)){throw new Exception("Variable is already in scope: " . $tmp);} else if(!empty($this->yystack[$this->yyidx + -1]->minor->bindVar)){ $tmp = $this->yystack[$this->yyidx + -2]->minor->noDuplicates($this->yystack[$this->yyidx + -1]->minor->bindVar, $this->yystack[$this->yyidx + -2]->minor->vars); if(isset($tmp)){throw new Exception("Bindvariable is already in scope: " . $tmp);}} $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars + $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->bindVar = $this->yystack[$this->yyidx + -2]->minor->bindVar + $this->yystack[$this->yyidx + -1]->minor->bindVar; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . ' .'; }
#line 4893 "sparql.php"
        break;
      case 244:
#line 415 "sparql.y"
{ $tmp = $this->yystack[$this->yyidx + -1]->minor->noDuplicates($this->yystack[$this->yyidx + 0]->minor->ssVars, $this->yystack[$this->yyidx + -1]->minor->ssVars); if(isset($tmp)){throw new Exception("Variable is already in scope: " . $tmp);} else if(!empty($this->yystack[$this->yyidx + 0]->minor->bindVar)){ $tmp = $this->yystack[$this->yyidx + -1]->minor->noDuplicates($this->yystack[$this->yyidx + 0]->minor->bindVar, $this->yystack[$this->yyidx + -1]->minor->vars); if(isset($tmp)){throw new Exception("Bindvariable is already in scope: " . $tmp);}} $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->bindVar = $this->yystack[$this->yyidx + -1]->minor->bindVar + $this->yystack[$this->yyidx + 0]->minor->bindVar; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4898 "sparql.php"
        break;
      case 245:
#line 416 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' .' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4903 "sparql.php"
        break;
      case 247:
#line 418 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' .'; }
#line 4908 "sparql.php"
        break;
      case 248:
      case 255:
      case 256:
      case 257:
      case 258:
      case 259:
      case 260:
      case 293:
      case 401:
      case 405:
      case 415:
      case 433:
      case 437:
      case 439:
      case 448:
      case 449:
#line 419 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4928 "sparql.php"
        break;
      case 261:
#line 434 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->bindVar = $this->yystack[$this->yyidx + 0]->minor->bindVar; $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4933 "sparql.php"
        break;
      case 263:
#line 437 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'OPTIONAL ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4938 "sparql.php"
        break;
      case 264:
#line 439 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'GRAPH ' . $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4943 "sparql.php"
        break;
      case 265:
#line 441 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'SERVICE SILENT ' . $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4948 "sparql.php"
        break;
      case 266:
#line 442 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'SERVICE ' . $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4953 "sparql.php"
        break;
      case 267:
#line 444 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->ssVars[$this->yystack[$this->yyidx + -1]->minor->query] = 1; $yygotominor->bindVar[$this->yystack[$this->yyidx + -1]->minor->query] = 1; $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . ' AS ' . $this->yystack[$this->yyidx + -1]->minor->query; }
#line 4958 "sparql.php"
        break;
      case 268:
      case 269:
      case 270:
      case 316:
      case 384:
      case 386:
      case 445:
#line 446 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4969 "sparql.php"
        break;
      case 271:
#line 451 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . ' { ' . $this->yystack[$this->yyidx + -1]->minor->query .  ' }'; }
#line 4974 "sparql.php"
        break;
      case 272:
#line 452 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . '{ }'; }
#line 4979 "sparql.php"
        break;
      case 273:
#line 453 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->count = $this->yystack[$this->yyidx + -1]->minor->count + 1; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4984 "sparql.php"
        break;
      case 274:
#line 454 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->count = 1; $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->query; }
#line 4989 "sparql.php"
        break;
      case 275:
#line 456 "sparql.y"
{if($this->yystack[$this->yyidx + -1]->minor->count > 0 ){if($this->yystack[$this->yyidx + -4]->minor->count == $this->yystack[$this->yyidx + -1]->minor->count){ $yygotominor = new NTToken(); $yygotominor->vars = $this->yystack[$this->yyidx + -4]->minor->vars; $yygotominor->query = '( ' . $this->yystack[$this->yyidx + -4]->minor->query . ' ) {' . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . ' }';}else{throw new Exception("Different Amount of Variables and Values for Value Clause : " . $this->yystack[$this->yyidx + -4]->minor->query . ' and ' . $this->yystack[$this->yyidx + -1]->minor->query);}}else{$yygotominor = new NTToken(); $yygotominor->addVars($this->yystack[$this->yyidx + -4]->minor->vars); $yygotominor->query = '( ' . $this->yystack[$this->yyidx + -4]->minor->query . ' ) {' . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query . ' }';}}
#line 4994 "sparql.php"
        break;
      case 276:
#line 457 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = '( ) { ' . $this->yystack[$this->yyidx + -1]->minor->query . ' }'; }
#line 4999 "sparql.php"
        break;
      case 277:
#line 458 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = '( ) { }'; }
#line 5004 "sparql.php"
        break;
      case 278:
#line 459 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' ( )'; }
#line 5009 "sparql.php"
        break;
      case 279:
      case 285:
      case 360:
      case 395:
#line 460 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = '( )'; }
#line 5017 "sparql.php"
        break;
      case 280:
#line 461 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->count = $this->yystack[$this->yyidx + -1]->minor->count + 1; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5022 "sparql.php"
        break;
      case 281:
#line 462 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->addVars($this->yystack[$this->yyidx + 0]->minor->vars); $yygotominor->count = 1; $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5027 "sparql.php"
        break;
      case 282:
#line 463 "sparql.y"
{if($this->yystack[$this->yyidx + -3]->minor->count > 0 ){if($this->yystack[$this->yyidx + -3]->minor->count == $this->yystack[$this->yyidx + -1]->minor->count){ $yygotominor = new NTToken(); $yygotominor->count = $this->yystack[$this->yyidx + -3]->minor->count; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . '( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )';}else{throw new Exception("Different Amount of Values for Value Clause : " . $this->yystack[$this->yyidx + -3]->minor->query . ' and ' . $this->yystack[$this->yyidx + -1]->minor->query);}}else{$yygotominor = new NTToken(); $yygotominor->count = $this->yystack[$this->yyidx + -1]->minor->count; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . PHP_EOL . '( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )';}}
#line 5032 "sparql.php"
        break;
      case 283:
#line 464 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . PHP_EOL . '( )'; }
#line 5037 "sparql.php"
        break;
      case 284:
#line 465 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->count = $this->yystack[$this->yyidx + -1]->minor->count; $yygotominor->query = '( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5042 "sparql.php"
        break;
      case 286:
      case 287:
      case 288:
      case 289:
      case 367:
      case 387:
      case 390:
      case 391:
      case 392:
      case 393:
      case 424:
      case 425:
      case 440:
      case 442:
      case 443:
      case 444:
      case 529:
#line 468 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5063 "sparql.php"
        break;
      case 290:
#line 472 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = 'UNDEF'; }
#line 5068 "sparql.php"
        break;
      case 291:
#line 474 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'MINUS ' . PHP_EOL .  $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5073 "sparql.php"
        break;
      case 294:
#line 478 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars + $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . ' UNION ' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5078 "sparql.php"
        break;
      case 295:
#line 479 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'UNION ' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5083 "sparql.php"
        break;
      case 296:
#line 481 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'FILTER ( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5088 "sparql.php"
        break;
      case 297:
      case 298:
#line 482 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'FILTER ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5094 "sparql.php"
        break;
      case 299:
#line 485 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasFNC = true; $yygotominor->hasAGG = true; $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5099 "sparql.php"
        break;
      case 300:
#line 487 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes; $yygotominor->query = '( DISTINCT' . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query .  ' )'; }
#line 5104 "sparql.php"
        break;
      case 301:
#line 488 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes; $yygotominor->query = '( ' . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query .  ' )'; }
#line 5109 "sparql.php"
        break;
      case 302:
      case 306:
#line 489 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = '( )' . PHP_EOL; }
#line 5115 "sparql.php"
        break;
      case 303:
#line 490 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ', ' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5120 "sparql.php"
        break;
      case 304:
#line 491 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = ', ' . PHP_EOL . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5125 "sparql.php"
        break;
      case 305:
#line 493 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = '( ' . $this->yystack[$this->yyidx + -2]->minor->query . PHP_EOL . $this->yystack[$this->yyidx + -1]->minor->query .  ' )'; }
#line 5130 "sparql.php"
        break;
      case 310:
#line 500 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' ' . $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5135 "sparql.php"
        break;
      case 312:
      case 329:
#line 502 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . '; ' . $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5141 "sparql.php"
        break;
      case 313:
      case 331:
#line 503 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query. ';'; }
#line 5147 "sparql.php"
        break;
      case 314:
      case 332:
#line 504 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '; ' . $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5153 "sparql.php"
        break;
      case 315:
      case 334:
#line 505 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = ';'; }
#line 5159 "sparql.php"
        break;
      case 317:
      case 356:
      case 366:
#line 508 "sparql.y"
{ if(!checkNS('rdf:type')){throw new Exception("Missing Prefix for rdf:type (a)");} $yygotominor = new NTToken(); $yygotominor->query = 'rdf:type'; }
#line 5166 "sparql.php"
        break;
      case 320:
      case 337:
#line 512 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ', ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5172 "sparql.php"
        break;
      case 321:
      case 338:
#line 513 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = ', ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5178 "sparql.php"
        break;
      case 325:
#line 519 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' ' . $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5183 "sparql.php"
        break;
      case 326:
#line 520 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' ' . $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5188 "sparql.php"
        break;
      case 328:
#line 522 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5193 "sparql.php"
        break;
      case 330:
#line 524 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -3]->minor->query . '; ' . $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5198 "sparql.php"
        break;
      case 333:
#line 527 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '; ' . ' ' . $this->yystack[$this->yyidx + -1]->minor->query . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5203 "sparql.php"
        break;
      case 335:
      case 339:
      case 343:
#line 530 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5210 "sparql.php"
        break;
      case 341:
#line 537 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . '|' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5215 "sparql.php"
        break;
      case 342:
#line 538 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '|' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5220 "sparql.php"
        break;
      case 345:
#line 542 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . '/' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5225 "sparql.php"
        break;
      case 346:
#line 543 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '/' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5230 "sparql.php"
        break;
      case 347:
#line 545 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5235 "sparql.php"
        break;
      case 349:
#line 548 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '^' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5240 "sparql.php"
        break;
      case 351:
#line 551 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = '*'; }
#line 5245 "sparql.php"
        break;
      case 352:
#line 552 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = '+'; }
#line 5250 "sparql.php"
        break;
      case 353:
#line 553 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = '?'; }
#line 5255 "sparql.php"
        break;
      case 354:
      case 359:
      case 374:
      case 377:
#line 555 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = '( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5263 "sparql.php"
        break;
      case 355:
#line 556 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '!' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5268 "sparql.php"
        break;
      case 358:
#line 560 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' ' . $this->yystack[$this->yyidx + -1]->minor->query; }
#line 5273 "sparql.php"
        break;
      case 361:
#line 563 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->addVars($this->yystack[$this->yyidx + 0]->minor->vars); $yygotominor->addBNodes($this->yystack[$this->yyidx + 0]->minor->bNodes); $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5278 "sparql.php"
        break;
      case 362:
#line 564 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' | ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5283 "sparql.php"
        break;
      case 363:
#line 565 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '| ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5288 "sparql.php"
        break;
      case 364:
#line 567 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = '^' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5293 "sparql.php"
        break;
      case 365:
#line 568 "sparql.y"
{ if(!checkNS('rdf:type')){throw new Exception("Missing Prefix for rdf:type (a)");} $yygotominor = new NTToken(); ; $yygotominor->query = '^rdf:type'; }
#line 5298 "sparql.php"
        break;
      case 370:
      case 373:
#line 575 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasBN = true; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = '[ ' . $this->yystack[$this->yyidx + -1]->minor->query . ' ]'; }
#line 5304 "sparql.php"
        break;
      case 385:
      case 394:
#line 597 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5310 "sparql.php"
        break;
      case 388:
      case 389:
#line 602 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->vars = array(); $yygotominor->vars[$this->yystack[$this->yyidx + 0]->minor->value] = 1; $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->value; }
#line 5316 "sparql.php"
        break;
      case 396:
      case 400:
      case 404:
      case 414:
      case 432:
#line 612 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5325 "sparql.php"
        break;
      case 397:
#line 613 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor);$yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5330 "sparql.php"
        break;
      case 398:
#line 614 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' || ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5335 "sparql.php"
        break;
      case 399:
#line 615 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '|| ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5340 "sparql.php"
        break;
      case 402:
#line 619 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' && ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5345 "sparql.php"
        break;
      case 403:
#line 620 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '&& ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5350 "sparql.php"
        break;
      case 406:
#line 624 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '= ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5355 "sparql.php"
        break;
      case 407:
#line 625 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '!= ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5360 "sparql.php"
        break;
      case 408:
#line 626 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '< ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5365 "sparql.php"
        break;
      case 409:
#line 627 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '> ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5370 "sparql.php"
        break;
      case 410:
#line 628 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '<= ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5375 "sparql.php"
        break;
      case 411:
#line 629 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '>= ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5380 "sparql.php"
        break;
      case 412:
#line 630 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'IN' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5385 "sparql.php"
        break;
      case 413:
#line 631 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'NOT IN' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5390 "sparql.php"
        break;
      case 416:
      case 417:
#line 635 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' ' . $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5396 "sparql.php"
        break;
      case 418:
      case 419:
#line 637 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5402 "sparql.php"
        break;
      case 420:
#line 639 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' + ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5407 "sparql.php"
        break;
      case 421:
#line 640 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' - ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5412 "sparql.php"
        break;
      case 422:
      case 423:
#line 641 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . ' ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5418 "sparql.php"
        break;
      case 426:
      case 435:
#line 645 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '+ ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5424 "sparql.php"
        break;
      case 427:
      case 436:
#line 646 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '- ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5430 "sparql.php"
        break;
      case 428:
      case 429:
#line 647 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -2]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -2]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -2]->minor->vars + $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -2]->minor->bNodes + $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . ' * ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5436 "sparql.php"
        break;
      case 430:
#line 649 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '* ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5441 "sparql.php"
        break;
      case 431:
#line 650 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '/ ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5446 "sparql.php"
        break;
      case 434:
#line 655 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = '! ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5451 "sparql.php"
        break;
      case 438:
#line 660 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + -1]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = '( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5456 "sparql.php"
        break;
      case 441:
#line 663 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasFNC = true; $yygotominor->hasAGG = true; $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5461 "sparql.php"
        break;
      case 450:
      case 451:
#line 673 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'STR( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5467 "sparql.php"
        break;
      case 452:
#line 675 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'LANGMATCHES( ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5472 "sparql.php"
        break;
      case 453:
#line 676 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'DATATYPE( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5477 "sparql.php"
        break;
      case 454:
#line 677 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->query = 'BOUND( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5482 "sparql.php"
        break;
      case 455:
#line 678 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'URI( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5487 "sparql.php"
        break;
      case 456:
#line 679 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasBN = true; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes[$this->yystack[$this->yyidx + -1]->minor->query] = 1; $yygotominor->addBNodes($this->yystack[$this->yyidx + -1]->minor->bNodes); $yygotominor->query = 'BNODE( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5492 "sparql.php"
        break;
      case 457:
#line 680 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasBN = true; $yygotominor->query = 'BNODE( )'; }
#line 5497 "sparql.php"
        break;
      case 458:
#line 681 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = 'RAND( )'; }
#line 5502 "sparql.php"
        break;
      case 459:
#line 682 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'ABS(' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5507 "sparql.php"
        break;
      case 460:
#line 683 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars;$yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'CEIL(' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5512 "sparql.php"
        break;
      case 461:
#line 684 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'FLOOR(' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5517 "sparql.php"
        break;
      case 462:
#line 685 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'ROUND(' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5522 "sparql.php"
        break;
      case 463:
#line 686 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars;$yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'CONCAT' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5527 "sparql.php"
        break;
      case 465:
#line 688 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'STRLEN( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5532 "sparql.php"
        break;
      case 467:
#line 690 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'UCASE( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5537 "sparql.php"
        break;
      case 468:
#line 691 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query =  'LCASE( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5542 "sparql.php"
        break;
      case 469:
#line 692 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'ENCODE_FOR_URI( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5547 "sparql.php"
        break;
      case 470:
#line 693 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'CONTAINS( ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query .  ' )'; }
#line 5552 "sparql.php"
        break;
      case 471:
#line 694 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'STRSTARTS( ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query .  ' )'; }
#line 5557 "sparql.php"
        break;
      case 472:
#line 695 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'STRENDS( ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query .  ' )'; }
#line 5562 "sparql.php"
        break;
      case 473:
#line 696 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'STBEFORE( ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query .  ' )'; }
#line 5567 "sparql.php"
        break;
      case 474:
#line 697 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'STRAFTER( ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query .  ' )'; }
#line 5572 "sparql.php"
        break;
      case 475:
#line 698 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'YEAR( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5577 "sparql.php"
        break;
      case 476:
#line 699 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'MONTH( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5582 "sparql.php"
        break;
      case 477:
#line 700 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'DAY( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5587 "sparql.php"
        break;
      case 478:
#line 701 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'HOURS( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5592 "sparql.php"
        break;
      case 479:
#line 702 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'MINUTES( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5597 "sparql.php"
        break;
      case 480:
#line 703 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'SECONDS( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5602 "sparql.php"
        break;
      case 481:
#line 704 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'TIMEZONE( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5607 "sparql.php"
        break;
      case 482:
#line 705 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'TZ( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5612 "sparql.php"
        break;
      case 483:
#line 706 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = 'NOW( )'; }
#line 5617 "sparql.php"
        break;
      case 484:
#line 707 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = 'UUID( )'; }
#line 5622 "sparql.php"
        break;
      case 485:
#line 708 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = 'STRUUID( )'; }
#line 5627 "sparql.php"
        break;
      case 486:
#line 709 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'MD5( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5632 "sparql.php"
        break;
      case 487:
#line 710 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'SHA1( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5637 "sparql.php"
        break;
      case 488:
#line 711 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'SHA256( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5642 "sparql.php"
        break;
      case 489:
#line 712 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'SHA384( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5647 "sparql.php"
        break;
      case 490:
#line 713 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'SHA512( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5652 "sparql.php"
        break;
      case 491:
#line 714 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'COALESCE' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5657 "sparql.php"
        break;
      case 492:
#line 715 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -5]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -5]->minor->vars + $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -5]->minor->bNodes + $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'IF( ' . $this->yystack[$this->yyidx + -5]->minor->query . ', ' . $this->yystack[$this->yyidx + -3]->minor->query .  ', ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5662 "sparql.php"
        break;
      case 493:
#line 716 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->addVars($this->yystack[$this->yyidx + -3]->minor->vars); $yygotominor->addVars($this->yystack[$this->yyidx + -1]->minor->vars); $yygotominor->addBNodes($this->yystack[$this->yyidx + -3]->minor->bNodes); $yygotominor->addBNodes($this->yystack[$this->yyidx + -1]->minor->bNodes); $yygotominor->query = 'STRLANG( ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query .  ' )'; }
#line 5667 "sparql.php"
        break;
      case 494:
#line 717 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'STRDT( ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query .  ' )'; }
#line 5672 "sparql.php"
        break;
      case 495:
#line 718 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'SAMETERM( ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query .  ' )'; }
#line 5677 "sparql.php"
        break;
      case 496:
#line 719 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'ISIRI( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5682 "sparql.php"
        break;
      case 497:
#line 720 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'ISURI( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5687 "sparql.php"
        break;
      case 498:
#line 721 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'ISBLANK( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5692 "sparql.php"
        break;
      case 499:
#line 722 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'ISLITERAL( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5697 "sparql.php"
        break;
      case 500:
#line 723 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'ISNUMERIC( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5702 "sparql.php"
        break;
      case 501:
#line 725 "sparql.y"
{ $yygotominor = new NTToken; $yygotominor->copyBools($this->yystack[$this->yyidx + -5]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -5]->minor->vars + $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -5]->minor->bNodes + $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'REGEX( ' . $this->yystack[$this->yyidx + -5]->minor->query . ', ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5707 "sparql.php"
        break;
      case 502:
#line 726 "sparql.y"
{ $yygotominor = new NTToken; $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'REGEX( ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5712 "sparql.php"
        break;
      case 503:
#line 728 "sparql.y"
{ $yygotominor = new NTToken; $yygotominor->copyBools($this->yystack[$this->yyidx + -5]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -5]->minor->vars + $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -5]->minor->bNodes + $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'SUBSTR( ' . $this->yystack[$this->yyidx + -5]->minor->query . ', ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5717 "sparql.php"
        break;
      case 504:
#line 729 "sparql.y"
{ $yygotominor = new NTToken; $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'SUBSTR( ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5722 "sparql.php"
        break;
      case 505:
#line 731 "sparql.y"
{ $yygotominor = new NTToken; $yygotominor->copyBools($this->yystack[$this->yyidx + -7]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -5]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -7]->minor->vars + $this->yystack[$this->yyidx + -5]->minor->vars + $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -7]->minor->bNodes + $this->yystack[$this->yyidx + -5]->minor->bNodes + $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'REPLACE( ' . $this->yystack[$this->yyidx + -7]->minor->query . ', ' . $this->yystack[$this->yyidx + -5]->minor->query . ', ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5727 "sparql.php"
        break;
      case 506:
#line 732 "sparql.y"
{ $yygotominor = new NTToken; $yygotominor->copyBools($this->yystack[$this->yyidx + -5]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -3]->minor); $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -5]->minor->vars + $this->yystack[$this->yyidx + -3]->minor->vars + $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -5]->minor->bNodes + $this->yystack[$this->yyidx + -3]->minor->bNodes + $this->yystack[$this->yyidx + -1]->minor->bNodes; $yygotominor->query = 'REPLACE( ' . $this->yystack[$this->yyidx + -5]->minor->query . ', ' . $this->yystack[$this->yyidx + -3]->minor->query . ', ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; }
#line 5732 "sparql.php"
        break;
      case 507:
#line 734 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'EXISTS ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5737 "sparql.php"
        break;
      case 508:
#line 736 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->copyBools($this->yystack[$this->yyidx + 0]->minor); $yygotominor->ssVars = $this->yystack[$this->yyidx + 0]->minor->ssVars; $yygotominor->vars = $this->yystack[$this->yyidx + 0]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + 0]->minor->bNodes; $yygotominor->query = 'NOT EXISTS ' . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5742 "sparql.php"
        break;
      case 509:
#line 738 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'COUNT( DISTINCT * )'; }
#line 5747 "sparql.php"
        break;
      case 510:
#line 739 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'COUNT( DISTINCT ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; }
#line 5752 "sparql.php"
        break;
      case 511:
#line 740 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'COUNT( * )'; }
#line 5757 "sparql.php"
        break;
      case 512:
#line 741 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'COUNT( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; }
#line 5762 "sparql.php"
        break;
      case 513:
#line 742 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'SUM( DISTINCT ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; }
#line 5767 "sparql.php"
        break;
      case 514:
#line 743 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'MIN( DISTINCT ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; }
#line 5772 "sparql.php"
        break;
      case 515:
#line 744 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'MAX( DISTINCT ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; }
#line 5777 "sparql.php"
        break;
      case 516:
#line 745 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'AVG( DISTINCT ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; }
#line 5782 "sparql.php"
        break;
      case 517:
#line 746 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'SAMPLE( DISTINCT ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; }
#line 5787 "sparql.php"
        break;
      case 518:
#line 747 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'SUM( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; }
#line 5792 "sparql.php"
        break;
      case 519:
#line 748 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'MIN( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; }
#line 5797 "sparql.php"
        break;
      case 520:
#line 749 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'MAX( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; }
#line 5802 "sparql.php"
        break;
      case 521:
#line 750 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'AVG( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; }
#line 5807 "sparql.php"
        break;
      case 522:
#line 751 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'SAMPLE( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; }
#line 5812 "sparql.php"
        break;
      case 523:
#line 752 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'GROUP_CONCAT( DISTINCT ' . $this->yystack[$this->yyidx + -5]->minor->query . ' ; SEPARATOR = ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -5]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -5]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -5]->minor->bNodes; }
#line 5817 "sparql.php"
        break;
      case 524:
#line 753 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'GROUP_CONCAT( DISTINCT ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; }
#line 5822 "sparql.php"
        break;
      case 525:
#line 754 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'GROUP_CONCAT( ' . $this->yystack[$this->yyidx + -5]->minor->query . ' ; SEPARATOR = ' $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -5]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -5]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -5]->minor->bNodes; }
#line 5827 "sparql.php"
        break;
      case 526:
#line 755 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->hasAGG = true; $yygotominor->query = 'GROUP_CONCAT( ' . $this->yystack[$this->yyidx + -1]->minor->query . ' )'; $yygotominor->copyBools($this->yystack[$this->yyidx + -1]->minor); $yygotominor->vars = $this->yystack[$this->yyidx + -1]->minor->vars; $yygotominor->bNodes = $this->yystack[$this->yyidx + -1]->minor->bNodes; }
#line 5832 "sparql.php"
        break;
      case 527:
#line 757 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + -1]->minor->query . $this->yystack[$this->yyidx + 0]->minor->value; }
#line 5837 "sparql.php"
        break;
      case 528:
#line 758 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + -2]->minor->query . $this->yystack[$this->yyidx + -1]->minor->value . $this->yystack[$this->yyidx + 0]->minor->query; }
#line 5842 "sparql.php"
        break;
      case 533:
      case 534:
      case 535:
      case 536:
      case 537:
      case 538:
#line 765 "sparql.y"
{$yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->value; }
#line 5852 "sparql.php"
        break;
      case 539:
      case 540:
      case 541:
#line 773 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->value; }
#line 5859 "sparql.php"
        break;
      case 542:
#line 777 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = "true";}
#line 5864 "sparql.php"
        break;
      case 543:
#line 778 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = "false";}
#line 5869 "sparql.php"
        break;
      case 544:
      case 545:
      case 546:
      case 547:
#line 780 "sparql.y"
{ $yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->value;}
#line 5877 "sparql.php"
        break;
      case 548:
#line 785 "sparql.y"
{ if(!$this->checkBase($this->yystack[$this->yyidx + 0]->minor->value)){throw new Exception("Missing Base for " . $this->yystack[$this->yyidx + 0]->minor->value);} $yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->value;}
#line 5882 "sparql.php"
        break;
      case 550:
      case 551:
#line 788 "sparql.y"
{if(!$this->checkNS($this->yystack[$this->yyidx + 0]->minor->value)){$throw new Exception("Missing Prefix for " . $this->yystack[$this->yyidx + 0]->minor->value);} $yygotominor = new NTToken(); $yygotominor->query = $this->yystack[$this->yyidx + 0]->minor->value;}
#line 5888 "sparql.php"
        break;
      case 552:
#line 791 "sparql.y"
{$yygotominor = new NTToken(); $yygotominor->hasBN = true; $yygotominor->bNodes[$this->yystack[$this->yyidx + 0]->minor->value] = 1;}
#line 5893 "sparql.php"
        break;
      case 553:
#line 792 "sparql.y"
{$yygotominor = new NTToken(); $yygotominor->hasBN = true;}
#line 5898 "sparql.php"
        break;
  };
  $yygoto = self::$yyRuleInfo[2*$yyruleno];
  $yysize = self::$yyRuleInfo[(2*$yyruleno)+1];

  $state_for_reduce = $this->yystack[$this->yyidx - $yysize]->stateno;
  
  $this->yyidx -= $yysize;
  $yyact = $this->yy_find_reduce_action($state_for_reduce,$yygoto);
  if( $yyact < self::YYNSTATE ){
    $this->yy_shift($yyact, $yygoto, $yygotominor);
  }else if( $yyact == self::YYNSTATE + self::YYNRULE + 1 ){
    $this->yy_accept();
  }
}

/*
** The following code executes when the parse fails
*/
private function yy_parse_failed(
){
  if( $this->yyTraceFILE ){
    fprintf($this->yyTraceFILE,"%sFail!\n",$this->yyTracePrompt);
  }
  while( $this->yyidx>=0 ) $this->yy_pop_parser_stack();
  /* Here code is inserted which will be executed whenever the
  ** parser fails */
#line 116 "sparql.y"

    /*transfer somehow execution class and write the error into it maybe? maybe as fourth parameter (kinda wasteful as every token will throw it in the parser again)*/
#line 5930 "sparql.php"
}

/*
** The following code executes when a syntax error first occurs.
*/
private function yy_syntax_error(
  $yymajor,                   /* The major type of the error token */
  $yyminor            /* The minor type of the error token */
){
}

/*
** The following is executed when the parser accepts
*/
private function yy_accept(
){
  if( $this->yyTraceFILE ){
    fprintf($this->yyTraceFILE,"%sAccept!\n",$this->yyTracePrompt);
  }
  while( $this->yyidx>=0 ) $this->yy_pop_parser_stack();
  /* Here code is inserted which will be executed whenever the
  ** parser accepts */
#line 111 "sparql.y"

print('Success');

#line 5958 "sparql.php"
}

/* The main parser program.
** The first argument is a pointer to a structure obtained from
** "SparqlPHPAlloc" which describes the current state of the parser.
** The second argument is the major token number.  The third is
** the minor token.  The fourth optional argument is whatever the
** user wants (and specified in the grammar) and is available for
** use by the action routines.
**
** Inputs:
** <ul>
** <li> A pointer to the parser (an opaque structure.)
** <li> The major token number.
** <li> The minor token number.
** <li> An option argument of a grammar-specified type.
** </ul>
**
** Outputs:
** None.
*/
function SparqlPHP(
  $yymajor,                 /* The major token code number */
  $yyminor = null           /* The value for the token */
){
  $yyact = 0;            /* The parser action. */
  $yyendofinput = 0;     /* True if we are at the end of input */
  $yyerrorhit = 0;   /* True if yymajor has invoked an error */

  /* (re)initialize the parser, if necessary */
  if( $this->yyidx<0 ){
    $this->yyidx = 0;
    $this->yyerrcnt = -1;
    $ent = new SparqlPHPyyStackEntry;
    $ent->stateno = 0;
    $ent->major = 0;
    $this->yystack = array( 0 => $ent );

    $this->YY_NO_ACTION = self::YYNSTATE + self::YYNRULE + 2;
    $this->YY_ACCEPT_ACTION  = self::YYNSTATE + self::YYNRULE + 1;
    $this->YY_ERROR_ACTION   = self::YYNSTATE + self::YYNRULE;
  }
  $yyendofinput = ($yymajor==0);

  if( $this->yyTraceFILE ){
    fprintf($this->yyTraceFILE,"%sInput %s\n",$this->yyTracePrompt,
      self::$yyTokenName[$yymajor]);
  }

  do{
    $yyact = $this->yy_find_shift_action($yymajor);
    if( $yyact<self::YYNSTATE ){
      $this->yy_shift($yyact,$yymajor,$yyminor);
      $this->yyerrcnt--;
      if( $yyendofinput && $this->yyidx>=0 ){
        $yymajor = 0;
      }else{
        $yymajor = self::YYNOCODE;
      }
    }else if( $yyact < self::YYNSTATE + self::YYNRULE ){
      $this->yy_reduce($yyact-self::YYNSTATE);
    }else if( $yyact == $this->YY_ERROR_ACTION ){
      if( $this->yyTraceFILE ){
        fprintf($this->yyTraceFILE,"%sSyntax Error!\n",$this->yyTracePrompt);
      }
if (self::YYERRORSYMBOL) {
      /* A syntax error has occurred.
      ** The response to an error depends upon whether or not the
      ** grammar defines an error token "ERROR".  
      **
      ** This is what we do if the grammar does define ERROR:
      **
      **  * Call the %syntax_error function.
      **
      **  * Begin popping the stack until we enter a state where
      **    it is legal to shift the error symbol, then shift
      **    the error symbol.
      **
      **  * Set the error count to three.
      **
      **  * Begin accepting and shifting new tokens.  No new error
      **    processing will occur until three tokens have been
      **    shifted successfully.
      **
      */
      if( $this->yyerrcnt<0 ){
        $this->yy_syntax_error($yymajor, $yyminor);
      }
      $yymx = $this->yystack[$this->yyidx]->major;
      if( $yymx==self::YYERRORSYMBOL || $yyerrorhit ){
        if( $this->yyTraceFILE ){
          fprintf($this->yyTraceFILE,"%sDiscard input token %s\n",
             $this->yyTracePrompt,self::$yyTokenName[$yymajor]);
        }
        $this->yy_destructor($yymajor,$yyminor);
        $yymajor = self::YYNOCODE;
      }else{
         while(
          $this->yyidx >= 0 &&
          $yymx != self::YYERRORSYMBOL &&
          ($yyact = $this->yy_find_reduce_action(
                        $this->yystack[$this->yyidx]->stateno,
                        self::YYERRORSYMBOL)) >= self::YYNSTATE
        ){
          $this->yy_pop_parser_stack();
        }
        if( $this->yyidx < 0 || $yymajor==0 ){
          $this->yy_destructor($yymajor,$yyminor);
          $this->yy_parse_failed();
          $yymajor = self::YYNOCODE;
        }else if( $yymx!=self::YYERRORSYMBOL ){
          $this->yy_shift($yyact,self::YYERRORSYMBOL,0);
        }
      }
      $this->yyerrcnt = 3;
      $yyerrorhit = 1;
} else {  /* YYERRORSYMBOL is not defined */
      /* This is what we do if the grammar does not define ERROR:
      **
      **  * Report an error message, and throw away the input token.
      **
      **  * If the input token is $, then fail the parse.
      **
      ** As before, subsequent error messages are suppressed until
      ** three input tokens have been successfully shifted.
      */
      if( $this->yyerrcnt<=0 ){
        $this->yy_syntax_error($yymajor, $yyminor);
      }
      $this->yyerrcnt = 3;
      $this->yy_destructor($yymajor,$yyminor);
      if( $yyendofinput ){
        $this->yy_parse_failed();
      }
      $yymajor = self::YYNOCODE;
}
    }else{
      $this->yy_accept();
      $yymajor = self::YYNOCODE;
    }
  }while( $yymajor!=self::YYNOCODE && $this->yyidx>=0 );
}

}
