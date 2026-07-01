# syntax=docker/dockerfile:1

# =====================================================================
#  Dockerfile multistage pour SkillHub API (Node.js 20)
#
#  - builder    : installe TOUTES les dépendances (dev incluses) et sert
#                 de base "développement / CI" (lint + tests dans Docker).
#  - prod-deps  : installe uniquement les dépendances de production.
#  - runtime    : image finale LÉGÈRE (alpine), utilisateur NON-ROOT,
#                 EXPOSE + HEALTHCHECK. C'est le stage par défaut.
# =====================================================================

# ---------- Stage 1 : builder (deps complètes, base dev/CI) ----------
FROM node:20-alpine AS builder
WORKDIR /app

# Copier d'abord les manifestes pour profiter du cache de couches Docker
COPY package.json package-lock.json ./
RUN npm ci

# Code applicatif + tests + config lint (nécessaires pour la CI)
COPY src ./src
COPY tests ./tests
COPY eslint.config.js ./

# Rien à compiler (app JS pure) : ce stage sert à faire tourner
# `npm run lint` et `npm test` dans un environnement reproductible.
CMD ["npm", "start"]

# ---------- Stage 2 : dépendances de production seules ----------
FROM node:20-alpine AS prod-deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# ---------- Stage 3 : runtime (image finale légère, non-root) ----------
FROM node:20-alpine AS runtime
ENV NODE_ENV=production
WORKDIR /app

# On ne copie QUE le strict nécessaire à l'exécution
COPY --from=prod-deps /app/node_modules ./node_modules
COPY package.json ./
COPY src ./src

# L'image node:alpine fournit déjà un utilisateur non privilégié "node"
USER node

EXPOSE 3000

# Vérifie que l'endpoint /health répond 200 (pas de curl dans alpine :
# on utilise le client http natif de Node)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://127.0.0.1:3000/health',r=>process.exit(r.statusCode===200?0:1)).on('error',()=>process.exit(1))"

CMD ["node", "src/server.js"]
