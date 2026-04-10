
-- ============================================
-- BASE DE DONNÉES : academie (VERSION ÉTENDUE)
-- ~10 min de lecture, fins longues et variées
-- ============================================
USE joncart;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS 
    HistoriqueProgression,
    Inventaire,
    Personnage,
    Choix,
    Objet,
    Scene;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- TABLES
-- ============================================
 
CREATE TABLE Scene (
    id_scene      INT AUTO_INCREMENT PRIMARY KEY,
    titre         VARCHAR(255) NOT NULL,
    `description`   TEXT NOT NULL,
    image         VARCHAR(255) DEFAULT NULL,
    est_fin       TINYINT(1) DEFAULT 0,
    type_fin      ENUM('victoire','defaite','neutre') DEFAULT 'neutre'
);

CREATE TABLE Objet (
    id_objet  INT AUTO_INCREMENT PRIMARY KEY,
    nom       VARCHAR(100) NOT NULL,
    icone     VARCHAR(10)  DEFAULT '📦',
    effet_vie INT DEFAULT 0,
    effet_force INT DEFAULT 0
);

CREATE TABLE Choix (
    id_choix          INT AUTO_INCREMENT PRIMARY KEY,
    id_scene_source   INT NOT NULL,
    id_scene_dest     INT NOT NULL,
    texte             TEXT NOT NULL,
    effet_vie         INT DEFAULT 0,
    effet_force       INT DEFAULT 0,
    id_objet_donne    INT DEFAULT NULL,
    FOREIGN KEY (id_scene_source) REFERENCES Scene(id_scene),
    FOREIGN KEY (id_scene_dest)   REFERENCES Scene(id_scene),
    FOREIGN KEY (id_objet_donne)  REFERENCES Objet(id_objet)
);

CREATE TABLE Personnage (
    id_personnage INT AUTO_INCREMENT PRIMARY KEY,
    pseudo        VARCHAR(100) DEFAULT 'Héros',
    vie           INT DEFAULT 100,
    `force`         INT DEFAULT 10,
    id_scene_actuelle INT DEFAULT 1,
    nb_choix      INT DEFAULT 0,
    cree_le       DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_scene_actuelle) REFERENCES Scene(id_scene)
);

CREATE TABLE Inventaire (
    id_inventaire INT AUTO_INCREMENT PRIMARY KEY,
    id_personnage INT NOT NULL,
    id_objet      INT NOT NULL,
    obtenu_le     DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_personnage) REFERENCES Personnage(id_personnage),
    FOREIGN KEY (id_objet)      REFERENCES Objet(id_objet)
);

CREATE TABLE HistoriqueProgression (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    id_personnage INT NOT NULL,
    id_scene      INT NOT NULL,
    arrive_le     DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_personnage) REFERENCES Personnage(id_personnage),
    FOREIGN KEY (id_scene)      REFERENCES Scene(id_scene)
);

-- ============================================
-- OBJETS
-- ============================================

INSERT INTO Objet (id_objet, nom, icone, effet_vie, effet_force) VALUES
(1,  'Épée rouillée',        '⚔️',   0,   5),
(2,  'Bouclier en bois',     '🛡️',  10,   0),
(3,  'Potion de soins',      '🧪',  25,   0),
(4,  'Grimoire ancien',      '📖',   0,  10),
(5,  'Torche magique',       '🔦',   5,   0),
(6,  'Amulette maudite',     '🔮', -15,  20),
(7,  'Parchemin runique',    '📜',   0,  12),
(8,  'Clé dorée',            '🗝️',   0,   0),
(9,  'Pierre de protection', '💎',  15,   5),
(10, 'Orbe de lumière',      '🔱',  10,  10),
(11, 'Médaille d\'honneur',  '🏅',   5,   5),
(12, 'Cape de l\'ombre',     '🌑',   5,   8),
(13, 'Fiole d\'adrénaline',  '⚗️',  -5,  20),
(14, 'Anneau du pacte',      '💍', -20,  25),
(15, 'Sceau du conseil',     '📋',   5,   5);

-- ============================================
-- SCÈNES
-- Ids 1-10   : Acte I   — L'Arrivée
-- Ids 11-20  : Acte II  — L'Académie
-- Ids 21-30  : Acte III — Les Ombres
-- Ids 31-40  : Acte IV  — La Crise
-- Ids 41-50  : Acte V   — Le Dénouement
-- Ids 51-60  : Fins victoires (51-56)
-- Ids 61-70  : Fins défaites (61-70)
-- ============================================

INSERT INTO Scene (id_scene, titre, `description`, est_fin, type_fin) VALUES

-- ============================================================
-- ACTE I — L'ARRIVÉE
-- ============================================================

(1, 'Les Portes de l\'Académie',
'Les tours de cristal de l\'Académie percent la brume matinale. Votre lettre d\'admission froissée dans la poche, vous approchez du grand portail doré. Un garde en armure vous barre la route. Derrière lui, deux cents étudiants s\'agitent dans la cour.',
0, 'neutre'),

(2, 'Le Hall d\'Honneur',
'Le garde tamponne votre parchemin et vous sourit. Dans le hall aux fresques majestueuses, un vieux mage fouille ses poches avec affolement, et un couloir mène aux dortoirs. Une cloche sonne — premier cours dans vingt minutes.',
0, 'neutre'),

(3, 'Les Jardins Secrets',
'Vous longez les jardins luminescents. Votre pied heurte un grimoire au symbole étrange — un oeil dans un triangle. Une torche magique bleue brûle à quelques pas. Depuis une fenêtre du premier étage, une silhouette encapuchonnée vous observe.',
0, 'neutre'),

(4, 'La Cellule de Détention',
'Deux gardes vous ont maîtrisé avant que vous fassiez trois pas. Poignets liés par des menottes runiques, vous attendez dans une cellule propre. La porte s\'ouvre : le Directeur Morwen entre, silhouette imposante en robe noire. Il s\'assoit. Il attend.',
0, 'neutre'),

