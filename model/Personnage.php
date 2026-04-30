<?php
// ============================================
// MODÈLE : Personnage
// ============================================

class Personnage {

    // Types d'objets consommables (peuvent être utilisés manuellement)
    // Les autres objets sont passifs et s'appliquent à la collecte
    public const OBJETS_CONSOMMABLES = [3, 5, 13]; // Potion, Torche, Fiole

    public static function create(string $pseudo = 'Héros'): int {
        $pdo  = getPDO();
        $stmt = $pdo->prepare("
            INSERT INTO Personnage (pseudo, vie, `force`, id_scene_actuelle, nb_choix)
            VALUES (?, 100, 10, 1, 0)
        ");
        $stmt->execute([$pseudo]);
        return (int) $pdo->lastInsertId();
    }

    public static function getById(int $id): ?array {
        $pdo  = getPDO();
        $stmt = $pdo->prepare("SELECT * FROM Personnage WHERE id_personnage = ?");
        $stmt->execute([$id]);
        $row  = $stmt->fetch();
        return $row ?: null;
    }

    public static function appliquerChoix(int $id_personnage, array $choix): void {
        $pdo = getPDO();

        $stmt = $pdo->prepare("
            UPDATE Personnage
            SET vie               = GREATEST(0, LEAST(100, vie + ?)),
                `force`           = GREATEST(0, `force` + ?),
                id_scene_actuelle = ?,
                nb_choix          = nb_choix + 1
            WHERE id_personnage   = ?
        ");
        $stmt->execute([
            (int) $choix['effet_vie'],
            (int) $choix['effet_force'],
            (int) $choix['id_scene_dest'],
            $id_personnage,
        ]);

        $pdo->prepare("
            INSERT INTO HistoriqueProgression (id_personnage, id_scene) VALUES (?, ?)
        ")->execute([$id_personnage, (int) $choix['id_scene_dest']]);

        // Ajout d'objet : appliquer l'effet passif immédiatement si non consommable
        if (!empty($choix['id_objet_donne'])) {
            $id_objet = (int) $choix['id_objet_donne'];

            $existe = $pdo->prepare("
                SELECT COUNT(*) FROM Inventaire WHERE id_personnage = ? AND id_objet = ?
            ");
            $existe->execute([$id_personnage, $id_objet]);

            if ($existe->fetchColumn() == 0) {
                $pdo->prepare("
                    INSERT INTO Inventaire (id_personnage, id_objet, utilise)
                    VALUES (?, ?, 0)
                ")->execute([$id_personnage, $id_objet]);

                // Si objet passif → appliquer effet_vie / effet_force immédiatement
                if (!in_array($id_objet, self::OBJETS_CONSOMMABLES)) {
                    self::appliquerEffetObjet($id_personnage, $id_objet);
                }
            }
        }
    }

    /**
     * Applique l'effet d'un objet passif sur les stats du joueur.
     * Appelé à la collecte pour les objets passifs.
     */
    private static function appliquerEffetObjet(int $id_personnage, int $id_objet): void {
        $pdo = getPDO();
        $obj = $pdo->prepare("SELECT effet_vie, effet_force FROM Objet WHERE id_objet = ?");
        $obj->execute([$id_objet]);
        $effets = $obj->fetch();
        if (!$effets) return;

        if ((int)$effets['effet_vie'] === 0 && (int)$effets['effet_force'] === 0) return;

        $pdo->prepare("
            UPDATE Personnage
            SET vie     = GREATEST(0, LEAST(100, vie + ?)),
                `force` = GREATEST(0, `force` + ?)
            WHERE id_personnage = ?
        ")->execute([
            (int) $effets['effet_vie'],
            (int) $effets['effet_force'],
            $id_personnage,
        ]);
    }

    /**
     * Utilise un objet consommable depuis l'inventaire.
     * Retourne false si l'objet n'est pas consommable, déjà utilisé, ou absent.
     */
    public static function utiliserObjet(int $id_personnage, int $id_objet): bool {
        // Vérifier que c'est bien un consommable
        if (!in_array($id_objet, self::OBJETS_CONSOMMABLES)) return false;

        $pdo = getPDO();

        // Vérifier présence et non-utilisation
        $stmt = $pdo->prepare("
            SELECT id_inventaire FROM Inventaire
            WHERE id_personnage = ? AND id_objet = ? AND utilise = 0
        ");
        $stmt->execute([$id_personnage, $id_objet]);
        $inv = $stmt->fetch();
        if (!$inv) return false;

        // Récupérer les effets
        $obj = $pdo->prepare("SELECT effet_vie, effet_force FROM Objet WHERE id_objet = ?");
        $obj->execute([$id_objet]);
        $effets = $obj->fetch();

        // Appliquer les effets
        $pdo->prepare("
            UPDATE Personnage
            SET vie     = GREATEST(0, LEAST(100, vie + ?)),
                `force` = GREATEST(0, `force` + ?)
            WHERE id_personnage = ?
        ")->execute([
            (int) $effets['effet_vie'],
            (int) $effets['effet_force'],
            $id_personnage,
        ]);

        // Marquer comme utilisé
        $pdo->prepare("
            UPDATE Inventaire SET utilise = 1
            WHERE id_inventaire = ?
        ")->execute([(int) $inv['id_inventaire']]);

        return true;
    }

    public static function getInventaire(int $id_personnage): array {
        $pdo  = getPDO();
        $stmt = $pdo->prepare("
            SELECT o.*, i.utilise FROM Inventaire i
            JOIN Objet o ON o.id_objet = i.id_objet
            WHERE i.id_personnage = ?
            ORDER BY i.obtenu_le ASC
        ");
        $stmt->execute([$id_personnage]);
        return $stmt->fetchAll();
    }

    /**
     * Supprime toutes les données liées à un personnage.
     * Ordre FK : Combat → HistoriqueProgression → Inventaire → Personnage
     */
    public static function delete(int $id): void {
        $pdo = getPDO();
        $pdo->prepare("DELETE FROM Combat                WHERE id_personnage = ?")->execute([$id]);
        $pdo->prepare("DELETE FROM HistoriqueProgression WHERE id_personnage = ?")->execute([$id]);
        $pdo->prepare("DELETE FROM Inventaire            WHERE id_personnage = ?")->execute([$id]);
        $pdo->prepare("DELETE FROM Personnage            WHERE id_personnage = ?")->execute([$id]);
    }
}
