%{

//=================================================================================
//	Lenguajes y compiladores
// 	Grupo : M3
//	Temas especiales: AVG INLIST
//================================================================================= */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <float.h>
#include <ctype.h>

extern int yylineno;
extern char *yytext;
FILE *yyin; // Puntero al archivo que se pasa por parametro en el main.
int yylex();
void yyerror(char *msg);

int nroAuxReal=0;
int nroAuxEntero=0;

int contAVG=1; // Cantidad de expresiones de la funcion avg
char stringAVG[25]; //guardamos el contador de AVG
int auxAVG=0;
char auxIdAVG[15]; //variable auxiliar donde guardare el resulta final de la AVG que colocare en el ID
char stringBoolInlist[25];
char auxInlistwhile[25]; // usamos para cerrar el while con la funcion INLIST como condicion
char auxId[15];//variable auxiliar donde guardare el ID que colocare en el final de la polaca

char auxInlist[25];
int auxBool=0;

char cteStrSinBlancos[50];
void reemplazarBlancos(char *cad);

/* declaraciones para generacion de assembler */
char linea[50];
int topePilaAsm = 0;
char strPila[1000][50];
char strOpe[50];
char strConc[50];
char strNombre[50];
FILE *ArchivoAsm;
void desapilarOperando();
void desapilarOperandos(int);
void apilarOperando(char *strOp);
void imprimirHeader(FILE *p);
void imprimirVariables(FILE *p);
void generarASIG();
void generarAsm();

/* funciones para polaca etc */
int contEtiqueta = 0;   //para generar etiq unicas
char Etiqueta[10];      //para generar etiq unicas
char EtiqDesa[10];
char EtiqDesaW[10];
char pilaEtiquetas[150][10]; //guarda las etiquetas
int  topeEtiquetas = 0;
char pilaEtiquetasW[150][10]; //guarda las etiquetas
int  topeEtiquetasW = 0;
int  posPolaca = 0;
FILE *ArchivoPolaca;
char buffer[20];
char pilaPolaca[500][50];
int pilaWhile[150];
int topePilaWhile = 0;

int posicionActualPol = 0; // guardo la posicion actual de la polaca.

void apilarWhile(int pos);
int desapilarWhile();

void apilarPolaca(char *);
void trampearPolaca(char *strToken);
void insertarPolaca(char *s, int p);
void generarEtiqueta();
void apilarEtiqueta(char *strEtiq);
void desapilarEtiqueta();
void apilarEtiquetaW(char *strEtiq);
void desapilarEtiquetaW();
void grabarPolaca();
/* fin de funciones para polaca etc */

/*funciones y estructuras para handle de tipos */
char tipos[20][40];
int contTipos = 0;

int insertarTipo(char tipo[]);
int resetTipos();
int compararTipos(char *a, char *b);
int validarTipos(char tipo[]) ;
/*fin de funciones y estructuras para handle de tipos */


/* funciones tabla de simbolos */
typedef struct symbol {
    char nombre[50];
    char tipo[10];
    char valor[100];
    int longitud;
    int limite;
} symbol;

symbol nullSymbol;
symbol symbolTable[1000];
int pos_st = 0;

// symbolo auxiliar
symbol auxSymbol;
symbol auxSymbol2;
// el valor ! representa al simbolo nulo.

void writeTupla(FILE *p ,int filas,symbol symbolTable[]){
    int j;
    for(j=0; j < filas; j++ ){
        fprintf(p,"%-25s",symbolTable[j].nombre);
        if(j!=0 && strlen(symbolTable[j].tipo) <= 0)
            strcpy(symbolTable[j].tipo, symbolTable[j-1].tipo);
        fprintf(p,"|%-25s",symbolTable[j].tipo);
        fprintf(p,"|%-25s",symbolTable[j].valor);
        fprintf(p,"|%-25d",symbolTable[j].longitud);
        fprintf(p,"|%-25d",symbolTable[j].limite);
        fprintf(p, "\n");
    }
}

void writeTable(FILE *p,  int filas, symbol symbolTable[], void (*tupla)(FILE *p ,int filas, symbol symbolTable[])){   
    char titulos[5][20] = {"Nombre","Tipo","Valor","Longitud","Limite"};
    int j;
    for(j=0; j < 5; j++ ){
        if ( j == 0)
           fprintf(p,"%-25s",titulos[j]);
        else
            fprintf(p,"|%-25s",titulos[j]);
    }
    fprintf(p, "\n");
    int i;
    tupla(p,filas,symbolTable);
    fprintf(p,"\n");
}

//Estructura de la SymbolTable
void CrearSymbolTable(symbol symbolTable[],char * ruta){
    //Declaracion de variables
    //Definicion del archivo de salida y su cabecera
    FILE  *p = fopen(ruta, "w");
    writeTable(p, pos_st, symbolTable, writeTupla);
    //Fin
    fclose(p);
}

// helpers
char *downcase(char *p);
char *prefix_(char *p);
int searchSymbol(char key[]);
int saveSymbol(char nombre[], char tipo[], char valor[] );
symbol getSymbol(char nombre[]);
void symbolTableToExcel(symbol table[],char * ruta);
/* fin de funciones tabla de simbolos */

/* funciones para validacion (cabeceras)*/
/* funciones para validar el rango*/
void guardarIntEnTs(char entero[]);
void guardarFloatEnTs(char flotante[]);
void guardarStringEnTs(char cadena[]);
void guardarBooleanoEnTs(char booleano[]);
void replace_str(char *);

/* funciones para que el bloque DecVar cargue la tabla de símbolos */
char varTypeArray[2][100][50]; // Dos matrices de 100 filas y 50 columnas
int idPos = 0;
int typePos = 0;
int hayAnd = 0;
int hayOr = 0;

void collectId (char *id);
void collectType (char *type);
void consolidateIdType();
/* fin de funciones para que el bloque DecVar cargue la tabla de símbolos */

%}

%union{
 char s[500];
}
%token IF ELSE WHILE DEFVAR ENDDEF WRITE READ AVG INLIST
%token REAL BINA ENTERO BOOLEANO STRING_CONST
%token <s> ID
%token FLOAT INT STRING BOOL
%token P_A P_C C_A C_C L_A L_C PUNTO_Y_COMA D_P COMA
%token OP_CONCAT OP_SUM OP_RES OP_DIV OP_MUL MOD DIV 
%token CMP_MAY CMP_MEN CMP_MAYI CMP_MENI CMP_DIST CMP_IGUAL
%token ASIG
%token AND OR
%type <s> expresion

%%
raiz: programa {    fprintf(stdout,"\nCompila OK\n\n"); 
                    fflush(stdout);
                    CrearSymbolTable(symbolTable,"ts.txt");
                    grabarPolaca(); 
                    generarAsm();   }
    ;

programa:
    bloque_dec sentencias   {   fprintf(stdout,"\nprograma - bloque_dec sentencias");
                                fflush(stdout); }
    | bloque_escritura      {   fprintf(stdout,"\nprograma - escritura");   
                                fflush(stdout); }
    | bloque_dec            {   fprintf(stdout,"\nprograma - bloque_dec");  
                                fflush(stdout); }
    ;

bloque_escritura: 
    escritura                       {   fprintf(stdout,"\nbloque_escritura - escritura");
                                        fflush(stdout); }
    | bloque_escritura escritura    {   fprintf(stdout,"\nbloque_escritura - bloque_escritura escritura");
                                        fflush(stdout); }
    ;

bloque_dec: 
    DEFVAR declaraciones ENDDEF {   fprintf(stdout,"\nbloque_dec - DEFVAR declaraciones ENDDEF");    
                                    fflush(stdout); }
    ;

declaraciones: 
    declaraciones declaracion    {  fprintf(stdout,"\ndeclaraciones - declaraciones declaracion");  
                                    fflush(stdout); }
    | declaracion                {  fprintf(stdout,"\ndeclaraciones - declaracion");
                                    fflush(stdout); }
    ;

declaracion:
    lista_variables D_P tipo_dato   {   fprintf(stdout,"\ndeclaracion - lista_variables D_P tipo_dato");    
                                        fflush(stdout); }
    ;

