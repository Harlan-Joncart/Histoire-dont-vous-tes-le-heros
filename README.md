# Académie — L'Histoire dont vous êtes le Héros

Un jeu de rôle textuel PHP/MariaDB développé dans le cadre d'un projet SLAM (BTS SIO 1ère année). Le joueur crée un personnage, explore une académie de magie, prend des décisions qui influencent ses statistiques et son inventaire, et découvre l'une des 16 fins possibles.

---

## 🛠 Structure du projet

```
academie/
├── README.md                        # ce fichier
├── sql/
│   └── academie.sql                 # schéma et données SQL
├── index.php                        # point d'entrée, routeur
├── config/
│   └── database.php                 # configuration de la connexion BDD
├── controller/
│   └── GameController.php           # contrôleurs MVC
├── model/
│   ├── Scene.php                    # accès aux scènes et choix
│   ├── Personnage.php               # logique personnage et inventaire
│   └── Choix.php                    # accès aux choix
└── view/
    ├── accueil.php                  # page d'accueil
    ├── jeu.php                      # page de jeu
    ├── header.php                   # en-tête commun
    ├── footer.php                   # pied de page commun
    ├── css/
    │   └── style.css                # feuille de style (thème fantasy)
    └── images/
        └── mon-fond.jpg             # image de fond
```

---

## 🚀 Installation et configuration

1. **Serveur web** : Apache ou équivalent avec PHP 7.4+.
2. **Base de données** : MariaDB 10.x ou MySQL 5.7+.
3. **Extension PHP** : PDO et PDO_MySQL activées.

### Création de la base

1. Se connecter au serveur MySQL : `mysql -u root -p`.
2. Importer le schéma :
   ```bash
   mysql -u root -p < sql/academie.sql
   ```
   Le fichier `academie.sql` crée automatiquement la base `academie`, toutes les tables et insère les données de jeu.

### Configuration PHP

La connexion BDD est définie dans `config/database.php` :

```php
define('DB_HOST', 'localhost');   // adresse du serveur MariaDB
define('DB_NAME', 'academie');    // nom de la base
define('DB_USER', 'root');        // utilisateur
define('DB_PASS', '');            // mot de passe
```

### Déploiement

- Placez le dossier `academie/` à la racine de votre serveur web.
- Point d'entrée : `index.php` (ex : `http://localhost/academie/`).
- Les liens internes sont relatifs — conservez la structure des dossiers.

---

## 🧩 Fonctionnalités principales

- **Démarrer une partie** : saisie du pseudo, initialisation des stats et de la session.
- **Parcours de l'histoire** : 70 scènes narratives réparties sur 5 actes avec choix ramifiés.
- **Statistiques évolutives** : Vie et Force recalculées à chaque choix.
- **Inventaire** : collecte de 15 objets au fil de l'aventure (sans doublon).
- **Effets visibles** : chaque choix affiche ses effets (+vie, -vie, +objet) avant de cliquer.
- **Mort automatique** : si la vie tombe à 0, redirection vers une scène de défaite.
- **16 fins possibles** : 6 victoires et 10 défaites selon les décisions prises.
- **Blocage du retour arrière** : le bouton précédent du navigateur ne permet pas de revenir.
- **Gestion de session** : pseudo, stats et progression sont stockés en session PHP.

---

## 📖 Structure narrative

L'histoire est découpée en **5 actes** :

| Acte | Scènes | Résumé |
|---|---|---|
| I — L'Arrivée | 1 – 10 | Premier jour à l'Académie, choix d'entrée et d'élément magique |
| II — L'Académie | 11 – 20 | Tour nord, pacte du miroir, voie élémentaire (Feu / Eau / Vent) |
| III — Les Ombres | 21 – 30 | Journal de Serafina, Confrérie du Vide, piège ou fuite |
| IV — La Crise | 31 – 40 | Bataille du Conseil, les deux Orbes, ultimatum |
| V — Le Dénouement | 41 – 50 | Nuit de l'Éclipse, rituel de scellement, choix final |

### Fins disponibles

**6 Victoires :**
| # | Titre | Condition |
|---|---|---|
| V1 | Le Champion de l'Académie | Médaille décernée par Sol après l'Éclipse |
| V2 | Le Sage Vertueux | Compléter le journal de Serafina avec Drast |
| V3 | Le Grand Guérisseur | Guérir un cas incurable à l'infirmerie |
| V4 | L'Enquêteur de l'Ombre | Rejoindre la Cellule de Veille d'Aldric |
| V5 | L'Héritière de Serafina | Obtenir la carte des brèches dormantes de Sol |
| V6 | Le Duo Légendaire | Fonder la Brigade avec Elara |

**10 Défaites :**
| # | Titre | Cause |
|---|---|---|
| D1 | La Tour Perdue | Échec face au gardien masqué |
| D2 | Le Prix du Pacte | Contamination démoniaque non maîtrisée |
| D3 | Le Mauvais Camp | Ralliement à la Confrérie du Vide |
| D4 | La Flamme Incontrôlée | Perte de contrôle lors de l'Épreuve de Maîtrise |
| D5 | La Fuite | Abandon de l'Académie en pleine crise |
| D6 | Le Rituel Brisé | Cercle de stabilisation abandonné trop tôt |
| D7 | Le Piège Retourné | Embuscade retournée par la Confrérie |
| D8 | L'Expulsion | Refus d'expliquer sa présence dès l'arrivée |
| D9 | La Dénonciation Précipitée | Morwen dénoncé sans preuve — l'aile sud détruite |
| D10 | Le Vide | Magie perdue en sacrifiant trop dans le rituel |

---

## 🗄 Structure de la base de données

| Table | Rôle |
|---|---|
| `Scene` | Scènes narratives (titre, description, type de fin) |
| `Choix` | Transitions entre scènes avec effets sur les stats |
| `Objet` | Objets collectables avec leurs effets vie/force |
| `Personnage` | Données du joueur en cours de partie |
| `Inventaire` | Objets portés par le joueur |
| `HistoriqueProgression` | Historique des scènes visitées |

---

## 🔗 Routes disponibles

| URL | Action |
|---|---|
| `index.php` | Page d'accueil |
| `index.php?action=start` | Démarrer une nouvelle partie (POST) |
| `index.php?action=jeu` | Afficher la scène en cours |
| `index.php?action=choix` | Soumettre un choix (POST) |
| `index.php?action=rejouer` | Supprimer la partie et revenir à l'accueil |

---

## 💡 Astuces & dépannage

- **Erreur 500** : activez les erreurs PHP en ajoutant en haut de `index.php` :
  ```php
  ini_set('display_errors', 1);
  error_reporting(E_ALL);
  ```
- **Erreur de connexion BDD** : vérifiez les paramètres dans `config/database.php`.
- **Erreurs SQL** : vérifiez que `academie.sql` a bien été importé et que la base contient toutes les tables.
- **Mots réservés MariaDB** : les colonnes `force` et `description` sont entourées de backticks dans le SQL (`` `force` ``, `` `description` ``). Ne pas les retirer.
- **Sessions** : `session_start()` est appelé dans le contrôleur — ne pas le rappeler dans les vues.
- **Image de fond manquante** : vérifiez que `mon-fond.jpg` est bien présent dans `view/images/`.

---

## 📦 Évolutions possibles

- Interface d'administration pour éditer les scènes et les choix.
- Écran de fin récapitulatif avec les stats et objets collectés.
- Sauvegarde en base de données de la progression du joueur.
- Système de combat au tour par tour.
- Conditions sur les choix selon les stats ou l'inventaire du joueur.
