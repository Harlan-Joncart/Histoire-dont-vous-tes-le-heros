<?php include __DIR__ . '/header.php'; ?>

<?php
    $est_fin     = (bool) $scene['est_fin'];
    $type_fin    = $scene['type_fin'] ?? 'neutre';
    $pct_vie     = max(0, min(100, (int) $perso['vie']));
    $cls_vie     = $pct_vie > 60 ? 'high' : ($pct_vie > 30 ? 'medium' : 'low');
    $pct_force   = min(100, (int) $perso['force'] * 2); // force max ~50
?>

<div class="jeu-wrapper">

    <!-- ===== PANNEAU GAUCHE : STATS + INVENTAIRE ===== -->
    <aside class="jeu-sidebar">
        <div class="sidebar-perso">
            <div class="perso-avatar">🧙</div>
            <div class="perso-nom"><?= htmlspecialchars($perso['pseudo']) ?></div>
            <div class="perso-annee">Étudiant · Académie</div>
        </div>

        <div class="stats-bloc">
            <div class="stat-row">
                <span class="stat-icon">❤️</span>
                <div class="stat-bar-wrap">
                    <div class="stat-label">Vie</div>
                    <div class="stat-bar">
                        <div class="stat-fill <?= $cls_vie ?>" style="width:<?= $pct_vie ?>%"></div>
                    </div>
                    <div class="stat-val"><?= $perso['vie'] ?> / 100</div>
                </div>
            </div>

            <div class="stat-row">
                <span class="stat-icon">⚔️</span>
                <div class="stat-bar-wrap">
                    <div class="stat-label">Force</div>
                    <div class="stat-bar">
                        <div class="stat-fill force" style="width:<?= $pct_force ?>%"></div>
                    </div>
                    <div class="stat-val"><?= $perso['force'] ?></div>
                </div>
            </div>
        </div>

        <div class="inventaire-bloc">
            <h3 class="inv-titre">🎒 Inventaire</h3>
            <?php if (empty($inventaire)): ?>
                <p class="inv-vide">Aucun objet pour l'instant.</p>
            <?php else: ?>
                <ul class="inv-liste">
                    <?php foreach ($inventaire as $obj): ?>
                        <li class="inv-item" title="<?= htmlspecialchars($obj['nom']) ?>">
                            <span class="inv-icone"><?= htmlspecialchars($obj['icone']) ?></span>
                            <span class="inv-nom"><?= htmlspecialchars($obj['nom']) ?></span>
                            <?php if ((int)$obj['effet_vie'] !== 0 || (int)$obj['effet_force'] !== 0): ?>
                                <span class="inv-effets">
                                    <?php if ((int)$obj['effet_vie'] > 0): ?>+<?= $obj['effet_vie'] ?>❤️<?php endif; ?>
                                    <?php if ((int)$obj['effet_vie'] < 0): ?><?= $obj['effet_vie'] ?>❤️<?php endif; ?>
                                    <?php if ((int)$obj['effet_force'] > 0): ?>+<?= $obj['effet_force'] ?>⚔️<?php endif; ?>
                                </span>
                            <?php endif; ?>
                        </li>
                    <?php endforeach; ?>
                </ul>
            <?php endif; ?>
        </div>

        <div class="nb-choix">
            <span>📜 Choix effectués :</span>
            <strong><?= (int) $perso['nb_choix'] ?></strong>
        </div>
    </aside>

    <!-- ===== ZONE PRINCIPALE : SCÈNE + CHOIX ===== -->
    <main class="jeu-main">

        <?php if ($est_fin && $type_fin === 'victoire'): ?>
            <div class="fin-banner victoire">🏆 VICTOIRE</div>
        <?php elseif ($est_fin && $type_fin === 'defaite'): ?>
            <div class="fin-banner defaite">💀 DÉFAITE</div>
        <?php endif; ?>

        <h2 class="scene-titre"><?= htmlspecialchars($scene['titre']) ?></h2>
        <div class="scene-desc">
            <?= nl2br(htmlspecialchars($scene['description'])) ?>
        </div>

        <div class="choix-section">
            <?php if ($est_fin): ?>
                <div class="fin-actions">
                    <p class="fin-stats">
                        Partie terminée en <strong><?= (int) $perso['nb_choix'] ?></strong> choix.
                        Vie finale : <strong><?= $perso['vie'] ?></strong> | Force finale : <strong><?= $perso['force'] ?></strong>
                    </p>
                    <a href="index.php?action=rejouer" class="btn-rejouer">🔄 Nouvelle partie</a>
                </div>
            <?php else: ?>
                <p class="choix-titre">Que faites-vous ?</p>
                <form method="POST" action="index.php?action=choix">
                    <?php foreach ($choix as $c): ?>
                        <button type="submit" name="id_choix" value="<?= (int) $c['id_choix'] ?>" class="btn-choix">
                            <span class="btn-choix-arrow">▶</span>
                            <?= htmlspecialchars($c['texte']) ?>
                            <?php if ((int)$c['effet_vie'] !== 0 || (int)$c['effet_force'] !== 0 || !empty($c['id_objet_donne'])): ?>
                                <span class="btn-choix-effets">
                                    <?php if ((int)$c['effet_vie'] > 0): ?><span class="eff-pos">+<?= $c['effet_vie'] ?>❤️</span><?php endif; ?>
                                    <?php if ((int)$c['effet_vie'] < 0): ?><span class="eff-neg"><?= $c['effet_vie'] ?>❤️</span><?php endif; ?>
                                    <?php if ((int)$c['effet_force'] > 0): ?><span class="eff-pos">+<?= $c['effet_force'] ?>⚔️</span><?php endif; ?>
                                    <?php if (!empty($c['id_objet_donne'])): ?><span class="eff-item">+🎒</span><?php endif; ?>
                                </span>
                            <?php endif; ?>
                        </button>
                    <?php endforeach; ?>
                </form>
            <?php endif; ?>
        </div>

    </main>
</div>

<?php include __DIR__ . '/footer.php'; ?>