lista_variables: 
    lista_variables COMA ID {   collectId(yylval.s);
                                fprintf(stdout,"\nlista_variables - lista_variables COMA ID: %s", yylval.s);   
                                fflush(stdout); }
    | ID    {   collectId(yylval.s);
                fprintf(stdout,"\nlista_variables - ID: %s", yylval.s);
                fflush(stdout); }
    ;

tipo_dato: 
    STRING      {   collectType("string"); 
                    fprintf(stdout,"\ntipo_dato - STRING");   
                    fflush(stdout); 
                    consolidateIdType();    }
    | FLOAT     {   collectType("float");
                    fprintf(stdout,"\ntipo_dato - FLOAT");
                    fflush(stdout); 
                    consolidateIdType();    }
    | INT       {   collectType("int");
                    fprintf(stdout,"\ntipo_dato - INT"); 
                    fflush(stdout); 
                    consolidateIdType();    }
    | BOOL      {   collectType("bool");
                    fprintf(stdout,"\ntipo_dato - BOOL"); 
                    fflush(stdout); 
                    consolidateIdType();    }
    ;

sentencias: 
    sentencias sentencia    {   fprintf(stdout,"\nsentencias - sentencias sentencia");   
                                fflush(stdout); }
    | sentencia             {   fprintf(stdout,"\nsentencias - sentencia"); 
                                fflush(stdout); }
    ;

sentencia: 
    asignacion PUNTO_Y_COMA {   fprintf(stdout,"\nsentencia - asignacion PUNTO_Y_COMA"); 
                                fflush(stdout);
                                    if(auxAVG==0){
                                        //fprintf(stdout,"\n\n\nPaseeeeeeeee\n\n\n");
                                        apilarPolaca(auxId);
                                        apilarPolaca("=");
                                        strcpy(auxId,"");
                                    } 
                                    auxAVG=0;

                                }
    | iteracion             {   fprintf(stdout,"\nsentencia - iteracion");  
                                fflush(stdout); }
    | decision              {   fprintf(stdout,"\nsentencia - decision");   
                                fflush(stdout); }
    | escritura             {   fprintf(stdout,"\nsentencia - escritura");  
                                fflush(stdout); }
    | lectura               {   fprintf(stdout,"\nsentencia - lectura");    
                                fflush(stdout); }
   	;

decision: 
    IF P_A condicion P_C L_A sentencias L_C {   fprintf(stdout,"\ndecision - IF P_A condicion P_C L_A sentencias L_C");
                                                fflush(stdout);
                                                fprintf(stdout,"\nInicio del then");
                                                fflush(stdout);
                                                desapilarEtiqueta();
                                                strcat(Etiqueta,":");
                                                apilarPolaca(Etiqueta);
                                                if(hayAnd !=0 )
                                                    {
                                                    desapilarEtiqueta();
                                                    strcat(EtiqDesa,":");
                                                    apilarPolaca(EtiqDesa);
                                                    hayAnd--;
                                                    }
                                                fprintf(stdout,"\nFin del then");   
                                                fflush(stdout); }
   | IF P_A condicion P_C L_A sentencias L_C {  fprintf(stdout,"\ndecision - IF P_A condicion P_C L_A sentencias L_C");
                                                fflush(stdout);
                                                fprintf(stdout,"\nInicio del then");
                                                fflush(stdout);

                                                strcpy(auxInlist,Etiqueta);
                                                strcat(auxInlist,":");
                                                generarEtiqueta();
                                                apilarPolaca(Etiqueta);
                                                apilarPolaca("JMP");
                                                apilarPolaca(auxInlist);
                                                desapilarEtiqueta();
                                                strcat(Etiqueta,":");
                                                apilarEtiqueta(Etiqueta);
                                                fprintf(stdout,"\nFin del then");
                                                fflush(stdout); }
    ELSE                                    {   fprintf(stdout,"\nInicio del else");
                                                fflush(stdout);   }
    L_A sentencias L_C                      {   fprintf(stdout,"\nFin del else");
                                                fflush(stdout);
                                                desapilarEtiqueta();
                                                //strcat(EtiqDesa,":");
                                                apilarPolaca(EtiqDesa); 
                                                }
    | IF P_A condicion P_C L_A  L_C         {   fprintf(stdout,"\nFin del then");
                                                fflush(stdout);
                                                generarEtiqueta();//fin
                                                apilarPolaca(Etiqueta);//fin
                                                apilarPolaca("JMP");
                                                desapilarEtiqueta();
                                                strcat(EtiqDesa,":");
                                                apilarPolaca(EtiqDesa);
                                                apilarEtiqueta(Etiqueta);   }
    ELSE                                    {   fprintf(stdout,"\nelse");
                                                fflush(stdout); 
                                                }
    L_A sentencias L_C                      {   fprintf(stdout,"\nfin del else");
                                                fflush(stdout);
                                                desapilarEtiqueta();
                                                strcat(EtiqDesa,":");                                           
                                                apilarPolaca(EtiqDesa); 
                                                }
   ;

iteracion: 
    WHILE   {   fprintf(stdout,"\niteracion - WHILE");
                fflush(stdout);
                generarEtiqueta();//fin
                apilarEtiquetaW(Etiqueta);
                strcat(Etiqueta, ":");
                apilarPolaca(Etiqueta); }
    P_A condicion P_C L_A sentencias L_C    {   fprintf(stdout,"\niteracion - P_A condicion P_C L_A sentencias");
                                                fflush(stdout);
                                                desapilarEtiquetaW(); 
                                                apilarPolaca(EtiqDesaW);
                                                apilarPolaca("JMP");
                                                desapilarEtiqueta();
                                                if(auxBool==0){
                                                    //fprintf(stdout,"\nPASO 1");
                                                    fflush(stdout);
                                                    strcat(EtiqDesa,":");
                                                    apilarPolaca(EtiqDesa);
                                                }
                                                else{
                                                    //fprintf(stdout,"\nPASO 2");
                                                    fflush(stdout);
                                                    strcat(auxInlistwhile,":");
                                                    apilarPolaca(auxInlistwhile);
                                                    strcpy(auxInlistwhile, "");
                                                    auxBool=0;
                                                }   }    
    ;

asignacion: 
    lista_asignacion expresion  {   
                                 if(auxAVG==0){
                                                //fprintf(stdout,"\n\n\nPASEEEEEE 3\n\n\n"); 

                                                fprintf(stdout,"\nasignacion - ID ASIG expresion");
                                                fflush(stdout);
                                               //_------ insertarPolaca($2,posicionActualPol);
                                               //--------posicionActualPol = 0;
                                    }
                                      else{
                                          //guardo el resultado final en el ID del AVG

                                            //fprintf(stdout,"\n\n\nPASEEEEEE 4\n\n\n"); 
                                            apilarPolaca(auxIdAVG);
                                            apilarPolaca("_aux");  
                                            apilarPolaca("=");
                                            strcpy(auxIdAVG,"");
                                        }
                                }
    | lista_asignacion concatenacion     {  fprintf(stdout,"\nasignacion - ID ASIG concatenacion");
                                            fflush(stdout);
                                            // auxSymbol = getSymbol($1);
                                            // if(strcmp(auxSymbol.tipo,"string")!=0){ 
                                            //     auxSymbol = nullSymbol; 
                                            //     yyerror("Tipos incompatibles");
                                            // }
                                            // validarTipos("string");
                                            // // apilarPolaca($1);
                                            // apilarPolaca("=");  
                                    }
    ;

