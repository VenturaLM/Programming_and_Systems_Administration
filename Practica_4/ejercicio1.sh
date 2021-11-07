#!/bin/bash

#	Ejemplo de ejecución:					./ejercicio1.sh ficherosPr4/peliculas.txt
#	Expresiones regulares en tiempo real:	https://regex101.com/

if [[ -f $1 ]]; then
	#	Mostrar líneas que contienen la duración de la película:
	#	Al principio de línea un dígito →  ^[0-9]
	#	una "h"							→	\h
	#	un espacio						→	[[:space:]]
	#	dos dígitos						→	[0-5][0-9]
	#	secuencia "min"					→	\min
	echo "*******"
	echo "1) Lenght of the film:"
	cat $1 | grep -E "^[0-9]\h[[:space:]][0-5][0-9]\min"

	#	Mostrar líneas que contienen el país de la película, suponiendo que siempre aparecen entre corchetes.
	echo "*******"
	echo "2) Country:"
	cat $1 | grep -E "\[.*\]"

	#	Mostrar únicamente los países.
	#	Para ello, usar el mismo comando anterior añadiéndole "-o" que, en lugar de imprimir la línea completa, únicamente imprime las coincidencias.
	echo "*******"
	echo "3) Just the country:"
	cat $1 | grep -E -o "\[.*\]" | grep -E -o "[[:alpha:]]+.[[:alpha:]]+"

	echo "*******"	
	echo "4) $(cat $1 | grep -E "\(.+\/2016\)" | wc -l) films in 2016 and $(cat $1 | grep -E "\(.+\/2017\)" | wc -l) films in 2017."

	echo "*******"
	echo "5) Erase empty lines:"
	cat $1 | grep -E "^."

	echo "*******"
	echo "6) Starting lines with the letter 'E' or 'L':"
	cat $1 | grep -E "^[[:space:]]*[EL]"

	echo "*******"
	#	([dlt]{1})	→	Agrupación 1. El último \1 hace referencia a esta agrupación. En caso de que fuese \n, hace referencia a la agrupación n.
	#	{1}			→	Número de veces que se repite el patrón.
	echo "7) Lines containing d, l, or t, a vowel and the same letter:"
	cat $1 | grep -E "([dlt]{1})[aeiou]{1}\1"

	echo "*******"
	echo "8) Lines containing 8 or more 'a'":
	cat $1 | grep -E "([Aa].*){8,}"

	echo "*******"
	#	Comenzar con algo != de espacio	→ 	[^\ ]	→ Con esto niego el escape de espacio. Aquí no funciona [[:space:]].
	#	Que termine con 3 puntos		→	[\.]{3}$
	echo "9) Lines ending with 3 dots without starting with space:"
	cat $1 | grep -E "^[^\ ].*[\.]{3}$"

	echo "*******"
	#	s/	→	Sustituye en el primer grupo localizado con los paréntesis.
	echo "10)"
	sed -r -e 's/([ÁÉÍÓÚáéíóú])/"\1"/g' $1 | grep -E "[ÁÉÍÓÚáéíóú]" --color

else
	echo "Failure: No such a file."
	exit -1
fi