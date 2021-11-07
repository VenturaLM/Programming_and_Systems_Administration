#!/bin/bash

#	Ejemplo de ejecución:	./ejercicio5.sh

echo -n "How old are you? "
read age

if [[ $age -lt 21 ]]; then
	#	Años que faltan para poder conducir.
	let time_remaining=$((21-age))

	echo "You are not allowed to drive a car. You will need to spend $time_remaining years."
else
	#	Veces que se conduce por año.
	let r=$(($RANDOM%200))
	#	Veces que ha conducido desde que tiene edad de conducir.
	let times=$(((age-20)*r))
	echo "You are allowed to drive a car and you have driven $times times."
fi