<?php

class BaseController
{
    /**
     * Charge une vue en lui passant des données
     *
     * @param string $view Le nom de la vue (sans extension)
     * @param array  $data Associatif de variables à passer
     */
    protected function render(string $view, array $data = [])
    {
        extract($data, EXTR_SKIP);
        require __DIR__ . '/../views/header.php';
        require __DIR__ . '/../views/' . $view . '.php';
        require __DIR__ . '/../views/footer.php';
    }
}
