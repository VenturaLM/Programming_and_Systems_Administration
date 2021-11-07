#!/bin/bash

#	Ejemplo de ejecución:	./ejercicio1.sh ejemploCarpeta

#	if(0 < arg < 1)
#	{
#		Controlar el número de argumentos.
#	}

if [[ $# -eq 0 ]] || [[ $# -gt 1 ]]; then
	echo "Type just 1 argument."
	exit -1
fi

if [[ -d $1 ]]; then
	#	La opción -e realiza un salto de línea.
	echo -e
	echo "Argument [$1] introduced."
	echo -e

	#	En caso de que también quiera mostrar los archivos .h, sustituir la sentencia del bucle por la siguiente:
	#	$(find $1 -name "*.c" -o -name "*.h")
	for x in $(find $1 -name "*.c"); do
		echo "File '$x' has $(cat $x | wc -l) lines and $(cat $x | wc -m) characters."
	done | sort -nr -k4

	#	sort	→	Ordenar.
	#	-nr 	→	Númericamente y de manera inversa.
	#	-k4		→	Cambia la clave de ordenación que, de manera predeterminada es la primera columna.
	#				Como interesa ordenarlo por el número de líneas, se ordena por el elemento cuarto del
	#				echo del bucle: "$(cat $x | wc -l)".
else
	echo "No such a directory."
	exit -1
fi