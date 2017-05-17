#!/bin/sh

intro () {
    echo "Le but de cet exercice est d'attribuer les droits corrects à des fichiers."
    echo "Le fichier secret.txt doit être lisible et inscriptible par et uniquement par le propriétaire du fichier."
    echo "Le fichier public.txt doit être lisible par tous, mais modifiable uniquement par vous (le propriétaire) et le groupe."
    echo "Le fichier programme.sh ne doit pas être modifiable, même par vous. Par contre, c'est un programme. C'est d'ailleurs le seul programme, les autres fichiers sont de simples fichiers textes."
    echo "Le fichier reserve/prive.txt doit être lisible et modifiable par tous, par contre seuls ceux qui connaissent son chemin doivent pouvoir le faire, personne d'autre (sauf le propriétaire)."
    echo "Les droits ont été mis d'une certaine façon au début, mais votre script doit fonctionner quels que soient les droits initiaux."
}

setup () {
    mkdir -p reserve
    chmod 755 reserve
    for ij in secret.txt:640 public.txt:440 programme.sh:444 reserve/prive.txt:000; do
        i=$(echo "$ij"|cut -f1 -d:)
        j=$(echo "$ij"|cut -f2 -d:)
        echo "Contenu du fichier $i" > $i
        if [ "$i" = "programme.sh" ]; then
            echo '#!/bin/sh
echo "Le programme fonctionne"' > $i
        fi
        chmod $j $i
    done
}

setupsecondaire () {
    cleanup
    mkdir -p reserve
    chmod 700 reserve
    for ij in secret.txt:000 public.txt:666 programme.sh:666 reserve/prive.txt:647; do
        i=$(echo "$ij"|cut -f1 -d:)
        j=$(echo "$ij"|cut -f2 -d:)
        echo "Contenu du fichier $i" > $i
        if [ "$i" = "programme.sh" ]; then
            echo '#!/bin/sh
echo "Le programme fonctionne"' > $i
        fi
        chmod $j $i
    done
    chmod 000 reserve
}

setupfinal () {
    setup
}

normaltests () {
    runandcapture
    nostderr
    thistest Vérification de secret.txt
    checkmodes secret.txt 600
    thistest Vérification de public.txt
    checkmodes public.txt 664
    thistest Vérification de programme.sh
    checkmodes programme.sh 555
    thistest Vérification de reserve/prive.txt
    checkmodes reserve 711
    checkmodes reserve/prive.txt 666
}

finaltests () {
    normaltests
    setupsecondaire
    normaltests
}

. ../common/framework.sh
