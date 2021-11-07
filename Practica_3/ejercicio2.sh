#!/bin/bash

#	Ejemplo de ejecución 1:	./ejercicio2.sh ejemploCarpeta
#	Ejemplo de ejecución 2:	./ejercicio2.sh ejemploCarpeta 400

case $# in
	0 )
		echo "You have typed insufficient arguments."
		echo "Arguments:"
		echo "1 → Directory."
		echo "2 → Bytes."

		exit -1;;

	1 )
		echo "Name, Lenght, UID, UserID, Username, i-nodes, Date, Permission, Executable"

		for i in $(find $1 -size +0); do
			if [[ -x $i ]]; then
				let executable=1
			else
				let executable=0
			fi

			extension=$(echo $i | grep -E -o '\..*')

			#	-n "$extension" indica que se escogen todas las cadenas que no sean NULL.
			#	En caso de querer aquellas que sean NULL, sustituir -n por -z.
			if [[ -n "$extension" ]]; then
				#	man stat para más información sobre los comandos utilizados en la siguiente línea:
				#	stat -c %u $i 	→	Estadística que muestra el ID de usuario del propietario.
				#	stat -c %U $i 	→	Estadísticas con el formato modificado, mostrando el usuario del fichero i.
				#	stat %i $i 		→	Estadística que muestra los i-nodos.
				#	stat %W $i 		→	Estadística que muestra la fecha de origen del fichero (en segundos) desde 01-01-1970.
				#	stat %A $i 		→ 	Estadística que muestra los permisos del fichero.
				echo "$(basename -s $extension $i), $(basename -s $extension $i | wc -m), $(stat -c %u $i), $(stat -c %U $i), $(stat -c %i $i), $(stat -c %W $i), $(stat -c %A $i), $executable"
			else
				echo "$(basename $i), $(basename $i | wc -m), $(stat -c %u $i), $(stat -c %U $i), $(stat -c %i $i), $(stat -c %W $i), $(stat -c %A $i), $executable"
			fi
		done | sort -nr -k2;;

	2 )
		echo "Name, Lenght, UID, UserID, Username, i-nodes, Date, Permission, Executable"

		#	find $1 -size +$2c		→ 	la c indica que la unidad de referencia son los bytes.
		#	Para más información	→	man find.
		for i in $(find $1 -size +$2c); do
			if [[ -x $i ]]; then
				let executable=1
			else
				let executable=0
			fi

			extension=$(echo $i | grep -E -o '\..*')

			if [[ -n "$extension" ]]; then
				echo "$(basename -s $extension $i), $(basename -s $extension $i | wc -m), $(stat -c %u $i), $(stat -c %U $i), $(stat -c %i $i), $(stat -c %W $i), $(stat -c %A $i), $executable"
			else
				echo "$(basename $i), $(basename $i | wc -m), $(stat -c %u $i), $(stat -c %U $i), $(stat -c %i $i), $(stat -c %W $i), $(stat -c %A $i), $executable"
			fi
		done | sort -nr -k2;;

	* )
		echo "You have typed too many arguments."
		echo "Arguments:"
		echo "1 → Directory."
		echo "2 → Bytes."

		exit -1;;
	
esac