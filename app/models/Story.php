<?php

class Story
{
    protected $pdo;

    public function __construct()
    {
        $this->pdo = getPDO();
    }

    /**
     * Retourne les informations d'une page d'histoire
     *
     * @param int $id
     * @return array|false
     */
    public function getPage(int $id)
    {
        $stmt = $this->pdo->prepare('SELECT * FROM Histoire WHERE Id_Histoire = ?');
        $stmt->execute([$id]);
        return $stmt->fetch();
    }
}
