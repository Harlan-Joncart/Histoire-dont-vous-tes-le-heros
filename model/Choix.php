<?php
// ============================================
// MODÈLE : Choix
// ============================================

class Choix {

    public static function getById(int $id): ?array {
        $pdo  = getPDO();
        $stmt = $pdo->prepare("SELECT * FROM Choix WHERE id_choix = ?");
        $stmt->execute([$id]);
        $row  = $stmt->fetch();
        return $row ?: null;
    }
}
