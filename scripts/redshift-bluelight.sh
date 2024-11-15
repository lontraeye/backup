#!/bin/bash

ICONS=("" "" "")
INDEX_FILE="index.txt"
REDSHIFT_PROCESS="redshift"

if [[ ! -f $INDEX_FILE ]]; then
    echo 0 >"$INDEX_FILE"
fi

index=$(<"$INDEX_FILE")

print_icon() {
    echo "${ICONS[index]}"
}

increment_icon() {
    index=$(((index + 1) % ${#ICONS[@]}))
    echo "$index" >"$INDEX_FILE"
}

if [[ $# -eq 0 ]]; then
    echo "Por favor, forneça um comando (incrementar ou mostrar)."
    exit 1
fi

kill_redshift() {
    if pgrep -x "$REDSHIFT_PROCESS" >/dev/null; then
        echo "Matando o processo $REDSHIFT_PROCESS..."
        pkill -x "$REDSHIFT_PROCESS"
    fi
}

case $1 in
mostrar)
    print_icon
    ;;
incrementar)
    increment_icon
    print_icon

    if [[ $index -eq 0 ]]; then

        kill_redshift 

	redshift -O 5000 & 

    elif [[ $index -eq 1 ]]; then

        kill_redshift

         redshift -l 24.7335773514906:-53.71932206893908 &

    elif [[ $index -eq 2 ]]; then
        kill_redshift

        redshift -x &
    fi
    ;;
*)
    echo "Comando inválido. Use 'mostrar' ou 'incrementar'."
    exit 1
    ;;
esac
