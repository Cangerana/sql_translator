%{
  #include "y.tab.h"
  #include<stdlib.h>
  #include<stdio.h>
%}
%option yylineno

ALL_DIGITS [\nA-Za-z0-9!#$%&'()*+,-./:;?@[\\\]_`{|}~  ]*
IDENTIFIER [A-Za-z][A-Za-z0-9_\.]+
NUMBER [0-9]+

COMMENT --{ALL_DIGITS}

UNION "U"
DIFFERENCE "-"
INTERCECTION "∩"
PRODUCT "x"

AND "and"
OR "or"

COMMA ","
GTEQ ">="
LTEQ "<="
LT "<"
EQ "="
DF "!="
GT ">"

STRING '{ALL_DIGITS}'
NUMERIC {NUMBER}

PROJECTION projection
SELECTION selection
JOIN "|x|"
LEFT_JOIN "=|x|"
RIGTH_JOIN "|x|="
OUTER_JOIN "=|x|="


%%

{PROJECTION}   { return PROJECTION; }
{SELECTION}    { return SELECTION; }
{AND}          { return AND; }
{OR}           { return OR; }
{UNION}        { return UNION; }
{DIFFERENCE}   { return DIFFERENCE; }
{INTERCECTION} { return INTERCECTION; }
{PRODUCT}      { return PRODUCT; }
{IDENTIFIER}   { /*printf("aaahh %s\n", yytext);*/ yylval.p_string=malloc(yyleng); sprintf(yylval.p_string,"%s",yytext); return IDENTIFIER;}
{STRING}       { /*printf("STRING %s\n", yytext);*/ yylval.p_string=malloc(yyleng); sprintf(yylval.p_string,"%s",yytext);return STRING; }
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
{GT}           { return GT; }
{COMMA}        { return COMMA; }
{COMMENT}      { /* ignoring comments */ }
{NUMERIC}      { yylval.p_string=malloc(yyleng); sprintf(yylval.p_string,"%s",yytext); return NUMERIC; }
[\n\t ]+       { /* ignoring newlines, tabs and spaces */ }

%%