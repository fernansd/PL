/*
	Enunciado: Sumar
	Codifica un programa en flex que copie el archivo de entrada en uno de 
	salida, poniendo a 0 a todo número positivo que sea múltiplo de 3.
 */

%{

%}

digito [0-9]
numero {digito}+

%%

{numero}		{
					int numero = atoi(yytext);
					if (numero % 3 == 0)
						numero = 0;
						
					fprintf(yyout, "%2d", numero);
				}

.				{ ECHO; }

%%

extern FILE *yyin, *yyout;
void  main(int argc, char *argv[])
{
	switch(argc)
	{
		case 2: yyin=fopen(argv[1],"r"); 
				break;
		case 3: yyin=fopen(argv[1],"r"); 
				yyout=fopen(argv[2],"w");
		default:
			printf("\nNúmero de parámetros incorrecto\n");
			printf("LLamar: %s <fichero-entrada>  [<fichero-salida>]");
			exit(-1);
	}
	yylex();
}