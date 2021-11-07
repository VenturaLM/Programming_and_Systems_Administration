#!/bin/bash

#	Ejemplo de ejecución:	./ejercicio6.sh ejemploCarpeta

function fill_file_html()
{
	#	Aqui $1 es el argumento de la función, no el argumento del programa.
	for i in $(find "$1" -maxdepth 1); do
		if [[ ! -d $i ]]; then
			echo "<ul>" >> "$html_file"
			echo "<li>$i</li>" >> "$html_file"
			echo "</ul>" >> "$html_file"
		else
			#	Para que rastree en distintos directorios.
			if [[ $i != $1 ]]; then
				echo "<ul>" >> "$html_file"
				echo "<li><strong>$i</strong></li>" >> "$html_file"
				#	Vuelvo a llamar a la función de manera recursiva.
				fill_file_html $i
				echo "</ul>" >> "$html_file"
			fi
		fi
	done
}

case $# in
	1 )
		if [[ -d $1 ]]; then
			html_file="$(basename "$1").hmtl"
		else
			exit -1
		fi

		cat > "$html_file" << end
			<html>
			<head>
			<title>Listado del directorio $1/$html_file</title>
			</head>
			<body>
			<style type="text/css">
			body { font-family: sans-serif;}
			</style>
			<h1>Listado del directorio $1</h1>
end
	fill_file_html $1
		#	>> Para continuar escribiendo sin reemplazar el fichero.
		cat >> "$html_file" << end
			</body>
			</html>
end
	;;
#	El "end" anterior tiene que estar sin espaciado y sin tabulación alguna.

	* )
		echo "You have typed insufficient or too many arguments."
		echo "Arguments:"
		echo "1 → Directory."

		exit -1;;
esac