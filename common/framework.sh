HDIR=$(dirname "$0")
cd "$HDIR"
HDIR=$(pwd)
stylebold=$(tput bold)
stylenormal=$(tput sgr0)


buildUpdate () {
    (find .;echo ./reponse.sh;echo ./.FILES;echo ./JOURNAL.txt)|sort -u > .FILES
}

cleanup () {
    (find . -type f; cat .FILES; cat .FILES)|sort|uniq -u | xargs --no-run-if-empty rm --
    (find . -type d; cat .FILES; cat .FILES)|sort|uniq -u | xargs --no-run-if-empty rm -r --
}


if [ ! -f ./.FILES ]; then
    buildUpdate
fi

oui () {
    echo "    Oui! $ALLTESTS/$NUMTESTS" >> JOURNAL.txt    
}

non () {
    echo "XX  Non! $ALLTESTS/$NUMTESTS" >> JOURNAL.txt
}

initialcheck () {
    thistest "Le fichier de réponse existe"
    SUBTEST=0
    SUBTEST=$((SUBTEST+1))
    NUMTESTS=$((NUMTESTS+1))
    echo "  Sous-test $MAINTEST.1" >> JOURNAL.txt
    echo "    Le fichier <$(pwd)/reponse.sh> existe-t-il ?" >> JOURNAL.txt
    if [ -f "reponse.sh" ]; then
        ALLTESTS=$((ALLTESTS+1))
        oui
    else
        non
    fi
    checkmode ./reponse.sh 1 7
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
        oui
    else
        non
    fi
}

fileexists () {
    SUBTEST=$((SUBTEST+1))
    NUMTESTS=$((NUMTESTS+1))
    echo "  Sous-test $MAINTEST.$SUBTEST" >> JOURNAL.txt
    echo "    Le fichier <$1> existe-t-il ?" >> JOURNAL.txt
    if [ -f "$1" ]; then
        ALLTESTS=$((ALLTESTS+1))
        oui
    else
        non
    fi
}

filenotexists () {
    SUBTEST=$((SUBTEST+1))
    NUMTESTS=$((NUMTESTS+1))
    echo "  Sous-test $MAINTEST.$SUBTEST" >> JOURNAL.txt
    echo "    Le fichier <$1> n'existe-t-il bien pas ?" >> JOURNAL.txt
    if [ ! -f "$1" ]; then
        ALLTESTS=$((ALLTESTS+1))
        oui
    else
        non
    fi
}

checkmodes () {
    for loop in 1 2 3; do
        k=$(echo "$2"|cut -c${loop}-${loop})
        checkmode $1 $loop $k
    done
}

checkmode () {
    SUBTEST=$((SUBTEST+1))
    NUMTESTS=$((NUMTESTS+1))
    echo "  Sous-test $MAINTEST.$SUBTEST" >> JOURNAL.txt
    WHO="???"
    if [ "$2" = "1" ]; then
        WHO="le propriétaire"
    fi
    if [ "$2" = "2" ]; then
        WHO="le groupe"
    fi
    if [ "$2" = "3" ]; then
        WHO="les autres"
    fi
    WHAT="???"
    case $3 in
        0|1|2|3)
            WHAT="-"
            ;;
        4|5|6|7)
            WHAT="r"
            ;;
        *)
            true
            ;;
    esac
    case $3 in
        0|1|4|5)
            WHAT="${WHAT}-"
            ;;
        2|3|6|7)
            WHAT="${WHAT}w"
            ;;
        *)
            true
            ;;
    esac
    case $3 in
        0|2|4|6)
            WHAT="${WHAT}-"
            ;;
        1|3|5|7)
            WHAT="${WHAT}x"
            ;;
        *)
            true
            ;;
    esac
    echo "    Le mode du fichier <${1}> pour ${WHO} est ${WHAT} ?" >> JOURNAL.txt
    if [ $(stat -c %a "$1" | cut -c${2}-${2}) = "$3" ]; then
        ALLTESTS=$((ALLTESTS+1))
        oui
    else
        non
    fi
}

filecheck () {
    fileexists "$2"
    SUBTEST=$((SUBTEST+1))
    NUMTESTS=$((NUMTESTS+1))
    echo "  Sous-test $MAINTEST.$SUBTEST" >> JOURNAL.txt
    echo "    Le fichier <$2> correspond-il bien au contenu <$1> ?" >> JOURNAL.txt
    SUM=$(md5sum < $2|cut -c1-32)
    if [ "$1" = "$SUM" ]; then
        ALLTESTS=$((ALLTESTS+1))
        oui
    else
        non
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
        oui
    else
        non
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
    echo "${stylebold}Aucun test effectué.${stylenormal}"
    echo "--------------------------------------------"
    cleanup
    setup
    exit 0
fi

MAINTEST=0
ALLTESTS=0
NUMTESTS=0

if [ "$1" = "test" ]; then
    rm -f JOURNAL.txt
    cleanup
    setup
    initialcheck
    normaltests
    die
fi

if [ "$1" = "commit" ]; then
    DATE=$(date -u +%s)
    cleanupfinal
    setupfinal
    if [ ! -f ../NOM.txt ]; then
        echo "Vous devez créer le fichier $(dirname "$HDIR")/NOM.txt avec votre nom dedans"
        exit 0
    fi
    SIGN=$(md5sum < ../NOM.txt|cut -c1-32)
    if [ -w /home/usager/jean-christophe.dubacq/selftests ]; then
        DEST="/home/usager/jean-christophe.dubacq/selftests"
    else
        DEST=/tmp/rendu
        mkdir -p $DEST
    fi
    cp ../NOM.txt ${DEST}/$SIGN.NOM.txt
    if [ -f reponse.sh ]; then
        cp reponse.sh ${DEST}/$SIGN.$(basename "$(pwd)").$DATE.reponse.sh
    else
        touch ${DEST}/$SIGN.$(basename "$(pwd)").$DATE.reponse.sh
    fi
    rm -f JOURNAL.txt
    initialcheck
    finaltests
    cp JOURNAL.txt ${DEST}/$SIGN.$(basename "$(pwd)").$DATE.journal.txt
    echo "$ALLTESTS/$NUMTESTS" > ${DEST}/$SIGN.$(basename "$(pwd)").$DATE.mark.txt
    die
fi

if [ "$1" = "cleanup" ]; then
    cleanup
fi

if [ "$1" = "update" ]; then
    buildUpdate
fi