lista_asignacion:
    ID ASIG                     {   

                                    

                                    if(auxAVG==0)
                                    {
                                        //fprintf(stdout,"\n\n\nPASEEEEEE 1\n\n\n"); 
                                        fprintf(stdout,"\nlista_asignacion - ID ASIG"); 
                                        fflush(stdout); 
                                        //------auxSymbol = getSymbol($1);
                                        // validarTipos(auxSymbol.tipo);
                                        //------auxSymbol = nullSymbol;
                                        //------apilarPolaca("_aux");
                                        //-------posicionActualPol = posPolaca;
                                        //----apilarPolaca("");
                                        //-----------apilarPolaca("=");
                                        //guardamos el id donde guardaremos el resultado
                                        strcpy(auxId,$1);
                                        //strcpy(auxIdAVG,$1);
                                        

                                        //-------------apilarPolaca($1);
                                        //---apilarPolaca("=");
                                        //-----apilarPolaca("_aux");
                                        //------apilarPolaca("=");
                                    }
                                    else
                                        {   //fprintf(stdout,"\n\n\nPaseeeeeeeee 2\n\n\n");
                                            strcpy(auxIdAVG,$1);
                                        }
                                      
                                }
    | lista_asignacion ID ASIG    {     fprintf(stdout,"\nlista_asignacion - lista_asignacion ID ASIG");
                                        fflush(stdout); 
                                        apilarPolaca($2);
                                        apilarPolaca("_aux");
                                        apilarPolaca("=");  }
    ;
    

avg: 
    AVG {   auxAVG=1;
            apilarPolaca("0");//inicializo la variable "_aux" en 0
            apilarPolaca("_aux");//creo mi variable "_aux" para acumular los resultados intermedios      
            apilarPolaca("=");
        
        } P_A C_A contenido_avg C_C P_C   {   fprintf(stdout,"\navg - AVG P_A C_A contenido_avg C_C P_C");
                                                        fflush(stdout); 
                                                        //auxAVG=0;
                                            }
	;

contenido_avg: 
                 {apilarPolaca("_aux");} expresion    					
    
                                        {   fprintf(stdout,"\ncontenido_avg - expresion ---> Cont:=1");
                                            fflush(stdout);
                                            apilarPolaca("+");
                                            apilarPolaca("_aux");
                                            apilarPolaca("=");
                                         }
	| contenido_avg COMA {apilarPolaca("_aux");} expresion  {    contAVG++; 
                                                                    fprintf(stdout,"\ncontenido_avg - contenido_avg COMA expresion %d", contAVG); 
                                                                    fflush(stdout);
                                                                    apilarPolaca("+"); 
                                                                    apilarPolaca("_aux");
                                                                    apilarPolaca("=");
                                                                 }
    ;

concatenacion: 
    ID OP_CONCAT ID                  {  fprintf(stdout,"\nconcatenacion - ID OP_CONCAT ID");
                                        fflush(stdout);
                                        // auxSymbol = getSymbol($1);
                                        // if(strcmp(auxSymbol.tipo,"string")!=0){ 
                                        //     auxSymbol = nullSymbol; yyerror("Tipos incompatibles");
                                        // }
                                        // auxSymbol = getSymbol($3);
                                        // if(strcmp(auxSymbol.tipo,"string")!=0){
                                        //     auxSymbol = nullSymbol; yyerror("Tipos incompatibles");
                                        // }
                                        // validarTipos("string");
                                        fprintf(stdout,"\nacá hay que validar concatenacion: ID OP_CONCAT ID");
                                        fflush(stdout);
                                        apilarPolaca($1);
                                        apilarPolaca($3);
                                        apilarPolaca("++"); }
    | ID OP_CONCAT constanteString  {   fprintf(stdout,"\nconcatenacion - ID OP_CONCAT constanteString");
                                        fflush(stdout);
                                        // auxSymbol = getSymbol($1);
                                        // if(strcmp(auxSymbol.tipo,"string")!=0){
                                        //     auxSymbol = nullSymbol; yyerror("Tipos incompatibles");
                                        // }
                                        fprintf(stdout,"\nacá hay que validar concatenacion: ID OP_CONCAT constanteString");
                                        trampearPolaca($1);
                                        // validarTipos("string");
                                        apilarPolaca("++"); }
    | constanteString OP_CONCAT ID  {   fprintf(stdout,"\nconcatenacion - constanteString OP_CONCAT ID");
                                        fflush(stdout);
                                        // auxSymbol = getSymbol($3);
                                        // if(strcmp(auxSymbol.tipo,"string")!=0){
                                        //     auxSymbol = nullSymbol; yyerror("Tipos incompatibles");
                                        // }
                                        fprintf(stdout,"\nacá hay que validar concatenacion: constanteString OP_CONCAT ID");
                                        fflush(stdout);
                                        // validarTipos("string");
                                        apilarPolaca($3);
                                        apilarPolaca("++"); }
    | constanteString OP_CONCAT constanteString {   fprintf(stdout,"\nconcatenacion - constanteString OP_CONCAT constanteString");
                                                    fflush(stdout);
                                                    // validarTipos("string");
                                                    apilarPolaca("++");     }
    | constanteString                   {   fprintf(stdout,"\nconcatenacion - constanteString");
                                            fflush(stdout);
                                            /*validarTipos("string");*/ }
    ;

condicion: 
    expresion CMP_MAY expresion     {   fprintf(stdout,"\ncondicion - expresion CMP_MAY expresion");
                                        fflush(stdout);
                                        // validarTipos("float");
                                        apilarPolaca("CMP");
                                        generarEtiqueta();
                                        apilarEtiqueta(Etiqueta);
                                        apilarPolaca(Etiqueta);
                                        apilarPolaca("JNB");    }
    | expresion CMP_MEN expresion   {   fprintf(stdout,"\ncondicion - expresion CMP_MEN expresion");
                                        fflush(stdout);
                                        // validarTipos("float");
                                        apilarPolaca("CMP");
                                        generarEtiqueta();
                                        apilarEtiqueta(Etiqueta);
                                        apilarPolaca(Etiqueta);
                                        apilarPolaca("JNA");    }
    | expresion CMP_MAYI expresion   {  fprintf(stdout,"\ncondicion - expresion CMP_MAYI expresion");
                                        fflush(stdout);
                                        // validarTipos("float");
                                        apilarPolaca("CMP");
                                        generarEtiqueta();
                                        apilarEtiqueta(Etiqueta);
                                        apilarPolaca(Etiqueta);
                                        apilarPolaca("JNBE");   }
    | expresion CMP_MENI expresion  {   fprintf(stdout,"\ncondicion - expresion CMP_MENI expresion");
                                        fflush(stdout);
                                        // validarTipos("float");
                                        apilarPolaca("CMP");
                                        generarEtiqueta();
                                        apilarEtiqueta(Etiqueta);
                                        apilarPolaca(Etiqueta);
                                        apilarPolaca("JNAE");   }
    | expresion CMP_DIST expresion  {   fprintf(stdout,"\ncondicion - expresion CMP_DIST expresion");
                                        fflush(stdout);
                                        // validarTipos("float");
                                        apilarPolaca("CMP");
                                        generarEtiqueta();
                                        apilarEtiqueta(Etiqueta);
                                        apilarPolaca(Etiqueta);
                                        apilarPolaca("JE"); }
    | expresion CMP_IGUAL expresion {   fprintf(stdout,"\ncondicion - expresion CMP_IGUAL expresion");
                                        fflush(stdout);
                                        // validarTipos("float");
                                        apilarPolaca("CMP");
                                        generarEtiqueta();
                                        apilarEtiqueta(Etiqueta);
                                        apilarPolaca(Etiqueta); 
                                        apilarPolaca("JNZ");    }


    | P_A condicion P_C AND P_A condicion P_C   {   fprintf(stdout,"\ncondicion - AND"); hayAnd++;

    }

    | P_A condicion P_C OR P_A condicion P_C    {   fprintf(stdout,"\ncondicion - OR"); hayOr++;

    }

    | INLIST P_A ID                 {   fprintf(stdout,"\ncondicion - INLIST P_A ID");
                                        fflush(stdout);
                                        //fprintf(stdout,"CONDICION: INLIST \n");
                                        //generarEtiqueta();
                                        //fprintf(stdout,"ETIQUETA DEL if con INLIST=  %s \n\n\n",Etiqueta);
                                        //apilarPolaca(Etiqueta);
                                        apilarPolaca("_aux"); //creo variable auxiliar para guardar el resultado de 
                                                            //la busqueda de la funcion INLIST
                                        apilarPolaca("0"); 
                                        apilarPolaca("=");
                                        strcpy(auxInlist,$3);
                                        apilarPolaca(auxInlist);    }
    PUNTO_Y_COMA C_A contenido_inlist C_C P_C   {   fprintf(stdout,"\ncondicion - PUNTO_Y_COMA C_A contenido_inlist C_C P_C");
                                                    fflush(stdout);
                                                    auxBool=1; 
                                                    //fprintf(stdout,"inlist: INLIST P_A ID PUNTO_Y_COMA C_A contenido_inlist C_C P_C\n");
                                                    apilarPolaca("_aux");
                                                    apilarPolaca("1");
                                                    apilarPolaca("CMP");
                                                    generarEtiqueta();
                                                    fprintf(stdout,"\nETIQUETA if de INLIST=  %s:",Etiqueta);
                                                    fflush(stdout);
                                                    apilarPolaca(Etiqueta);
                                                    apilarPolaca("JNZ");
                                                    strcpy(auxInlistwhile,Etiqueta);   }
    ;