(5, 'La Bibliothèque Secrète',
'Le vieux mage — Professeur Drast — vous guide derrière une tapisserie jusqu\'à une pièce cachée. Des milliers de livres, certains enchaînés, d\'autres qui flottent. "Choisissez avec discernement", murmure-t-il avant de vous laisser seul.',
0, 'neutre'),

(6, 'Les Dortoirs — Chambre 7',
'Elara Fenwick vous attend dans le couloir. Étudiante de deuxième année, regard perçant. Elle vous tend une fiole sans attendre. "Tu en auras besoin." Elle baisse la voix : "Ce soir, dans l\'aile est, ne va pas seul. Ne fais confiance à personne d\'autre que moi."',
0, 'neutre'),

(7, 'Le Bureau du Directeur',
'Le bureau de Morwen : cartes astrales aux murs, globe de cristal tournant. Il vous regarde longuement. "Une chance. Un artefact a été volé — l\'Orbe de Valdris. Retrouvez-le avant la nuit. Réussissez, votre casier est vierge. Échouez, vous repartez d\'où vous venez."',
0, 'neutre'),

(8, 'L\'Atelier des Illusions',
'Le grimoire s\'intitule "Miroirs de Kelvadren". Vous apprenez vite : sort "Double" — copie visuelle — sort "Voile" — invisibilité brève. Un miroir encadré d\'argent occupe un mur entier. Quelque chose vous regarde depuis l\'intérieur. Une voix dans votre crâne : "Libère-moi."',
0, 'neutre'),

(9, 'Le Journal de Serafina',
'Le journal sans nom appartient à Serafina Vael, disparue il y a trente ans. Dernière entrée : "La Confrérie du Vide infiltre les maîtres. Ils veulent ouvrir une brèche lors de l\'Éclipse — dans trois semaines. Ils savent que je sais. Fuyez, ou combattez."',
0, 'neutre'),

(10, 'Le Cours d\'Élémentarité',
'Le Professeur Aldric tourne autour de l\'arène. Quand vient votre tour, deux éléments répondent simultanément : Feu et Eau. Aldric s\'arrête net. "Un Dualiste. Une fois par génération." La salle entière murmure. Il vous regarde longuement. "Choisissez votre voie principale."',
0, 'neutre'),

-- ============================================================
-- ACTE II — L'ACADÉMIE
-- ============================================================

(11, 'La Tour Nord — Escalier',
'Votre laissez-passer de Morwen en poche, vous montez dans le noir. Les sorts de lumière s\'éteignent mystérieusement. Au troisième palier, deux voix : "L\'Orbe est à l\'étage." "Le rituel dans trois semaines." Les silhouettes descendent vers vous.',
0, 'neutre'),

(12, 'L\'Orbe en Vue',
'Quatrième palier : une pièce circulaire, des runes aux murs. Sur un piédestal d\'obsidienne, l\'Orbe pulse — blanc et chaud comme une étoile captive. La porte se referme derrière vous. Une troisième silhouette sort de l\'ombre, bâton de bois noir à la main.',
0, 'neutre'),

(13, 'Le Combat du Gardien',
'Le gardien attaque sans un mot. Bâton de bois noir, arcs de lumière sombre. La pièce est étroite. Vos sorts s\'entrechoquent dans un tonnerre de magie. Il est fort — mais peut-être pas plus que vous.',
0, 'neutre'),

(14, 'Le Pacte du Miroir',
'Votre main traverse la surface froide du miroir. L\'entité vous saisit le poignet. Flash noir. Douleur dans le sternum. Soudain, les flux magiques apparaissent comme des rivières de lumière. La puissance est réelle. Le miroir, lui, est vide. Dehors, quelqu\'un hurle.',
0, 'neutre'),

(15, 'L\'Épreuve des Valeurs',
'Vous résistez. L\'entité supplie, menace, promet. Vous tracez des runes dans l\'air, les yeux fermés. Flash blanc — le miroir se fissure et tombe en poussière dorée. Quelqu\'un applaudit lentement derrière vous. C\'est le Directeur Morwen. "Neuf sur dix cèdent."',
0, 'neutre'),

(16, 'La Voie du Feu',
'Vous choisissez le Feu. La progression est foudroyante. En deux semaines, des sorts qui prennent normalement des mois. Mais la nuit, des rêves de brasier. Aldric vous convoque : "La flamme vous consume. Disciplinez-la avant que ce soit elle qui vous discipline."',
0, 'neutre'),

(17, 'La Voie de l\'Eau',
'Vous choisissez l\'Eau. Lente, patiente, inévitable. En une semaine, vous guérissez une blessure que les meilleurs guérisseurs déclaraient incurable. La rumeur se répand. Elara vous retrouve le soir : "J\'ai besoin de toi cette nuit. Pas pour combattre. Pour soigner."',
0, 'neutre'),

(18, 'La Voie du Vent',
'Vous hésitez entre Feu et Eau — le Vent choisit à votre place, vous soulevant légèrement du sol. Aldric note quelque chose. "Troisième élément pour un Dualiste. Exceptionnel." Il vous oriente vers un cours spécial en petite classe : Magie Tactique, enseigné par Yrenne Sol.',
0, 'neutre'),

(19, 'La Magie Tactique',
'Dix étudiants triés sur le volet. Sol elle-même enseigne : combinaisons élémentaires avancées, contre-sorts, et — plus surprenant — lecture des intentions à travers les flux magiques. Elle semble vous observer plus que les autres.',
0, 'neutre'),

(20, 'L\'Aile Est — Observation',
'Depuis une lucarne, vous observez : vingt personnes en robes noires autour d\'une fissure violette dans le sol. Parmi elles, deux professeurs que vous reconnaissez. Les chants font vibrer les pierres. La fissure s\'élargit lentement. Elara est à votre côté, livide.',
0, 'neutre'),

