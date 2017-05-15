#!/bin/sh

intro () {
    echo "Cet exercice vise à tester les fonctions de copie, déplacement, suppression. Des fichiers vont être installés dans le répertoire de l'exercice. Votre script devra copier les fichiers se terminant par \"jpg\" dans un répertoire (à créer) \"Images\", déplacer les fichiers intitulés \"notes\" suivi de quelque chose et terminés par .txt dans un répertoire (à créer) notes, et enfin effacer tous les fichiers qui auront comme début tmp, TMP ou toute autre combinaison majuscules/minuscules. Quant au fichier mire.gif, il doit être renommé en MIRE.GIF et mis dans le dossier \"Images\"."

}


cleanupfinal () {
    find . -type f -name '*.sh' -prune -o -type f -print0 | xargs -0 --no-run-if-empty rm
    find . -mindepth 1 -type d -print0 | xargs -0 --no-run-if-empty rmdir
}

setup () {
    for i in orange.jpg prune.jpg marmotte.jpg notes12.txt notes24avril.txt note.txt notthingham.txt tmp41.xls TMP18.doc TPM.txt TMP.txt mire.gif; do
        echo "Contenu du fichier $i" > $i
    done
}

setupfinal () {
    setup
    for i in antitest.JPG amour.jpg antitest.txt note92.txt notes221.txt tmp.xls; do
        echo "Contenu du fichier $i" > $i
    done
    rm TMP18.doc
}

normaltests () {
    runandcapture
    nostderr
    thistest Vérification des copies
    for i in orange.jpg prune.jpg marmotte.jpg; do
        SIGN=$(echo "Contenu du fichier $i"|md5sum|cut -c1-32)
        filecheck $SIGN $i
        filecheck $SIGN Images/$i
    done
    thistest Vérification du déplacement
    for i in notes12.txt notes24avril.txt; do
        SIGN=$(echo "Contenu du fichier $i"|md5sum|cut -c1-32)
        filenotexists $i
        filecheck $SIGN notes/$i
    done
    thistest Vérification de la suppression
    for i in TMP18.doc tmp41.xls TMP.txt; do
        filenotexists $i
    done
    thistest Vérification du renommage
    filenotexists mire.gif
    SIGN=$(echo "Contenu du fichier mire.gif"|md5sum|cut -c1-32)
    filecheck $SIGN Images/MIRE.GIF
}

finaltests () {
    runandcapture
    nostderr
    thistest Vérification des copies
    for i in orange.jpg prune.jpg marmotte.jpg amour.jpg; do
        SIGN=$(echo "Contenu du fichier $i"|md5sum|cut -c1-32)
        filecheck $SIGN $i
        filecheck $SIGN Images/$i
    done
    thistest Vérification du déplacement
    for i in notes12.txt notes24avril.txt notes221.txt; do
        SIGN=$(echo "Contenu du fichier $i"|md5sum|cut -c1-32)
        filenotexists $i
        filecheck $SIGN notes/$i
    done
    thistest Vérification de la suppression
    for i in tmp41.xls TMP.txt tmp.xls; do
        filenotexists $i
    done
    thistest Vérification du renommage
    filenotexists mire.gif
    SIGN=$(echo "Contenu du fichier mire.gif"|md5sum|cut -c1-32)
    filecheck $SIGN Images/MIRE.GIF
}

cleanup () {
    true
}

. ../common/framework.sh