contenido_inlist: 
    expresion   {   fprintf(stdout,"\ncontenido_inlist - expresion");
                    fflush(stdout);
                    apilarPolaca("CMP");
                    generarEtiqueta();
                    fprintf(stdout,"\nETIQUETA 1 =  %s",Etiqueta);
                    apilarPolaca(Etiqueta);
                    apilarPolaca("JNZ");
                    apilarPolaca("_aux"); 
                    apilarPolaca("1"); 
                    apilarPolaca("=");  
                    desapilarEtiqueta();
                    strcat(Etiqueta,":");
                    fprintf(stdout,"\nDESAPILAR ETIQUETA 1=  %s",Etiqueta);
                    apilarPolaca(Etiqueta); }

	| contenido_inlist  PUNTO_Y_COMA    {   fprintf(stdout,"contenido_inlist - contenido_inlist PUNTO_Y_COMA expresion\n");
                                            fflush(stdout);
                                            apilarPolaca(auxInlist);    }
        expresion   {   //fprintf(stdout,"contenido_inlist: contenido_inlist PUNTO_Y_COMA expresion\n");
                        apilarPolaca("CMP"); 
                        generarEtiqueta();
                        fprintf(stdout,"\nETIQUETA 1=  %s",Etiqueta);
                        fflush(stdout);
                        apilarPolaca(Etiqueta);
                        apilarPolaca("JNZ");
                        apilarPolaca("_aux"); 
                        apilarPolaca("1"); 
                        apilarPolaca("=");
                        desapilarEtiqueta();
                        strcat(Etiqueta,":");
                        fprintf(stdout,"\nDESAPILAR ETIQUETA 1=  %s",Etiqueta);
                        fflush(stdout);
                        apilarPolaca(Etiqueta); }
    ;
    
expresion:
    expresion OP_SUM termino        {   fprintf(stdout,"\nexpresion - expresion OP_SUM termino"); 
                                        fflush(stdout);
                                        apilarPolaca("+");  }
    | expresion OP_RES termino      {   fprintf(stdout,"\nexpresion - expresion OP_RES termino");
                                        apilarPolaca("-");  }
    | termino                       {   fprintf(stdout,"\nexpresion - termino");   }
    ;

termino: 
    termino OP_MUL factor       {   fprintf(stdout,"\ntermino - termino OP_MUL factor"); 
                                    fflush(stdout);
                                    // validarTipos("float");
                                    apilarPolaca("*");  }
    | termino OP_DIV factor     {   fprintf(stdout,"\ntermino - termino OP_DIV factor"); 
                                    fflush(stdout);
                                    // validarTipos("float");
                                    apilarPolaca("/");  }
    | termino DIV factor        {   fprintf(stdout,"\ntermino - termino DIV factor"); 
                                    fflush(stdout);
                                    // validarTipos("float");
                                    apilarPolaca("DIV");    }
    | termino MOD factor        {   fprintf(stdout,"\ntermino - termino MOD factor"); 
                                    fflush(stdout);
                                    // validarTipos("float");
                                    apilarPolaca("MOD");    }
    | factor                    {   fprintf(stdout,"\ntermino - factor");
                                    fflush(stdout);   }
    ;

factor: 
    P_A expresion P_C           {   fprintf(stdout,"\nfactor - P_A expresion P_C");
                                    fflush(stdout); }
    | ID                        {   fprintf(stdout,"\nfactor - ID (insertando tipo)");
                                    fflush(stdout);
                                    auxSymbol=getSymbol($1);
                                    insertarTipo(auxSymbol.tipo);
                                    fprintf(stdout,"\nTipo insertado de ID=  %s",auxSymbol.tipo);
                                    fflush(stdout);
                                    apilarPolaca($1);   }
    | constanteNumerica         {   fprintf(stdout,"\nfactor - constanteNumerica");
                                    fflush(stdout); }
    | avg                       {   fprintf(stdout,"\nfactor - avg");
                                    fflush(stdout);
                                    sprintf(stringAVG, "%d", contAVG); // replaced itoa(contAVG, stringAVG, 10) for this.
                                    
                                    apilarPolaca("_aux");
                                    apilarPolaca(stringAVG);
                                    apilarPolaca("/");
                                    apilarPolaca("_aux");
                                    apilarPolaca("=");
                                      }
    ;



constanteNumerica: 
    ENTERO              {   guardarIntEnTs(yylval.s);
                            fprintf(stdout,"\nconstante - ENTERO: %s", yylval.s);
                            fflush(stdout);
                            apilarPolaca(yylval.s); }
    | REAL              {   guardarFloatEnTs(yylval.s);
                            fprintf(stdout,"\nconstante - REAL: %s" , yylval.s);
                            fflush(stdout);
                            replace_str(yylval.s);
                            apilarPolaca(yylval.s); //apilarPolaca(prefix_(downcase(yylval.s)));
                            } 
    | BOOLEANO          {   guardarBooleanoEnTs(yylval.s);
                            fprintf(stdout,"\nconstante - BOOLEANO: %s" , yylval.s); 
                            fflush(stdout);
                            apilarPolaca(yylval.s); }
    ;
constanteString: 
    STRING_CONST        {   guardarStringEnTs(yylval.s);
                            fprintf(stdout,"\nconstante - STRING %s" , yylval.s);
                            fflush(stdout); }
    ;

escritura:
    WRITE expresion PUNTO_Y_COMA        {   fprintf(stdout,"\nescritura - WRITE expresion PUNTO_Y_COMA");
                                            fflush(stdout);
                                            apilarPolaca("WRITE");
                                            resetTipos();   }
    | WRITE concatenacion PUNTO_Y_COMA  {   fprintf(stdout,"\nescritura - WRITE concatenacion PUNTO_Y_COMA");
                                            fflush(stdout);
                                            apilarPolaca("WRITE");
                                            resetTipos();   }
    ;

lectura:
    READ ID PUNTO_Y_COMA    {   fprintf(stdout,"\nlectura - READ ID PUNTO_Y_COMA"); 
                                fflush(stdout);
                                apilarPolaca("READ");   }

    ;
%%

/* funciones para validacion */
void guardarBooleanoEnTs(char Booleano[]) {
    saveSymbol(Booleano,"cBool", NULL);
    insertarTipo("cBool");		
}

void guardarIntEnTs(char entero[]) {
    saveSymbol(entero,"cInt", NULL);
    insertarTipo("cInt");
}

void guardarFloatEnTs(char flotante[]) {
    saveSymbol(flotante,"cFloat", NULL);
    insertarTipo("cFloat");
}

void replace_str(char *str)
{
    //printf("\n entro1 %s\n",str);
    char *ToRep = strstr(str,".");
    //printf("\n entro2 %s\n",ToRep);
    if(ToRep!=NULL){
    char *Rest = (char*)malloc(strlen(ToRep)+1);
    //printf("\n entro3 %s\n",Rest);
    strcpy(Rest,((ToRep)+strlen(".")));
    //printf("\n entro4 %s\n",Rest);
    strcpy(ToRep,"p");
    //printf("\n entro5 %s\n",ToRep);
    strcat(ToRep,Rest);
    //printf("\n entro6 %s\n",ToRep);
    free(Rest);
    //printf("\n entro7 %s\n",str);
    }
}

