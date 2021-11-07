#!/bin/bash

#	Ejemplo de ejecución:	./ejercicio4.sh ejemploCarpeta

if [[ $# -lt 1 ]] ; then
	echo "Type at least 1 argument."
	echo "Arguments:"
	echo "1 → [Necessary] Directory."
	echo "2...N → [Optional] Directory."
	exit -1
fi

for i in $*; do
	#	En caso de que sea un directorio (-d) ó un fichero(-f):
	if [[ ! -d $i ]]; then
		echo "$i: no such a directory."
		exit -1
	fi
done

#	Fecha en segundos desde 01-01-1970 asociada al nombre del fichero.
date=$(date +%s)

#	Carpeta donde se guardará la copia de seguridad bajo previa comprabación de su existencia.
if [[ ! -d Copia ]]; then
	backup=$(mkdir Copia)
fi

#	Se efectúa la compresión.
tar -cf copia-$USER-$date.tar.gz $*

#	Se mueve la compresión al registro de compresiones.
mv copia-$USER-$date.tar.gz Copia

#	Recorrer la carpeta copia para identificar los archivos con +200 segundos de antigüedad.
for x in $(find Copia); do
	if [[ -f $x ]]; then
		# %Y: time of last data modification, seconds since Epoch.
		let birth="$(stat -c %Y $x)"
		let time=$((date-birth))
		let removal_time=200

		if [[ time -ge removal_time ]]; then
			rm "$x"
		fi
	fi
done

echo -e
echo "Success!: Backup done."