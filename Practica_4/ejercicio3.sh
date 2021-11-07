#!/bin/bash

#	Ejemplo de ejecución: 	./ejercicio3.sh
#	Este programa únicamente es válido en el sistema operativo Linux de la Universidad de Córdoba a 17-05-2020.

DIA=`date +"%d/%m/%Y"`
HORA=`date +"%H:%M:%S"`

DIA2=`date -u +%s`

for (( i = 1; i <= $(who | wc -l); i++ )); do

	users=$(who | sed -r -e 's/^(.+)p.+(2020.+)\(.*$/\2/' | sed -n "$i p")
	user_time=`date -d "$users" +%s`
	user=$(who | sed -r -e 's/^(.+) +pts.*/\1/' | sed -n "$i p")

	let segundos=$((DIA2-user_time))
	let horas=$((segundos/3600))		#	Segundos en un día.
	let segundos=$((segundos-horas*3600))
	let minutos=$((segundos/60))
	let segundos=$((segundos-minutos*60))

	echo "El usuario $user lleva un total de $horas horas, $minutos minutos y $segundos segundos conectado."
	
done