-- ============================================================
-- ACTE III — LES OMBRES
-- ============================================================

(21, 'La Salle du Grand Conseil',
'Quinze fauteuils en demi-cercle. Au centre : la Maîtresse Suprême Yrenne Sol, regard de glace. "Racontez-nous ce que vous avez lu. Sans omettre un seul détail." Un silence absolu dans la salle.',
0, 'neutre'),

(22, 'La Révélation Éclate',
'À mi-récit, deux maîtres blêmissent. Sol les fixe. "Professeur Cassin. Professeur Wyrd. Sortez." Ils se lèvent. Cassin lève la main — un sort. Le lustre explose. La salle plonge dans le chaos.',
0, 'neutre'),

(23, 'Le Traité de Combat',
'Le livre rouge — "Arts Cinétiques Avancés" — vous dévore deux nuits. Vos réflexes magiques s\'aiguisent, votre puissance double. Pendant un exercice, votre sort frappe un mur et fait trembler le bâtiment. Aldric apparaît dans l\'embrasure. Il attend une explication.',
0, 'neutre'),

(24, 'La Note Menaçante',
'Dans votre chambre, une note non signée : "Nous savons ce que tu as lu. Rejoins-nous, ou crains-nous. — C.V." Confrérie du Vide. Deux options : tendre un piège, ou alerter le directeur maintenant.',
0, 'neutre'),

(25, 'La Cellule de Veille',
'Aldric vous remet un badge gravé d\'une rune. "Cellule de Veille. Trois membres seulement." Il vous montre une carte avec cinq points rouges — des balises magiques en pentagramme parfait. Le point central se trouve exactement sous la Salle du Grand Conseil.',
0, 'neutre'),

(26, 'La Crypte sous la Chapelle',
'Une trappe sous l\'autel. Un laboratoire souterrain : machines magiques, diagrammes. Au centre — un second Orbe, identique à celui de Valdris, mais d\'une lumière rouge sang. Morwen est là. "J\'espérais que vous ne veniez pas. Mais puisque vous êtes là..."',
0, 'neutre'),

(27, 'La Vérité de Morwen',
'"La Confrérie veut l\'Orbe doré pour ouvrir la brèche. Moi, j\'ai l\'Orbe rouge pour la sceller définitivement. Le rituel demande deux participants. Je suis lié à cet Orbe depuis vingt ans — il me consumera peut-être. Aidez-moi à terminer ce que j\'ai commencé."',
0, 'neutre'),

(28, 'L\'Alliance Nocturne',
'Plan d\'Elara : elle distrait les gardes. Vous entrez par la lucarne et détruisez la pierre de focus — le cristal noir au centre du cercle rituel. "Quelques secondes une fois repéré. Pas plus." Elle vous regarde. "Tu peux le faire ?"',
0, 'neutre'),

(29, 'Le Piège',
'Vous falsifiez une réponse à la note. Rendez-vous dans une salle désaffectée. Elara et vous installez des runes d\'alarme, puis vous attendez dans l\'ombre, immobiles.',
0, 'neutre'),

(30, 'L\'Embuscade Réussie',
'Trois membres arrivent. L\'un est le Professeur Cassin — celui qui vous complimentait la semaine dernière. Il regarde les menottes runiques sans émotion. Pendant qu\'on l\'emmène, il murmure : "Regardez ce que Morwen cache dans la crypte. Puis jugez."',
0, 'neutre'),

-- ============================================================
-- ACTE IV — LA CRISE
-- ============================================================

(31, 'La Bataille du Conseil',
'Des éclairs magiques traversent la salle du Conseil. Sol déploie un bouclier doré qui absorbe deux sorts simultanément. "Protégez les archives !" Wyrd s\'y précipite. Cassin vous vise directement.',
0, 'neutre'),

(32, 'Poursuite de Wyrd',
'Vous vous élancez après Wyrd dans les couloirs. Il est rapide, lance des sorts derrière lui. Un mur s\'effondre à votre gauche. Une porte se soude. Vous ripostez et gagnez du terrain — mais le chemin mène vers les sous-sols.',
0, 'neutre'),

(33, 'Retour de l\'Orbe',
'L\'Orbe de Valdris entre vos mains pulse au rythme de votre coeur — mémoires fugaces d\'un autre. Vous rejoignez le bureau de Morwen. Il accueille l\'Orbe avec un soulagement manifeste, puis vous regarde. "Je vous dois des explications."',
0, 'neutre'),

(34, 'Nuit du Rituel — L\'Entrée',
'Le plan se déploie. Elara disparaît dans le couloir opposé. Un fracas — sa diversion. La lucarne est à deux mètres. En bas, les chants du cercle. La fissure violette pulse. La pierre de focus brille au centre, noire et ardente.',
0, 'neutre'),

(35, 'La Pierre Détruite',
'Vous plongez. Vos mains saisissent le cristal. Toute votre magie sur ce seul point. La pierre explose. La fissure violette se referme dans un hurlement. Plusieurs membres du cercle tombent, étordis. Elara est à vos côtés une seconde plus tard. "On a réussi. Pour ce soir."',
0, 'neutre'),

(36, 'Sol Révèle les Mensonges',
'Sol vous convoque. "Je sais ce que vous avez fait dans l\'aile est. Et ce que vous avez trouvé dans la bibliothèque secrète." Elle pose deux dossiers sur son bureau. "La Confrérie est plus grande que Morwen ne vous a dit. Il vous protégeait — mais il vous a aussi menti."',
0, 'neutre'),

(37, 'Le Doute sur Morwen',
'Sol vous montre des documents : Morwen correspond secrètement avec un membre de la Confrérie depuis six ans. "Pas pour trahir — pour espionner. Mais la ligne est mince." Elle marque une pause. "Il agit seul parce qu\'il ne fait confiance à personne. Même pas à vous."',
0, 'neutre'),

