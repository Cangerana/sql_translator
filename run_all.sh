clear
if flex query.l ; then
    if yacc -d query.y ; then
        if gcc lex.yy.c y.tab.c -o query -lfl ; then
            ./query < input.txt 
            cat output_query.sql
        fi
    fi
fi

rm lex.yy.c query y.tab.c y.tab.h