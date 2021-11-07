#!/bin/bash

#	Ejemplo de ejecución:	./ejercicio6.sh 0
#							-/ejercicio6.sh 1
#	https://regex101.com/
#	Estructura del fichero /etc/passwd:	Usuario|Password|UID|GID|gecos|Home|Shell
case $1 in

	0 )	#	Todos los usuarios.
		cat /etc/passwd | sed -r -n "s/^(.*):.*:(.*):(.*):(.*):(.*):(.*)/Logname: \1\n->UID: \2\n->GID: \3\n->gecos: \4\n->Home: \5#\n->Shell por defecto: \6/p";;

	1 )	#	Usuarios cuyo UID sea mayor que 1000.
		for i in $(cat /etc/passwd | sed -r -n "s/^(.*):.*:([1-9][0-9][0-9][1-9]+):(.*):(.*):(.*):(.*)/\2/p"); do
		if [[ "$i" -gt 1000 ]]; then
		#echo "$i"
		cat /etc/passwd | sed -r -n "s/^(.*):.*:($i):(.*):(.*):(.*):(.*)/Logname: \1\n->UID: \2\n->GID: \3\n->gecos: \4\n->Home: \5\n->Shell por defecto: \6/p"
		fi
		done;;

	*)
		echo "Argumento incorrecto."
		exit -1;;
esac