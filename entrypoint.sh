#!/bin/bash
set -euo pipefail

echo "--- Étape 1 : Collecte des fichiers statiques (incluant CSS compilé) ---"
python manage.py collectstatic --noinput

echo "--- Étape 2 : Upload des fichiers vers Azure Blob Storage ---"
if [ -f "initialize_azure.py" ]; then
    python initialize_azure.py
else
    echo "Warning: initialize_azure.py not found, skipping Azure initialization."
fi

echo "--- Étape 3 : Migrations de la base de données ---"
python manage.py migrate --noinput

echo "--- Étape 4 : Démarrage du serveur Gunicorn ---"
exec gunicorn job_board.wsgi:application --bind 0.0.0.0:8000 --workers 2
