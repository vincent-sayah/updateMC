#!/bin/sh

# Effacer l'écran
clear

# Demander les informations de la base de données, login et mot de passe
echo "Nom de la base de données : \c"
read dbname
echo "Login BDD : \c"
read dbuser
echo "Mot de passe BDD : \c"
read dbpassword
echo ""

# Demander le type d'authentification à migrer
echo "Mode d'authentification à migrer (A-Annudef / I-Intradef / X pour annuler) : \c"
read authType

# Vérifier l'option choisie
case "$authType" in
    A)
        echo "Vous avez choisi de migrer vers MindefConnect avec l'authentification Annudef."
        ;;
    I)
        echo "Vous avez choisi de migrer vers MindefConnect avec l'authentification Intradef."
        ;;
    X)
        echo "Opération annulée. Sortie du script."
        exit 1
        ;;
    *)
        echo "Option non reconnue. Sortie du script."
        exit 1
        ;;
esac

# Fonction pour exécuter la requête en fonction du type d'authentification
execute_query() {
    query="$1"
    result=$(echo "$query" | mysql -u"$dbuser" -p"$dbpassword" -D "$dbname" 2>&1)
    echo "Résultat de la requête : $result"
    if [ "$result" != "" ] && [ "$result" != "0" ]; then
        echo "Erreur : La requête a échoué."
    else
        echo "La requête a été exécutée avec succès."
    fi
}

# Exécuter la requête en fonction du type d'authentification
if [ "$authType" = "A" ]; then
    query="
    UPDATE $dbname.usr_data
    SET 
        login = (
            SELECT udft.value
            FROM $dbname.udf_text AS udft
            JOIN $dbname.udf_definition AS udfdef ON udft.field_id = udfdef.field_id
            WHERE udft.usr_id = $dbname.usr_data.usr_id
                AND udfdef.field_name = 'drcpt'
                AND udft.value IS NOT NULL AND udft.value != ''
        ),
        auth_mode = 'oidc',
        passwd_enc_type = NULL,
        passwd_salt = NULL,
        passwd = '',
        ext_account = (
            SELECT udft.value
            FROM $dbname.udf_text AS udft
            JOIN $dbname.udf_definition AS udfdef ON udft.field_id = udfdef.field_id
            WHERE udft.usr_id = $dbname.usr_data.usr_id
                AND udfdef.field_name = 'drcpt'
                AND udft.value IS NOT NULL AND udft.value != ''
        )
    WHERE EXISTS (
        SELECT 1
        FROM $dbname.udf_text AS udft
        JOIN $dbname.udf_definition AS udfdef ON udft.field_id = udfdef.field_id
        WHERE udft.usr_id = $dbname.usr_data.usr_id
            AND udfdef.field_name = 'drcpt'
            AND udft.value IS NOT NULL AND udft.value != ''
    );"
elif [ "$authType" = "I" ]; then
    query="
    UPDATE $dbname.usr_data
    SET 
        auth_mode = 'oidc',
        passwd = '',
        passwd_enc_type = NULL,
        passwd_salt = NULL
    WHERE COALESCE(ext_account, '') != '';"
else
    echo "Option non reconnue. Sortie du script."
    exit 1
fi

# Exécuter la requête et afficher le résultat
execute_query "$query"
