<?php
// ============================================
// MODÈLE : Choix
// ============================================

class Choix {

    /**
     * Récupère un choix par son ID.
     * SÉCURITÉ : vérifie que ce choix appartient bien à la scène actuelle
     * du personnage, pour empêcher la manipulation des id dans le HTML.
     */
    public static function getByIdForPlayer(int $id_choix, int $id_personnage): ?array {
        $pdo = getPDO();

        $stmt = $pdo->prepare("
            SELECT c.*
            FROM Choix c
            JOIN Personnage p ON p.id_scene_actuelle = c.id_scene_source
            WHERE c.id_choix      = ?
              AND p.id_personnage = ?
        ");
        $stmt->execute([$id_choix, $id_personnage]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    /**
     * Récupère les choix d'une scène, avec évaluation des conditions
     * (vie min, force min, objet requis) par rapport au joueur.
     *
     * Chaque choix est enrichi de :
     *   'verrouille' => bool
     *   'raison'     => string (explication si verrouillé)
     *
     * Si $masquer_verrouilles = true, les choix inaccessibles sont exclus.
     */
    public static function getChoixDisponibles(int $id_scene, int $id_personnage, bool $masquer_verrouilles = false): array {
        $pdo = getPDO();

        // Stats du joueur
        $stmtP = $pdo->prepare("SELECT vie, `force` FROM Personnage WHERE id_personnage = ?");
        $stmtP->execute([$id_personnage]);
        $perso = $stmtP->fetch();

        // IDs des objets en inventaire
        $stmtI = $pdo->prepare("SELECT id_objet FROM Inventaire WHERE id_personnage = ?");
        $stmtI->execute([$id_personnage]);
        $inventaire_ids = array_column($stmtI->fetchAll(), 'id_objet');

        // Tous les choix de la scène
        $stmtC = $pdo->prepare("SELECT * FROM Choix WHERE id_scene_source = ? ORDER BY id_choix ASC");
        $stmtC->execute([$id_scene]);
        $choix = $stmtC->fetchAll();

        $resultat = [];
        foreach ($choix as $c) {
            $verrouille = false;
            $raison     = '';

            if ((int)$c['cond_vie_min'] > 0 && (int)$perso['vie'] < (int)$c['cond_vie_min']) {
                $verrouille = true;
                $raison     = 'Vie insuffisante (' . $c['cond_vie_min'] . '❤️ requis)';
            }

            if (!$verrouille && (int)$c['cond_force_min'] > 0 && (int)$perso['force'] < (int)$c['cond_force_min']) {
                $verrouille = true;
                $raison     = 'Force insuffisante (' . $c['cond_force_min'] . '⚔️ requis)';
            }

            if (!$verrouille && !empty($c['cond_objet_requis'])) {
                if (!in_array((int)$c['cond_objet_requis'], $inventaire_ids)) {
                    $stmtO = $pdo->prepare("SELECT nom, icone FROM Objet WHERE id_objet = ?");
                    $stmtO->execute([(int)$c['cond_objet_requis']]);
                    $obj    = $stmtO->fetch();
                    $verrouille = true;
                    $raison = 'Requiert : ' . ($obj ? $obj['icone'] . ' ' . $obj['nom'] : 'objet inconnu');
                }
            }

            $c['verrouille'] = $verrouille;
            $c['raison']     = $raison;

            if ($masquer_verrouilles && $verrouille) {
                continue;
            }

            $resultat[] = $c;
        }

        return $resultat;
    }

    /** Méthode simple sans conditions (usage interne). */
    public static function getById(int $id): ?array {
        $pdo  = getPDO();
        $stmt = $pdo->prepare("SELECT * FROM Choix WHERE id_choix = ?");
        $stmt->execute([$id]);
        $row  = $stmt->fetch();
        return $row ?: null;
    }
}
