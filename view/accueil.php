<?php include __DIR__ . '/header.php'; ?>

<div class="accueil-bg">
    <div class="accueil-overlay"></div>
    <div class="accueil-content">
        <div class="accueil-emblem">⚜</div>
        <h1 class="accueil-titre">Académie</h1>
        <p class="accueil-sous-titre">L'Histoire dont vous êtes le Héros</p>

        <div class="accueil-regles">
            <h2>Règles du jeu</h2>
            <ul>
                <li>🗺️ Chaque décision façonne votre destin</li>
                <li>⚔️ Vos statistiques évoluent selon vos choix</li>
                <li>🎒 Collectez des objets pour survivre</li>
                <li>🏆 Plusieurs fins vous attendent — victoire ou défaite</li>
                <li>⛔ Impossible de revenir en arrière !</li>
            </ul>
        </div>

        <form method="POST" action="index.php?action=start" class="start-form">
            <label for="pseudo" class="pseudo-label">Votre nom, aventurier :</label>
            <input
                type="text"
                id="pseudo"
                name="pseudo"
                class="pseudo-input"
                placeholder="Ex : Aelindra"
                maxlength="50"
                autocomplete="off"
            >
            <button type="submit" class="btn-start">
                <span>⚔</span> Commencer l'aventure
            </button>
        </form>
    </div>
</div>

<?php include __DIR__ . '/footer.php'; ?>