(38, 'Les Deux Orbes Réunis',
'Les deux Orbes face à face dans la crypte génèrent des arcs d\'énergie visibles entre eux. "Ensemble, ils peuvent sceller la brèche définitivement. Séparément, inutiles. La Confrérie le sait. C\'est pourquoi ils ont volé l\'Orbe doré." Morwen pose ses mains sur le rebord du piédestal.',
0, 'neutre'),

(39, 'L\'Ultimatum',
'Une lettre signée d\'un cercle vide : "Livrez les deux Orbes avant l\'Éclipse ou nous frappons la ville voisine. Douze heures." Morwen est livide. Sol est calme. Elara serre les poings. Vous devez décider maintenant.',
0, 'neutre'),

(40, 'L\'Alliance Finale',
'Morwen, Sol, Elara et vous — quatre personnes dans la crypte. L\'Éclipse est dans six heures. Le plan est simple dans ses grandes lignes, périlleux dans ses détails : tenir le rituel de scellement quoi qu\'il arrive dehors. Ensemble.',
0, 'neutre'),

-- ============================================================
-- ACTE V — LE DÉNOUEMENT
-- ============================================================

(41, 'La Nuit de l\'Éclipse',
'Minuit. Le ciel vire au violet. La brèche sous la Salle du Conseil commence à s\'ouvrir. Des combats au-dessus — gardes loyaux contre la Confrérie. Dans la crypte : les deux Orbes sur leurs piédestaux. Morwen et Sol en transe. Elara et vous formez le cercle de stabilisation.',
0, 'neutre'),

(42, 'L\'Assaut Final',
'Cinq membres de la Confrérie défoncent la porte de la crypte. Ils visent les Orbes. Morwen et Sol ne peuvent pas interrompre la transe — le rituel romprait. Elara vous regarde. Vous n\'avez que des secondes.',
0, 'neutre'),

(43, 'Tenir le Cercle',
'Vous ne bougez pas. Les sorts vous frappent — vous encaissez, chanceler, mais les mains restent dans la position du cercle. Elara couverte de sang tient aussi. La brèche tremble. Le rituel avance.',
0, 'neutre'),

(44, 'Combattre les Envahisseurs',
'Vous lâchez. Votre magie explose dans la crypte — deux membres tombent. Mais sans vous, le cercle fléchit. Morwen saigne du nez. Sol psalmodie plus vite pour compenser. La brèche résiste.',
0, 'neutre'),

(45, 'Le Sacrifice de Morwen',
'L\'Orbe rouge explose. Morwen est projeté contre le mur. La brèche se referme dans un son comme une porte claquée dans un palais vide. Elara court vers lui. Ses yeux sont ouverts. Il respire, à peine. "C\'était... prévu", dit-il.',
0, 'neutre'),

(46, 'La Brèche Fermée',
'Silence total dans la crypte. Les membres de la Confrérie encore debout s\'effondrent — la brèche était leur source de puissance. Elara s\'appuie contre vous. Vous regardez les deux Orbes : l\'un doré, intact. L\'autre réduit en poussière d\'argent.',
0, 'neutre'),

(47, 'L\'Après-Éclipse',
'L\'aube sur l\'Académie. Arrestations, interrogatoires, larmes. Cassin est jugé. Wyrd est en fuite. Morwen est à l\'infirmerie, vivant mais diminué. Sol préside le Grand Conseil en urgence. Elle vous convoque dans trois heures.',
0, 'neutre'),

(48, 'La Convocation de Sol',
'"Vous avez trois options devant vous." Sol pose trois documents sur son bureau, chacun avec un sceau différent. "Je veux que vous les connaissiez toutes avant de choisir. Prenez le temps."',
0, 'neutre'),

(49, 'La Brèche Partiellement Fermée',
'Le rituel a dérape. La brèche est fermée à moitié. Un éclat dimensionnel reste dans les fondations — perturbations magiques toutes les six nuits, zones inutilisables. Morwen, épuisé : "Ce n\'est pas suffisant. Il faudra recommencer."',
0, 'neutre'),

(50, 'Ce Qui Reste',
'L\'Académie est debout. Vous aussi, à peine. Ce que vous faites maintenant — les choix que vous posez dans les jours qui suivent — définira qui vous serez ici. Les portes ouvertes ne le restent pas éternellement.',
0, 'neutre'),

-- ============================================================
-- FINS — VICTOIRES (51-56)
-- ============================================================

(51, 'VICTOIRE I — Le Champion',
'🏆 VICTOIRE — "Le Champion de l\'Académie"

Trois mois après l\'Éclipse. Le Grand Amphithéâtre est comble pour la première fois depuis dix ans.

Sol épingle la Médaille de l\'Académie sur votre veste — accordée pour la dernière fois il y a quarante-deux ans. "Pas pour la victoire. Pour avoir cherché la vérité sans en avoir reçu l\'ordre, l\'avoir partagée sans en tirer profit, et avoir tenu quand tout vous encourageait à lâcher."

Elara dans les jardins après la cérémonie : "Alors, Champion. Tu comptes faire quoi ?"

Il reste des mystères. Le journal de Serafina suggère d\'autres secrets enfouis. Wyrd est encore en fuite. Et l\'Orbe doré, intact dans la crypte, attend peut-être que quelqu\'un comprenne à quoi il sert vraiment.

Pour la première fois, vous regardez les tours de cristal non plus comme une destination, mais comme un point de départ.',
1, 'victoire'),

(52, 'VICTOIRE II — Le Sage',
'🏆 VICTOIRE — "Le Sage Vertueux"

Six semaines après l\'Éclipse. Drast vous retrouve seul dans la bibliothèque secrète.

Il pose un livre sur la table — simple, sans décoration. Les premières pages sont écrites dans une main soignée : Serafina Vael. Le reste est vide.

"Elle n\'a jamais pu le terminer. Sol pense que vous devriez."

Vous avez appris une chose depuis votre arrivée : les sorts s\'apprennent dans les livres. La sagesse, elle, se forge dans les refus — chaque fois qu\'il était si facile de faire le mauvais choix et que vous ne l\'avez pas fait.

Vous ouvrez le livre vide. Vous cherchez une plume.',
1, 'victoire'),

