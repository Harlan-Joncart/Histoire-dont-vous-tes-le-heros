<?php
// ============================================
// MODÈLE : Scene
// ============================================

class Scene {

    public static function getById(int $id): ?array {
        $pdo  = getPDO();
        $stmt = $pdo->prepare("SELECT * FROM Scene WHERE id_scene = ?");
        $stmt->execute([$id]);
        $row  = $stmt->fetch();
        return $row ?: null;
    }

    public static function getChoix(int $id_scene): array {
        $pdo  = getPDO();
        $stmt = $pdo->prepare("SELECT * FROM Choix WHERE id_scene_source = ?");
        $stmt->execute([$id_scene]);
        return $stmt->fetchAll();
    }
}
