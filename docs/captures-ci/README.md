# Captures d'écran — preuves du pipeline CI/CD

- **01-ci-run-vert.png** — liste des workflow runs sur GitHub Actions,
  plusieurs runs verts (`quality`, `build`, `deploy`).
- **02-ci-run-rouge.png** — run en échec (`Build image Docker`) rencontré
  pendant la mise en place du scan Trivy, corrigé dans les commits suivants
  (visible dans l'historique de la PR #4 : commit rouge puis commit vert).
- **03-pr-fusionnee.png** — PR #3 (`develop → main`) fusionnée, avec
  description structurée (contexte / changements / comment tester) et
  les 8 checks passés.
- **04-protection-branche-main.png** — Ruleset `protect-main` : branche
  ciblée, PR obligatoire avant merge, force push bloqué.
- **05-protection-branche-status-checks.png** — détail des status checks
  requis (`Quality (Node 20/22, lint + test dans Docker)`,
  `Build image Docker`) avant de pouvoir merger sur `main`.
