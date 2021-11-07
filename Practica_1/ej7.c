/*--------------------------------------------------------------------------------------------
	Ejercicio Resumen 7 - Práctica 1: Programación en POSIX.

		-Asignatura: 	Programación y Administración de Sistemas 2019 - 2020. 
		-Profesor: 		Juan Carlos Fernández Caballero (jfcaballero@uco.es).
		-Autor: 		Ventura Lucena Martínez (i72lumav@uco.es).
--------------------------------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <sys/types.h>
#include <pwd.h>
#include <grp.h>
#include <unistd.h>
#include <string.h>
#include <ctype.h>

int main(int argc, char *argv[])
{
	int c;
	FILE* file;
	char aux[2] = ":";
	char *token;
	char group_name[63];
//--------------------------------------------------------------------------------------------
//								Estructura para usar long_options							//
//--------------------------------------------------------------------------------------------
	static struct option long_options[] =
	{
		/* Opciones que no van a actuar sobre un flag */
		/* "opcion", recibe o no un argumento, 0,
		   identificador de la opción */
		{"username",	required_argument,	0,	'u'},
		{"useruid",		required_argument, 	0,	'i'},
		{"groupname",	required_argument,	0,	'g'},
		{"groupuid",	required_argument,	0,	'd'},
		{"allgroups",	no_argument,	0,	's'},
		{"allinfo",		required_argument, 	0,	'a'},
		{"bactive",		no_argument,	0,	'b'},
		{"help",	no_argument,	0,	'h'},
		/* Necesario para indicar el final de las opciones */
		{0, 0, 0, 0}
	};

	//getopt_long guardará el índice de la opción en esta variable.
	int option_index = 0;
	opterr = 0;
//--------------------------------------------------------------------------------------------
//								Obtener información de usuario								//
//--------------------------------------------------------------------------------------------
	char *lgn;
	struct passwd *pw;
	struct group *gr;
//--------------------------------------------------------------------------------------------
	char *lang = "LANG", *value;
//--------------------------------------------------------------------------------------------
	if(argc == 1)
	{
		//Caso en el que no se haya introducido ningún nombre de usuario.
		if((lgn = getenv("USER")) == NULL || (pw = getpwnam(lgn)) == NULL)
		{
			fprintf(stderr, "Get of user information failed.\n");
			exit(EXIT_FAILURE);
		}

		value = getenv(lang);

		if(strstr(value, "ES"))
		{
			printf("Nombre: \t\t%s\n", pw->pw_gecos);
			printf("Usuario: \t\t%s\n", pw->pw_name);
			printf("Contraseña: \t\t%s\n", pw->pw_passwd);
			printf("ID usuario: \t\t%d\n", pw->pw_uid);
			printf("Carpeta del usuario: \t%s\n", pw->pw_dir);
			printf("Terminal: \t\t%s\n", pw->pw_shell);
			printf("Grupo principal: \t%d\n", pw->pw_gid);

			gr = getgrgid(pw->pw_gid);			
			printf("Nombre grupo principal: %s\n", gr->gr_name);
		}else{
			printf("Name: \t\t\t%s\n", pw->pw_gecos);
			printf("Login: \t\t\t%s\n", pw->pw_name);
			printf("Password: \t\t%s\n", pw->pw_passwd);
			printf("UID: \t\t\t%d\n", pw->pw_uid);
			printf("Home: \t\t\t%s\n", pw->pw_dir);
			printf("Shell: \t\t\t%s\n", pw->pw_shell);
			printf("Main group: \t\t%d\n", pw->pw_gid);

			gr = getgrgid(pw->pw_gid);			
			printf("Main group name: \t%s\n", gr->gr_name);
		}

		exit(EXIT_SUCCESS);
	}
