<?php

require_once __DIR__ . '/BaseController.php';

class HomeController extends BaseController
{
    public function index()
    {
        $title = 'Bienvenue dans votre histoire';
        $this->render('home', ['title' => $title]);
    }
}
