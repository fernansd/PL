/*
	Enunciado: Fichero de registro de accesos
	Codifica un analizador que reemplaze una palabra por otra en un fichero
	de entrada
 */

%{
	// Palabras con las que tratará el programa
	char usuario_objetivo[128];
	char fecha_objetivo[9];
	int n_ocurrencias;
	int comprueba_fecha; // Si vale 0 no se busca por fecha
%}

letra       [a-zA-Z]
digito      [0-9]
blanco      [ \t]
palabra     {letra}+
fecha       {digito}{1,2}[/-]{digito}{1,2}[/-]{digito}{1,2}
hora        {digito}{1,2}:{digito}{1,2}
registro    {palabra}{blanco}+{fecha}{blanco}+{hora}

%%
{registro}  { // Si encuentra la palaabra la sustituye
				char usuario[128];
				char fecha[128];
				sscanf(yytext, "%s %s %*", usuario, fecha);

				if (strcmp(usuario, usuario_objetivo) == 0) {
					if (comprueba_fecha) {
						if (strcmp(fecha, fecha_objetivo) == 0)
							n_ocurrencias++;
					} else {
						n_ocurrencias++;
					}
				}
			}

.|\n 		{ ; }

%%

extern FILE *yyin;
void  main(int argc, char *argv[])
{
	// Valores por defecto
	n_ocurrencias = 0;
	comprueba_fecha = 0;

	switch(argc)
	{
		case 3: yyin=fopen(argv[1],"r");
				// Comprueba overflow del array palabra
				if (strlen(argv[2]) > 127) {
					perror("\nSobrepasado el tamaño del nombre de usuario\n"
							"Máximo 127 caracteres.\n");
					exit(-1);
				}
				strcpy(usuario_objetivo, argv[2]);
				break;
		case 4:
				yyin=fopen(argv[1],"r");
				// Comprueba overflow del array palabra
				if (strlen(argv[2]) > 127) {
					perror("\nSobrepasado el tamaño del nombre de usuario\n"
							"Máximo 127 caracteres.\n");
					exit(-1);
				}
				strcpy(usuario_objetivo, argv[2]);

				if (strlen(argv[3]) > 8) {
					perror("\nSobrepasado el tamaño de la fecha\n"
							"Máximo 8 caracteres.\n");
					exit(-1);
				}
				strcpy(fecha_objetivo, argv[3]);

				comprueba_fecha = 1; // Activa búsqueda con fecha
				break;
		default:
			printf("\nNúmero de parámetros incorrecto\n");
			printf("LLamar: %s <fichero-registro> <usuario> [<fecha>]\n", argv[0]);
			exit(-1);
	}
	yylex();
	if (comprueba_fecha) {
		printf("Accesos de usuario %s en fecha %s: %d\n", usuario_objetivo,
			fecha_objetivo, n_ocurrencias);
	} else {
		printf("Accesos de usuario %s: %d\n", usuario_objetivo,
			n_ocurrencias);
	}
}