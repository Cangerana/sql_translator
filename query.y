%{
    #include<stdio.h>
    #include <stdlib.h>
    #include <string.h>
    FILE *output_query;
    int yyerror();
    int yylex();
    char *where = "";

    void write(char *p1, char *p2) {
      fprintf(output_query, p1, p2);
    }

    char *add_two_str(char * left_param, char * rigth_param) {
      char *file_content = malloc(sizeof(left_param)*153 + sizeof(rigth_param)*2);

      sprintf(file_content,"%s%s", left_param, rigth_param);

      return file_content;
    }

    char *add_three_str(char * left_param, char * midle_param, char * rigth_param) {
      char *file_content = malloc(sizeof(left_param)*153 + sizeof(midle_param) + sizeof(rigth_param));

      sprintf(file_content,"%s%s%s", left_param, midle_param, rigth_param);

      return file_content;
    }
%}

%union {
	char *p_string;
	int   yint;
}
%start start
%token <p_string> IDENTIFIER
%token <p_string> STRING
%token <p_string> NUMERIC
%token <p_string> AND OR NOT
%token <p_string> UNION DIFFERENCE INTERCECTION PRODUCT
%token <p_string> JOIN LEFT_JOIN RIGTH_JOIN OUTER_JOIN
%token <p_string> ADD SUB MUL DIV MOD EXP ANDB ORB XORB NOTB LFT RGT
%token PROJECTION SELECTION 
%token LB RB COMMA GTEQ LTEQ EQ GT LT DF
%type <p_string> condition
%type <p_string> exp
%type <p_string> type_join
%type <p_string> operator
%type <p_string> set

%%
start: 
| agebra
;

agebra : query
| agebra set { write("%s\n", $2); } agebra
| LB { write("(\n", ""); } agebra RB { write(")\n", ""); }
;

query : projection { write("FROM ", ""); } tables_from where { where = "";}
| { write("SELECT *\nFROM ", ""); } tables_from where { where = "";}
;

projection : PROJECTION { write("SELECT %s\n", ""); } identifiers
;

identifiers : IDENTIFIER { write("  %s\n", $1); }
| IDENTIFIER { write("  %s,\n", $1); } COMMA identifiers
;

tables_from : IDENTIFIER { write("%s\n", $1); } joins
| LB tables_from RB joins
| tables_from { write(", ", ""); } PRODUCT tables_from
| conditions tables_from
;

joins : 
| type_join { write("%s", $1); } tables_join
| type_join { write("%s (\n", $1); } projection { write("FROM ", ""); } tables_from { write(")\n", ""); }
;

type_join : JOIN { $$ = "INNER JOIN "; }
| LEFT_JOIN { $$ = "LEFT JOIN "; }
| RIGTH_JOIN { $$ = "RIGTH JOIN "; }
| OUTER_JOIN { $$ = "FULL OUTER JOIN "; }
;

tables_join : IDENTIFIER { write("%s\n", $1); } joins
| LB tables_join RB joins
/* | conditions tables_join */
| condition { write("ON %s\n", $1); } table joins
| LB tables_join RB PRODUCT tables_join
;

table : IDENTIFIER { write("%s\n", $1); }
| LB IDENTIFIER RB { write("%s\n", $2); } joins
;

conditions : SELECTION condition { 
  if (where == "") where = $2;
  else where = add_three_str(where, " AND ", $2);
}
| LB conditions RB tables_join
;

condition : exp
| LB condition RB { $$ = add_three_str("(", $2, ")"); }
| condition operator condition { $$ = add_three_str($1, $2, $3); }
;

operator : AND  { $$ = " AND "; }
| OR { $$ = " OR "; }
| NOT { $$ = " NOT "; }
;

set : UNION { $$ = "\n\nUNION\n\n"; }
| DIFFERENCE { $$ = "\n\nEXCEPT\n\n"; }
| INTERCECTION { $$ = "\n\nINTERCECTION\n\n"; }
;

where : { if (where != "") { write("WHERE\n %s\n", where); } }
;

exp : { $$ = ""; }
| NUMERIC
| IDENTIFIER
| STRING
| exp GTEQ exp { $$ = add_three_str($1, " >= ", $3); }
| exp LTEQ exp { $$ = add_three_str($1, " <= ", $3); }
| exp LT exp { $$ = add_three_str($1, " < ", $3); }
| exp EQ exp { $$ = add_three_str($1, " = ", $3); }
| exp DF exp { $$ = add_three_str($1, " != ", $3); }
| exp GT exp { $$ = add_three_str($1, " > ", $3); }
| exp ADD exp { $$ = add_three_str($1, " + ", $3); }
| exp SUB exp { $$ = add_three_str($1, " - ", $3); }
| exp MUL exp { $$ = add_three_str($1, " * ", $3); }
| exp DIV exp { $$ = add_three_str($1, " / ", $3); }
| exp MOD exp { $$ = add_three_str($1, " % ", $3); }
| exp EXP exp { $$ = add_three_str($1, " ^ ", $3); }
| exp ANDB exp { $$ = add_three_str($1, " & ", $3); }
| exp ORB exp { $$ = add_three_str($1, " | ", $3); }
| exp XORB exp { $$ = add_three_str($1, " # ", $3); }
| exp NOTB exp { $$ = add_three_str($1, " ~ ", $3); }
| exp LFT exp { $$ = add_three_str($1, " << ", $3); }
| exp RGT exp { $$ = add_three_str($1, " >> ", $3); }
| LB exp RB { $$ = add_three_str("( ", $2, " )"); }
;
%%

int yyerror() {
	printf("Error \n");
  return 1;
}

int main() {

    output_query = fopen ("output_query.sql", "w");

    yyparse();
  
  return 1;
}
