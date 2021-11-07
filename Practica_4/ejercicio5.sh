#!/bin/bash

#	Ejemplo de ejecución:	./ejercicio5.sh
#	https://regex101.com/

#	Modelo de procesador:
#	s/^model name[^\ ]: (.*$)/Modelo del procesodor: \1/p 	→	Selecciona aquello que comience por "model name : -caracteres- hasta fin del línea."
#	head -1 												→	Dado que muestra los mismos procesadores, escoger sólo la primera coincidencia.
cat /proc/cpuinfo | sed -r -n "s/^model name[^\ ]: (.*$)/Modelo del procesodor: \1/p" | head -1

#	Megahercios:
cat /proc/cpuinfo | sed -r -n "s/^cpu MHz[^\ ].*: (.*)/Megaherzios: \1/p" | head -1

#	Número de hilos máximos de ejecución:
cat /proc/cpuinfo | sed -r -n "s/^processor[^\ ]: (.*)/\1/p" | echo "Número de hilos máximo de ejecución: $(wc -l)"

#	Tamaño de caché:
cat /proc/cpuinfo | sed -r -n "s/^cache size[^\ ]: (.*)/Tamaño de caché: \1/p" | head -1

#	Identificador del vendedor:
cat /proc/cpuinfo | sed -r -n "s/^vendor_id[^\ ]: (.*)/Identificador del vendedor: \1/p" | head -1

#	Particiones disponibles con su número de bloques (Ordenadas alfabéticamente de forma inversa por partición).
echo "Particiones y número de bloques:"
cat /proc/partitions | sed -r -n "s/.*[0-9]+.*[0-9]+.* ([0-9]+) (.*)$/Partición: \2, Número de bloques: \1/p" | sort -br -k2