void guardarStringEnTs(char cadena[]) {
    char sincomillas[31];
    int longitud = strlen(cadena);
    int i;
    for(i=0; i<longitud - 2 ; i++) {
            sincomillas[i]=cadena[i+1];
    }
    sincomillas[i]='\0';
    saveSymbol(sincomillas,"cString", NULL);
    insertarTipo("string");
    reemplazarBlancos(sincomillas);
    apilarPolaca(sincomillas);
}

/* funciones para que el bloque DecVar cargue la tabla de símbolos */
void collectId (char *id) {
    strcpy(varTypeArray[0][idPos++], id);
}

void collectType (char *type){
    strcpy(varTypeArray[1][typePos++], type);
}

void consolidateIdType() {
    int i;
    for(i=0; i < idPos; i++) {
        saveSymbol(varTypeArray[0][i],varTypeArray[1][i], NULL);
    }
    idPos=0;
    typePos=0;
}
/* fin de funciones para que el bloque DecVar cargue la tabla de símbolos */

/* funciones tabla de simbolos */
char *downcase(char *p){
    char *pOrig = p;
    for ( ; *p; ++p) *p = tolower(*p);
    return pOrig;
}

char *prefix_(char *p){
    int tam = strlen(p);
    p = p + tam ;
    int i;
    for(i=0; i < tam + 1 ; i++){
        *(p+1) = *p;
        p--;
    }
    *(p+1) = '_';
    return p+1;
}

int searchSymbol(char key[]){
    static int llamada=0;
    llamada++;
    char mynombre[100];
    strcpy(mynombre,key);
    prefix_(downcase(mynombre));
    int i;
    for ( i = 0;  i < pos_st ; i++) {
        if(strcmp(symbolTable[i].nombre, mynombre) == 0){
            return i;
        }
    }
    return -1;
}

int saveSymbol(char nombre[], char tipo[], char valor[] ){
    char mynombre[100];
    char type[10];
    strcpy(type,tipo);
    strcpy(mynombre,nombre);
    downcase(type);
    int use_pos = searchSymbol(nombre);
    if ( use_pos == -1){
        use_pos = pos_st;
        pos_st++;
    }
    symbol newSymbol;
    
    //printf("\n Llegue... \n");
    if((strcmp(type,"float")==0 || strcmp(type,"cfloat")==0) && strstr(mynombre,".")!=NULL )
        replace_str(mynombre);
    
    //printf("\n Pase... \n");

    strcpy(newSymbol.nombre, prefix_(downcase(mynombre)));
    strcpy(newSymbol.tipo, type);
    if (valor == NULL){
        strcpy(newSymbol.valor, nombre);
    }
    else{
        strcpy(newSymbol.valor, valor);
    }
    newSymbol.longitud = strlen(nombre);

    int pos = searchSymbol(nombre);
    if(pos != -1)
        {
        printf("\nERROR!!!\nSimbolo duplicado ---> '%s' \n", nombre);
        exit(0);
        }
    symbolTable[use_pos] = newSymbol;
    newSymbol = nullSymbol;
    return 0;
}

symbol getSymbol(char nombre[]){
    int pos = searchSymbol(nombre);
    if(pos >= 0) return symbolTable[pos];
    return nullSymbol;
}

void symbolTableToExcel(symbol table[],char * ruta){
    //Declaracion de variables
    int i;
    //Definicion del archivo de salida y su cabecera
    FILE  *ptr = fopen(ruta, "w");
    fprintf(ptr,"nombre,tipo,valor,longitud,limite\n");
    for(i=0;i < pos_st ;i++) {
        fprintf(ptr, "%s,%s,%s,%d,%d\n",table[i].nombre,table[i].tipo,table[i].valor,table[i].longitud,table[i].limite);
    }
    //Fin
    fclose(ptr);
}
/* fin de funciones tabla de simbolos */

/*funciones  para handle de tipos */
int insertarTipo(char tipo[]) {
    strcpy(tipos[contTipos],tipo);
    strcpy(tipos[contTipos+1],"null");
    contTipos++;
    return 0;
}

int resetTipos(){
    contTipos = 0;
    strcpy(tipos[contTipos],"null");
    return 0;
}

int compararTipos(char *a, char *b){
    char auxa[50];
    char auxb[50];
    strcpy(auxa,a);
    strcpy(auxb,b);
    downcase(auxa);
    downcase(auxb);
    // fprintf(stdout,"Comparando %s y %s",auxa,auxb);
    // fflush(stdout);
    
    // sino se declaro alguna variable asigno null a tipo
    if (!strcmp(auxa, ""))
     strcpy(auxa,"null");
    
    if (!strcmp(auxb, ""))
     strcpy(auxb,"null");
    
    // Si se agrego algun null salgo
    if(!strcmp(auxa, "null") || !strcmp(auxb, "null") ){
      //     fprintf(stdout,"Son iguales\n");
           return 2;
    }
    // si  le asigno a un float un int lo deja pasar
    if ( !strcmp(auxa, "float") && !strcmp(auxb, "cint") ){
        //   fprintf(stdout,"Son iguales\n");
           return 0;
    }
    if(!strcmp(auxa, "float") && !strcmp(auxb, "int") ){
       //    fprintf(stdout,"Son iguales\n");
           return 0;
    }
    if (strstr(auxa,auxb) != NULL){
        return 0;
    }
    if (strstr(auxb,auxa) != NULL){
        return 0;
    }
    return 1;
}

int validarTipos(char tipo[]) {
    char msg[100];
    int i;
    for(i=0; i< contTipos; i++){
        if(compararTipos(tipo,tipos[i])==2){
            sprintf(msg, "Variable no declarada");
            yyerror(msg);
        }
        if(compararTipos(tipo,tipos[i])!=0){
            sprintf(msg, "Tipos incompatibles");
            yyerror(msg);
        }
    }
    resetTipos();
    return 0;
}
/*fin de funciones  para handle de tipos */

/***************************************************
funcion que genera la polaca en el archivo intermedia.txt
***************************************************/
void apilarPolaca(char *strToken){
        strcpy(pilaPolaca[posPolaca],strToken);
        //fprintf(ArchivoPolaca, "%d : %s\n", posPolaca, strToken);
        posPolaca++;
   	/*if (c != EOF )
			fprintf(ArchivoPolaca, ",");*/
}

void trampearPolaca(char *strToken){
    strcpy(pilaPolaca[posPolaca],pilaPolaca[posPolaca-1]);
    strcpy(pilaPolaca[posPolaca-1],strToken);
    posPolaca++;
}

void insertarPolaca(char *strToken, int pos){
    strcpy(pilaPolaca[pos],strToken);
}

void grabarPolaca(){
    int i;
    for(i=0; i<posPolaca ; i++){
        fprintf(ArchivoPolaca, "%s\n",pilaPolaca[i]);
    }
    fclose(ArchivoPolaca);
}

/***************************************************
funcion que genera etiquetas unicas
***************************************************/
void generarEtiqueta(){
    char string[25];
  	strcpy(Etiqueta,"@@etiq");
	contEtiqueta = contEtiqueta + 1;
    sprintf(string, "%d", contEtiqueta); // replaced itoa(contEtiqueta, string, 10)  for this.
    strcat(Etiqueta, string);
}

/***************************************************
funcion que guarda en la pila una etiqueta
***************************************************/
void apilarEtiqueta(char *strEtiq){
    strcpy(pilaEtiquetas[topeEtiquetas],strEtiq);
    topeEtiquetas = topeEtiquetas + 1;
}

void apilarEtiquetaW(char *strEtiq){
    strcpy(pilaEtiquetasW[topeEtiquetasW],strEtiq);
    topeEtiquetasW++;
}

void apilarWhile(int pos){
    pilaWhile[topePilaWhile]=pos;
    topePilaWhile++;
}

int desapilarWhile(){
    topePilaWhile--;
    return(pilaWhile[topePilaWhile]);
}

/***************************************************
funcion que saca de la pila una etiqueta
***************************************************/
void desapilarEtiqueta(){
    topeEtiquetas = topeEtiquetas - 1;
    strcpy(EtiqDesa,pilaEtiquetas[topeEtiquetas]);
	strcpy(pilaEtiquetas[topeEtiquetas],"");
}