(53, 'VICTOIRE III — Le Guérisseur',
'🏆 VICTOIRE — "Le Grand Guérisseur"

Deux mois après l\'Éclipse. Un étudiant arrive à l\'infirmerie — sort de corruption, réputé irréversible. Vous travaillez quatre heures, seul. Eau, purification, une intuition que vous n\'auriez pas eue en début d\'année. À l\'aube, il respire normalement.

L\'Archiguérisseuse Maren, dans l\'encadrement de la porte : "Je recommande un cursus de Magie Médicale en parallèle de votre formation. Inhabituel pour un premier-an." Pause. "Beaucoup de choses vous réussissent mal en première année."

C\'est une blague. Vous ne l\'auriez pas compris à votre arrivée.',
1, 'victoire'),

(54, 'VICTOIRE IV — L\'Enquêteur',
'🏆 VICTOIRE — "L\'Enquêteur de l\'Ombre"

Aldric vous remet un badge discret — une rune sur un morceau de métal ordinaire. Rien qui attirerait l\'attention.

"Cellule de Veille. Trois membres. Vous êtes le troisième."

Double vie : étudiant le jour, enquêteur la nuit. Trois semaines plus tard, vous identifiez un réseau de communication encodée de membres de la Confrérie en fuite. Deux arrestations suivent. Votre nom n\'est jamais mentionné dans les rapports.

"Les meilleurs enquêteurs sont ceux dont on n\'entend jamais parler."

Non. Ça ne vous dérange pas.',
1, 'victoire'),

(55, 'VICTOIRE V — L\'Héritière de Serafina',
'🏆 VICTOIRE — "L\'Héritière"

Sol pose sur son bureau le reste du journal de Serafina Vael — pages qu\'elle gardait dans ses propres archives depuis trente ans.

"Elle était ma meilleure étudiante. Ce que vous avez fait cette nuit, c\'est ce qu\'elle aurait voulu faire si elle en avait eu la chance."

Vous lisez jusqu\'au soir. Serafina avait découvert bien plus que la Confrérie : une carte de trente-deux brèches dormantes à travers l\'empire, dessinée à la main.

Trente et un points restent inexpliqués.

"Prenez-la, dit Sol. Et prenez le temps qu\'il faut."',
1, 'victoire'),

(56, 'VICTOIRE VI — Le Duo Légendaire',
'🏆 VICTOIRE — "Le Duo Légendaire"

Elara et vous êtes convoqués ensemble devant le Grand Conseil.

Sol annonce la création d\'une nouvelle division : la Brigade de Réponse aux Anomalies Magiques. Deux étudiants en première année à sa tête — fait sans précédent.

"Deux cerveaux complémentaires ont accompli en une nuit ce que notre service de renseignement n\'a pas réussi en trois ans."

Elara vous regarde de côté. "On est coéquipiers officiels maintenant."

"On l\'était déjà."

Le premier dossier atterrit sur votre bureau le lendemain. Une anomalie à deux jours de route. Wyrd a peut-être été repéré.',
1, 'victoire'),

-- ============================================================
-- FINS — DÉFAITES (61-70)
-- ============================================================

(61, 'DÉFAITE I — La Tour Perdue',
'💀 DÉFAITE — "La Chute dans la Tour"

Le gardien vous a démoli méthodiquement. L\'Orbe vous a glissé des doigts quand vous avez perdu connaissance.

Infirmerie. Deux côtes fissurées. Elara à votre chevet, regard vide.

Morwen vient le lendemain. Il ne crie pas. "Je vous avais dit de récupérer l\'Orbe, pas d\'affronter ses gardiens seul. Ce sont deux choses différentes."

Votre dossier est suspendu trois semaines. Aldric continue de vous enseigner — seul ancrage. Le Grand Conseil statue : vous restez, sans les crédits du trimestre. Repartir à zéro.

La leçon est amère. Elle restera.',
1, 'defaite'),

(62, 'DÉFAITE II — Le Prix du Pacte',
'💀 DÉFAITE — "Consumé par les Ténèbres"

Le pouvoir du démon était réel. Vous l\'avez utilisé. Les premiers jours, grisants. Les nuits, l\'entité revenait — dans vos rêves, patiente.

Troisième semaine : vous perdez le contrôle. Un sort incendie le bureau d\'Aldric. Personne n\'est blessé, mais la violence parle.

Drast diagnostique la contamination démoniaque en vingt minutes. Six semaines sans magie. Tâches non magiques — bibliothécaire, aide aux cuisines.

Dans cette période, vous trouvez un livre sur les pactes démoniaques. L\'auteur : Aldric Morwen. Écrit quarante ans plus tôt.

Vous n\'êtes pas le premier.',
1, 'defaite'),

(63, 'DÉFAITE III — Le Mauvais Camp',
'💀 DÉFAITE — "Trahi et Banni"

Les arguments de la Confrérie semblaient tenir : magie libre, connaissances censurées. Vous y avez cru trois semaines.

La désillusion : des ordres. Voler des documents. Désactiver des runes. Surveiller Sol. Quand vous avez refusé la troisième commande, ils ont utilisé vos actes passés. Dénonciation anonyme.

Procès d\'une semaine. Vous dites toute la vérité. Aldric témoigne pour vous.

Verdict : exclusion temporaire dix-huit mois. Pas d\'effacement magique — une grâce.

Vous quittez par la porte principale un matin gris. Le garde qui vous avait accueilli est là. Il ne dit rien.',
1, 'defaite'),

