<?php
// ============================================
// CONTRÔLEUR : GameController
// ============================================

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../model/Scene.php';
require_once __DIR__ . '/../model/Personnage.php';
require_once __DIR__ . '/../model/Choix.php';
require_once __DIR__ . '/../model/Combat.php';

class GameController {

    // ---- Accueil -------------------------------------------------------
    public static function accueil(): void {
        include __DIR__ . '/../view/accueil.php';
    }

    // ---- Démarrer une nouvelle partie ----------------------------------
    public static function start(): void {
        session_start();

        if (!empty($_SESSION['player_id'])) {
            Personnage::delete((int) $_SESSION['player_id']);
        }

        $pseudo = trim($_POST['pseudo'] ?? 'Héros');
        if ($pseudo === '') $pseudo = 'Héros';

        $id = Personnage::create($pseudo);
        $_SESSION['player_id'] = $id;

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

        $scene_courante = Scene::getById((int) $perso['id_scene_actuelle']);

        // Vie à 0 hors scène de fin → défaite forcée scène 61
        if ((int) $perso['vie'] <= 0 && !(bool) $scene_courante['est_fin']) {
            $pdo = getPDO();
            $pdo->prepare("UPDATE Personnage SET id_scene_actuelle = 61 WHERE id_personnage = ?")
                ->execute([$player_id]);
            $pdo->prepare("INSERT INTO HistoriqueProgression (id_personnage, id_scene) VALUES (?, 61)")
                ->execute([$player_id]);
            $perso = Personnage::getById($player_id);
            $scene_courante = Scene::getById(61);
        }

        $scene      = $scene_courante;
        $inventaire = Personnage::getInventaire($player_id);

        // Message flash (objet utilisé, etc.)
        $flash = $_SESSION['flash'] ?? null;
        unset($_SESSION['flash']);

        // ---- CAS COMBAT ------------------------------------------------
        if (!empty($scene['is_combat']) && !(bool) $scene['est_fin']) {
            $combat = Combat::getCombatActif($player_id, (int) $scene['id_scene']);

            if (!$combat) {
                Combat::initier($player_id, $scene);
                $combat = Combat::getCombatActif($player_id, (int) $scene['id_scene']);
            }

            $dernier_tour = $_SESSION['dernier_tour_combat'] ?? null;
            if ($dernier_tour && isset($dernier_tour['id_scene']) && $dernier_tour['id_scene'] !== (int) $scene['id_scene']) {
                $dernier_tour = null;
            }
            unset($_SESSION['dernier_tour_combat']);

            $perso = Personnage::getById($player_id);

            include __DIR__ . '/../view/combat.php';
            return;
        }

        // ---- CAS NORMAL ------------------------------------------------
        unset($_SESSION['dernier_tour_combat']);

        $choix = Choix::getChoixDisponibles((int) $perso['id_scene_actuelle'], $player_id);

        include __DIR__ . '/../view/jeu.php';
    }

    // ---- Traitement d'un choix narratif --------------------------------
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

        // SÉCURITÉ : valide que le choix appartient à la scène actuelle du joueur
        $choix = Choix::getByIdForPlayer($id_choix, $player_id);

        if (!$choix) {
            header('Location: index.php?action=jeu');
            exit;
        }

        // Double vérification des conditions côté serveur
        $perso = Personnage::getById($player_id);
        if (!self::choixConditionsRemplies($choix, $perso, $player_id)) {
            header('Location: index.php?action=jeu');
            exit;
        }

        Personnage::appliquerChoix($player_id, $choix);

        header('Location: index.php?action=jeu');
        exit;
    }

    // ---- Utiliser un objet consommable ---------------------------------
    public static function utiliserObjet(): void {
        session_start();

        if (empty($_SESSION['player_id'])) {
            header('Location: index.php');
            exit;
        }

        if ($_SERVER['REQUEST_METHOD'] !== 'POST' || empty($_POST['id_objet'])) {
            header('Location: index.php?action=jeu');
            exit;
        }

        $player_id = (int) $_SESSION['player_id'];
        $id_objet  = (int) $_POST['id_objet'];

        $ok = Personnage::utiliserObjet($player_id, $id_objet);

        if ($ok) {
            // Récupérer le nom de l'objet pour le message flash
            $pdo  = getPDO();
            $stmt = $pdo->prepare("SELECT nom, icone, effet_vie, effet_force FROM Objet WHERE id_objet = ?");
            $stmt->execute([$id_objet]);
            $obj  = $stmt->fetch();

            $effets = [];
            if ((int)$obj['effet_vie']   > 0) $effets[] = '+' . $obj['effet_vie']   . '❤️';
            if ((int)$obj['effet_vie']   < 0) $effets[] = $obj['effet_vie']          . '❤️';
            if ((int)$obj['effet_force'] > 0) $effets[] = '+' . $obj['effet_force'] . '⚔️';
            if ((int)$obj['effet_force'] < 0) $effets[] = $obj['effet_force']        . '⚔️';

            $_SESSION['flash'] = [
                'type'    => 'succes',
                'message' => $obj['icone'] . ' ' . $obj['nom'] . ' utilisé — ' . implode(' ', $effets),
            ];
        } else {
            $_SESSION['flash'] = [
                'type'    => 'erreur',
                'message' => 'Impossible d\'utiliser cet objet.',
            ];
        }

        header('Location: index.php?action=jeu');
        exit;
    }

    // ---- Traitement d'un tour de combat --------------------------------
    public static function combatTour(): void {
        session_start();

        if (empty($_SESSION['player_id'])) {
            header('Location: index.php');
            exit;
        }

        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            header('Location: index.php?action=jeu');
            exit;
        }

        $player_id = (int) $_SESSION['player_id'];
        $id_combat = (int) ($_POST['id_combat'] ?? 0);
        $action    = $_POST['action_combat'] ?? 'attaque';

        $actions_valides = ['attaque', 'defense', 'fuite'];
        if (!in_array($action, $actions_valides)) {
            $action = 'attaque';
        }

        // SÉCURITÉ : vérifier que ce combat appartient bien à ce joueur
        $pdo  = getPDO();
        $stmt = $pdo->prepare("
            SELECT id_combat, id_scene
            FROM Combat
            WHERE id_combat = ? AND id_personnage = ? AND termine = 0
        ");
        $stmt->execute([$id_combat, $player_id]);
        $combat_row = $stmt->fetch();

        if (!$combat_row) {
            header('Location: index.php?action=jeu');
            exit;
        }

        $resultat = Combat::jouerTour($id_combat, $player_id, $action);
        $resultat['id_scene'] = (int) $combat_row['id_scene'];
        $_SESSION['dernier_tour_combat'] = $resultat;

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

    // ---- Utilitaire privé : vérification des conditions ---------------
    private static function choixConditionsRemplies(array $choix, array $perso, int $id_personnage): bool {
        if ((int)$choix['cond_vie_min'] > 0 && (int)$perso['vie'] < (int)$choix['cond_vie_min']) {
            return false;
        }
        if ((int)$choix['cond_force_min'] > 0 && (int)$perso['force'] < (int)$choix['cond_force_min']) {
            return false;
        }
        if (!empty($choix['cond_objet_requis'])) {
            $pdo  = getPDO();
            $stmt = $pdo->prepare("SELECT COUNT(*) FROM Inventaire WHERE id_personnage = ? AND id_objet = ?");
            $stmt->execute([$id_personnage, (int)$choix['cond_objet_requis']]);
            if ($stmt->fetchColumn() == 0) return false;
        }
        return true;
    }
}