//--------------------------------------------------------------------------------------------
	while((c = getopt_long(argc, argv, "u:i:g:d:sa:bh", long_options, &option_index)) != -1)
	{
		if(c == -1)
		{
			break;
		}

		switch(c)
		{
			case 'u':
				//	Argumento:	Username.
				//	Comprueba que ninguna de las opciones siguientes, desde la actual, sea incompatible.
				for (int i = optind; i < argc; i++)
				{
					if((strcmp(argv[i], "a")) || (strcmp(argv[i], "i")))
					{
						printf("Options not compatible.\n");
						printf("For more information see: ./ej7 --help\n");
						exit(EXIT_FAILURE);
					}
				}

				lgn = optarg;

				if((pw = getpwnam(lgn)) == NULL)
				{
					fprintf(stderr, "Get of user information failed.\n");
					exit(EXIT_FAILURE);
				}

				printf("Name: \t\t\t%s\n", pw->pw_gecos);
				printf("Login: \t\t\t%s\n", pw->pw_name);
				printf("Password: \t\t%s\n", pw->pw_passwd);
				printf("UID: \t\t\t%d\n", pw->pw_uid);
				printf("Home: \t\t\t%s\n", pw->pw_dir);
				printf("Shell: \t\t\t%s\n", pw->pw_shell);
				printf("Main group: \t\t%d\n", pw->pw_gid);
				break;
//--------------------------------------------------------------------------------------------
			case 'i':
				//	Argumento:	UID.
				//	Comprueba que ninguna de las opciones siguientes, desde la actual, sea incompatible.			
				for (int i = optind; i < argc; i++)
				{
					if(strcmp(argv[i], "u"))
					{
						printf("Options not compatible.\n");
						printf("For more information see: ./ej7 --help\n");
						exit(EXIT_FAILURE);
					}
				}
				
				//	Comprueba que el argumento introducido sea un un dígito:
				//		- Si es dígito: Se acepta.
				//		- Si no es dígito: No se acepta.
				for(int i = 0; i < strlen(optarg); i++)
				{
					if(!isdigit(optarg[i]))
					{
						fprintf(stderr, "The argument must be an user id.\n");
						printf("For more information see: ./ej7 --help\n");
						exit(EXIT_FAILURE);
					}
				}

				if((pw = getpwuid(atoi(optarg))) == NULL)
				{
					fprintf(stderr, "Get of user information failed.\n");
					exit(EXIT_FAILURE);
				}

				printf("Name: \t\t\t%s\n", pw->pw_gecos);
				printf("Login: \t\t\t%s\n", pw->pw_name);
				printf("Password: \t\t%s\n", pw->pw_passwd);
				printf("Home: \t\t\t%s\n", pw->pw_dir);
				printf("Shell: \t\t\t%s\n", pw->pw_shell);
				printf("Main group: \t\t%d\n", pw->pw_gid);
				break;
//--------------------------------------------------------------------------------------------
			case 'g':
				//	Argumento:	Groupname.
					if((gr = getgrnam(optarg)) == NULL)
					{
						fprintf(stderr, "The argument must be a group name.\n");
						printf("For more information see: ./ej7 --help\n");
						exit(EXIT_FAILURE);
					}
			
					printf("Main group number: \t%d\n", gr->gr_gid);
				break;
//--------------------------------------------------------------------------------------------
			case 'd':
				//	Argumento:	Group number.

				//	Comprueba que el argumento introducido sea un un dígito:
				//		- Si es dígito: Se acepta.
				//		- Si no es dígito: No se acepta.
				for(int i = 0; i < strlen(optarg); i++)
				{
					if(!isdigit(optarg[i]))
					{
						fprintf(stderr, "The argument must be a group number.\n");
						printf("For more information see: ./ej7 --help\n");
						exit(EXIT_FAILURE);
					}
				}

				if((gr = getgrgid(atoi(optarg))) == NULL)
				{
					fprintf(stderr, "Get of user information failed.\n");
					exit(EXIT_FAILURE);
				}

				printf("Main group: \t%s\n", gr->gr_name);
				break;
//--------------------------------------------------------------------------------------------
			case 's':
				//	Argumento:	-

				if((file = fopen("/etc/group", "r")) == NULL){
					printf("Text opening failed.\n");
					exit(EXIT_FAILURE);
				}

				printf("\t(GroupName - GroupNumber)\n");
				printf("\t------------------------\n");
				while(fgets(group_name, 63, file) != NULL){

					token = strtok(group_name, aux);
					if(token != NULL)
					{
						gr = getgrnam(group_name);
						printf("\t%s - %d\n", group_name, gr->gr_gid);
					}
				}

				fclose(file);
				break;
//--------------------------------------------------------------------------------------------
			case 'a':
				//	Argumento:	Username.
				//	Comprueba que ninguna de las opciones siguientes, desde la actual, sea incompatible.			
				for (int i = optind; i < argc; i++)
				{
					if(strcmp(argv[i], "u"))
					{
						printf("Options not compatible.\n");
						printf("For more information see: ./ej7 --help\n");
						exit(EXIT_FAILURE);
					}
				}

				lgn = optarg;

				if((pw = getpwnam(lgn)) == NULL)
				{
					fprintf(stderr, "Get of user information failed.\n");
					exit(EXIT_FAILURE);
				}

				printf("Name: \t\t\t%s\n", pw->pw_gecos);
				printf("Login: \t\t\t%s\n", pw->pw_name);
				printf("Password: \t\t%s\n", pw->pw_passwd);
				printf("UID: \t\t\t%d\n", pw->pw_uid);
				printf("Home: \t\t\t%s\n", pw->pw_dir);
				printf("Shell: \t\t\t%s\n", pw->pw_shell);
				printf("Main group: \t\t%d\n", pw->pw_gid);

				gr = getgrgid(pw->pw_gid);			
				printf("Main group name: \t%s\n", gr->gr_name);
				break;
//--------------------------------------------------------------------------------------------
			case 'b':
				//	Argumento:	-

				if((lgn = getenv("USER")) == NULL || (pw = getpwnam(lgn)) == NULL)
				{
					fprintf(stderr, "Get of user information failed.\n");
					exit(EXIT_FAILURE);
				}

				printf("Main group: \t\t%d\n", pw->pw_gid);

				gr = getgrgid(pw->pw_gid);			
				printf("Main group name: \t%s\n", gr->gr_name);
				break;
//--------------------------------------------------------------------------------------------
			case 'h':
				//	Argumento:	-
				//	Descripción de una posible ayuda referente al programa.

				printf("How to use:\n\t-No arguments: ./ej7\n\t-Arguments: ./ej7 [OPTIONS]\n\n");

				printf("Description:\n\tShows information about the users of the system.\n\n");

				printf("Options:\n");
				printf("\t-a, --allinfo: \t\tSpecifies the user's information and the group to which it belongs.\n");
				printf("\t-b, --bactive: \t\tSpecifies the current group and user.\n");
				printf("\t-d, --groupuid: \tSpecifies the group ID.\n");
				printf("\t-g, --groupname: \tSpecifies the main group name.\n");
				printf("\t-h, --help: \t\tShows this help.\n");
				printf("\t-i, --useruid: \t\tSpecifies the user's struct.\n");
				printf("\t-s, --allgroups: \tShows information about the system groups.\n");
				printf("\t-u, --username: \tSpecifies the user's information.\n\n");

				printf("Options' arguments:\n");
				printf("\t-a, --allinfo: \t\t[Username].\n");
				printf("\t-b, --bactive: \t\t-\n");
				printf("\t-d, --groupuid: \t[Group number].\n");
				printf("\t-g, --groupname: \t[Group name].\n");
				printf("\t-h, --help: \t\t-\n");
				printf("\t-i, --useruid: \t\t[User ID].\n");
				printf("\t-s, --allgroups: \t-\n");
				printf("\t-u, --username: \t[Username].\n");

				printf("\nOptions not compatible:\n\t1. [-u] [-i] or [-i] [-u].\n\t2. [-u] [-a] or [-a] [-u].\n");
				break;
//--------------------------------------------------------------------------------------------
			case '?':
				if(optopt == 'u')
				{
					fprintf (stderr, "Option %c requires an argument.\n", optopt);
					printf("For more information see: ./ej7 --help\n");
					exit(EXIT_FAILURE);
				}

				if(optopt == 'i')
				{
					fprintf (stderr, "Option %c requires an argument.\n", optopt);
					printf("For more information see: ./ej7 --help\n");
					exit(EXIT_FAILURE);
				}

				if(optopt == 'g')
				{
					fprintf (stderr, "Option %c requires an argument.\n", optopt);
					printf("For more information see: ./ej7 --help\n");
					exit(EXIT_FAILURE);
				}

				if(optopt == 'd')
				{
					fprintf (stderr, "Option %c requires an argument.\n", optopt);
					printf("For more information see: ./ej7 --help\n");
					exit(EXIT_FAILURE);
				}

				if(optopt == 'a')
				{
					fprintf (stderr, "Option %c requires an argument.\n", optopt);
					printf("For more information see: ./ej7 --help\n");
					exit(EXIT_FAILURE);
				}
				//	Comprueba si el carácter es imprimible.
				else if(isprint (optopt))
				{
		            fprintf(stderr, "Unrecognized option \"-%c\".\nFor more information see: ./ej7 --help\n", optopt);
		        	exit(EXIT_FAILURE);
		        }
		        //	Carácter no imprimible o especial.
		        else{
		            fprintf(stderr, "Character `\\x%x' is not printable.\n", optopt);
		            printf("For more information see: ./ej7 --help\n");
		            exit(EXIT_FAILURE);
		        }
				break;

			default:
				abort();
		}
	}

	if (optind < argc)
	{
		printf("\nArguments ARGV that are not options: ");
		while (optind < argc)
			printf("%s ", argv[optind++]);
		putchar ('\n');
	}

	exit(EXIT_SUCCESS);
}