#!/bin/bash

case $# in
	0 )
		echo "You have typed insufficient arguments."
		echo "Arguments:"
		echo "1 → [Necessary] Directory."
		echo "2 → [Optional] Lesser files."
		echo "3 → [Optional] Bigger files."

		exit -1;;

	1 )	#Ejemplo de ejecución:	./ejercicio3.sh ejemploCarpeta/
		#	Directorio - Pequeños y Grandes por defecto = 4.
		#	Compruebo si el argumento 1 es un directorio.
		if [[ -d $1 ]]; then

			#	if(existe $1/<nombre_directorio>)
			#	{
			#		remove($1/<nombre_directorio>/...)
			#		create($1/<nombre_directorio>)
			#	}else{
			#		create($1/<nombre_directorio>)
			#	}

			#	--------------------------------------------------------------------------------------
			if [[ -e $1/pequenos ]]; then
				rm -d -r $1/pequenos
				lesser_files=$(mkdir $1/pequenos)
			else
				lesser_files=$(mkdir $1/pequenos)
			fi
			#	--------------------------------------------------------------------------------------
			if [[ -e $1/medianos ]]; then
				rm -d -r $1/medianos
				medium_files=$(mkdir $1/medianos)
			else
				medium_files=$(mkdir $1/medianos)
			fi
			#	--------------------------------------------------------------------------------------
			if [[ -e $1/grandes ]]; then
				rm -d -r $1/grandes
				bigger_files=$(mkdir $1/grandes)
			else
				bigger_files=$(mkdir $1/grandes)
			fi
			#	--------------------------------------------------------------------------------------

			#	Gestión de ficheros auxiliares.
			bigger_file=$(mktemp)
			lesser_file=$(mktemp)
			medium_file=$(mktemp)

			#	Número de ficheros que hay en el directorio pasado como argumento.
			n_Files=$(find $1 -type f | wc -l)

			let n_medium_files=$((n_Files-4))
			let n_medium_files_2=$((n_medium_files-4))

			#	--------------------------------------------------------------------------------------

			#	Operaciones con los 4 ficheros más grandes.
			for iterator_1 in $(find $1); do
				#	-f comprueba si es un fichero.
				if [[ -f $iterator_1 ]]; then
					echo "$iterator_1 $(stat -c %s $iterator_1)"
				fi
			done | sort -nr -k2 | head -4 | grep -E -o '.*\ ' >> bigger_file

			#	--------------------------------------------------------------------------------------

			#	Operaciones con los 4 ficheros más pequeños.
			for iterator_2 in $(find $1); do
				if [[ -f $iterator_2 ]]; then
					echo "$iterator_2 $(stat -c %s $iterator_2)"
				fi
			done | sort -n -k2 | head -4 | grep -E -o '.*\ ' >> lesser_file

			#	--------------------------------------------------------------------------------------

			#	Operaciones con los ficheros medianos.
			for iterator_3 in $(find $1); do
				if [[ -f $iterator_3 ]]; then
					echo "$iterator_3 $(stat -c %s $iterator_3)"
				fi
			done | sort -n -k2 | tail -$n_medium_files | sort -nr -k2 | tail -$n_medium_files_2 | grep -E -o '.*\ ' >> medium_file

			#	--------------------------------------------------------------------------------------

			#	Se introducen los ficheros en sus respectivas carpetas.
			for iterator_1 in $(cat bigger_file); do
				cp $iterator_1 $1/grandes
			done

			for iterator_2 in $(cat lesser_file); do
				cp $iterator_2 $1/pequenos
			done

			for iterator_3 in $(cat medium_file); do
				cp $iterator_3 $1/medianos
			done

			#	--------------------------------------------------------------------------------------
		fi;;

	2 )	#Ejemplo de ejecución:	./ejercicio3.sh ejemploCarpeta/ 15
		#	Pequeños - Grandes por defecto = 4.
		if [[ -d $1 ]]; then
			#	--------------------------------------------------------------------------------------
			if [[ -e $1/pequenos ]]; then
				rm -d -r $1/pequenos
				lesser_files=$(mkdir $1/pequenos)
			else
				lesser_files=$(mkdir $1/pequenos)
			fi
			#	--------------------------------------------------------------------------------------
			if [[ -e $1/medianos ]]; then
				rm -d -r $1/medianos
				medium_files=$(mkdir $1/medianos)
			else
				medium_files=$(mkdir $1/medianos)
			fi
			#	--------------------------------------------------------------------------------------
			if [[ -e $1/grandes ]]; then
				rm -d -r $1/grandes
				bigger_files=$(mkdir $1/grandes)
			else
				bigger_files=$(mkdir $1/grandes)
			fi
			#	--------------------------------------------------------------------------------------

			#	Gestión de ficheros auxiliares.
			bigger_file=$(mktemp)
			lesser_file=$(mktemp)
			medium_file=$(mktemp)

			#	Número de ficheros que hay en el directorio pasado como argumento.
			n_Files=$(find $1 -type f | wc -l)

			let n_medium_files=$((n_Files-4))
			let n_medium_files_2=$((n_medium_files-$2))

			#	--------------------------------------------------------------------------------------

			#	Operaciones con los 4 ficheros más grandes.
			for iterator_1 in $(find $1); do
				if [[ -f $iterator_1 ]]; then
					echo "$iterator_1 $(stat -c %s $iterator_1)"
				fi
			done | sort -nr -k2 | head -4 | grep -E -o '.*\ ' >> bigger_file

			#	--------------------------------------------------------------------------------------

			#	Operaciones con los 4 ficheros más pequeños.
			for iterator_2 in $(find $1); do
				if [[ -f $iterator_2 ]]; then
					echo "$iterator_2 $(stat -c %s $iterator_2)"
				fi
			done | sort -n -k2 | head -$2 | grep -E -o '.*\ ' >> lesser_file

			#	--------------------------------------------------------------------------------------

			#	Operaciones con los ficheros medianos.
			for iterator_3 in $(find $1); do
				if [[ -f $iterator_3 ]]; then
					echo "$iterator_3 $(stat -c %s $iterator_3)"
				fi
			done | sort -n -k2 | tail -$n_medium_files | sort -nr -k2 | tail -$n_medium_files_2 | grep -E -o '.*\ ' >> medium_file

			#	--------------------------------------------------------------------------------------

			#	Se introducen los ficheros en sus respectivas carpetas.
			for iterator_1 in $(cat bigger_file); do
				cp $iterator_1 $1/grandes
			done

			for iterator_2 in $(cat lesser_file); do
				cp $iterator_2 $1/pequenos
			done

			for iterator_3 in $(cat medium_file); do
				cp $iterator_3 $1/medianos
			done

			#	--------------------------------------------------------------------------------------
		fi;;

	3 )	#	Ejemplo ejecución:	./ejercicio3.sh ejemploCarpeta/ 5 5
		#	Pequeños y Grandes.
		if [[ -d $1 ]]; then
			#	--------------------------------------------------------------------------------------
			if [[ -e $1/pequenos ]]; then
				rm -d -r $1/pequenos
				lesser_files=$(mkdir $1/pequenos)
			else
				lesser_files=$(mkdir $1/pequenos)
			fi
			#	--------------------------------------------------------------------------------------
			if [[ -e $1/medianos ]]; then
				rm -d -r $1/medianos
				medium_files=$(mkdir $1/medianos)
			else
				medium_files=$(mkdir $1/medianos)
			fi
			#	--------------------------------------------------------------------------------------
			if [[ -e $1/grandes ]]; then
				rm -d -r $1/grandes
				bigger_files=$(mkdir $1/grandes)
			else
				bigger_files=$(mkdir $1/grandes)
			fi
			#	--------------------------------------------------------------------------------------

			#	Gestión de ficheros auxiliares.
			bigger_file=$(mktemp)
			lesser_file=$(mktemp)
			medium_file=$(mktemp)

			#	Número de ficheros que hay en el directorio pasado como argumento.
			n_Files=$(find $1 -type f | wc -l)

			let n_medium_files=$((n_Files-$3))
			let n_medium_files_2=$((n_medium_files-$2))

			#	--------------------------------------------------------------------------------------

			#	Operaciones con los 4 ficheros más grandes.
			for iterator_1 in $(find $1); do
				if [[ -f $iterator_1 ]]; then
					echo "$iterator_1 $(stat -c %s $iterator_1)"
				fi
			done | sort -nr -k2 | head -$3 | grep -E -o '.*\ ' >> bigger_file

			#	--------------------------------------------------------------------------------------

			#	Operaciones con los 4 ficheros más pequeños.
			for iterator_2 in $(find $1); do
				if [[ -f $iterator_2 ]]; then
					echo "$iterator_2 $(stat -c %s $iterator_2)"
				fi
			done | sort -n -k2 | head -$2 | grep -E -o '.*\ ' >> lesser_file

			#	--------------------------------------------------------------------------------------

			#	Operaciones con los ficheros medianos.
			for iterator_3 in $(find $1); do
				if [[ -f $iterator_3 ]]; then
					echo "$iterator_3 $(stat -c %s $iterator_3)"
				fi
			done | sort -n -k2 | tail -$n_medium_files | sort -nr -k2 | tail -$n_medium_files_2 | grep -E -o '.*\ ' >> medium_file

			#	--------------------------------------------------------------------------------------

			#	Se introducen los ficheros en sus respectivas carpetas.
			for iterator_1 in $(cat bigger_file); do
				cp $iterator_1 $1/grandes
			done

			for iterator_2 in $(cat lesser_file); do
				cp $iterator_2 $1/pequenos
			done

			for iterator_3 in $(cat medium_file); do
				cp $iterator_3 $1/medianos
			done

			#	--------------------------------------------------------------------------------------
		fi;;

	* )
		echo "You have typed too many arguments."
		echo "Arguments:"
		echo "1 → [Necessary] Directory."
		echo "2 → [Optional] Lesser files."
		echo "3 → [Optional] Bigger files."

		exit -1;;
esac

	rm bigger_file
	rm lesser_file
	rm medium_file