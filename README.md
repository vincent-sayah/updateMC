# updateMC
Migration authentification LDAP vers MindefConnect


Description :

Ce script a été conçu pour faciliter la migration d'un système d'authentification Annudef ou Intradef vers MindefConnect dans une base de données MySQL d’ILIAS.
Il effectue les étapes nécessaires, telles que la mise à jour des champs appropriés en fonction des nouveaux critères d'authentification.

Utilisation :

1-	Exécution du Script :
•	Placez le script dans le répertoire souhaité.
•	Assurez-vous que le script a les permissions d'exécution : #chmod +x updateMC.sh
•	Exécutez le script : #./updateMC.sh

2-	Informations Requises :

•	Le script demandera les informations suivantes :
	Nom de la base de données MySQL.
	Login MySQL.
	Mot de passe MySQL.

3-	Type d'Authentification à Migrer :

•	Choisissez le type d'authentification à migrer vers MindefConnect (A - Annudef, I - Intradef).

ATTENTION !

En cas de migration d’une authentification Annudef vers MD, la réalisation ci-dessous doit être effectuée sur la Plateforme ILIAS :

- Dans les paramètres utilisateur, créez un champ supplémentaire nommé "drcpt".
- Dans les paramètres LDAP, mappez le champ "drcpt" avec "login".
- Lancez un cron de synchronisation LDAP : le champ "drcpt" des utilisateurs prend la valeur du login intradef de l'utilisateur.


•	Répondez en tapant A ou I (X pour annuler et sortir).

4-	Exécution des Mises à Jour :

•	Le script effectuera les mises à jour nécessaires en fonction du type d'authentification choisi.

5-	Résultats :

•	Le script affichera les résultats de chaque étape, signalant les erreurs éventuelles ou la réussite des opérations.

 

Exemple d'Utilisation :

#./updateMC.sh
Nom de la base de données : bdd_ilias
Login : votre_login
Mot de passe : *************
Type d'authentification à migrer (A - Annudef, I - Intradef, X - Annuler) : A

Vous avez choisi de migrer vers MindefConnect avec l'authentification Intradef.
Résultat de la requête :
La requête a été exécutée avec succès.



Avertissement :

L'utilisation de ce script peut entraîner des modifications importantes dans la base de données. Assurez-vous de comprendre les implications avant de l'exécuter en production :

•	Assurez-vous d'avoir une sauvegarde de la base de données avant d'exécuter le script.
•	Veillez à fournir des informations correctes lors de l'exécution du script.
•	En cas d'erreur ou de problème, contactez l'administrateur du système.