void desapilarEtiquetaW(){
    topeEtiquetasW--;
    strcpy(EtiqDesaW,pilaEtiquetasW[topeEtiquetasW]);
	strcpy(pilaEtiquetasW[topeEtiquetasW],"");
}
/* fin de funciones para polaca */

int main(int argc,  char *argv[]){
    if ((ArchivoPolaca = fopen("intermedia.txt", "wt")) == NULL) {
        fprintf(stderr,"\nNo se puede crear el archivo: %s", "intermedia.txt");
        exit(1);
    }
    if ((yyin = fopen(argv[1], "rt")) == NULL){
	    fprintf(stderr, "\nNo se puede abrir el archivo: %s", argv[1]);
        exit(1);
	}
    strcpy(nullSymbol.nombre, "!");  // inicializando simbolo nulo
    yyparse();
    fclose(ArchivoPolaca);
    fclose(yyin);
    return 0;
}

void yyerror(char *msg){
    fflush(stderr);
    fprintf(stderr, "\n\n--- ERROR ---\nAt line %d: \'%s\'.\n\n", yylineno, msg);
    exit(1);
}

void reemplazarBlancos(char *cad){
	int i,num;
	char aux[50];
	for(i=0; i < strlen(cad); i++){
		if((cad[i]=='_') || cad[i]=='\0' || cad[i]=='\n' || (cad[i]>='0' &&cad[i]<='9') || (cad[i]>='a' && cad[i]<= 'z')|| (cad[i]>= 'A' &&cad[i]<='Z')){
			cteStrSinBlancos[i]=cad[i];
        }
		else{
		    cteStrSinBlancos[i]='_';
        }
	}
	cteStrSinBlancos[i--]='\0';
	strcpy(cad,cteStrSinBlancos);
}

/* todas las funciones para generar asm */
/***************************************************
funcion que saca de la pila asm un operando
***************************************************/
void desapilarOperando(){
	topePilaAsm--;
    if(topePilaAsm < 0){
        topePilaAsm=0;
        strcpy(strOpe,"!");
    }else{
    strcpy(strOpe,strPila[topePilaAsm]);
	strcpy(strPila[topePilaAsm],"");
    }
}
/***************************************************
funcion que guarda en la pila un operando
***************************************************/
void apilarOperando(char *strOp){
    printf("Apilando %s --- %d\n", strOp, topePilaAsm);
    strtok(strOp,"\n");
    strcpy(strPila[topePilaAsm],strOp);
    topePilaAsm++;
}
void imprimirHeader(FILE *p){
    fprintf(p,"include macros2.asm\n");
    fprintf(p,"include number.asm\n");
    fprintf(p,".MODEL LARGE\n.386\n.STACK 200h\n\n.DATA\n\tMAXTEXTSIZE equ 50\n ");
//    fprintf(p,"\t__result dd ? \n" );
    fprintf(p,"\t__flags dw ? \n" );
    fprintf(p,"\t__descar dd ? \n" );
    fprintf(p,"\toldcw dw ? \n" );
    fprintf(p,"\t__auxConc db MAXTEXTSIZE dup (?), '$'\n" );
    fprintf(p,"\t__resultConc db MAXTEXTSIZE dup (?), '$'\n" );
    fprintf(p,"\tmsgPRESIONE db 0DH, 0AH,'Presione una tecla para continuar...','$'\n");
    fprintf(p,"\t_newLine db 0Dh, 0Ah,'$'\n" );
    fprintf (ArchivoAsm,"vtext db 100 dup('$')\n ");
}
void imprimirFin(FILE *p){
    fprintf(p,"\n;finaliza el asm\n ");
    fprintf(p,"\tmov ah,4ch\n" );
    fprintf(p,"\tmov al,0\n" );
    fprintf(p,"\tint 21h\n" );
    //fprintf(p,"\n\nEND START" );
}
void imprimirProcs(FILE *p){
fprintf(p,"\nSTRLEN PROC NEAR\n");
fprintf(p,"\tmov BX,0\n");
fprintf(p,"\nSTRL01:\n");
fprintf(p,"\tcmp BYTE PTR [SI+BX],'$'\n");
fprintf(p,"\tje STREND\n");
fprintf(p,"\tinc BX\n");
fprintf(p,"\tjmp STRL01\n");
fprintf(p,"\nSTREND:\n");
fprintf(p,"\tret\n");
fprintf(p,"\nSTRLEN ENDP\n");
fprintf(p,"\nCOPIAR PROC NEAR\n");
fprintf(p,"\tcall STRLEN\n");
fprintf(p,"\tcmp BX,MAXTEXTSIZE\n");
fprintf(p,"\tjle COPIARSIZEOK\n");
fprintf(p,"\tmov BX,MAXTEXTSIZE\n");
fprintf(p,"\nCOPIARSIZEOK:\n");
fprintf(p,"\tmov CX,BX\n");
fprintf(p,"\tcld\n");
fprintf(p,"\trep movsb\n");
fprintf(p,"\tmov al,'$'\n");
fprintf(p,"\tmov BYTE PTR [DI],al\n");
fprintf(p,"\tret\n");
fprintf(p,"\nCOPIAR ENDP\n");
fprintf(p,"\nCONCAT PROC NEAR\n");
fprintf(p,"\tpush ds\n");
fprintf(p,"\tpush si\n");
fprintf(p,"\tcall STRLEN\n");
fprintf(p,"\tmov dx,bx\n");
fprintf(p,"\tmov si,di\n");
fprintf(p,"\tpush es\n");
fprintf(p,"\tpop ds\n");
fprintf(p,"\tcall STRLEN\n");
fprintf(p,"\tadd di,bx\n");
fprintf(p,"\tadd bx,dx\n");
fprintf(p,"\tcmp bx,MAXTEXTSIZE\n");
fprintf(p,"\tjg CONCATSIZEMAL\n");
fprintf(p,"\nCONCATSIZEOK:\n");
fprintf(p,"\tmov cx,dx\n");
fprintf(p,"\tjmp CONCATSIGO\n");
fprintf(p,"\nCONCATSIZEMAL:\n");
fprintf(p,"\tsub bx,MAXTEXTSIZE\n");
fprintf(p,"\tsub dx,bx\n");
fprintf(p,"\tmov cx,dx\n");
fprintf(p,"\nCONCATSIGO:\n");
fprintf(p,"\tpush ds\n");
fprintf(p,"\tpop es\n");
fprintf(p,"\tpop si\n");
fprintf(p,"\tpop ds\n");
fprintf(p,"\tcld\n");
fprintf(p,"\trep movsb\n");
fprintf(p,"\tmov al,'$'\n");
fprintf(p,"\tmov BYTE PTR [DI],al\n");
fprintf(p,"\tret\n");
fprintf(p,"\nCONCAT ENDP\n");
fprintf(p,"END START; final del archivo. \n");
}
 void imprimirVariables(FILE *p){  //aca tengo que leer la tabla de simbolos, para los float es fácil
                                  //para las cadenas no
    fprintf(p, "\n;Declaracion de variables de usuario\n");
    int i;
    float auxf;
    float auxi;
    char auxs[50];
    for(i=0; i < pos_st ; i++){
        
        if(strcmp(symbolTable[i].tipo, "float")==0){
            fprintf (p, "\t@%s\tdd\t?\n", &symbolTable[i].nombre[1]);
        }
        if(strcmp(symbolTable[i].tipo, "cfloat")==0){
            auxf= atof(symbolTable[i].valor);
            sprintf(auxs, "%.3f", auxf);
            fprintf (p, "\t@%s\tdd\t%s\n", symbolTable[i].nombre, auxs);
        }

        if(strcmp(symbolTable[i].tipo, "int")==0){
            fprintf (p, "\t@%s\tdd\t?\n", &symbolTable[i].nombre[1]);
        }

        if(strcmp(symbolTable[i].tipo, "cint")==0){
            auxi= atoi(symbolTable[i].valor);
            sprintf(auxs, "%.3f", auxi);
            fprintf (p, "\t@%s\tdd\t%s\n", symbolTable[i].nombre, auxs);
        }

        if(strcmp(symbolTable[i].tipo, "string")==0){
            fprintf (p,"\t@%s\tdb\tMAXTEXTSIZE dup (?),'$'\n", &symbolTable[i].nombre[1]);
        }
        if(strcmp(symbolTable[i].tipo, "cstring")==0){
                reemplazarBlancos(symbolTable[i].nombre);
                fprintf(p,"\t@%s\tdb\t'%s','$',%lu dup (?)\n", cteStrSinBlancos, symbolTable[i].valor, 49-strlen(symbolTable[i].valor) );
        }
    }
            //DECLARACION DE AUXILIARES
    for(i=0;i<100;i++){
        fprintf(p,"\t@auxR%d \tDD 0.0\n",i);
        //fprintf(p,"\t@_auxE%d \tDW 0\n",i);
    }
}
void generarCONC(){
	desapilarOperando();	//segundo operando en strOpe
    reemplazarBlancos(strOpe);
    auxSymbol = getSymbol(strOpe);
    desapilarOperando();
    reemplazarBlancos(strOpe);
    auxSymbol2 = getSymbol(strOpe);
	if(strcmp(auxSymbol2.tipo,"cstring")==0){
        fprintf(ArchivoAsm,"\tMOV SI, OFFSET @%s\n",auxSymbol2.nombre);
        fprintf(ArchivoAsm,"\tMOV DI, OFFSET __auxConc\n");
        fprintf(ArchivoAsm,"\tCALL COPIAR\n");
    }
    if(strcmp(auxSymbol2.tipo,"string")==0){
        fprintf(ArchivoAsm,"\tMOV SI, OFFSET @%s\n",&auxSymbol2.nombre[1]);
        fprintf(ArchivoAsm,"\tMOV DI, OFFSET __auxConc\n");
        fprintf(ArchivoAsm,"\tCALL COPIAR\n");
    }
    if(strcmp(auxSymbol.tipo,"cstring")==0){
        fprintf(ArchivoAsm,"\tMOV SI, OFFSET @%s\n",auxSymbol.nombre);
    	fprintf(ArchivoAsm,"\tMOV DI, OFFSET __auxConc\n");
    	fprintf(ArchivoAsm,"\tCALL CONCAT\n");
    }
    if(strcmp(auxSymbol.tipo,"string")==0){
        fprintf(ArchivoAsm,"\tMOV SI, OFFSET @%s\n",&auxSymbol.nombre[1]);
    	fprintf(ArchivoAsm,"\tMOV DI, OFFSET __auxConc\n");
    	fprintf(ArchivoAsm,"\tCALL CONCAT\n");
    }
	fprintf(ArchivoAsm,"\tMOV SI, OFFSET __auxConc\n");
    apilarOperando("__auxConc");
}
void generarWRITE(){
desapilarOperandos(1);

    //fprintf(ArchivoAsm,"\n %s \n", auxSymbol.tipo);
    if(strcmp(auxSymbol.tipo,"float")==0){
        fprintf(ArchivoAsm,"\tdisplayFloat @%s, 2\n",&auxSymbol.nombre[1]);
        goto sig;
    } 
    //else
        if(strcmp(auxSymbol.tipo,"cfloat")==0){
            fprintf(ArchivoAsm,"\tdisplayFloat @%s, 2\n",auxSymbol.nombre);
            goto sig;
        } 
        //else
            if(strcmp(auxSymbol.tipo,"int")==0){
                fprintf(ArchivoAsm,"\tdisplayFloat @%s, 2\n",&auxSymbol.nombre[1]);
                goto sig;
            } 
            //else
                if(strcmp(auxSymbol.tipo,"cint")==0){
                    fprintf(ArchivoAsm,"\tdisplayFloat @%s, 2\n",auxSymbol.nombre);
                    goto sig;
                } 
                //else 
                    if (strcmp(auxSymbol.tipo,"string")==0){
                        fprintf(ArchivoAsm,"\n\tLEA DX, @%s \n",&auxSymbol.nombre[1]);
                        fprintf(ArchivoAsm,"\tMOV AH, 9\n");
                        fprintf(ArchivoAsm,"\tINT 21H\n");
                    } 
                    else {
                        fprintf(ArchivoAsm,"\n\tLEA DX, @%s \n",auxSymbol.nombre);
                        fprintf(ArchivoAsm,"\tMOV AH, 9\n");
                        fprintf(ArchivoAsm,"\tINT 21H\n");
                        }
        sig:
        fprintf(ArchivoAsm,"\tnewline\n");
}
void generarADD(){
desapilarOperandos(2);

    if(strcmp(auxSymbol.tipo,"cint")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol.tipo,"int")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"cint")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol2.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"int")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol2.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol.tipo,"cfloat")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol.tipo,"float")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"cfloat")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol2.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"float")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol2.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    fprintf(ArchivoAsm,"\tfadd St(0),St(1)\n");
