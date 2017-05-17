#!/bin/sh

intro () {
    echo "Les minions se sont cachés dans des fichiers. Mais combien sont-ils au-fait ? Comptez les minions qui apparaissent dans les fichiers qui commencent par GRU et affichez le nombre sur la sortie standard (juste le nombre)."
}

setup () {
    echo 'Dragons:1
Minions:12
Licornes:3
Yétis:5
TRex:8
Minions:21' > GRU1
    echo 'Requins:12
Yétis:2
Minions:31
Poulets:3
Minons:5' > GRU2
}

setupfinal () {
    setup
    echo 'Serpent:6
TRex:1
Minions:50' > GRU3
    echo 'Minions:600
Mineurs:2' > GRU4
}

normaltests () {
    runandcapture
    nostderr
    thistest Vérification du compte de minions
    A=0
    N=$(cat GRU*|grep ^Minions: |cut -f2 -d:|while read line; do A=$((A+line)); echo $A; done|tail -n 1)
    stringequal "$N" "$(cat STDOUT.txt)"
}

finaltests () {
    normaltests
}

. ../common/framework.sh
