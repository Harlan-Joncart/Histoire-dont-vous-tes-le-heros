<?php
// ============================================
// CONTRÔLEUR : GameController
// ============================================

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../model/Scene.php';
require_once __DIR__ . '/../model/Personnage.php';
require_once __DIR__ . '/../model/Choix.php';

class GameController {

    // ---- Accueil -------------------------------------------------------
    public static function accueil(): void {
        include __DIR__ . '/../view/accueil.php';
    }

    // ---- Démarrer une nouvelle partie ----------------------------------
    public static function start(): void {
        session_start();

        // Supprimer ancienne partie si elle existe
        if (!empty($_SESSION['player_id'])) {
            Personnage::delete((int) $_SESSION['player_id']);
        }

        $pseudo = trim($_POST['pseudo'] ?? 'Héros');
        if ($pseudo === '') $pseudo = 'Héros';

        $id = Personnage::create($pseudo);
        $_SESSION['player_id'] = $id;

        // Enregistrer scène initiale dans l'historique
        $pdo = getPDO();
        $pdo->prepare("INSERT INTO HistoriqueProgression (id_personnage, id_scene) VALUES (?, 1)")
            ->execute([$id]);

        header('Location: index.php?action=jeu');
        exit;
    }

    // ---- Page de jeu ---------------------------------------------------
    public static function jeu(): void {
        session_start();

        if (empty($_SESSION['player_id'])) {
            header('Location: index.php');
            exit;
        }

        $player_id = (int) $_SESSION['player_id'];
        $perso     = Personnage::getById($player_id);

        if (!$perso) {
            session_destroy();
            header('Location: index.php');
            exit;
        }

        // Vie à 0 → défaite forcée (scène 20)
        if ((int) $perso['vie'] <= 0 && (int) $perso['id_scene_actuelle'] !== 20) {
            $pdo = getPDO();
            $pdo->prepare("UPDATE Personnage SET id_scene_actuelle = 20 WHERE id_personnage = ?")
                ->execute([$player_id]);
            $pdo->prepare("INSERT INTO HistoriqueProgression (id_personnage, id_scene) VALUES (?, 20)")
                ->execute([$player_id]);
            $perso = Personnage::getById($player_id);
        }

        $scene     = Scene::getById((int) $perso['id_scene_actuelle']);
        $choix     = Scene::getChoix((int) $perso['id_scene_actuelle']);
        $inventaire = Personnage::getInventaire($player_id);

        include __DIR__ . '/../view/jeu.php';
    }

    // ---- Traitement d'un choix -----------------------------------------
    public static function choix(): void {
        session_start();

        if (empty($_SESSION['player_id'])) {
            header('Location: index.php');
            exit;
        }

        if ($_SERVER['REQUEST_METHOD'] !== 'POST' || empty($_POST['id_choix'])) {
            header('Location: index.php?action=jeu');
            exit;
        }

        $player_id = (int) $_SESSION['player_id'];
        $id_choix  = (int) $_POST['id_choix'];
        $choix     = Choix::getById($id_choix);

        if (!$choix) {
            header('Location: index.php?action=jeu');
            exit;
        }

        Personnage::appliquerChoix($player_id, $choix);

        header('Location: index.php?action=jeu');
        exit;
    }

    // ---- Fin / rejouer -------------------------------------------------
    public static function rejouer(): void {
        session_start();
        if (!empty($_SESSION['player_id'])) {
            Personnage::delete((int) $_SESSION['player_id']);
        }
        session_destroy();
        header('Location: index.php');
        exit;
    }
}
