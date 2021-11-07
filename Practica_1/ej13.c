/*--------------------------------------------------------------------------------------------
	Ejercicio Resumen 13 - Práctica 1: Programación en POSIX.

		-Asignatura: 	Programación y Administración de Sistemas 2019 - 2020. 
		-Profesor: 		Juan Carlos Fernández Caballero (jfcaballero@uco.es).
		-Autor: 		Ventura Lucena Martínez (i72lumav@uco.es).
--------------------------------------------------------------------------------------------*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <mqueue.h>
#include <time.h>
#include <errno.h>
#include <unistd.h>

#define SERVER_QUEUE  "/server_queue"
#define MAX_SIZE     1024
#define MSG_STOP     "exit"

void functionLog(char *);
FILE *fLog = NULL;

int main(int argc, char *argv[])
{
/*--------------------------------------------------------------------------------------------
	-Variables referentes a la cola.
--------------------------------------------------------------------------------------------*/

	// Cola del servidor
	mqd_t mq_server;
	struct mq_attr attr;

	// Buffer para intercambiar mensajes.
	char buffer[MAX_SIZE];
	// flag que indica cuando hay que parar. Se escribe palabra exit.
	int must_stop = 0;

	// Inicializar los atributos de la cola.
	attr.mq_maxmsg = 10;        // Máximo número de mensajes.
	attr.mq_msgsize = MAX_SIZE; // Máximo tamaño de un mensaje.

    // Nombre para la cola.
    char serverQueue[100];
	sprintf(serverQueue, "%s-%s", SERVER_QUEUE, getenv("USER"));

