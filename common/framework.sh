HDIR=$(dirname "$0")
cd "$HDIR"
HDIR=$(pwd)
stylebold=$(tput bold)
stylenormal=$(tput sgr0)
setup

initialcheck () {
    thistest "Le fichier de réponse existe"
    SUBTEST=0
    SUBTEST=$((SUBTEST+1))
    NUMTESTS=$((NUMTESTS+1))
    echo "  Sous-test $MAINTEST.1" >> JOURNAL.txt
    echo "    Le fichier <$(pwd)/reponse.sh> existe-t-il ?" >> JOURNAL.txt
    if [ -f "reponse.sh" ]; then
        ALLTESTS=$((ALLTESTS+1))
        echo "    Oui! $ALLTESTS/$NUMTESTS" >> JOURNAL.txt
    else
        echo "    Non! $ALLTESTS/$NUMTESTS" >> JOURNAL.txt
    fi
}

runandcapture () {
    cd "$HDIR"
    if [ ! -f "reponse.sh" ]; then
        echo "Vous n'avez pas encore créé de fichier \"reponse.sh\" dans $HDIR"
        rm -f STDOUT.txt
        touch STDOUT.txt
    else
        echo "J'execute reponse.sh $@" >> JOURNAL.txt
        sh "reponse.sh" "$@" > STDOUT.txt 2>STDERR.txt
    fi
    lines=$(wc -l < STDERR.txt)
    if [ "$lines" -gt 0 ]; then
        echo "Il y a eu une sortie d'erreur générée" >> JOURNAL.txt
        echo "<<<<<<<<<${stylebold}" >> JOURNAL.txt
        cat STDERR.txt >> JOURNAL.txt
        echo "${stylenormal}>>>>>>>>>" >> JOURNAL.txt
    fi
}

thistest () {
    MAINTEST=$((MAINTEST+1))
    echo "Test $MAINTEST: $@" >> JOURNAL.txt
    SUBTEST=0
}

stringequal () {
    SUBTEST=$((SUBTEST+1))
    NUMTESTS=$((NUMTESTS+1))
    echo "  Sous-test $MAINTEST.$SUBTEST" >> JOURNAL.txt
    echo "    La chaîne <$1> est-elle égale à <$2> ?" >> JOURNAL.txt
    if [ "$1" = "$2" ]; then
        ALLTESTS=$((ALLTESTS+1))
        echo "    Oui! $ALLTESTS/$NUMTESTS" >> JOURNAL.txt
    else
        echo "    Non! $ALLTESTS/$NUMTESTS" >> JOURNAL.txt
    fi
}

fileexists () {
    SUBTEST=$((SUBTEST+1))
    NUMTESTS=$((NUMTESTS+1))
    echo "  Sous-test $MAINTEST.$SUBTEST" >> JOURNAL.txt
    echo "    Le fichier <$1> existe-t-il ?" >> JOURNAL.txt
    if [ -f "$1" ]; then
        ALLTESTS=$((ALLTESTS+1))
        echo "    Oui! $ALLTESTS/$NUMTESTS" >> JOURNAL.txt
    else
        echo "    Non! $ALLTESTS/$NUMTESTS" >> JOURNAL.txt
    fi
}

filecheck () {
    SUBTEST=$((SUBTEST+1))
    NUMTESTS=$((NUMTESTS+1))
    echo "  Sous-test $MAINTEST.$SUBTEST" >> JOURNAL.txt
    echo "    Le fichier <$2> correspond-il bien au contenu <$1> ?" >> JOURNAL.txt
    SUM=$(md5sum < $2|cut -c1-32)
    if [ "$1" = "$SUM" ]; then
        ALLTESTS=$((ALLTESTS+1))
        echo "    Oui! $ALLTESTS/$NUMTESTS" >> JOURNAL.txt
    else
        echo "    Non! $ALLTESTS/$NUMTESTS" >> JOURNAL.txt
    fi
}

nostderr () {
    SUBTEST=$((SUBTEST+1))
    NUMTESTS=$((NUMTESTS+1))
    echo "  Sous-test $MAINTEST.$SUBTEST" >> JOURNAL.txt
    echo "    L'exécution a-t-elle été sans aucune génération d'erreur ?" >> JOURNAL.txt
    cp STDERR.txt /tmp/
    SUM=$(md5sum < STDERR.txt|cut -c1-32)
    if [ "d41d8cd98f00b204e9800998ecf8427e" = "$SUM" ]; then
        ALLTESTS=$((ALLTESTS+1))
        echo "    Oui! $ALLTESTS/$NUMTESTS" >> JOURNAL.txt
    else
        echo "    Non! $ALLTESTS/$NUMTESTS" >> JOURNAL.txt
    fi
}


die () {
    cleanup
    rm -f STDOUT.txt STDERR.txt
    echo "---------- ${stylebold}$(basename "$(pwd)")${stylenormal} ---------------------------"
    cat JOURNAL.txt
    echo "--------------------------------------------"
    echo "${stylebold}Total des tests : $ALLTESTS/$NUMTESTS.${stylenormal}"
    if [ "$ALLTESTS" = "$NUMTESTS" ]; then
        echo "${stylebold}C'est bon !${stylenormal}"
        rm -f JOURNAL.txt
    else
        echo "Vous devriez vérifier le journal $(pwd)/JOURNAL.txt pour comprendre vos erreurs."
    fi
    echo "--------------------------------------------"
}


if [ -z "$1" ]; then
    echo "---------- ${stylebold}$(basename "$(pwd)")${stylenormal} ---------------------------"
    intro|fmt -s
    echo "--------------------------------------------"
    setup
    echo "${stylebold}Aucun test effectué.${stylenormal}"
    echo "--------------------------------------------"
    exit 0
fi

MAINTEST=0
ALLTESTS=0
NUMTESTS=0

if [ "$1" = "test" ]; then
    setup
    rm -f JOURNAL.txt
    initialcheck
    normaltests
    die
fi

if [ "$1" = "commit" ]; then
    echo "pas encore fait"
fi