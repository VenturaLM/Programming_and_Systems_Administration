#!/bin/bash

#	Ejemplo de ejecución:	./ejercicio2.sh ficherosPr4/peliculas.txt
#	Comprobar aquí:	https://regex101.com/

if [[ -f $1 ]]; then
	cat $1 | sed -r -e "/^=*$/d" | sed -r -e "/^[\ ]+.*$/d" | sed -r -e "s/^[(](.*)[)].*$/|-> Fecha de estreno: \1/g" | sed -r -e "s/^Dirigida por (.*)/|-> Director: \1/g" | sed -r -e "s/^([0-9]h [0-9][0-9]min)/|-> Duración: \1/g" | sed -r -e "s/^Reparto: (.*)/|-> Reparto: \1/g" | sed -r -e "s/^([^|])/Título: \1/g"
else
	echo "Failure: No such a file."
	exit -1
fi