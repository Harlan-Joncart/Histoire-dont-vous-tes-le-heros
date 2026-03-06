<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><?php echo isset($title) ? htmlspecialchars($title) : 'Histoire dont vous êtes le héros'; ?></title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<header>
    <h1><?php echo isset($title) ? htmlspecialchars($title) : ''; ?></h1>
</header>
<main>