//    fprintf(ArchivoAsm,"\tfstp __result\n");
//    apilarOperando("__result");
}


void generarREST(){
desapilarOperandos(2);

    if(strcmp(auxSymbol.tipo,"cint")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol.tipo,"int")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"cint")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol2.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"int")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol2.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol.tipo,"cfloat")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol.tipo,"float")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"cfloat")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol2.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"float")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol2.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    fprintf(ArchivoAsm,"\tfsub St(0),St(1)\n");
//    fprintf(ArchivoAsm,"\tfstp __result\n");
//    apilarOperando("__result");
}



void generarDIV(){
desapilarOperandos(2);

    if(strcmp(auxSymbol.tipo,"cint")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol.tipo,"int")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"cint")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol2.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"int")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol2.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol.tipo,"cfloat")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol.tipo,"float")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"cfloat")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol2.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"float")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol2.nombre[1]); //fld qword ptr ds:[_%s]\n
    }

    fprintf(ArchivoAsm,"\tfdiv St(0),St(1)\n");
//    fprintf(ArchivoAsm,"\tfstp __result\n");
//    apilarOperando("__result");
}
void generarMUL(){
desapilarOperandos(2);

    if(strcmp(auxSymbol.tipo,"cint")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol.tipo,"int")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"cint")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol2.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"int")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol2.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol.tipo,"cfloat")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol.tipo,"float")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"cfloat")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol2.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"float")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol2.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    fprintf(ArchivoAsm,"\tfmul St(0),St(1)\n");
//    fprintf(ArchivoAsm,"\tfstp __result\n");
//    apilarOperando("__result");
}




