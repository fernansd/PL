/*
	Enunciado: Contar aparaciones de una palabra
	Codifica un programa que reciba un fichero de texto y una palabra
	y cuente el número de veces que ese palabr aparece.
 */

%{
	int rep_palabra; // Número de veces que se repite la palabra
	char palabra[128]; // Palabra a buscar
%}

letra [a-zA-Z]
palabra {letra}+

%%

{palabra}		{
					// Sólo se hace algo cuando se encuentra la palabra
					if (strcmp(palabra, yytext) == 0)
						rep_palabra++;
				}

.				{ ; }

\n 				{ ; }

%%

extern FILE *yyin;
void  main(int argc, char *argv[])
{
	// Valores por defecto
	rep_palabra = 0;

	switch(argc)
	{
		case 3: yyin=fopen(argv[1],"r");
				// Comprueba overflow del array palabra
				if (strlen(argv[2]) > 127) {
					perror("\nSobrepasado el tamaño de la palabra a buscar\n"
							"Máximo 127 caracteres.\n");
					exit(-1);
				}
				strcpy(palabra, argv[2]);
				break;
		default:
			printf("\nNúmero de parámetros incorrecto\n");
			printf("LLamar: %s <fichero-entrada> <palabra-a-buscar>\n", argv[0]);
			exit(-1);
	}
	yylex();

	printf("\nVeces que '%s' se repite: %d\n", palabra, rep_palabra);
}