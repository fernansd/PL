/*
	Enunciado: Contar
	Elaborar un programa de flex que reciba un fichero de texto y cuente el
	número de caracteres, palabras y líneas que contiene.
 */

%{
	int n_char, n_palabras, n_lineas;
%}

letra [a-zA-Z]
palabra {letra}+

%%

{palabra}		{
					n_char += strlen(yytext);
					n_palabras++;
				}

\n				{ n_lineas++; }

%%

extern FILE *yyin, *yyout;
void  main(int argc, char *argv[])
{
	// Valores por defecto
	n_char = 0;
	n_palabras = 0;
	n_lineas = 0;

	switch(argc)
	{
		case 2: yyin=fopen(argv[1],"r");
				break;
		case 3: yyin=fopen(argv[1],"r"); 
				yyout=fopen(argv[2],"w");
				break;
		default:
			printf("\nNúmero de parámetros incorrecto\n");
			printf("LLamar: %s <fichero-entrada>  [<fichero-salida>]");
			exit(-1);
	}
	yylex();

	fprintf(yyout, "\nEstadísticas:\n"
					"\tNº caracteres: %d\n"
					"\tNº palabras: %d\n"
					"\tNº líneas: %d\n",
					n_char, n_palabras, n_lineas);
}