(64, 'DÉFAITE IV — La Flamme Incontrôlée',
'💀 DÉFAITE — "L\'Incendie de l\'Aile Est"

L\'Épreuve de Maîtrise. Un exercice standard : contrôler une flamme trente secondes, l\'éteindre. Pratiqué des dizaines de fois.

Mais la salle était pleine. Des regards. Quelque chose s\'est déréglé. La flamme a grandi. Vous avez paniqué — la panique est la pire ennemie du feu.

Le sort d\'extinction d\'Aldric arrête les dégâts. Un étudiant : brûlure au bras. L\'aile est : inutilisable trois mois.

L\'Académie ne vous exclut pas. Programme de remédiation — un an de magie fondamentale supervisé par Aldric. Il ne vous reproche rien. Il recommence, patiemment, depuis le début.',
1, 'defaite'),

(65, 'DÉFAITE V — La Fuite',
'💀 DÉFAITE — "Ceux Qui Ne Tiennent Pas"

Vous avez fui. Pas une décision consciente — une accumulation de peur et de pression.

Un soir, votre sac était fait. Cinq kilomètres sur la route de terre. Assis au bord d\'un fossé. L\'Académie visible en silhouette, tours toujours lumineuses.

Vous êtes rentré à l\'aube. Personne n\'avait fermé la porte.

Morwen le lendemain : "Je sais que vous êtes parti. Et que vous êtes revenu." Pause. "Rester demande du courage. Revenir en demande plus."

Votre statut reste intact. Mais vous portez maintenant la connaissance précise de votre propre limite.',
1, 'defaite'),

(66, 'DÉFAITE VI — Le Rituel Brisé',
'💀 DÉFAITE — "La Brèche Ouverte"

Vous avez lâché le cercle pour combattre — deux membres neutralisés. Mais sans le cercle complet, le rituel déraille.

L\'Orbe rouge explose trop tôt. La brèche se ferme à moitié. Un éclat dimensionnel reste dans les fondations. Perturbations toutes les six nuits. Zones inutilisables. Cours réorganisés.

Morwen vivant. Sol aussi. Personne ne vous reproche rien publiquement. C\'est presque pire.

Dans la crypte déserte, vous promettez à personne en particulier : vous trouverez comment extraire l\'éclat. Pas par les mots. Par le travail.',
1, 'defaite'),

(67, 'DÉFAITE VII — Le Piège Retourné',
'💀 DÉFAITE — "Dans l\'Ombre de la Confrérie"

Le piège s\'est retourné. La Confrérie avait anticipé — leurs espions vous avaient repéré depuis le début. En entrant dans la salle désaffectée, c\'est vous qui êtes tombé dans leur embuscade.

Blessé, capturé vingt minutes, libéré volontairement avec un message : "La prochaine fois, nous ne serons pas aussi généreux."

Morwen gèle votre accès aux zones sensibles. "Pour votre sécurité." La formule est polie. La réalité : vous êtes devenu un risque.

Deux mois sans être dans la boucle. Vous apprenez la fin de l\'Éclipse par des rumeurs de couloir.

L\'audace sans information, ce n\'est pas du courage.',
1, 'defaite'),

(68, 'DÉFAITE VIII — L\'Expulsion',
'💀 DÉFAITE — "Fin Avant le Commencement"

Morwen vous avait accordé une chance. Vous l\'avez refusée — par peur, par fierté, peu importe. Le résultat est le même.

Votre dossier est clôturé le soir même. Un garde vous escorte jusqu\'à vos affaires, puis jusqu\'à la porte. Pas de cérémonie.

Sur la route, vous vous retournez une seule fois. Les tours de cristal disparaissent dans la brume.

Vous n\'avez passé que deux jours à l\'Académie. Pas assez pour apprendre la magie. Juste assez pour apprendre que certaines portes ne se rouvrent pas.',
1, 'defaite'),

(69, 'DÉFAITE IX — La Dénonciation Précipitée',
'💀 DÉFAITE — "Quand les Certitudes s\'Effondrent"

Vous avez dénoncé Morwen sans preuves solides, sans consulter Sol d\'abord.

Le Conseil enquête. Morwen est suspendu trois semaines. Sans lui pour surveiller la crypte, deux membres de la Confrérie récupèrent l\'Orbe rouge.

La brèche s\'ouvre lors de l\'Éclipse. Pas complètement — mais une entité passe. Douze heures de combat collectif. L\'aile sud de l\'Académie est détruite.

Sol vous convoque. Son regard ne contient pas de colère. Pire : de la déception. "Vos doutes étaient peut-être fondés. Votre méthode a coûté une aile entière."

Vous restez. Mais rien ne sera comme avant.',
1, 'defaite'),

(70, 'DÉFAITE X — Le Vide',
'💀 DÉFAITE — "Absorbé par l\'Autre Côté"

Vous avez donné trop. En orientant toute votre magie dans le rituel, vous avez créé un canal — quelque chose de l\'autre côté a tiré.

La brèche se referme. L\'Académie est sauvée. Mais votre magie est... partie. Pas diminuée. Partie. Les flux que vous sentiez sont silencieux, comme une rivière asséchée.

Morwen à votre réveil : "Ce peut être temporaire. Ou non. Nous ne savons pas."

Les semaines suivantes sont étranges. Présent sans pouvoir pratiquer.

Sol vous propose un rôle : analyste. Lecture des flux, théorie, stratégie — sans pratique. "L\'intelligence n\'a pas besoin de magie pour fonctionner."

Le silence là où brûlait la flamme ne part pas vraiment.',
1, 'defaite');

-- ============================================================
-- CHOIX
-- ============================================================

-- ACTE I

-- Scène 1
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(1, 2,  'Saluer poliment le garde et présenter votre lettre d\'admission.', 0, 0, NULL),
(1, 3,  'Contourner discrètement par les jardins sur le côté.', 0, 2, 5),
(1, 4,  'Essayer de passer en force dans la foule.', -10, 0, NULL);

-- Scène 2
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(2, 5,  'Aider le vieux mage à retrouver son objet perdu.', 5, 5, 4),
(2, 6,  'Aller directement aux dortoirs vous installer.', 0, 0, NULL),
(2, 10, 'Filer en salle de cours pour ne pas être en retard.', 0, 3, NULL);

