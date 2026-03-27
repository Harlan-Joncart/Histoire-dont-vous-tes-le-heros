# Académie — L'Histoire dont vous êtes le Héros

Projet BTS SIO — Lycée Fulbert  
Application web PHP/MariaDB — Architecture MVC

---

## Arborescence

```
academie/
├── index.php                        ← Routeur principal (?action=...)
├── config/
│   └── database.php                 ← Connexion PDO
├── controller/
│   └── GameController.php           ← Logique : start, jeu, choix, rejouer
├── model/
│   ├── Scene.php                    ← Récupération scènes et choix
│   ├── Personnage.php               ← CRUD personnage + inventaire
│   └── Choix.php                    ← Récupération d'un choix par id
├── view/
│   ├── accueil.php                  ← Page d'accueil
│   ├── jeu.php                      ← Page de jeu (scène + stats + choix)
│   ├── header.php                   ← En-tête HTML commun
│   ├── footer.php                   ← Pied de page HTML commun
│   ├── css/
│   │   └── style.css                ← Style principal (thème fantasy)
│   └── images/
│       └── mon-fond.jpg             ← Image de fond
└── sql/
    └── academie.sql                 ← Script BDD complet
```

---

## Base de données

| Table | Rôle |
|---|---|
| `Scene` | Scènes narratives (titre, description, type de fin) |
| `Choix` | Transitions entre scènes avec effets sur les stats |
| `Objet` | Objets collectables avec effets vie/force |
| `Personnage` | Données du joueur (vie, force, scène actuelle) |
| `Inventaire` | Objets portés par le joueur |
| `HistoriqueProgression` | Historique des scènes visitées |

---

## Fonctionnalités

- Page d'accueil avec saisie du pseudo et règles du jeu
- Navigation entre 22 scènes via des choix multiples
- Système de vie et de force évolutifs selon les décisions
- Inventaire avec 8 objets collectables (sans doublon)
- Affichage des effets de chaque choix avant de cliquer
- Mort automatique si la vie tombe à 0
- 6 fins possibles : 3 victoires, 3 défaites
- Anti-retour navigateur (headers `no-cache`)
- Gestion de session PHP pour suivre la progression
- Nouvelle partie : suppression automatique de l'ancienne session

---

## Architecture MVC

| Couche | Fichiers |
|---|---|
| **Modèle** | `model/Scene.php`, `model/Personnage.php`, `model/Choix.php` |
| **Vue** | `view/accueil.php`, `view/jeu.php`, `view/header.php`, `view/footer.php` |
| **Contrôleur** | `controller/GameController.php` |
| **Routeur** | `index.php` |

---

## Actions disponibles

| URL | Action |
|---|---|
| `index.php` | Page d'accueil |
| `index.php?action=start` | Démarrer une nouvelle partie (POST) |
| `index.php?action=jeu` | Afficher la scène en cours |
| `index.php?action=choix` | Soumettre un choix (POST) |
| `index.php?action=rejouer` | Supprimer la partie et revenir à l'accueil |

---

## Remarques techniques

- Les colonnes `force` et `description` sont des mots réservés MariaDB — elles sont entourées de backticks dans le SQL (`` `force` ``, `` `description` ``).
- Le fichier `config/database.php` doit être adapté avant toute utilisation.
- Les sessions PHP sont démarrées dans le contrôleur, pas dans les vues.
- L'image de fond `mon-fond.jpg` doit se trouver dans `view/images/`.
