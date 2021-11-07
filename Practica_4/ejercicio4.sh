#!/bin/bash

#	Ejemplo de ejecución:	./ejercicio4.sh ficherosPr4/IPs.txt 1

case $# in
	2 )
		if [[ -f $1 ]]; then
			for i in $(cat $1); do
				#	-n para imprimir la línea que se ve afectada por la expresión regular. Para ellos es necesario poner la "p".
				time=$(ping -c 1 $i -W $2 | sed -r -n -e "s/.*time=(.*) ms.*/\1/p")

				#	En el caso de que no se guarde nada en tiempo, ya que no se ha recibido respuesta, se dirige al else.
				if [[ $time ]]; then
					echo "La IP $i respondió en $time milisegundos."
				else
					echo "La IP $i no respondió tras $2 segundos."
				fi
			#	NO se está ordenando bien por alguna extraña razón que desconozco.
			done | sort -n -k6
		else
			echo "Failure: No such a file."
			exit -1
		fi;;

	* )
		echo "Se ha introducido un número de parámetros incorrecto."
		exit -1;;
esac
