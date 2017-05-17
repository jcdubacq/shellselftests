#!/bin/sh

intro () {
    echo "Un fichier de noms \"noms.csv\" au format csv vous est fourni. Il comporte deux colonnes séparées par des virgules : un nom et prénom d'elfe, suivi du genre (M = masculin, F = féminin) de l'elfe. La tâche que vous devez accomplir est de séparer ce fichier en un fichier \"masculin.csv\" qui ne comporte plus qu'une colonne (le nom) et les lignes correspondant à des noms masculins, et un fichier \"feminin.csv\" qui aura aussi une seule colonne et les lignes correspondants à des noms féminins. De plus, ces deux fichiers devront être triés par ordre alphabétique (prénom puis nom)."
}

setup () {
    echo 'Tórin Kiladar,M
Adanmerun Werthanryl,M
Thaniadon Galatathar,M
Thanlassthor ,M
Minthanion Nelthalial,M
Aircion Auglynnonel,M
Tamoheus Celetathdren,M
Kamaeion Cuelenelen,M
Rithitur Rundirlal,M
Valandaugnïn Aldaviel,M
Lairetherdas Roloelwa,M
Thalestan Elervir,M
Galenassduil Cutholthar,M
Elgon Augglinaseer,M
Lithyangien Culynnelen,M
Elrathril Malanmae,M
Imbaradon Bermirian,M
Eruanthordrach Felvanian,M
Melfortien Aeravathar,M
Tidurdil Malereian,M
Suidordhron Werethion,M
Elien Cromvathar,M
Barathoron Cuësial,M
Veriothtur Larendilinil,M
Tiruraina Halynntinu,F
Morminaiel Galondhen,F
Erialiel Aeraos,F
Silwen Larenethryl,F
Maranna Beretheil,F
Filmaivya Galonlinde,F
Aeadhwen Aldarina,F
Læthedra Berdironel,F
Tirladiel Laryadar,F
Yathrinniel Roloron,F
Daerbanniel Haevir,F
Maebreththiriel Tathren,F
Findranneth Rhuimin,F
Limomariiel Aeraenddar,F
Maerwen Toradragelen,F
Camirwen Larenereina,F
Yæra Galadiriel,F
Rewethiel Gwaviel,F
Maerima Elenrina,F
Isthonsta Aeradilinellyn,F
Lostroncath Ealolithe,F
Sidhanathaiel Birelon,F
Caranwen Falalond,F
Anadhwen Galondhen,F
Amarwen Tathsumë,F'|shuf > noms.csv
}

setupfinal () {
    setup
    mv noms.csv tmp.csv
    shuf < tmp.csv |head -n 30 > noms.csv
    rm -f tmp.csv
}

normaltests () {
    runandcapture
    nostderr
    thistest Vérification des noms masculins
    filecheck eb0456ec35981e310db55c2c155cfe04 masculin.csv
    thistest Vérification des noms féminins
    filecheck 9f350efc34eda8bbc571bd54f411b0b5 feminin.csv
}

finaltests () {
    setup
    runandcapture
    nostderr
    thistest Vérification des noms masculins
    filecheck eb0456ec35981e310db55c2c155cfe04 masculin.csv
    thistest Vérification des noms féminins
    filecheck 9f350efc34eda8bbc571bd54f411b0b5 feminin.csv
    normaltests
    setupfinal
    runandcapture
    nostderr
    thistest Vérification des noms masculins
    filecheck $(grep ,M$ < noms.csv|sort|md5sum|cut -c1-32) masculin.csv
    thistest Vérification des noms féminins
    filecheck $(grep ,F$ < noms.csv|sort|md5sum|cut -c1-32) feminin.csv
}

. ../common/framework.sh