-- Scène 3
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(3, 8,  'Ramasser le grimoire et trouver un atelier pour l\'étudier.', 0, 8, 1),
(3, 6,  'Prendre la torche magique et rejoindre les dortoirs.', 5, 0, 3);

-- Scène 4
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(4, 7,  'S\'excuser sincèrement et expliquer votre motivation.', 0, 0, NULL),
(4, 68, 'Garder le silence et refuser d\'expliquer quoi que ce soit.', 0, 0, NULL);

-- Scène 5
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(5, 9,  'Ouvrir le journal dont les pages changent selon l\'angle.', 0, 5, NULL),
(5, 23, 'Prendre le traité de combat magique relié de rouge.', 0, 12, 7),
(5, 6,  'Refermer les livres et aller vous préparer pour les cours.', 5, 0, 3);

-- Scène 6
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(6, 10, 'Accepter la potion d\'Elara et aller en cours.', 10, 0, NULL),
(6, 20, 'Suivre Elara pour découvrir ce qu\'elle sait sur l\'aile est.', 0, 5, NULL);

-- Scène 7
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(7, 11, 'Accepter la mission et partir vers la tour nord.', 0, 5, 1),
(7, 68, 'Refuser la mission — trop dangereux pour un premier-an.', 0, 0, NULL);

-- Scène 8
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(8, 14, 'Accepter le marché de l\'entité dans le miroir.', -15, 15, 6),
(8, 15, 'Refuser et tenter de sceller le miroir.', 10, 0, NULL);

-- Scène 9
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(9, 21, 'Aller immédiatement révéler la conspiration au Grand Conseil.', 0, 5, NULL),
(9, 24, 'Garder le journal secret et observer avant d\'agir.', 5, 0, NULL);

-- Scène 10
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(10, 16, 'Choisir l\'élément Feu — la puissance vous attire.', 0, 15, 1),
(10, 17, 'Choisir l\'élément Eau — guérison et protection.', 20, 0, 2),
(10, 18, 'Laisser le Vent choisir à votre place.', 5, 8, NULL);

-- ACTE II

-- Scène 11
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(11, 12, 'Se plaquer dans l\'ombre et laisser les silhouettes passer.', 0, 0, NULL),
(11, 61, 'Dévaler l\'escalier en espérant les semer.', -5, 0, NULL);

-- Scène 12
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(12, 13, 'Affronter le gardien masqué de front.', -10, 5, NULL),
(12, 19, 'Utiliser le sort "Double" pour créer une illusion diversion.', 0, 5, NULL);

-- Scène 13
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(13, 33, 'Vaincre le gardien et saisir l\'Orbe.', -15, 0, 8),
(13, 61, 'Fuir — vous êtes trop blessé pour continuer.', -5, 0, NULL);

-- Scène 14
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(14, 62, 'Utiliser le pouvoir du démon sans retenue.', -20, 0, 14),
(14, 21, 'Résister à la corruption et alerter le Grand Conseil.', 5, 0, NULL);

-- Scène 15
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(15, 25, 'Rejoindre la Cellule de Veille d\'Aldric.', 5, 5, 11),
(15, 21, 'Demander à rejoindre la brigade du Grand Conseil.', 5, 5, NULL);

-- Scène 16
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(16, 23, 'Chercher à augmenter votre puissance avec le traité de combat.', 0, 10, NULL),
(16, 25, 'Suivre les conseils d\'Aldric et pratiquer la canalisation.', 5, 5, 7);

-- Scène 17
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(17, 20, 'Suivre Elara dans l\'aile est ce soir.', 5, 0, 3),
(17, 26, 'Enquêter seul sur la crypte dont vous avez entendu parler.', 0, 5, NULL);

-- Scène 18
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(18, 19, 'Suivre le cours de Magie Tactique avec Sol.', 5, 8, NULL),
(18, 20, 'Rejoindre Elara et enquêter sur l\'aile est.', 0, 5, 12);

-- Scène 19
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(19, 36, 'Sol vous révèle des informations en privé après le cours.', 5, 5, 15),
(19, 25, 'Rejoindre la Cellule de Veille d\'Aldric en parallèle.', 0, 8, NULL),
(19, 20, 'Retrouver Elara pour inspecter l\'aile est ensemble.', 0, 5, NULL);

-- Scène 20
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(20, 28, 'Accepter le plan d\'Elara — entrer par la lucarne.', 0, 5, NULL),
(20, 22, 'Refuser et aller chercher Morwen en renfort.', 0, 0, NULL);

-- ACTE III

-- Scène 21
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(21, 22, 'Tout révéler devant le Grand Conseil.', 0, 5, NULL),
(21, 63, 'Taire une partie pour protéger certains alliés.', 0, 0, NULL);

-- Scène 22
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(22, 31, 'Rester et combattre aux côtés des maîtres loyaux.', -5, 5, NULL),
(22, 32, 'Poursuivre Wyrd dans les archives.', 0, 5, NULL);

-- Scène 23
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(23, 25, 'Dire la vérité à Aldric sur la provenance du traité.', 0, 5, NULL),
(23, 24, 'Mentir — prétendre avoir trouvé le traité dans les dortoirs.', 0, 0, NULL);

-- Scène 24
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(24, 29, 'Tendre un piège à ceux qui vous ont contacté.', 0, 8, 12),
(24, 65, 'Fuir l\'Académie cette nuit — votre vie est en danger.', 0, 0, NULL);

-- Scène 25
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(25, 26, 'Inspecter la crypte — point central du pentagramme.', 0, 5, NULL),
(25, 31, 'Porter vos découvertes au Grand Conseil.', 5, 0, NULL);

-- Scène 26
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(26, 27, 'Écouter la vérité complète de Morwen.', 0, 5, NULL),
(26, 36, 'Sortir et aller chercher Sol — elle doit entendre ça.', 5, 0, NULL);

