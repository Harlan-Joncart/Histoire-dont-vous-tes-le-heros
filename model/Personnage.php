<?php
// ============================================
// MODÈLE : Personnage
// ============================================

class Personnage {

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
        $pdo  = getPDO();

        // Mise à jour stats + scène actuelle
        $stmt = $pdo->prepare("
            UPDATE Personnage
            SET vie              = GREATEST(0, LEAST(100, vie + ?)),
                `force`         = GREATEST(0, `force` + ?),
                id_scene_actuelle = ?,
                nb_choix        = nb_choix + 1
            WHERE id_personnage = ?
        ");
        $stmt->execute([
            (int) $choix['effet_vie'],
            (int) $choix['effet_force'],
            (int) $choix['id_scene_dest'],
            $id_personnage,
        ]);

        // Enregistrement historique
        $h = $pdo->prepare("
            INSERT INTO HistoriqueProgression (id_personnage, id_scene)
            VALUES (?, ?)
        ");
        $h->execute([$id_personnage, (int) $choix['id_scene_dest']]);

        // Ajout objet si présent
        if (!empty($choix['id_objet_donne'])) {
            // Vérif doublon
            $existe = $pdo->prepare("
                SELECT COUNT(*) FROM Inventaire
                WHERE id_personnage = ? AND id_objet = ?
            ");
            $existe->execute([$id_personnage, (int) $choix['id_objet_donne']]);
            if ($existe->fetchColumn() == 0) {
                $inv = $pdo->prepare("
                    INSERT INTO Inventaire (id_personnage, id_objet)
                    VALUES (?, ?)
                ");
                $inv->execute([$id_personnage, (int) $choix['id_objet_donne']]);
            }
        }
    }

    public static function getInventaire(int $id_personnage): array {
        $pdo  = getPDO();
        $stmt = $pdo->prepare("
            SELECT o.* FROM Inventaire i
            JOIN Objet o ON o.id_objet = i.id_objet
            WHERE i.id_personnage = ?
            ORDER BY i.obtenu_le ASC
        ");
        $stmt->execute([$id_personnage]);
        return $stmt->fetchAll();
    }

    public static function delete(int $id): void {
        $pdo = getPDO();
        $pdo->prepare("DELETE FROM HistoriqueProgression WHERE id_personnage = ?")->execute([$id]);
        $pdo->prepare("DELETE FROM Inventaire             WHERE id_personnage = ?")->execute([$id]);
        $pdo->prepare("DELETE FROM Personnage             WHERE id_personnage = ?")->execute([$id]);
    }
}