void generarMOD(){
desapilarOperandos(2);

    if(strcmp(auxSymbol.tipo,"cfloat")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol.tipo,"float")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"cfloat")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol2.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"float")==0){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol2.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    fprintf(ArchivoAsm,"ParialLp:\tfprem1\n");
    fprintf(ArchivoAsm,"\tfstsw ax\n");
    fprintf(ArchivoAsm,"\ttest ah, 100b\n");
    fprintf(ArchivoAsm,"\tjnz ParialLp\n");
    fprintf(ArchivoAsm,"\tfabs\n");
//    fprintf(ArchivoAsm,"\tfstp __result\n");
//    apilarOperando("__result");
}
void generarSalto(){
    desapilarOperando();
    // en strOpe la etiqueta a donde hay que saltar;
    fprintf(ArchivoAsm,"\tjmp %s\n",strOpe); //fld qword ptr ds:[_%s]\n
}
void generarCMP(){
desapilarOperandos(2);

    char salto[50];
    char label[50];

    if(strcmp(auxSymbol.tipo,"cfloat")==0 ||strcmp(auxSymbol.tipo,"cint")==0 ){
        fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol.tipo,"float")==0||strcmp(auxSymbol.tipo,"int")==0 ){
        fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol.nombre[1]); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"cfloat")==0 ||strcmp(auxSymbol2.tipo,"cint")==0 ){
        fprintf(ArchivoAsm,"\tfcomp @%s\n",auxSymbol2.nombre); //fld qword ptr ds:[_%s]\n
    }
    if(strcmp(auxSymbol2.tipo,"float")==0 ||strcmp(auxSymbol2.tipo,"int")==0 ){
        fprintf(ArchivoAsm,"\tfcomp @%s\n",&auxSymbol2.nombre[1]); //fld qword ptr ds:[_%s]\n
    }

    
   


    fgets(label,sizeof(label),ArchivoPolaca);
    fgets(salto,sizeof(salto),ArchivoPolaca);
    strtok(salto,"\n");
    strtok(label,"\n");
    fprintf(ArchivoAsm,"\tfstsw AX\n");
    fprintf(ArchivoAsm,"\tsahf\n");
    fprintf(ArchivoAsm,"\t%s %s\n",salto, label);
    //aca leo el archivo directo, y saco el saltador y saco la etiqueta a donde salta
}
void generarASIG(){
desapilarOperandos(2);

    printf("==== %s\n", auxSymbol.nombre);
    printf("==== %s\n", auxSymbol2.nombre);
    if(strcmp(auxSymbol.tipo,"string")==0){
        if(strcmp(auxSymbol2.tipo,"cstring")==0){
            fprintf(ArchivoAsm,"\tMOV SI, OFFSET @%s\n",auxSymbol2.nombre); //fld qword ptr ds:[_%s]\n
    		fprintf(ArchivoAsm,"\tMOV DI, OFFSET @%s\n",&auxSymbol.nombre[1]); //qword ptr ds:[
            fprintf(ArchivoAsm,"\tcall COPIAR\n");
        }
        if(strcmp(auxSymbol2.tipo,"string")==0){
            fprintf(ArchivoAsm,"\tMOV SI, OFFSET @%s\n",&auxSymbol2.nombre[1]); //fld qword ptr ds:[_%s]\n
    		fprintf(ArchivoAsm,"\tMOV DI, OFFSET @%s\n",&auxSymbol.nombre[1]); //qword ptr ds:[
            fprintf(ArchivoAsm,"\tcall COPIAR\n");
        }
    }else{
        if(strcmp(auxSymbol2.tipo,"cfloat")==0){
            printf("\ncfloat %s \n", auxSymbol2.nombre);
            fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol2.nombre); //fld qword ptr ds:[_%s]\n
    		fprintf(ArchivoAsm,"\tfstp @%s\n",&auxSymbol.nombre[1]); //qword ptr ds:[
        }
        if(strcmp(auxSymbol2.tipo,"float")==0){
            fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol2.nombre[1]); //fld qword ptr ds:[_%s]\n
    		fprintf(ArchivoAsm,"\tfstp @%s\n",&auxSymbol.nombre[1]); //qword ptr ds:[
        }
        if(strcmp(auxSymbol2.tipo,"cint")==0){
            fprintf(ArchivoAsm,"\tfld @%s\n",auxSymbol2.nombre); //fld qword ptr ds:[_%s]\n
    		fprintf(ArchivoAsm,"\tfstp @%s\n",&auxSymbol.nombre[1]); //qword ptr ds:[
        }
        if(strcmp(auxSymbol2.tipo,"int")==0){
            fprintf(ArchivoAsm,"\tfld @%s\n",&auxSymbol2.nombre[1]); //fld qword ptr ds:[_%s]\n
    		fprintf(ArchivoAsm,"\tfstp @%s\n",&auxSymbol.nombre[1]); //qword ptr ds:[
        }
        if(strcmp(auxSymbol2.nombre,"!")==0){
            fprintf(ArchivoAsm,"\tfstp @%s\n",&auxSymbol.nombre[1]); //qword ptr ds:[
        }
    }
    if(strcmp("__auxConc",strOpe)==0){
            fprintf(ArchivoAsm,"\tMOV DI, OFFSET @%s\n",&auxSymbol.nombre[1]);
            fprintf(ArchivoAsm,"\tCALL COPIAR\n");
    }
    // a:= 1
    // a:= b /b
    // a:= b /b cadena
    // a:= "cadena"
}

void desapilarOperandos(int cant) //1 o 2 oeprandos desapilarOperandos(2);
{
    char strAux[50];
    desapilarOperando();
    if(strcmp(strOpe,"_aux")==0)
    {
        sprintf(strAux, "%s%d","_auxR" ,nroAuxReal);
        strcpy(auxSymbol.tipo,"float");
        strcpy(auxSymbol.nombre,strAux);
        strcpy(auxSymbol.valor,"0");
        nroAuxReal++;
    }
    else
        auxSymbol = getSymbol(strOpe);
    
    if (cant == 1)
        return;

    desapilarOperando();
    if(strcmp(strOpe,"_aux")==0)
    {
        sprintf(strAux, "%s%d","_auxR" ,nroAuxReal);
        strcpy(auxSymbol2.tipo,"float");
        strcpy(auxSymbol2.nombre,strAux);
        strcpy(auxSymbol2.valor,"0");
        nroAuxReal++;
    }
    else
        auxSymbol2 = getSymbol(strOpe);

printf("\nSimbolo1 %s ---Simbolo2 %s \n",auxSymbol.nombre,auxSymbol2.nombre);

    return;
}

void generarAsm(){
    if ((ArchivoPolaca = fopen("intermedia.txt", "rt")) == NULL){
        printf("ERROR!!!\nNo se Puede Abrir El Archivo intermedia.txt \n");
        exit(0);
    }
    if ((ArchivoAsm = fopen("Final.asm", "wt")) == NULL){
        printf("ERROR!!!\nNo se Puede Abrir El Archivo Final.asm \n");
        exit(0);
    }
    printf("\n\n..... Generando codigo Assembler ....\n\n");
    imprimirHeader(ArchivoAsm);
    imprimirVariables(ArchivoAsm);
    fprintf(ArchivoAsm,"\n.CODE\n");
    fprintf(ArchivoAsm,"START:\n");
    fprintf(ArchivoAsm,"\n\tMOV AX, @DATA\n");
    fprintf(ArchivoAsm,"\n\tMOV DS, AX\n");
    fprintf(ArchivoAsm,"\n\tMOV ES, AX\n");
    fprintf(ArchivoAsm,"\n\n;Comienzo codigo de usuario\n\n");

    while(fgets(linea,sizeof(linea),ArchivoPolaca)!=NULL){
        printf("\n ************* %s ************* \n", linea);
        if( strcmp(linea,"+\n") == 0 )
            generarADD();
        else
            if( strcmp(linea,"*\n") == 0 )
                generarMUL();
            else
            if( strcmp(linea,"-\n") == 0 )
                generarREST();
            else
                if( strcmp(linea,"/\n") == 0 )
                generarDIV();
                else
                if( strcmp(linea,"DIV\n") == 0 )
                    generarDIV();
                else
                    if(strcmp(linea,"++\n") == 0 )
                        generarCONC();
                    else
                        if( strcmp(linea,"=\n") == 0 )
                            generarASIG();
                        else
                            if( strcmp(linea,"WRITE\n") == 0 )
                                generarWRITE();
                        else
                            if(strcmp(linea,"MOD\n") == 0)
                                generarMOD();
                            else
                                if (strcmp(linea, "JMP\n")==0)
                                    generarSalto();
                                else
                                if( strcmp(linea,"CMP\n")==0)
                                    generarCMP();
                                else
                                    if(strstr(linea,":")!=NULL && strstr(linea,"@@etiq")!=NULL )
                                        fprintf(ArchivoAsm, "%s", linea);
                                    else
                                        apilarOperando(linea);
/*                    	if( strcmp(linea,"==\n") == 0
    		                  || strcmp(linea,"<\n") == 0
    		                  || strcmp(linea,"<=\n") == 0
    		                  || strcmp(linea,">\n") == 0
    		                  || strcmp(linea,">=\n") == 0
    		                  || strcmp(linea,"!=\n") == 0 ) //comparacion
    		;                //    generarCMP(linea); //funcion que genera el codigo asm para los comparadores
    		                  else
    		                    if( strcmp(linea,"BF\n") == 0 || strcmp(linea,"BV\n") == 0 || strcmp(linea,"BI\n") == 0)
    		 ;                 //    generarSalto(linea);
    		                    else
    		                      if(strchr(linea, ':') && linea[0]!='_')
    		  ;                  //    ponerEtiqueta(linea);
*/
    }
    imprimirFin(ArchivoAsm);
    imprimirProcs(ArchivoAsm);
    fclose(ArchivoAsm);
}