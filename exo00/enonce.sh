#!/bin/sh

intro () {
    echo "Bonjour. L'énoncé de chaque exercice vous est donné en exécutant le script portant le nom enonce.sh dans chaque répertoire.

Pour répondre à un exercice, vous allez devoir créer un script appelé reponse.sh dans le répertoire de l'exercice, puis lancer \"enonce.sh test\". Divers tests auront alors lieu pour savoir si votre script fonctionne.

Je répète: pour répondre à un exercice, vous devez créer un script \"reponse.sh\" qui sera exécuté pour répondre au problème posé. Pas un autre nom, pas d'espace bizarre, pas de majuscules étranges.

Une fois que vous serez satisfait du passage des tests préliminaires par votre script, vous pourrez enregistrer votre réponse auprès du professeur en lançant \"enonce.sh\" commit. Des tests supplémentaires seront fait et donneront votre note.

Le but de ce premier exercice est de créer un fichier texte intitulé NOM.txt qui comprendra votre nom et prénom sur une seule ligne, d'une part ; et d'autre part un script dont la seule utilité est d'afficher dans le terminal la chaîne \"Bonjour.\" (sans les guillemets autour)."
}

setup () {
    true
}

setupfinal () {
    setup
}

normaltests () {
    runandcapture
    nostderr
    thistest Vérification du fichier NOM.txt
    fileexists ../NOM.txt
    stringequal "$(head -n 1 STDOUT.txt)" "Bonjour."
    thistest Vérification de la sortie
    stringequal "$(head -n 1 STDOUT.txt)" "Bonjour."
    filecheck 8bf282d28077db1c697afb13f25a7109 STDOUT.txt
}

finaltests () {
    normaltests
}

. ../common/framework.sh
