<?php
// ============================================
// MODÈLE : Combat (tour par tour)
// ============================================

class Combat {

    /**
     * Initialise un combat pour un joueur sur une scène donnée.
     * Supprime tout combat en cours non terminé sur cette scène.
     */
    public static function initier(int $id_personnage, array $scene): int {
        $pdo = getPDO();

        // Nettoyer un éventuel combat précédent sur cette scène
        $pdo->prepare("
            DELETE FROM Combat WHERE id_personnage = ? AND id_scene = ? AND termine = 0
        ")->execute([$id_personnage, (int)$scene['id_scene']]);

        $stmt = $pdo->prepare("
            INSERT INTO Combat
                (id_personnage, id_scene, pv_ennemi, pv_ennemi_max,
                 nom_ennemi, icone_ennemi, tour, termine, victoire,
                 id_scene_victoire, id_scene_defaite)
            VALUES (?, ?, ?, ?, ?, ?, 1, 0, 0, ?, ?)
        ");
        $stmt->execute([
            $id_personnage,
            (int) $scene['id_scene'],
            (int) $scene['combat_pv_ennemi'],
            (int) $scene['combat_pv_ennemi'],
            $scene['combat_nom_ennemi']  ?? 'Ennemi',
            $scene['combat_icone']       ?? '👹',
            $scene['combat_scene_win']   ?? null,
            $scene['combat_scene_lose']  ?? null,
        ]);

        return (int) $pdo->lastInsertId();
    }

    /**
     * Récupère le combat actif (non terminé) d'un joueur sur une scène.
     */
    public static function getCombatActif(int $id_personnage, int $id_scene): ?array {
        $pdo  = getPDO();
        $stmt = $pdo->prepare("
            SELECT * FROM Combat
            WHERE id_personnage = ? AND id_scene = ? AND termine = 0
            ORDER BY id_combat DESC LIMIT 1
        ");
        $stmt->execute([$id_personnage, $id_scene]);
        $row = $stmt->fetch();
        return $row ?: null;
    }

    /**
     * Joue un tour de combat.
     *
     * Actions joueur possibles :
     *   - 'attaque'  : dégâts basés sur la force du joueur
     *   - 'defense'  : réduit les dégâts reçus ce tour
     *   - 'fuite'    : tentative de fuite (50% de chance)
     *
     * Retourne un tableau décrivant ce qui s'est passé.
     */
    public static function jouerTour(int $id_combat, int $id_personnage, string $action): array {
        $pdo = getPDO();

        // Charger le combat
        $stmt = $pdo->prepare("SELECT * FROM Combat WHERE id_combat = ? AND id_personnage = ? AND termine = 0");
        $stmt->execute([$id_combat, $id_personnage]);
        $combat = $stmt->fetch();

        if (!$combat) {
            return ['erreur' => 'Combat introuvable ou déjà terminé.'];
        }

        // Charger le joueur
        $stmtP = $pdo->prepare("SELECT vie, `force` FROM Personnage WHERE id_personnage = ?");
        $stmtP->execute([$id_personnage]);
        $perso = $stmtP->fetch();

        $log    = [];
        $fin    = false;
        $victoire = false;

        $pv_ennemi = (int) $combat['pv_ennemi'];
        $vie_joueur = (int) $perso['vie'];
        $force_joueur = (int) $perso['force'];

        // --- ACTION DU JOUEUR ---
        $degats_joueur = 0;
        $defense_active = false;
        $fuite_reussie  = false;

        switch ($action) {
            case 'attaque':
                // Dégâts = force ÷ 2 + aléa (2 à 8)
                $degats_joueur = (int) floor($force_joueur / 2) + random_int(2, 8);
                $pv_ennemi    -= $degats_joueur;
                $log[] = "⚔️ Vous attaquez pour <strong>{$degats_joueur}</strong> dégâts.";
                break;

            case 'defense':
                $defense_active = true;
                $log[] = "🛡️ Vous vous mettez en posture défensive.";
                break;

            case 'fuite':
                $chance = random_int(1, 100);
                if ($chance <= 40) {
                    $fuite_reussie = true;
                    $log[] = "🏃 Vous parvenez à fuir le combat !";
                } else {
                    $log[] = "🏃 Vous tentez de fuir… mais l'ennemi vous bloque !";
                }
                break;
        }

        // --- RIPOSTE DE L'ENNEMI (sauf si fuite réussie ou ennemi mort) ---
        $degats_ennemi = 0;
        if (!$fuite_reussie && $pv_ennemi > 0) {
            // Ennemi fait entre 5 et 15 dégâts, réduits de moitié en défense
            $degats_bruts  = random_int(5, 15);
            $degats_ennemi = $defense_active ? (int) ceil($degats_bruts / 2) : $degats_bruts;
            $vie_joueur   -= $degats_ennemi;
            $vie_joueur    = max(0, $vie_joueur);

            if ($defense_active) {
                $log[] = "⚡ {$combat['nom_ennemi']} attaque, mais votre défense réduit les dégâts à <strong>{$degats_ennemi}</strong>.";
            } else {
                $log[] = "⚡ {$combat['nom_ennemi']} vous inflige <strong>{$degats_ennemi}</strong> dégâts.";
            }
        }

        // --- VÉRIFIER FIN DE COMBAT ---
        $id_scene_dest = null;

        if ($fuite_reussie) {
            // Fuite = défaite
            $fin      = true;
            $victoire = false;
            $id_scene_dest = (int) $combat['id_scene_defaite'];
            $log[] = "💨 Vous avez fui. La défaite est consommée.";

        } elseif ($pv_ennemi <= 0) {
            $pv_ennemi = 0;
            $fin       = true;
            $victoire  = true;
            $id_scene_dest = (int) $combat['id_scene_victoire'];
            $log[] = "🏆 {$combat['nom_ennemi']} est vaincu !";

        } elseif ($vie_joueur <= 0) {
            $fin      = true;
            $victoire = false;
            $id_scene_dest = (int) $combat['id_scene_defaite'];
            $log[] = "💀 Vous tombez, épuisé et blessé…";
        }

        // --- MISE À JOUR BASE DE DONNÉES ---
        // Mettre à jour PV ennemi et tour
        $pdo->prepare("
            UPDATE Combat
            SET pv_ennemi = ?,
                tour      = tour + 1,
                termine   = ?,
                victoire  = ?
            WHERE id_combat = ?
        ")->execute([$pv_ennemi, $fin ? 1 : 0, $victoire ? 1 : 0, $id_combat]);

        // Mettre à jour la vie du joueur
        $pdo->prepare("
            UPDATE Personnage SET vie = ? WHERE id_personnage = ?
        ")->execute([$vie_joueur, $id_personnage]);

        // Si fin de combat → changer la scène actuelle du joueur
        if ($fin && $id_scene_dest) {
            $pdo->prepare("
                UPDATE Personnage
                SET id_scene_actuelle = ?, nb_choix = nb_choix + 1
                WHERE id_personnage = ?
            ")->execute([$id_scene_dest, $id_personnage]);

            $pdo->prepare("
                INSERT INTO HistoriqueProgression (id_personnage, id_scene) VALUES (?, ?)
            ")->execute([$id_personnage, $id_scene_dest]);
        }

        return [
            'log'          => $log,
            'pv_ennemi'    => $pv_ennemi,
            'pv_ennemi_max'=> (int) $combat['pv_ennemi_max'],
            'vie_joueur'   => $vie_joueur,
            'tour'         => (int) $combat['tour'] + 1,
            'fin'          => $fin,
            'victoire'     => $victoire,
            'fuite'        => $fuite_reussie,
            'id_scene_dest'=> $id_scene_dest,
            'nom_ennemi'   => $combat['nom_ennemi'],
            'icone_ennemi' => $combat['icone_ennemi'],
        ];
    }
}
