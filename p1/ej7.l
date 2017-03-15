/*
	Enunciado: Fichero de registro de accesos
	Codifica un analizador que reemplaze una palabra por otra en un fichero
	de entrada
 */

/* Estados registrados */
%x multi_coment
%option stack yylineno

%{
	#include <ctype.h>

	// Tabla de símbolos
	char* palabras_clave[] = {"inicio", "fin", "__mod", "__o", "__y", "__no", 
			"leer", "escribir", "si", "entonces", "si_no", "fin_si", "mientras",
			"hacer", "fin_mientras", "repetir", "hasta_que", "para", "desde",
			"hasta", "paso", "fin_para"};
	const int clave_len = 22; // Longitud del array palabras_clave
	int yylineno;

	// Funciones auxiliares
	int esClave(const char * palabra);
	void imprimeMensaje(char* mensaje, char* elemento);
%}

/* Grupos de caracteres */
letra       [a-zA-Z]
digito      [0-9]
alnum       [{letra}{digito}]
blanco      [ \t]

/* Expresiones */
id          {letra}+([{letra}_]*{letra}+)?
id_malo     [{digito}_][{alnum}_]+
numero      {digito}+\.?{digito}*([e|E]{digito}+)?
numero_malo \.?[{digito}Ee\.]+
cadena      "'"([^"'"]|"\\\'")*"'"
op_asignacion    ":="
op_aritmetico    "+"|"-"|"*"|"/"|"__mod"|"**"
op_alfanumerico  "||"
op_relacional    "<"|"<="|">"|">="|"=="|"<>"
operador    {op_asignacion}|{op_aritmetico}|{op_alfanumerico}|{op_relacional} 

%%

\(\*		{
				yy_push_state(multi_coment);
				printf("[%d] Comentario multilínea: %s", yylineno, yytext);
			}
<multi_coment>{
	<<EOF>>         printf("Error. Comentario sin cerrar."); yyterminate();
	\*\)            yy_pop_state(); printf("*)\n\n");
	(.|\n)          ECHO;
}
#.*\n       printf("[%d] Comentario de una línea: %s\n", yylineno, yytext);

(?i:{id})	{
				if (esClave(yytext)) {
					imprimeMensaje("Palabra clave", yytext);
				} else {
					imprimeMensaje("Identificador", yytext);
				}
			}

{operador}  imprimeMensaje("Operador", yytext);

\(|\)       imprimeMensaje("Componente léxico", yytext);

;           printf("[%d] FIN_SENTENCIA\n\n", yylineno);

{cadena}	imprimeMensaje("Cadena", yytext);

{numero}    imprimeMensaje("Número", yytext);

{id_malo}   imprimeMensaje("Error. Identificador mal formateado", yytext);

{numero_malo} imprimeMensaje("Error. Número mal formateado", yytext);

.|\n        { ; }

%%

// Función que devuelve si una palabra es clave o no
int esClave(const char * palabra)
{
	char texto_id[128];
	strcpy(texto_id, palabra);
	// Convertir a minúsculas el identificador
	for (int i = 0; i < strlen(texto_id); i++)
		texto_id[i] = tolower(texto_id[i]);	

	for (int i = 0; i < clave_len; i++) {
		if (strcmp(palabras_clave[i], palabra) == 0) {
			return 1; // Verdadero si encuentra palabra clave
		}
	}

	return 0; // Si llega aquí no es clave
}

void imprimeMensaje(char* mensaje, char* elemento)
{
	printf("[%d] %s: %s\n\n", yylineno, mensaje, elemento);
}

extern FILE *yyin;
void  main(int argc, char *argv[])
{
	switch(argc)
	{
		case 2: yyin=fopen(argv[1],"r");
				if (yyin == NULL) {
					printf("Error. No se pudo abrir el fichero: %s", argv[1]);
					exit(-1);
				}
				break;
		default:
			printf("\nNúmero de parámetros incorrecto\n");
			printf("LLamar: %s <fichero-entrada>\n", argv[0]);
			exit(-1);
	}
	printf("[<nº-línea>] <tipo-de-elemento>: <elemento>\n"
			"-------------------------------------------\n\n");
	yylex();
	printf("\n");
}