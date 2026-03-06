<?php
// point d'entrée unique (front controller)

require_once __DIR__ . '/../app/config/database.php';
require_once __DIR__ . '/../app/controllers/BaseController.php';
require_once __DIR__ . '/../app/controllers/HomeController.php';

// simple routage basé sur un paramètre 'action'
$action = isset($_GET['action']) ? $_GET['action'] : 'home';

switch ($action) {
    case 'home':
        $ctrl = new HomeController();
        $ctrl->index();
        break;
    // ajouter d'autres routes ici

    default:
        header("HTTP/1.0 404 Not Found");
        echo "Page non trouvée";
        break;
}
