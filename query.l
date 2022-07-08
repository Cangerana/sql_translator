%{
  #include "y.tab.h"
  #include<stdlib.h>
  #include<stdio.h>
%}
%option yylineno

OPEN_COMMENT "--"

ALL_DIGITS [><!=∩A-Za-z0-9!#$%&'()*+,-./:;?@[\\\]_`{|}~ ]*

COMMENT {OPEN_COMMENT}{ALL_DIGITS}

IDENTIFIER [A-Za-z][A-Za-z0-9_\.]+

NUMBER [0-9]+

UNION "U"
DIFFERENCE "\\"
INTERCECTION "∩"
PRODUCT "X"

AND "and"
OR "or"
NOT "not"

COMMA ","
GTEQ ">="
LTEQ "<="
LT "<"
EQ "="
DF "!="|"<>"
GT ">"

ADD "+"
SUB "-"
MUL "*"
DIV "/"
MOD "%"
EXP "^"
ANDB "&"
ORB "|"
XORB "#"
NOTB "~"
LFT "<<"
RGT ">>"

STRING '{ALL_DIGITS}'
NUMERIC {NUMBER}

PROJECTION projection
SELECTION selection
JOIN "|x|"
LEFT_JOIN "=|x|"
RIGTH_JOIN "|x|="
OUTER_JOIN "=|x|="


%%

{COMMENT}      { /* ignoring comments */ }
{UNION}        { return UNION; }
{PRODUCT}      { return PRODUCT; }
{DIFFERENCE}   { return DIFFERENCE; }
{INTERCECTION} { return INTERCECTION; }
{PROJECTION}   { return PROJECTION; }
{SELECTION}    { return SELECTION; }
{AND}          { return AND; }
{OR}           { return OR; }
{NOT}          { return NOT; }
{IDENTIFIER}   { yylval.p_string=malloc(yyleng); sprintf(yylval.p_string,"%s",yytext); return IDENTIFIER;}
{STRING}       { yylval.p_string=malloc(yyleng); sprintf(yylval.p_string,"%s",yytext);return STRING; }
{OUTER_JOIN}   { return OUTER_JOIN; }
{LEFT_JOIN}    { return LEFT_JOIN; }
{RIGTH_JOIN}   { return RIGTH_JOIN; }
{JOIN}         { return JOIN; }
"("            { return LB; }
")"            { return RB; }
{GTEQ}         { return GTEQ; }
{LTEQ}         { return LTEQ; }
{LT}           { return LT; }
{EQ}           { return EQ; }
{DF}           { return DF; }
{GT}           { printf("aaahh %s\n", yytext); return GT; }
{ADD}          { return ADD; }
{SUB}          { return SUB; }
{MUL}          { return MUL; }
{DIV}          { return DIV; }
{MOD}          { return MOD; }
{EXP}          { return EXP; }
{ANDB}         { return ANDB; }
{ORB}          { return ORB; }
{XORB}         { return XORB; }
{NOTB}         { return NOTB; }
{LFT}          { return LFT; }
{RGT}          { return RGT; }
{COMMA}        { return COMMA; }
{NUMERIC}      { yylval.p_string=malloc(yyleng); sprintf(yylval.p_string,"%s",yytext); return NUMERIC; }
[\n\t ]+       { /* ignoring newlines, tabs and spaces */ }

%%