#!/bin/sh

intro () {
    echo "Les zombies sont là ! Je vais lancer plusieurs processus qui sont tous identiques et qui patientent 12345 secondes avant de mourir. Vous n'avez qu'une poignées de secondes pour les éliminer et triompher de cette épreuve. Toutefois, il ne faut éliminer qu'eux. Un processus qui attent 4 secondes est lancé en parallèle et celui-ci doit toujours être vivant..."
}

setup () {
    sleep 4 &
    NUM=$(date +%s)
    XNUM=$((NUM%3+2))
    for i in $(seq $XNUM); do
        sleep 12345 &
    done
}

setupfinal () {
    setup
}

normaltests () {
    runandcapture
    nostderr
    thistest Vérification que les 12345 sont morts
    stringequal "$(ps -ef | grep 'sleep 12345'|grep -v grep|wc -l)" "0"
    thistest Vérification que le sleep 4 est vivant
    stringequal "$(ps -ef | grep 'sleep 4'|grep -v grep|wc -l)" "1"
}

finaltests () {
    normaltests
}

. ../common/framework.sh
