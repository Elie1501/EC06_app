#!/usr/bin/env sh
# =====================================================================
#  deploy.sh — déploiement SIMULÉ.
#
#  Par défaut, ce script n'exécute AUCUNE action distante : il affiche
#  les commandes qui seraient lancées sur la cible et sert de trace
#  (artefact deploy.log) dans le pipeline.
#
#  Pour un déploiement réel (bonus), on remplacerait la section
#  "SIMULATION" par une connexion SSH utilisant une clé stockée dans
#  un secret GitHub (jamais en clair ici).
# =====================================================================
set -eu

IMAGE_TAG="${GITHUB_SHA:-local}"
TARGET_HOST="${DEPLOY_HOST:-<non configurée>}"
TARGET_USER="${DEPLOY_USER:-<non configuré>}"

echo "=== Déploiement SkillHub API — MODE SIMULÉ ==="
echo "Date          : $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
echo "Commit         : ${IMAGE_TAG}"
echo "Cible          : ${TARGET_USER}@${TARGET_HOST}"
echo ""
echo "Commandes qui seraient exécutées sur la cible :"
echo "  1. docker pull ghcr.io/<owner>/skillhub-api:${IMAGE_TAG}"
echo "  2. docker compose -f docker-compose.prod.yml up -d --no-build"
echo "  3. docker image prune -f"
echo "  4. curl -fsS http://localhost:3000/health   # vérification post-déploiement"
echo ""
echo "=== Déploiement simulé terminé avec succès ==="
