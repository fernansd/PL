/*
	Enunciado: Sumar parametrizado
	Este programa copia un archivo de entrada en uno de salida sumando un 
	número N1 a todo número que sea múltiplo de N2, ambos pasados por consola.
 */

%{
	int N1, N2;
%}

digito [0-9]
numero {digito}+

%%

{numero}		{
					int numero = atoi(yytext);
					if (numero % N2 == 0)
						numero += N1;
					
					fprintf(yyout, "%2d", numero);
				}

.				{ ECHO; }

%%

extern FILE *yyin, *yyout;
void  main(int argc, char *argv[])
{
	// Valores por defecto
	N1 = 1;
	N2 = 3;

	switch(argc)
	{
		case 2: yyin=fopen(argv[1],"r");
				break;
		case 3: yyin=fopen(argv[1],"r"); 
				yyout=fopen(argv[2],"w");
				break;
		case 4:	yyin=fopen(argv[1],"r"); 
				yyout=fopen(argv[2],"w");
				N1 = atoi(argv[3]);
				break;
		case 5: yyin=fopen(argv[1],"r"); 
				yyout=fopen(argv[2],"w");
				N1 = atoi(argv[3]);
				N2 = atoi(argv[4]);
				break;
		default:
			printf("\nNúmero de parámetros incorrecto\n");
			printf("LLamar: %s <fichero-entrada>  [<fichero-salida>] [N1] [N2]\n", argv[0]);
			exit(-1);
	}
	yylex();
}