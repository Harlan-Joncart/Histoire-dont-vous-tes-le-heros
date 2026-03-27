<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);
// ============================================
// ROUTEUR PRINCIPAL
// ============================================

require_once __DIR__ . '/controller/GameController.php';

// Anti-retour navigateur : headers no-cache
header('Cache-Control: no-store, no-cache, must-revalidate');
header('Pragma: no-cache');
header('Expires: 0');

$action = $_GET['action'] ?? 'accueil';

switch ($action) {
    case 'start':   GameController::start();   break;
    case 'jeu':     GameController::jeu();     break;
    case 'choix':   GameController::choix();   break;
    case 'rejouer': GameController::rejouer(); break;
    default:        GameController::accueil(); break;
}
