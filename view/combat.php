<?php include __DIR__ . '/header.php'; ?>

<?php
    $pct_vie       = max(0, min(100, (int) $perso['vie']));
    $cls_vie       = $pct_vie > 60 ? 'high' : ($pct_vie > 30 ? 'medium' : 'low');
    $pct_force     = min(100, (int) $perso['force'] * 2);
    $pct_ennemi    = ($combat['pv_ennemi_max'] > 0)
                     ? max(0, min(100, round($combat['pv_ennemi'] / $combat['pv_ennemi_max'] * 100)))
                     : 0;
    $cls_ennemi    = $pct_ennemi > 60 ? 'high' : ($pct_ennemi > 30 ? 'medium' : 'low');

    // Récupérer le log du dernier tour depuis la session
    // $dernier_tour est passé directement par le controller (déjà nettoyé de la session)
    // Si non défini (premier affichage), on l'initialise à null
    $dernier_tour = $dernier_tour ?? null;
?>

<div class="jeu-wrapper">

    <!-- ===== PANNEAU GAUCHE : STATS ===== -->
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
                        <li class="inv-item">
                            <span class="inv-icone"><?= htmlspecialchars($obj['icone']) ?></span>
                            <span class="inv-nom"><?= htmlspecialchars($obj['nom']) ?></span>
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

    <!-- ===== ZONE COMBAT ===== -->
    <main class="jeu-main">

        <div class="combat-arena">

            <!-- Titre de la scène -->
            <h2 class="scene-titre combat-titre">
                ⚔️ <?= htmlspecialchars($scene['titre']) ?>
                <span class="combat-tour-badge">Tour <?= (int) $combat['tour'] ?></span>
            </h2>

            <!-- Description narrative -->
            <div class="scene-desc combat-desc">
                <?= nl2br(htmlspecialchars($scene['description'])) ?>
            </div>

            <!-- Barres de vie des deux combattants -->
            <div class="combat-barres">

                <!-- Joueur -->
                <div class="combattant joueur-bloc">
                    <div class="combattant-header">
                        <span class="combattant-icone">🧙</span>
                        <span class="combattant-nom"><?= htmlspecialchars($perso['pseudo']) ?></span>
                    </div>
                    <div class="stat-bar combat-barre">
                        <div class="stat-fill <?= $cls_vie ?>" style="width:<?= $pct_vie ?>%; transition: width 0.8s ease;"></div>
                    </div>
                    <div class="combattant-pv"><?= $perso['vie'] ?> / 100 ❤️</div>
                </div>

                <div class="combat-vs">VS</div>

                <!-- Ennemi -->
                <div class="combattant ennemi-bloc">
                    <div class="combattant-header">
                        <span class="combattant-icone"><?= htmlspecialchars($combat['icone_ennemi']) ?></span>
                        <span class="combattant-nom"><?= htmlspecialchars($combat['nom_ennemi']) ?></span>
                    </div>
                    <div class="stat-bar combat-barre">
                        <div class="stat-fill <?= $cls_ennemi ?>" style="width:<?= $pct_ennemi ?>%; transition: width 0.8s ease;"></div>
                    </div>
                    <div class="combattant-pv"><?= $combat['pv_ennemi'] ?> / <?= $combat['pv_ennemi_max'] ?> ❤️</div>
                </div>
            </div>

            <!-- Log du dernier tour -->
            <?php if ($dernier_tour && !empty($dernier_tour['log'])): ?>
                <div class="combat-log">
                    <h3 class="log-titre">📋 Tour <?= ((int)$dernier_tour['tour'] - 1) ?></h3>
                    <ul class="log-liste">
                        <?php foreach ($dernier_tour['log'] as $ligne): ?>
                            <li class="log-ligne"><?= $ligne ?></li>
                        <?php endforeach; ?>
                    </ul>
                </div>
            <?php endif; ?>

            <!-- Actions du joueur -->
            <div class="combat-actions">
                <p class="choix-titre">Que faites-vous ?</p>
                <form method="POST" action="index.php?action=combat-tour">
                    <input type="hidden" name="id_combat" value="<?= (int) $combat['id_combat'] ?>">

                    <button type="submit" name="action_combat" value="attaque" class="btn-choix btn-combat-attaque">
                        <span class="btn-choix-arrow">⚔️</span>
                        <span>
                            <strong>Attaquer</strong>
                            <small class="combat-hint">Inflige des dégâts basés sur votre Force</small>
                        </span>
                        <span class="btn-choix-effets">
                            <span class="eff-neg">~<?= (int) floor($perso['force'] / 2) + 5 ?> pv</span>
                        </span>
                    </button>

                    <button type="submit" name="action_combat" value="defense" class="btn-choix btn-combat-defense">
                        <span class="btn-choix-arrow">🛡️</span>
                        <span>
                            <strong>Se défendre</strong>
                            <small class="combat-hint">Réduit de moitié les dégâts reçus ce tour</small>
                        </span>
                        <span class="btn-choix-effets">
                            <span class="eff-pos">-50% dégâts</span>
                        </span>
                    </button>

                    <button type="submit" name="action_combat" value="fuite" class="btn-choix btn-combat-fuite">
                        <span class="btn-choix-arrow">🏃</span>
                        <span>
                            <strong>Fuir</strong>
                            <small class="combat-hint">40% de chance de s'échapper (sinon défaite)</small>
                        </span>
                        <span class="btn-choix-effets">
                            <span style="color: var(--beige-fonce);">40%</span>
                        </span>
                    </button>
                </form>
            </div>

        </div><!-- .combat-arena -->
    </main>
</div>

<?php include __DIR__ . '/footer.php'; ?>
