/*
 * This file is part of flex.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of the University nor the names of its contributors
 * may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE.
 */

%{
/* A template scanner file to build "scanner.c". */
#include <stdio.h>
#include <stdlib.h>
#include "config.h"
%}

%option 8bit
%option nounput nomain noyywrap 
%option warn yylineno



%%

foo|bar         ;
[[:digit:]]+    ;
[[:blank:]]+    ;
.|\n            ;
%%

int main ( int argc, char** argv )
{
    FILE* fp = NULL;
    void *yyscanner=0;
    
#ifdef YY_TYPEDEF_YY_SCANNER_T
#define YY_CALL_ONLY_ARG yyscanner
#define YY_CALL_LAST_ARG ,yyscanner
    yylex_init(&yyscanner);
#else
#define YY_CALL_ONLY_ARG
#define YY_CALL_LAST_ARG
#endif

#ifdef YYTABLES_NAME
    if((fp  = fopen(argv[1],"r"))== NULL)
        yy_fatal_error("could not open tables file for reading" YY_CALL_LAST_ARG);

    if(yytables_fload(fp YY_CALL_LAST_ARG) < 0)
        yy_fatal_error("yytables_fload returned < 0" YY_CALL_LAST_ARG);
#endif
    
    if(argc > 2){
        if((fp  = fopen(argv[2],"r"))== NULL)
            yy_fatal_error("could not open input file for reading" YY_CALL_LAST_ARG);
#ifdef YY_TYPEDEF_YY_SCANNER_T
        yyset_in (fp, yyscanner);
#else
        yyin = fp;
#endif
    }
    while(yylex(YY_CALL_ONLY_ARG) != 0)
        ;
        
#ifdef YYTABLES_NAME
    yytables_destroy(YY_CALL_ONLY_ARG);
#endif
    yylex_destroy(YY_CALL_ONLY_ARG);

    if(argc < 0) /* silence the compiler */
        yyscanner = (void*)fp;

    return 0;
}