-- Scène 27
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(27, 38, 'Faire confiance à Morwen et l\'aider pour le rituel.', 0, 5, 10),
(27, 37, 'Poser des questions difficiles — trop de zones d\'ombre.', 5, 0, NULL);

-- Scène 28
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(28, 35, 'Entrer par la lucarne et détruire la pierre de focus.', -10, 5, NULL),
(28, 22, 'Reculer et aller chercher Morwen en renfort.', 0, 0, NULL);

-- Scène 29
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(29, 30, 'Se rendre au rendez-vous piégé.', -5, 5, NULL),
(29, 31, 'Annuler le piège et alerter directement le Grand Conseil.', 5, 0, NULL);

-- Scène 30
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(30, 26, 'Aller vérifier la crypte — les doutes de Cassin méritent d\'être levés.', 0, 5, NULL),
(30, 31, 'Ignorer Cassin et témoigner directement devant le Conseil.', 5, 5, NULL);

-- ACTE IV

-- Scène 31
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(31, 32, 'Courir après Wyrd dans les archives.', -5, 5, NULL),
(31, 33, 'Protéger Sol pendant la bataille.', 5, 5, 9);

-- Scène 32
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(32, 26, 'Capturer Wyrd et lui faire avouer les secrets de Morwen.', -10, 0, NULL),
(32, 69, 'Wyrd vous échappe — vous perdez sa trace.', -5, 0, NULL);

-- Scène 33
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(33, 34, 'Retourner dans l\'aile est avec Elara ce soir.', 0, 5, NULL),
(33, 38, 'Demander à Morwen de montrer les deux Orbes dans la crypte.', 0, 5, NULL);

-- Scène 34
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(34, 35, 'Plonger et saisir la pierre de focus.', -10, 5, NULL),
(34, 66, 'Hésiter — vous êtes repéré avant d\'agir.', -20, 0, NULL);

-- Scène 35
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(35, 40, 'Suivre Elara pour préparer le rituel de scellement final.', 5, 5, NULL),
(35, 47, 'Remettre tout entre les mains de Morwen et Sol.', 10, 0, NULL);

-- Scène 36
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(36, 37, 'Écouter Sol jusqu\'au bout sur les mensonges de Morwen.', 0, 5, NULL),
(36, 40, 'Ignorer les doutes — l\'heure n\'est plus aux questions.', 5, 0, NULL);

-- Scène 37
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(37, 40, 'Faire confiance à Morwen malgré tout — agir ensemble.', 0, 5, NULL),
(37, 69, 'Signaler Morwen au Grand Conseil — trop de zones d\'ombre.', 0, 0, NULL);

-- Scène 38
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(38, 39, 'Préparer le rituel — l\'Éclipse approche.', 5, 5, NULL),
(38, 36, 'Consulter Sol avant de vous engager davantage.', 5, 0, NULL);

-- Scène 39
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(39, 40, 'Refuser de céder et préparer le rituel en urgence.', 0, 10, NULL),
(39, 67, 'Tendre une nouvelle embuscade à la Confrérie avant l\'Éclipse.', -10, 5, NULL);

-- Scène 40
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(40, 41, 'Prendre votre place dans le rituel — la nuit de l\'Éclipse commence.', 0, 5, NULL),
(40, 65, 'Paniquer devant l\'ampleur de la situation et fuir.', -10, 0, NULL);

-- ACTE V

-- Scène 41
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(41, 42, 'Maintenir le cercle quoi qu\'il arrive.', 0, 5, NULL),
(41, 70, 'Orienter toute votre magie dans le rituel — donner absolument tout.', -20, 0, NULL);

-- Scène 42
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(42, 43, 'Tenir le cercle coûte que coûte.', -15, 0, NULL),
(42, 44, 'Lâcher le cercle et combattre les envahisseurs.', -10, 5, NULL);

-- Scène 43
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(43, 45, 'Tenir jusqu\'à la fin — le rituel se termine.', -10, 0, NULL),
(43, 66, 'Vous effondrer — plus assez de force pour tenir.', -30, 0, NULL);

-- Scène 44
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(44, 45, 'Rejoindre le cercle après avoir neutralisé les envahisseurs.', -10, 0, NULL),
(44, 66, 'Le rituel déraille avant que vous puissiez revenir.', -20, 0, NULL);

-- Scène 45
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(45, 46, 'Laisser le rituel se terminer — l\'Académie avant tout.', 0, 0, NULL),
(45, 70, 'Donner tout ce qui vous reste pour accélérer la fermeture.', -20, 0, NULL);

-- Scène 46
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(46, 47, 'Rejoindre Sol pour les arrestations et le rapport.', 5, 0, NULL),
(46, 48, 'Attendre la convocation de Sol dans la crypte.', 0, 0, NULL);

-- Scène 47
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(47, 48, 'Se rendre à la convocation de Sol.', 0, 0, NULL),
(47, 51, 'Rejoindre la cérémonie des Distinctions annoncée par Morwen.', 5, 5, 11);

-- Scène 48
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(48, 51, 'Choisir la Médaille de l\'Académie — honneur public.', 5, 0, 11),
(48, 54, 'Choisir la Cellule de Veille — discrétion et enquête.', 0, 5, NULL),
(48, 56, 'Choisir la Brigade avec Elara — duo légendaire.', 5, 5, NULL);

-- Scène 49
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(49, 66, 'Accepter l\'échec — vous avez fait ce que vous pouviez.', 0, 0, NULL),
(49, 50, 'Refuser d\'abandonner — il doit y avoir une solution.', 0, 5, NULL);

-- Scène 50
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(50, 52, 'Chercher Drast pour compléter le journal de Serafina.', 0, 5, 4),
(50, 53, 'Aller à l\'infirmerie et vous consacrer à la guérison.', 10, 0, 3),
(50, 55, 'Demander à Sol les pages secrètes du journal de Serafina.', 0, 5, NULL);
