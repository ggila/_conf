E_MAUVAIS_ARGS=85
parametres_scripts="-a -h -m -z"
#                  -a = all, -h = help, etc.

if [ $# -ne $Nombre_arguments_attendus ]
then
echo "Usage: `basename $0` $parametres_scripts"
  # `basename $0` est le nom du fichier contenant le script.
  exit $E_MAUVAIS_ARGS
fi
