/*
	Enunciado: Sustitución de una palabra
	Codifica un analizador que reemplaze una palabra por otra en un fichero
	de entrada
 */

%{
	// Palabras con las que tratará el programa
	char palabra_buscada[128];
	char palabra_reemplazo[128];
	const char*  nombre_archivo_aux = "archivo-aux-ej5-lex.txt";
%}

letra [a-zA-Z]
palabra {letra}+

%%

{palabra}		{
					// Si encuentra la palaabra la sustituye
					if (strcmp(palabra_buscada, yytext) == 0) {
						fprintf(yyout, "%s", palabra_reemplazo);
					} else {
						fprintf(yyout, "%s", yytext);
					}
				}

.|\n 			{ ECHO; }

%%

extern FILE *yyin, *yyout;
void  main(int argc, char *argv[])
{

	if (argc == 4) {
		yyin=fopen(argv[1],"r");
		// Comprueba overflow del array palabra
		if (strlen(argv[2]) > 127 || strlen(argv[3]) > 127) {
			perror("\nSobrepasado el tamaño de la palabra a buscar\n"
					"Máximo 127 caracteres.\n");
			exit(-1);
		}
		strcpy(palabra_buscada, argv[2]);
		strcpy(palabra_reemplazo, argv[3]);
		yyout = fopen(nombre_archivo_aux, "w");

	} else {
		printf("\nNúmero de parámetros incorrecto\n");
		printf("LLamar: %s <fichero-entrada> <palabra-buscada> "
				"<palabra-reemplazo>\n", argv[0]);
		exit(-1);
	}
	yylex();
	rename(nombre_archivo_aux, argv[1]);
}