//--------------------------------------------------------------------------------------------

    int flag = 0, status;

    switch(fork())
    {
    	case -1:
    		perror("Process child failed.");
    		exit(EXIT_FAILURE);

//--------------------------------------------------------------------------------------------

    	case 0:
    		printf("[Client]: Queue name: %s\n", serverQueue);

    		//	El proceso hijo abre la cola creada por el padre.
    		mq_server = mq_open(serverQueue, O_RDWR);

    		if(mq_server == (mqd_t)-1 )
			{
     	 		perror("There was an error opening the server queue.");
      			exit(EXIT_FAILURE);
			}

    		printf("[Client]: Queue descriptor: %d\n", (int) mq_server);
	    	printf("\nSending to server (type \"%s\" to stop):\n\n", MSG_STOP);
	    		
	    	// Iterar hasta escribir el código de salida.
			while(strncmp(buffer, MSG_STOP, strlen(MSG_STOP)))
			{
				//	WRITE
				if(flag == 0)
    			{
					//usleep(1);
					printf("\t[Client]: > ");
					fgets(buffer, MAX_SIZE, stdin);
					functionLog(buffer);

					//	Enviar y comprobar si el mensaje se manda.
					//	int mq_send(mqd_t mqdes, const char *msg_ptr, size_t msg_len, unsigned msg_prio);
					if(mq_send(mq_server, buffer, MAX_SIZE, 0) != 0)
					{
						perror("Message send failed");
						exit(EXIT_FAILURE);
					}

					flag = 1;
				}else{
					//	READ
					ssize_t bytes_read;

					// Recibir el mensaje.
					bytes_read = mq_receive(mq_server, buffer, MAX_SIZE, NULL);
					// Comparar que la recepción es correcta (bytes leidos no son negativos).
					if(bytes_read < 0)
					{
						perror("Message receive failed.");
						exit(EXIT_FAILURE);
					}

					// Comprobar el fin del bucle.
					if(strncmp(buffer, MSG_STOP, strlen(MSG_STOP))==0)
					{
						must_stop = 1;
					}else{
						printf("\t[Client]: Message received: %s", buffer);
						printf("\t[Client]: Characters read: %ld\n\n", strlen(buffer) - 1);
					}

					flag = 0;
				}	
			}

			// Cerrar la cola del servidor.
			if(mq_close(mq_server) == (mqd_t)-1)
			{
				perror("There was an error while closing the queue.");
				exit(EXIT_FAILURE);
			}

    		exit(EXIT_SUCCESS);

//--------------------------------------------------------------------------------------------

    	default:
    		// Nombre para la cola. Al concatenar el login será única en un sistema compartido.
   			printf("\n[Server]: Queue name: %s\n", serverQueue);

   			// Crear la cola de mensajes del servidor.
			mq_server = mq_open(serverQueue, O_CREAT | O_RDWR, 0644, &attr);

			if(mq_server == (mqd_t)-1 )
			{
   				perror("There was an error opening the server queue.");
     			exit(EXIT_FAILURE);
			}
			printf("[Server]: Queue descriptor: %d\n", (int) mq_server);

			// Iterar hasta que llegue el código de salida, es decir, la palabra exit.
			while (!must_stop)
			{
				//	READ
				if(flag == 0)
				{
					// Número de bytes leidos.
					ssize_t bytes_read;

					// Recibir el mensaje
					bytes_read = mq_receive(mq_server, buffer, MAX_SIZE, NULL);
					flag = 1;

					// Comparar que la recepción es correcta (bytes leidos no son negativos).
					if(bytes_read < 0)
					{
						perror("Message receive failed.");
						exit(EXIT_FAILURE);
					}

					// Comprobar el fin del bucle
					if(strncmp(buffer, MSG_STOP, strlen(MSG_STOP))==0)
					{
						must_stop = 1;
					}else{
						printf("\t[Server]: Message received: %s", buffer);
						printf("\t[Server]: Characters read: %ld\n\n", strlen(buffer) - 1);
					}

				}else{
					//	WRITE
					//usleep(1);
					printf("\t[Server]: > ");
					fgets(buffer, MAX_SIZE, stdin);

					functionLog(buffer);

					//	En caso de que la siguiente palabra escrita sea "exit", saldrá del bucle y finalizará el programa.
					if (strncmp(buffer, MSG_STOP, strlen(MSG_STOP))==0)
					{
						must_stop = 1;
					}
					//	Enviar y comprobar si el mensaje se manda.
					//	int mq_send(mqd_t mqdes, const char *msg_ptr, size_t msg_len, unsigned msg_prio);
					if(mq_send(mq_server, buffer, MAX_SIZE, 0) != 0)
					{
						perror("Message send failed");
						exit(EXIT_FAILURE);
					}
					flag = 0;
				}
			}

			// Cerrar la cola del servidor
			if(mq_close(mq_server) == (mqd_t)-1)
			{
				perror("There was an error while closing the server queue.");
				exit(EXIT_FAILURE);
			}

			// Eliminar la cola del servidor
			if(mq_unlink(serverQueue) == (mqd_t)-1)
			{
				perror("There was an error while removing the server queue.");
				exit(EXIT_FAILURE);
			}

//--------------------------------------------------------------------------------------------

			//	Recogida del hijo creado.
			int childpid = wait(&status); 
			if(childpid > 0)
			{
			 	if (WIFEXITED(status)) 
				{
					  printf("\nChild %d exited, status = %d\n",childpid, WEXITSTATUS(status));
				} 
				else if(WIFSIGNALED(status)) 
				{
					  printf("\nChild %d killed (signal %d)\n", childpid, WTERMSIG(status));
				} 
				else if(WIFSTOPPED(status)) 
				{
					  printf("\nChild %d stopped (signal %d)\n", childpid, WSTOPSIG(status));
				} 
			}else{
				printf("Error en la invocacion de wait o la llamada ha sido interrumpida por una señal.\n");
				exit(EXIT_FAILURE);
			} 

			exit(EXIT_SUCCESS);
	}

	exit(EXIT_SUCCESS);
}

/*--------------------------------------------------------------------------------------------
	-Función:
		void functionLog(char *mensaje)

	-Descripción:
		Función encargada de registrar los mensajes, tanto del servidor como del cliente,
		en un fichero de texto nombrado "logfile_ej13.txt".
--------------------------------------------------------------------------------------------*/

void functionLog(char *mensaje)
{
	int resultado;
	char nombreFichero[100];
	char mensajeAEscribir[300];
	time_t t;

	// Abrir el fichero
	sprintf(nombreFichero,"logfile_ej13.txt");
	if(fLog==NULL)
	{
		fLog = fopen(nombreFichero,"at");
		if(fLog==NULL)
		{
			perror("There was an error opening the logfile: log-file-ej13.");
			exit(1);
		}
	}

	// Obtener la hora actual
	t = time(NULL);
	struct tm * p = localtime(&t);
	strftime(mensajeAEscribir, 1000, "[%Y-%m-%d, %H:%M:%S]", p);

	// Vamos a incluir la hora y el mensaje que nos pasan
	sprintf(mensajeAEscribir, "%s --> %s\n", mensajeAEscribir, mensaje);

	// Escribir finalmente en el fichero
	resultado = fputs(mensajeAEscribir,fLog);
	if (resultado < 0)
		perror("Could not write on file.");

	fclose(fLog);
	fLog=NULL;
}