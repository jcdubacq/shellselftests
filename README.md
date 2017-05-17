# shellselftests

Ces exercices sont basés sur des tests pour améliorer la pratique du shell Unix.

Avant de commencer:

 * Créez un fichier NOM.txt à la racine du répertoire (dans le même répertoire que ce fichier texte) qui contiendra votre nom et prénom (par exemple un fichier NOM.txt qui contiendra "Jean-Christophe Dubacq").

Ils fonctionnent tous de la même façon :

 * l'énoncé (et l'initialisation du répertoire de test) est faite par la commande

    ./enonce.sh

 * La réponse est attendue sous forme d'un script dans

    ./reponse.sh

 * La commande suivante permet de faire tourner un premier jeu de test sur le fichier de réponse fournie. Ce premier jeu de test donne un score (par exemple 22/33 signifie que 22 tests élémentaires ont réussi et 11 ont échoué). Il n'y a pas de valeur intrinsèque aux tests. Un 21/22 peut-être facile à obtenir et un 22/22 difficile ; la seule distinction claire est entre une réussite totale et un échec (partiel ou total).

    ./enonce.sh test

 * La commande suivante permet de soumettre au correcteur son script. Les résultats sont enregistrés. En théorie, une seule soumission doit être faite. Un deuxième jeu de tests est utilisé pour cette soumission, pour éviter certaines façons de ne pas répondre au problème posé.

    ./enonce.sh commit

 * Le commande suivante permet de nettoyer le répertoire pour ne laisser que les fichiers sources nécessaires. Il laisse le fichier de réponse intact !

    ./enonce.sh cleanup
