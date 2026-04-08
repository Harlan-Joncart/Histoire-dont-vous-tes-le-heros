
-- ============================================
-- BASE DE DONNÉES : joncart 
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
-- DONNÉES : OBJETS
-- ============================================
 
INSERT INTO Objet (id_objet, nom, icone, effet_vie, effet_force) VALUES
(1,  'Épée rouillée',        '⚔️',   0,   5),
(2,  'Bouclier en bois',     '🛡️',  10,   0),
(3,  'Potion de soins',      '🧪',  25,   0),
(4,  'Grimoire ancien',      '📖',   0,  10),
(5,  'Arc elfique',          '🏹',   0,   8),
(6,  'Amulette maudite',     '🔮', -15,  15),
(7,  'Torche magique',       '🔦',   5,   0),
(8,  'Clé dorée',            '🗝️',   0,   0),
(9,  'Pierre de protection', '💎',  15,   5),
(10, 'Parchemin runique',    '📜',   0,  12),
(11, 'Fiole d\'adrénaline',  '⚗️',  -5,  20),
(12, 'Bandeau du guerrier',  '🎗️',   0,   7),
(13, 'Orbe de lumière',      '🔱',  10,  10),
(14, 'Cape de l\'ombre',     '🌑',   5,   5),
(15, 'Médaille d\'honneur',  '🏅',   5,   5);
 
-- ============================================
-- DONNÉES : SCÈNES
-- 1-10   : Acte I — L'Arrivée
-- 11-25  : Acte II — Les Épreuves
-- 26-40  : Acte III — Le Danger Révélé
-- 41-55  : Acte IV — La Confrontation
-- 56-70  : Fins (victoires et défaites)
-- ============================================
 
INSERT INTO Scene (id_scene, titre, `description`, est_fin, type_fin) VALUES
 
-- ============================================================
-- ACTE I — L'ARRIVÉE (scènes 1 à 10)
-- ============================================================
 
(1, 'Les Portes de l\'Académie',
'La brume matinale enveloppe les tours de cristal de l\'Académie des Mages. Vous êtes debout depuis l\'aube, votre sac sur le dos, votre lettre d\'admission froissée dans la poche. Des centaines de jeunes gens comme vous convergent vers l\'immense portail de pierre dorée. Gravées dans le linteau, des runes pulsent d\'une lumière bleutée : "SCIENTIA · VIRTUS · HONOR".
 
Un garde en armure d\'acier vous interpelle : "Halt ! Identifiez-vous, nouvel arrivant." Derrière lui, deux autres gardes surveillent la foule. Vous remarquez qu\'un étudiant près de vous glisse discrètement une pièce de monnaie dans la main d\'un des gardes et passe sans s\'arrêter. Une autre étudiante, elle, tend calmement son parchemin et échange quelques mots courtois avec le garde principal.
 
Comment allez-vous aborder votre première impression à l\'Académie ?',
0, 'neutre'),
 
(2, 'L\'Entrée Principale — Hall des Premiers Pas',
'Votre politesse a manifestement touché le garde, un homme d\'une cinquantaine d\'années au visage buriné. "Bienvenue, jeune étudiant. Première promotion ?" Il tamponner votre parchemin avec soin avant de vous rendre. "Un conseil, gratuitement : ne traînez pas dans les couloirs après la cloche de minuit. Et méfiez-vous de l\'aile est — les travaux magiques ont rendu les murs... poreux."
 
Vous pénétrez dans le hall d\'honneur. Le plafond s\'élève à vingt mètres, orné de fresques représentant les grandes batailles magiques de l\'histoire. Sous vos pieds, un pavement de marbre noir et or. Des dizaines de portraits de maîtres défunts vous regardent passer.
 
Dans l\'angle droit, un vieux mage à la barbe argentée fouille frénétiquement ses poches en marmonant. Dans l\'angle gauche, un tableau d\'affichage recouvert d\'annonces et de cartes. Au centre, un large couloir mène aux dortoirs.',
0, 'neutre'),
 
(3, 'Les Jardins Secrets',
'Vous longez le mur d\'enceinte, glissant entre deux buissons taillés en forme de dragon. Les jardins de l\'Académie sont une merveille : des plantes luminescentes poussent entre des fontaines de pierre, des papillons aux ailes d\'argent virevoltent autour de fleurs impossibles.
 
Alors que vous progressez, votre pied heurte quelque chose de dur. Un livre, relié de cuir brun, à moitié enfoui sous les feuilles mortes. Sur sa couverture, aucun titre — seulement un symbole : un œil ouvert dans un triangle. Vous sentez une légère chaleur émaner de ses pages.
 
Plus loin, derrière un if taillé, vous apercevez une torche magique abandonnée, son flamboiement bleu encore vif. Et depuis une fenêtre du premier étage, une silhouette encapuchonnée vous observe fixement, immobile.',
0, 'neutre'),
 
(4, 'La Cellule de Détention',
'Votre tentative de forcer le passage a tourné court. Deux gardes vous ont plaqué au sol avant que vous ayez fait trois pas. "Encore un qui croit que le règlement s\'applique aux autres", a grogné l\'un d\'eux.
 
Vous voilà dans une cellule propre mais austère, les poignets liés par des menottes runiques qui empêchent tout usage de magie. Une heure s\'écoule. Puis la porte s\'ouvre. Le directeur Aldric Morwen en personne entre, une silhouette imposante dans sa robe noire brodée d\'argent. Son regard vous jauge longuement.
 
"Dites-moi une chose," commence-t-il avec un calme glacial, "pourquoi devrais-je ne pas vous renvoyer chez vous sur-le-champ ?" Il s\'assoit en face de vous et croise les doigts. C\'est votre seule chance de vous expliquer.',
0, 'neutre'),
 
(5, 'La Bibliothèque — Section Secrète',
'Le vieux mage s\'appelle Professeur Elowen Drast, spécialiste des artefacts anciens. Son objet perdu, vous l\'avez retrouvé glissé sous un banc du hall : un pendentif en obsidienne gravé d\'une spirale. Il le serre contre lui avec un soupir de soulagement.
 
"Venez," dit-il simplement. Il vous guide à travers un dédale de couloirs que vous n\'auriez jamais trouvé seul, jusqu\'à une porte dérobée derrière une tapisserie. Derrière : la bibliothèque secrète. Des milliers de livres du sol au plafond, certains enchaînés, d\'autres qui flottent lentement. L\'air sent l\'encre vieille et l\'ozone.
 
"Ces ouvrages ne sont pas dans les catalogues officiels," murmure Drast. "Choisissez avec discernement." Il vous laisse seul. Trois livres vous attirent particulièrement : un traité de combat magique relié de rouge, un journal personnel sans nom apparent, et un grimoire dont les pages semblent changer de texte selon l\'angle de vue.',
0, 'neutre'),
 
(6, 'Les Dortoirs — Chambre 7',
'Les dortoirs de l\'Académie ressemblent davantage à un monastère qu\'à une école : de longues rangées de portes numérotées, des fenêtres en ogive donnant sur la cour intérieure, des bougies magiques qui s\'allument automatiquement au passage. Vous trouvez votre chambre : minuscule mais équipée d\'un bureau, d\'un lit à baldaquin et d\'une étagère vide qui vous tend les bras.
 
Elara Fenwick est dans le couloir, adossée au mur comme si elle vous attendait. C\'est une étudiante de deuxième année au regard perçant et aux cheveux coupés court. "Tu es nouveau, n\'est-ce pas ?" Elle vous tend une fiole de liquide bleuté sans attendre votre réponse. "Potion de soins, faite maison. Meilleure que les officielles. Garde-la — tu en auras besoin plus tôt que tu ne le crois."
 
Elle baisse la voix. "Ce soir, après la cloche, des choses vont se passer dans l\'aile est. Ne t\'y aventure pas seul. Et ne fais confiance à personne d\'autre que moi ici." Elle disparaît dans l\'escalier avant que vous puissiez lui poser une question.',
0, 'neutre'),
 
(7, 'Le Bureau du Directeur',
'Le bureau du Directeur Morwen occupe tout le sommet de la Tour Centrale. Des murs tapissés de cartes astrales, une bibliothèque personnelle impressionnante, et en son centre, un globe de cristal qui tourne lentement sur lui-même, projetant des reflets irisés sur le plafond.
 
Après votre explication — maladroite mais sincère — le directeur reste silencieux un long moment. "Vos motivations sont peut-être honorables," dit-il enfin. "Mais votre méthode révèle une impulsivité dangereuse dans notre domaine." Il se lève et s\'approche de la fenêtre donnant sur les jardins.
 
"Je vais vous donner une chance. Une seule. Il y a trois nuits, un artefact a été volé dans notre chambre forte — l\'Orbe de Lumière de Valdris. Nous pensons qu\'il se trouve toujours dans l\'enceinte. Si vous le retrouvez avant la nuit, votre casier sera vierge. Échouez, et vous repartez d\'où vous venez." Il se retourne. "Qu\'en dites-vous ?"',
0, 'neutre'),
 
(8, 'L\'Atelier des Illusions',
'Le grimoire trouvé dans les jardins s\'intitule, selon les runes intérieures que vous parvenez à déchiffrer, "Miroirs de Kelvadren — Traité des Illusions Fondamentales". Vous le lisez dans un atelier désaffecté de l\'aile nord, assis sur un tonneau renversé.
 
La magie d\'illusion vous vient avec une facilité troublante. En une heure, vous maîtrisez le sort "Double" — créer une copie visuelle de vous-même — et "Voile" — vous rendre visuellement transparent pendant quelques secondes.
 
C\'est là que vous voyez le miroir. Il occupe tout un mur de l\'atelier, son cadre d\'argent ouvragé représentant des silhouettes en train de se tordre. Et dans le miroir, quelque chose vous regarde. Pas votre reflet — autre chose. Une entité aux yeux de braise qui s\'approche de la surface de verre en tendant une main fine. Sa voix est un murmure qui résonne directement dans votre crâne : "Libère-moi. Je peux t\'offrir ce qu\'aucun maître ne t\'apprendra jamais."',
0, 'neutre'),
 
(9, 'La Prophétie du Grimoire',
'Le journal sans nom est en réalité le carnet personnel d\'une ancienne étudiante disparue il y a trente ans — Serafina Vael. Ses dernières entrées décrivent, avec une précision glaçante, une organisation secrète au sein même du corps professoral : la Confrérie du Vide. Leur objectif : ouvrir une brèche dimensionnelle sous la Tour Centrale lors de la prochaine Éclipse Magique — dans trois semaines.
 
Et la dernière ligne du journal, tracée en rouge : "Ils savent que j\'ai découvert la vérité. Ils viennent. Si vous lisez ceci, fuyez, ou combattez. Il n\'y a pas de troisième option."
 
Vous refermez le journal, les mains tremblantes. Dehors, des cloches sonnent — pas les cloches habituelles, mais quelque chose de plus grave, de plus urgent. Et derrière vous, la porte de la bibliothèque s\'ouvre lentement.',
0, 'neutre'),
 
(10, 'Le Premier Cours — Salle Élémentaire',
'La salle d\'élémentarité est spectaculaire : un amphithéâtre circulaire dont le centre est une arène de sable où se manifestent les sorts. Quarante nouveaux étudiants sont assis en arc de cercle, silencieux et intimidés. Le professeur Aldric — un homme jeune aux manières précises — tourne autour de l\'arène comme un prédateur.
 
"L\'affinité élémentaire n\'est pas un choix," déclare-t-il. "C\'est une nature. Mais la nature peut être cultivée ou réprimée. Aujourd\'hui, nous allons découvrir la vôtre." Un par un, les étudiants sont appelés. Certains font jaillir des flammes, d\'autres de l\'eau, de la pierre, du vent. Quand vient votre tour, vous posez la main sur la pierre de test.
 
Deux éléments répondent simultanément — le Feu et l\'Eau, en parfaite opposition. Le professeur Aldric écarquille les yeux. "Extraordinaire. Un Dualiste. Cela n\'arrive qu\'une fois par génération." La salle murmure. "Vous devrez choisir votre voie principale — les deux en même temps, c\'est... instable."',
0, 'neutre'),
 
-- ============================================================
-- ACTE II — LES ÉPREUVES (scènes 11 à 25)
-- ============================================================
 
(11, 'La Tour Nord — Escalier des Ombres',
'La Tour Nord est interdite aux étudiants, mais la lettre de mission du directeur vous donne un laissez-passer. L\'escalier en colimaçon est plongé dans le noir — vos sorts de lumière s\'éteignent après quelques marches, absorbés par quelque chose dans les murs. Vous montez à tâtons.
 
Au troisième palier, vous entendez des voix. Deux individus en robes noires discutent à voix basse. "L\'Orbe est en sécurité à l\'étage. Les gardes de Morwen ne savent pas encore que nous l\'avons." Pause. "Et le rituel ?" "Dans trois semaines. L\'Éclipse suffira." Ils descendent vers vous — vous avez deux secondes pour réagir.',
0, 'neutre'),
 
(12, 'Le Pacte Démoniaque',
'Vous avez posé la main sur la surface du miroir. Le verre est froid comme la mort, puis brûlant, puis votre main traverse la surface comme dans de l\'eau. L\'entité vous saisit le poignet — vous ne pouvez plus reculer.
 
Le pacte est instantané : une douleur fulgurate dans le sternum, un flash de lumière noire, et soudain vous voyez le monde différemment. Les flux magiques apparaissent comme des rivières lumineuses. Vous ressentez une puissance nouvelle, étrange, qui n\'est pas la vôtre.
 
Mais le miroir est vide. L\'entité a disparu. Et depuis les jardins en bas, vous entendez hurler quelqu\'un.',
0, 'neutre'),
 
(13, 'L\'Épreuve des Valeurs',
'Vous reculez d\'un pas, puis d\'un autre. L\'entité dans le miroir gronde, pousse, supplie, menace — tout à la fois. Mais vous tenez bon. Vous fermez les yeux, cherchez dans votre mémoire le sort de scellement que vous avez lu en passant dans la bibliothèque, et tracez les runes dans l\'air d\'une main ferme.
 
Un flash blanc. Le miroir se fissure du haut en bas, puis les morceaux tombent et se réduisent en poussière dorée. Dans le silence qui suit, quelqu\'un applaudit lentement derrière vous.
 
C\'est le Directeur Morwen. "Je vous observais depuis le couloir," dit-il. "Ce miroir est en réalité le Test du Miroir de Valdris — une épreuve imposée à tous les vrais étudiants. Neuf sur dix cèdent." Il vous tend une médaille d\'honneur en argent. "Vous venez de rejoindre l\'élite."',
0, 'neutre'),
 
(14, 'La Salle du Conseil Convoqué',
'Deux maîtres en robes bordeaux vous escortent jusqu\'à la Salle du Grand Conseil — une pièce en demi-cercle où quinze fauteuils hauts sont disposés face à une tribune. Plusieurs maîtres sont déjà là, certains dans des conversations à voix basse qui s\'interrompent à votre entrée.
 
Vous reconnaissez deux visages : le professeur Aldric à droite, l\'air grave, et une femme aux cheveux blancs que vous n\'avez jamais vue, dont le regard vous transperce depuis le fauteuil central. C\'est la Maîtresse Suprême, Yrenne Sol — la véritable autorité de l\'Académie, au-dessus même du directeur.
 
"Racontez-nous exactement ce que vous avez lu," dit-elle sans préambule. Sa voix est douce mais absolue. "Ne supprimez aucun détail."',
0, 'neutre'),
 
(15, 'La Voie du Feu',
'Vous choisissez le Feu. La décision est viscérale, immédiate — comme si la flamme en vous avait attendu qu\'on lui donne la permission. Dès lors, votre progression en magie du feu est foudroyante. En deux semaines, vous maîtrisez des sorts qu\'il faut normalement des mois pour apprendre.
 
Mais le feu a un prix. Vous dormez mal. Des rêves de brasier, de cités en cendres, d\'un phénix qui vous dévore de l\'intérieur. Le professeur Aldric vous convoque. "Votre puissance est réelle," dit-il, "mais vous la laissez vous consumer. La flamme doit être dirigée, pas libérée." Il vous remet un parchemin runique — un exercice de canalisation. "Maîtrisez ceci avant l\'épreuve de la semaine prochaine. Votre vie en dépendra peut-être."',
0, 'neutre'),
 
(16, 'La Voie de l\'Eau',
'Vous choisissez l\'Eau. La puissance vient différemment — pas comme une explosion, mais comme une marée. Lente, patiente, inévitable. En une semaine vous guérissez une blessure que les meilleurs guérisseurs de l\'Académie avaient déclarée incurable chez un vieux mage. La rumeur se répand.
 
Elara vous retrouve à la bibliothèque ce soir-là. "Tu as soigné Professeur Fenwick ?" Elle semble stupéfaite. "Même le directeur n\'y était pas arrivé. Écoute — j\'ai besoin de toi cette nuit. Pas pour combattre. Pour soigner les victimes de ce qui va se passer dans l\'aile est." Elle pose une main sur votre bras. "Fais-moi confiance."',
0, 'neutre'),
 
(17, 'L\'Embuscade au Troisième Palier',
'Vous plongez dans l\'ombre du renfoncement juste à temps. Les deux silhouettes passent à un mètre de vous sans vous voir. Leurs robes portent un symbole brodé — un cercle vide, comme un soleil éteint.
 
Vous attendez trente secondes, puis montez. Quatrième palier : une pièce circulaire, des runes sur les murs, et au centre, sur un piédestal d\'obsidienne, l\'Orbe de Lumière de Valdris. Il pulse doucement, chaud et blanc comme une étoile captive.
 
Mais la porte de l\'escalier se referme derrière vous avec un déclic. Et depuis les ombres du fond de la pièce, une troisième silhouette se dresse — plus grande que les deux autres, tenant un bâton de bois noir.',
0, 'neutre'),
 
(18, 'Confrontation avec le Gardien Masqué',
'Le gardien masqué vous attaque sans un mot. Son bâton trace des arcs de lumière noire dans l\'air. Vous esquivez, ripostez. Le combat est brutal, rapide, sans règles. Vos sorts du feu illuminent la pièce comme un orage.',
0, 'neutre'),
 
(19, 'Ruse et Illusion',
'Vous utilisez le sort "Double" appris dans l\'atelier. Votre copie illusoire s\'avance vers le gardien, attirant son attention. Dans sa confusion d\'une seconde, vous plongez, attraper l\'Orbe sur le piédestal, et bondissez vers la fenêtre.',
0, 'neutre'),
 
(20, 'La Nuit de l\'Aile Est',
'Elara vous conduit à travers des passages dérobés que vous n\'auriez jamais trouvés seul. L\'aile est de l\'Académie est officiellement fermée pour "restauration", mais derrière les portes condamnées, vous entendez des chants — une mélodie grave et rythmée qui fait vibrer les pierres sous vos pieds.
 
Par une lucarne, vous observez : une vingtaine de personnes en robes noires forment un cercle autour d\'une fissure dans le sol qui émet une lumière violette. Parmi elles, vous reconnaissez deux professeurs — dont l\'un est censé être en mission à l\'étranger.
 
"La Confrérie du Vide," murmure Elara. "Ils ouvrent un portail. Pas encore assez large pour qu\'ils passent — mais dans trois semaines..." Elle marque une pause. "Ce soir ils vont sacrifier quelque chose pour sceller leur engagement. Nous devons les arrêter. Mais nous sommes deux."',
0, 'neutre'),
 
(21, 'L\'Alliance avec Elara',
'Vous et Elara travaillez vite. Elle maîtrise la magie du vent, vous le feu ou l\'eau — ensemble, vous êtes complémentaires. Elle improvise un plan : elle distrait les gardes extérieurs en créant un incident dans le couloir d\'en face, vous entrez par la lucarne et détruisez le nœud central du rituel — la pierre de focus posée au centre du cercle.',
0, 'neutre'),
 
(22, 'Chercher du Renfort',
'Vous reculez et optez pour alerter le directeur. Cela prend du temps — trop de temps. Quand Morwen arrive avec quatre gardes, la cérémonie est terminée. Les membres de la Confrérie ont disparu. La fissure violette dans le sol est là, refermée mais pas guérie.',
0, 'neutre'),
 
(23, 'Le Traité de Combat Magique',
'Le livre rouge est un traité militaire : "Arts Cinétiques Avancés — Usage Offensif de la Magie de Combat". Vous le lisez en deux nuits, absorbant des techniques que même les étudiants de troisième année ignorent. Vos réflexes magiques s\'aiguisent. Votre force de frappe double.
 
Mais lors d\'un exercice pratique, vous perdez momentanément le contrôle. Un sort frappe un mur avec une force qui fait trembler le bâtiment entier. Le professeur Aldric, qui passait par là, vous regarde avec un mélange d\'alarme et d\'intérêt. "Où avez-vous appris ce sort ?" Vous avez le choix de mentir ou de dire la vérité.',
0, 'neutre'),
 
(24, 'La Vérité sur le Traité',
'"Dans la bibliothèque secrète — le Professeur Drast m\'y a conduit," répondez-vous franchement.
 
Aldric vous fixe un long moment, puis : "Bien. L\'honnêteté mérite sa récompense." Il vous emmène dans son bureau personnel et vous montre quelque chose d\'inattendu : une carte de l\'Académie avec plusieurs points marqués en rouge. "Depuis trois semaines, des incidents magiques anormaux se produisent à ces endroits. Je cherche quelqu\'un de discret et de capable pour enquêter. Êtes-vous intéressé ?"',
0, 'neutre'),
 
(25, 'Le Mensonge sur le Traité',
'"Je l\'ai trouvé dans les dortoirs, abandonné par un étudiant." Le mensonge sort facilement, peut-être trop.
 
Aldric hoche la tête lentement, et vous avez la troublante sensation qu\'il ne vous croit pas. Il confisque votre traité sans commentaire et vous renvoie. Mais deux jours plus tard, vous trouvez dans votre chambre une note non signée : "Je sais ce que tu as lu. Je sais où tu l\'as trouvé. Rejoins-nous, ou crains-nous. — C.V."
 
C.V. Confrérie du Vide.',
0, 'neutre'),
 
-- ============================================================
-- ACTE III — LE DANGER RÉVÉLÉ (scènes 26 à 40)
-- ============================================================
 
(26, 'La Révélation Devant le Conseil',
'Vous récitez tout ce que vous avez lu dans le journal de Serafina Vael. La salle du conseil devient de plus en plus silencieuse à mesure que vous parlez. Certains maîtres se raidissent, d\'autres blêmissent.
 
Quand vous terminez, la Maîtresse Suprême Yrenne Sol reste immobile pendant trente secondes entières. "Montrez-moi ce journal." Vous le tendez. Elle le feuillette rapidement, s\'arrête sur plusieurs pages. Puis elle relève les yeux — mais pas vers vous. Vers deux des maîtres assis dans les fauteuils. "Professeur Cassin. Professeur Wyrd. Sortez de cette salle immédiatement."
 
Les deux hommes se lèvent comme des automates. Puis l\'un d\'eux lève la main et lance un sort.',
0, 'neutre'),
 
(27, 'La Bataille dans la Salle du Conseil',
'Le sort du Professeur Cassin fracasse le lustre central. La salle plonge dans le chaos. Les maîtres loyaux ripostent. Des éclairs magiques traversent la pièce. Vous êtes au milieu de tout ça.
 
Yrenne Sol déploie un bouclier d\'une puissance que vous n\'avez jamais vue — une sphère d\'énergie dorée qui absorbe deux sorts simultanément. "Protégez les archives !" crie-t-elle. Vous voyez la porte des archives s\'ouvrir — et l\'un des maîtres traîtres s\'y précipiter.',
0, 'neutre'),
 
(28, 'Poursuite du Traître',
'Vous vous élancez après le Professeur Wyrd. Il est rapide pour son âge — il court dans les couloirs en lançant des sorts derrière lui pour vous ralentir. Un mur s\'effondre à vôtre gauche. Une porte se soude. Vous ripostez et gagnez du terrain.',
0, 'neutre'),
 
(29, 'Protéger la Maîtresse Suprême',
'Vous choisissez de rester aux côtés d\'Yrenne Sol pendant que les traîtres tentent de la submerger. Votre magie combinée à la sienne crée un effet inattendu : vos flammes et son invocation de lumière fusionnent en un torrent de feu solaire qui neutralise les deux maîtres traîtres d\'un seul arc.
 
Quand la poussière retombe, Sol pose une main sur votre épaule. "Votre instinct est bon. Vous avez choisi les personnes plutôt que les documents." Elle marque une pause. "C\'est plus rare qu\'on ne le croit."',
0, 'neutre'),
 
(30, 'L\'Investigation avec Aldric',
'Vous acceptez la mission d\'enquête proposée par le Professeur Aldric. Les points rouges sur sa carte correspondent à des lieux précis : la cave à charbon, la fontaine nord-est, le grenier de la Tour Centrale, et la crypte sous la chapelle — un endroit dont vous ne soupçonniez pas l\'existence.
 
En trois jours d\'investigation discrète, vous reconstituez un schéma. Les incidents ne sont pas des accidents : ce sont des balises magiques, disposées en pentagramme. Quelqu\'un prépare un rituel d\'une envergure considérable. Et le point central du pentagramme — l\'épicentre du rituel — se situe exactement sous la Salle du Grand Conseil.',
0, 'neutre'),
 
(31, 'La Note de la Confrérie',
'La note de la Confrérie du Vide vous hante. Vous avez deux jours avant qu\'ils contactent à nouveau, selon ce que vous déduisez de leur message. Vous choisissez d\'utiliser ce temps pour préparer soit une fuite, soit un piège.',
0, 'neutre'),
 
(32, 'Tendre un Piège à la Confrérie',
'Vous falsifiez une réponse à la note, acceptant soi-disant de les rejoindre. Le lieu de rendez-vous qu\'ils fixent — une ancienne salle de cours désaffectée — devient votre terrain. Vous y installez des runes d\'alarme et alertez discrètement Elara.',
0, 'neutre'),
 
(33, 'L\'Orbe Récupéré — Retour au Directeur',
'L\'Orbe de Lumière de Valdris entre vos mains est une expérience étrange : il semble vous connaître. Il pulse au rythme de votre cœur, et projette des images fugaces — des fragments de mémoire qui ne sont pas les vôtres. Quelqu\'un d\'autre l\'a tenu longtemps avant vous.
 
Vous descendez la tour et vous rendez directement au bureau du directeur. Morwen accueille l\'Orbe avec un soulagement manifeste. "Savez-vous ce qu\'est cet objet réellement ?" dit-il en le posant dans un coffret spécial. "C\'est une clé. La clé d\'un verrou que nous espérons ne jamais avoir à utiliser." Il vous regarde. "Et vous l\'avez traversé deux étages de gardes ennemis pour me le rapporter. Je vous dois des explications."',
0, 'neutre'),
 
(34, 'Les Explications de Morwen',
'Assis en face du directeur, vous apprenez l\'existence de la Confrérie du Vide — une société secrète fondée il y a cent ans par d\'anciens maîtres qui croyaient que la magie devait être libérée de toute contrainte éthique. Dispersée et écrasée à plusieurs reprises, elle renaît toujours.
 
"Depuis trois ans, ils s\'infiltrent à nouveau," dit Morwen. "J\'ai des soupçons mais pas de preuves. Ce que vous m\'avez rapporté change la donne." Il se lève. "Vous avez fait plus en une journée que mon service de renseignement en six mois. Que voulez-vous en échange ?"',
0, 'neutre'),
 
(35, 'La Nuit du Rituel — Avec Elara',
'Le plan d\'Elara est audacieux au bord de l\'imprudence. Vous entrez par la lucarne. En bas, le cercle est en plein rituel — les chants résonnent, la fissure violette s\'élargit lentement. La pierre de focus, un cristal noir de la taille d\'un poing, est au centre.
 
Vous n\'avez que quelques secondes avant d\'être repéré.',
0, 'neutre'),
 
(36, 'Détruire la Pierre de Focus',
'Vous plongez. Le vent créé par Elara dans le couloir fait irruption par une fenêtre, dispersant les membres du cercle. Dans la confusion, vous bondissez, attraper la pierre, et concentrez tout ce que vous avez — feu, eau, ou les deux — sur le cristal noir.
 
La pierre explose. Une onde de choc magique traverse la pièce. La fissure violette se referme dans un son comme un hurlement. Plusieurs membres de la Confrérie s\'effondrent, étordis. Deux s\'enfuient.
 
Elara est à vos côtés une seconde plus tard. "On a réussi." Elle sourit pour la première fois depuis votre rencontre. Puis, plus sombrement : "Mais ils reviendront. Ce n\'était qu\'un avant-poste."',
0, 'neutre'),
 
(37, 'Intervention Tardive',
'Quand Morwen et ses gardes arrivent, le rituel est interrompu par votre irruption non planifiée — vous avez foncé sans attendre, poussé par un instinct. La Confrérie se disperse. La fissure se referme partiellement, mais pas complètement.
 
Le directeur vous regarde au milieu du chaos. "Vous n\'avez pas attendu," dit-il. Ce n\'est pas un reproche. C\'est un constat.',
0, 'neutre'),
 
(38, 'Le Rendez-Vous Piégé',
'Trois membres de la Confrérie arrivent au rendez-vous. Ils sont méfiants — l\'un d\'eux scanne la salle avant d\'entrer. Votre rune d\'alarme les avertit de sa présence avant qu\'elle ne se déclenche. Ils s\'apprêtent à fuir.
 
Elara, cachée derrière la porte, agit en premier.',
0, 'neutre'),
 
(39, 'Un Maître Parmi les Traîtres',
'Parmi les trois membres capturés se trouve le Professeur Cassin — votre professeur de Théorie Magique. Celui qui, la semaine dernière, vous complimentait sur votre travail écrit.
 
Il vous regarde sans émotion. "Vous êtes plus perspicace que la plupart," dit-il. "Cela fait de vous soit un allié précieux, soit un danger. La Confrérie n\'a pas de place pour les dangers."
 
Un garde lui pose les menottes runiques. Mais pendant qu\'on l\'emmène, il murmure quelque chose que vous seul entendez : "Regardez ce que Morwen cache dans la crypte. Puis jugez qui sont les vrais traîtres."',
0, 'neutre'),
 
(40, 'La Crypte sous la Chapelle',
'Vous ne pouvez pas ne pas y aller. La crypte est accessible par une trappe sous l\'autel de la chapelle. En descendant, vous découvrez non pas des tombes, mais un laboratoire souterrain. Des machines magiques, des diagrammes complexes, et au centre : un second Orbe de Lumière, identique à celui que vous avez rapporté, mais d\'une lumière rouge sang.
 
Et le directeur Morwen est là, qui vous regarde entrer comme s\'il vous attendait. "J\'espérais que Cassin ne vous parlerait pas," dit-il calmement. "Mais puisque vous êtes là... il est temps que vous connaissiez la vérité complète."',
0, 'neutre'),
 
-- ============================================================
-- ACTE IV — LA CONFRONTATION (scènes 41 à 55)
-- ============================================================
 
(41, 'La Vérité du Directeur',
'"La Confrérie du Vide cherche à ouvrir un portail pour laisser entrer quelque chose," dit Morwen. "Moi, je cherche à construire une barrière pour que ça ne se reproduise jamais." Il désigne l\'Orbe rouge. "Les deux Orbes ensemble forment une clé et un verrou. L\'un ouvre la brèche dimensionnelle. L\'autre peut la sceller définitivement — au prix de sa destruction."
 
Il s\'approche. "La Confrérie veut l\'Orbe doré pour ouvrir. Je garde l\'Orbe rouge pour sceller. Mais je ne peux pas agir seul — le rituel de scellement demande deux participants." Il s\'arrête. "Vous êtes arrivé ici par hasard, ou peut-être pas. Aidez-moi à terminer ce que j\'ai commencé il y a vingt ans."',
0, 'neutre'),
 
(42, 'Faire Confiance à Morwen',
'Vous acceptez. Morwen vous explique tout : la Confrérie prépare l\'Éclipse Magique dans six jours — la seule fenêtre pendant laquelle le portail peut être ouvert assez largement. Votre rôle sera de maintenir l\'Orbe doré stable pendant qu\'il actionne l\'Orbe rouge pour sceller définitivement la brèche sous l\'Académie.
 
"Le rituel de scellement consumera l\'Orbe rouge," prévient-il. "Et il est possible que cela me consume aussi. Je suis lié à cet Orbe depuis vingt ans." Sa voix ne tremble pas. "C\'est un risque que j\'accepte."',
0, 'neutre'),
 
(43, 'Douter de Morwen',
'Quelque chose dans l\'explication de Morwen ne colle pas. Pourquoi mener cette opération seul depuis vingt ans ? Pourquoi ne pas avoir alerté la Maîtresse Suprême ? Vous posez ces questions directement.
 
Morwen hésite — un infime battement d\'ailes. Puis il répond, et sa réponse est trop lisse, trop préparée. Vous n\'êtes pas convaincu. Vous prenez la décision de chercher Yrenne Sol avant d\'aller plus loin.',
0, 'neutre'),
 
(44, 'Trouver Yrenne Sol',
'La Maîtresse Suprême est dans ses appartements, encore éveillée malgré l\'heure tardive. Elle écoute votre récit sans vous interrompre. Quand vous terminez, elle ferme les yeux quelques secondes.
 
"Aldric Morwen est loyal," dit-elle finalement. "Mais il est seul depuis trop longtemps. Il a peur que je refuse le sacrifice — et il a peut-être raison de le craindre, car je n\'aurais pas laissé un étudiant de première année prendre ce risque." Elle se lève. "Allez lui dire que je viens. Nous ferons le rituel ensemble, comme il aurait dû se faire depuis le début."',
0, 'neutre'),
 
(45, 'La Nuit de l\'Éclipse — Acte Final',
'L\'Éclipse Magique commence à minuit. Le ciel au-dessus de l\'Académie prend une teinte violacée, les étoiles disparaissent derrière un voile invisible. Sous la Salle du Grand Conseil, la brèche commence à s\'ouvrir — la Confrérie du Vide a infiltré les fondations depuis des semaines.
 
Dans la crypte, vous vous tenez avec Morwen, Sol, et Elara. Les deux Orbes sont posés sur leurs piédestaux respectifs, face à face. Dehors, on entend des combats — les gardes loyaux contre les membres de la Confrérie qui ont déclenché leur assaut final.
 
Morwen pose les mains sur l\'Orbe rouge. Sol pose les siennes sur l\'Orbe doré. Ils vous regardent — vous et Elara — pour tenir le cercle de stabilisation. Le rituel commence.',
0, 'neutre'),
 
(46, 'Tenir le Cercle',
'Le rituel est une bataille en lui-même. Des ondes d\'énergie opposées se heurtent à travers vous. Vos os semblent vibrer. Elara est à vos côtés, pâle mais déterminée. Les deux Orbes pulsent de plus en plus vite.
 
Et puis la Confrérie enfonce la porte de la crypte.',
0, 'neutre'),
 
(47, 'Le Dernier Assaut',
'Cinq membres de la Confrérie — dont certains que vous reconnaissez — font irruption. Ils ont compris le plan. Ils veulent l\'Orbe doré avant le scellement.
 
Vous devez choisir : lâcher le cercle de stabilisation pour combattre, ou tenir coûte que coûte.',
0, 'neutre'),
 
(48, 'Tenir le Cercle contre Tout',
'Vous tenez. Elara aussi. Les membres de la Confrérie vous frappent de sorts — vous encaissez, vous chancelez, mais vous ne lâchez pas. Votre vie s\'effrite. Mais le rituel avance.
 
Morwen et Sol sont en transe profonde. Leurs voix fusionnent en un chant que vous ne comprenez pas mais dont vous sentez la puissance résonner dans votre poitrine comme un second cœur.',
0, 'neutre'),
 
(49, 'Lâcher le Cercle pour Combattre',
'Vous lâchez et attaquez. Vos sorts explosent dans la crypte étroite. Deux membres de la Confrérie tombent. Mais sans vous, le cercle de stabilisation flanche — l\'énergie des deux Orbes se dérègle, créant un feedback magique qui fait saigner Morwen du nez.',
0, 'neutre'),
 
(50, 'La Brèche Résiste',
'Le rituel dure plus longtemps que prévu. La brèche ne veut pas se fermer — quelque chose de l\'autre côté pousse. Morwen tremble. Sol psalmodie plus fort. Vous sentez le sol craquer sous vous.',
0, 'neutre'),
 
(51, 'Donner le Reste de sa Magie',
'Dans un geste instinctif, vous orientez toute votre magie — pas vers la défense ou l\'attaque, mais vers le rituel lui-même. Vous devenez un conduit. L\'énergie vous traverse comme une rivière, de la tête aux pieds, brûlante et glacée à la fois.',
0, 'neutre'),
 
(52, 'La Brèche se Ferme',
'Un son comme la fin du monde. L\'Orbe rouge éclate en mille fragments lumineux. La brèche dimensionnelle se referme avec un bruit de porte claquée dans un palais vide.
 
Le silence.
 
Morwen est agenouillé, épuisé mais vivant. Sol, qui ne plie jamais, a les larmes aux yeux. Elara vous attrape avant que vous ne tombiez.',
0, 'neutre'),
 
(53, 'L\'Académie Sauvée, Mais À Quel Prix',
'Vous reprenez conscience dans l\'infirmerie, trois heures plus tard. Elara est là, assise à votre chevet. "Tu as tenu," dit-elle simplement.
 
Votre magie est... différente. Pas disparue, mais transformée. Le passage de l\'énergie des deux Orbes à travers vous a laissé une trace. Vous pouvez sentir les flux magiques d\'une façon nouvelle, comme si vous voyiez une couleur supplémentaire que les autres ne perçoivent pas.',
0, 'neutre'),
 
(54, 'Les Traîtres Jugés',
'Dans les jours qui suivent, la Confrérie du Vide est démantelée. Les membres capturés sont jugés par le Grand Conseil. Certains sont des professeurs de longue date — leur trahison secoue l\'Académie jusqu\'au fondations. Mais l\'institution tient.
 
Votre témoignage est crucial dans trois des procès. Le Professeur Cassin vous regarde pendant que vous témoignez. Son expression n\'est pas la haine — c\'est quelque chose de plus complexe. La résignation, peut-être.',
0, 'neutre'),
 
(55, 'Une Proposition Inattendue',
'Trois semaines après l\'Éclipse, Yrenne Sol vous convoque seule à seule. Elle vous offre deux choses : un poste d\'assistant de recherche — rare pour un étudiant de première année — et quelque chose de plus personnel. La possibilité de lire le reste du journal de Serafina Vael, dont elle garde la suite dans ses propres archives.
 
"Serafina était ma meilleure étudiante," dit-elle doucement. "Elle a sacrifié sa vie pour prévenir ce qui vient de se passer. Ce que vous avez fait... c\'est ce qu\'elle aurait voulu faire si elle en avait eu la chance." Elle vous tend les pages. "Lisez. Puis décidez de votre suite."',
0, 'neutre'),
 
-- ============================================================
-- FINS VICTOIRES (scènes 56 à 62) — longues et variées
-- ============================================================
 
(56, 'FIN VICTOIRE I — Le Champion de l\'Académie',
'🏆 VICTOIRE — "Le Champion de l\'Académie"
 
Trois mois ont passé depuis la nuit de l\'Éclipse Magique.
 
Le Grand Amphithéâtre de l\'Académie est comble pour la première fois depuis dix ans. Sur l\'estrade, le Directeur Morwen — remis de l\'épreuve du rituel, les tempes un peu plus grises mais le regard aussi acéré — présente la cérémonie annuelle des Distinctions. Vous êtes dans la rangée du premier rang, entre Elara et le Professeur Aldric, qui a refusé de s\'asseoir dans les fauteuils des maîtres pour cette occasion.
 
Quand Yrenne Sol prononce votre nom, la salle retient son souffle une demi-seconde, puis applaudit. Vous montez sur l\'estrade. La Médaille de l\'Académie — accordée pour la dernière fois il y a quarante-deux ans — est accrochée à votre veste par les mains de la Maîtresse Suprême elle-même.
 
"Ce n\'est pas pour la victoire du soir de l\'Éclipse," dit-elle dans le micro, pour que toute la salle entende. "C\'est pour ce que vous avez fait avant : chercher la vérité sans en avoir reçu l\'ordre, la partager sans en avoir tiré profit, et tenir quand tout vous encourageait à lâcher."
 
Après la cérémonie, Elara vous retrouve dans les jardins. "Alors, Champion de l\'Académie," dit-elle avec son demi-sourire habituel. "Tu comptes faire quoi de tout ça ?"
 
La réponse est simple : continuer. Il reste des mystères dans cette école. Le journal de Serafina suggère d\'autres secrets encore enfouis. L\'Orbe rouge a disparu lors de son explosion, mais l\'Orbe doré est intact — et selon les notes de Morwen, il existe peut-être un troisième Orbe quelque part au-delà des frontières de l\'empire.
 
Le soleil se couche sur les tours de cristal. Pour la première fois depuis votre arrivée, vous regardez ces tours non plus comme une destination, mais comme un point de départ.
 
Votre histoire à l\'Académie ne fait que commencer.',
1, 'victoire'),
 
(57, 'FIN VICTOIRE II — Le Sage des Valeurs',
'🏆 VICTOIRE — "Le Sage des Valeurs"
 
Six semaines après la nuit de l\'Éclipse.
 
Vous êtes dans la bibliothèque secrète — celle où le Professeur Drast vous avait conduit votre premier jour. Mais cette fois, vous y êtes seul, par invitation officielle. Drast est assis dans son fauteuil habituel, entouré de ses livres comme d\'une armure douce.
 
"Vous savez pourquoi j\'ai gardé cette bibliothèque secrète ?" dit-il sans préambule. "Pas pour protéger les livres. Pour protéger les lecteurs. Ces ouvrages testent les gens. Ils révèlent ce qu\'ils sont vraiment." Il vous regarde. "Vous avez refusé le démon dans le miroir. Vous avez refusé de rejoindre la Confrérie malgré la menace. Vous avez refusé de mentir devant le conseil."
 
Il se lève et prend un livre sur l\'étagère derrière lui — un volume simple, sans décoration. "Serafina Vael avait commencé à écrire un guide pour les futures générations. Elle n\'a jamais pu le terminer." Il vous tend le livre. Les premières pages sont écrites dans une main féminine soignée. Le reste est vide.
 
"La Maîtresse Sol pense que vous devriez le compléter," dit Drast simplement. "Pas maintenant — vous avez le temps. Mais un jour."
 
C\'est ainsi que vous comprenez ce que l\'Académie vous a vraiment appris : les sorts, les formules, les théories — tout ça s\'apprend dans les livres. Mais la sagesse, elle, ne s\'enseigne pas. Elle se forge, épreuve après épreuve, refus après refus, dans les moments où il serait si facile de faire le mauvais choix.
 
Vous ouvrez le livre vide et cherchez une plume.',
1, 'victoire'),
 
(58, 'FIN VICTOIRE III — Le Grand Guérisseur',
'🏆 VICTOIRE — "Le Grand Guérisseur"
 
Deux mois après la nuit de l\'Éclipse.
 
L\'infirmerie de l\'Académie n\'a jamais été aussi fréquentée. Le combat contre la Confrérie a laissé des blessures — physiques pour certains, magiques pour d\'autres. Vous passez vos après-midis libres ici, aux côtés de l\'Archiguérisseuse Maren, une femme silencieuse aux mains sûres.
 
"Tu as un don naturel," dit-elle un jour en vous regardant soigner la brûlure magique d\'un garde. "Mais ce n\'est pas juste la technique. C\'est l\'attention que tu portes aux gens. Tu regardes le patient, pas la blessure."
 
Ce soir-là, on vous apporte un cas que Maren considérait comme perdu : un jeune étudiant de deuxième année, victime d\'un sort de corruption porté par un membre de la Confrérie, dont la magie propre se retournait lentement contre lui. Les livres disaient que c\'était irréversible.
 
Vous passez quatre heures à travailler, en combinant ce que vous avez appris sur l\'eau — la guérison, la purification — avec une intuition que vous n\'auriez pas eue trois mois plus tôt. À l\'aube, l\'étudiant respire normalement.
 
Maren, dans l\'encadrement de la porte, vous regarde sans rien dire pendant un long moment. Puis : "Je vais recommander que vous suiviez le cursus de Magie Médicale en parallèle de votre formation principale. C\'est inhabituel en première année." Elle marque une pause. "Beaucoup de choses semblent vous réussir mal en première année."
 
C\'est une blague. Vous ne l\'auriez pas compris à votre arrivée.
 
Dehors, l\'Académie se réveille sous un ciel clair. Quelqu\'un a planté des fleurs nouvelles dans les jardins. Vous ne savez pas qui. Vous décidez que ça n\'a pas d\'importance.',
1, 'victoire'),
 
(59, 'FIN VICTOIRE IV — L\'Enquêteur de l\'Ombre',
'🏆 VICTOIRE — "L\'Enquêteur de l\'Ombre"
 
Cinq semaines après la nuit de l\'Éclipse.
 
Le Professeur Aldric vous remet officiellement un badge discret — une rune gravée sur un morceau de métal ordinaire, rien qui attirerait l\'attention. "Vous faites maintenant partie de la Cellule de Veille," dit-il. "Trois personnes dans toute l\'Académie ont ce badge. Vous, moi, et quelqu\'un d\'autre dont vous n\'avez pas besoin de savoir le nom pour l\'instant."
 
Votre rôle : continuer les enquêtes sur les anomalies magiques, identifier d\'éventuels membres résiduels de la Confrérie, et documenter toute activité suspecte. Concrètement, cela signifie que vous menez une double vie : étudiant le jour, enquêteur la nuit.
 
C\'est épuisant, exaltant, et parfois effrayant.
 
Trois semaines plus tard, vous identifiez un réseau de communication encodée utilisé par des membres de la Confrérie encore en fuite. Aldric présente vos découvertes au Grand Conseil. Deux arrestations suivent dans les jours qui viennent. Votre nom n\'est jamais mentionné dans les rapports officiels.
 
"C\'est le travail," dit Aldric quand vous lui faites remarquer que votre contribution disparaît dans l\'anonymat. "Les meilleurs enquêteurs sont ceux dont on n\'entend jamais parler." Il marque une pause. "Cela ne vous dérange pas ?"
 
Vous réfléchissez honnêtement. Non. Ce qui vous importe, c\'est que la fissure sous l\'Académie est fermée, que la Confrérie est affaiblie, et que les couloirs de cette école sont un peu plus sûrs qu\'ils ne l\'étaient il y a deux mois.
 
Vous avez accompli quelque chose de réel. Ça suffit — pour l\'instant.',
1, 'victoire'),
 
-- ============================================================
-- FINS DÉFAITES (scènes 60 à 65) — longues et variées
-- ============================================================
 
(60, 'FIN DÉFAITE I — La Défaite du Voleur',
'💀 DÉFAITE — "La Chute dans la Tour"
 
La confrontation avec le gardien masqué s\'est mal terminée. Ses sorts ont brisé vos défenses une à une, méthodiquement, sans haine — juste de l\'efficacité. L\'Orbe de Lumière vous a glissé des doigts quand vous avez perdu connaissance.
 
Vous vous réveillez dans l\'infirmerie. Deux côtes fissurées, une brûlure magique sur l\'avant-bras gauche. Dehors, la nuit est tombée. Elara est là, à votre chevet, mais son regard vous dit tout avant qu\'elle parle.
 
"L\'Orbe est parti. Ils ont quitté l\'Académie." Elle marque une pause. "Le directeur est au courant."
 
Morwen vient vous voir le lendemain matin. Il ne crie pas — c\'est presque pire. Il est calme, le regard vide d\'une quelconque surprise. "Je vous avais dit de récupérer l\'Orbe, pas d\'affronter ses gardiens seul," dit-il. "Ce sont deux choses différentes."
 
Votre dossier d\'admission est suspendu. Pendant trois semaines, vous suivez les cours sans statut officiel, dans une sorte de limbe administratif. Certains étudiants le savent. D\'autres, non. Le Professeur Aldric continue de vous enseigner normalement — c\'est peut-être votre seul ancrage.
 
Au bout de trois semaines, le Grand Conseil statue : vous restez, mais sans les crédits de ce trimestre. Vous repartez à zéro.
 
C\'est humiliant. C\'est juste. Et au fond, dans les moments de silence avant de vous endormir, vous repassez en boucle ce moment dans la tour où vous avez choisi le combat frontal alors qu\'il existait d\'autres options.
 
La leçon est amère. Elle restera.',
1, 'defaite'),
 
(61, 'FIN DÉFAITE II — Consumé par les Ténèbres',
'💀 DÉFAITE — "Le Prix du Pacte"
 
Le pouvoir du démon était réel. Vous l\'avez utilisé.
 
Les premiers jours, c\'était grisent. Vos sorts atteignaient une puissance que vos camarades mettaient des années à acquérir. Les professeurs vous regardaient avec une perplexité teintée d\'admiration. Vous faisiez semblant de ne rien remarquer d\'anormal.
 
Mais chaque nuit, il revenait. Pas dans le miroir — le miroir était brisé — mais dans vos rêves. L\'entité aux yeux de braise, qui vous rappelait doucement, patiemment, que rien n\'est gratuit.
 
La troisième semaine, vous avez perdu le contrôle pendant un cours. Un sort de feu, destiné à la cible de pratique, a dévié et incendié le bureau du Professeur Aldric. Personne n\'a été blessé, mais la violence de la déflagration — dix fois supérieure à ce que vous aviez voulu — a tout dit.
 
Aldric vous a regardé dans les yeux après. Longuement. "Ce n\'est pas vous qui avez fait ça," a-t-il dit doucement. Ce n\'était pas une question.
 
Le Professeur Drast a diagnostiqué la contamination démoniaque en vingt minutes de consultation. Le traitement existe, mais il est long et douloureux. Pendant six semaines, vous ne pouvez pas utiliser la magie. Vous restez à l\'Académie, mais confiné à des tâches non magiques — bibliothécaire assistant, aide aux cuisines, gardien de nuit.
 
C\'est dans cette période que vous comprenez réellement ce que vous aviez failli devenir. Et c\'est dans cette période aussi que vous rencontrez, à la bibliothèque, un livre sur les pactes démoniaques écrit par quelqu\'un qui avait traversé exactement ce que vous traversez.
 
Il s\'appelait Aldric Morwen. Quarante ans plus tôt.',
1, 'defaite'),
 
(62, 'FIN DÉFAITE III — Trahi et Banni',
'💀 DÉFAITE — "Le Mauvais Camp"
 
Vous avez rejoint la société secrète. Sur le moment, les arguments semblaient tenir : la Confrérie du Vide promettait une magie libérée de toute contrainte institutionnelle, un accès aux connaissances que l\'Académie censurait, et une fraternité entre ceux qui refusaient de se plier aux règles arbitraires des anciens.
 
Vous y avez cru pendant trois semaines.
 
La désillusion est venue progressivement. D\'abord : des tâches moralement troubles présentées comme des "épreuves d\'engagement". Puis : des ordres. Pas des suggestions — des ordres. Voler des documents dans le bureau d\'Aldric. Désactiver une rune de sécurité dans l\'aile est. Surveiller les allées et venues de la Maîtresse Suprême.
 
Quand vous avez refusé la troisième commande, ils ne vous ont pas menacé. Ils ont simplement utilisé ce que vous aviez déjà fait. Proof d\'implication, ont-ils dit. Une dénonciation anonyme est arrivée au bureau du directeur deux jours plus tard.
 
Le procès a duré une semaine. Vous avez dit la vérité — toute la vérité, y compris vos actes. Aldric a témoigné en votre faveur. Morwen est resté neutre. Sol a écouté sans expression.
 
Le verdict : exclusion temporaire de dix-huit mois et travaux d\'intérêt général pour l\'Académie. Pas d\'effacement de votre magie — c\'est une grâce, selon les standards habituels pour les affaires de cette nature.
 
Vous quittez l\'Académie par la porte principale, un matin gris de novembre. Le garde qui vous avait accueilli votre premier jour est là. Il vous regarde sans rien dire.
 
Dix-huit mois. Et la possibilité — pas la garantie, la possibilité — de recommencer.',
1, 'defaite'),
 
(63, 'FIN DÉFAITE IV — L\'Incendie de l\'Aile Est',
'💀 DÉFAITE — "La Flamme Incontrôlée"
 
Vous aviez choisi le Feu. Le Feu vous a choisi aussi — mais différemment.
 
L\'incident s\'est produit lors de l\'Épreuve de Maîtrise en fin de premier trimestre. Un exercice standard : contrôler une flamme pendant trente secondes, puis l\'éteindre. Vous l\'aviez fait des dizaines de fois en pratique privée.
 
Mais ce jour-là, la salle était pleine. Des dizaines de regards posés sur vous. Et quelque chose dans cette pression a déréglé quelque chose en vous. La flamme a grandi. Vous avez essayé de la contenir. Elle a grandi encore. Vous avez paniqué — et la panique est la pire ennemie du feu.
 
Le sortilège d\'extinction d\'urgence du Professeur Aldric a arrêté les dégâts avant que l\'incendie ne se propage au-delà de l\'aile est. Personne n\'a été grièvement blessé. Un étudiant a eu une brûlure au bras. L\'aile est est inutilisable pour trois mois.
 
Dans les jours qui suivent, vous découvrez progressivement l\'étendue de vos erreurs : vous n\'aviez pas suivi les exercices de canalisation qu\'Aldric vous avait donnés. Vous aviez préféré explorer la puissance brute au lieu de la discipliner. Et la nuit avant l\'épreuve, vous aviez lu encore un chapitre du traité de combat offensif au lieu de vous reposer.
 
L\'Académie ne vous exclut pas. Elle vous rétrograde. Vous suivez un programme de remédiation — un an de magie fondamentale, recommençant depuis le début, sous supervision constante.
 
C\'est long. C\'est humble. Et le professeur qui supervise votre remédiation est, ironiquement, le Professeur Aldric lui-même, qui ne vous reproche rien et qui recommence patiemment à vous enseigner ce que vous auriez dû écouter la première fois.',
1, 'defaite'),
 
(64, 'FIN DÉFAITE V — La Fuite',
'💀 DÉFAITE — "Ceux Qui Ne Tiennent Pas"
 
Vous avez fui.
 
Ce n\'est pas une décision que vous avez prise consciemment — c\'est une accumulation. La pression de la mission du directeur. La menace de la Confrérie. Le sentiment d\'être trop petit pour ce qui se passait autour de vous. Et un soir, votre sac était fait et vous étiez dans les jardins, glissant vers la porte secondaire comme vous étiez entré votre premier jour.
 
Personne ne vous a arrêté. Personne ne vous a couru après. Vous avez parcouru cinq kilomètres sur la route de terre avant de vous asseoir au bord d\'un fossé, seul dans le noir, avec l\'Académie visible en silhouette derrière vous, ses tours de cristal toujours lumineuses.
 
Vous avez réfléchi longtemps là, dans ce fossé.
 
Vous êtes rentré à l\'aube. La porte était encore ouverte. Un garde vous a regardé revenir sans un mot — juste un signe de tête.
 
Le directeur Morwen vous a reçu le lendemain matin. "Je sais que vous êtes parti," dit-il. "Et je sais que vous êtes revenu." Il ne vous a pas demandé pourquoi. "Rester demande du courage. Revenir en demande plus."
 
Votre statut à l\'Académie reste intact. Mais vous portez quelque chose de nouveau en vous — pas de la honte, exactement. Plutôt une connaissance précise de votre propre limite, et la conscience que vous l\'avez vue de près et que vous avez choisi de ne pas la franchir définitivement.
 
C\'est peut-être la leçon la plus importante que cette école vous ait apprise, même si elle ne figure dans aucun manuel.',
1, 'defaite'),
 
(65, 'FIN DÉFAITE VI — Le Rituel Brisé',
'💀 DÉFAITE — "La Brèche Ouverte"
 
Vous avez lâché le cercle de stabilisation pour combattre — et vous avez bien combattu. Deux membres de la Confrérie sont neutralisés grâce à vous. Mais sans le cercle complet, le rituel de scellement de Morwen et Sol a dérapé.
 
L\'Orbe rouge a explosé trop tôt. La brèche s\'est fermée partiellement — mais pas entièrement. Un fragment de l\'autre dimension est resté coincé dans les fondations de l\'Académie, comme un éclat de verre dans une plaie.
 
La situation n\'est pas catastrophique — pas encore. Mais l\'éclat dimensionnel irradie une énergie instable qui perturbe toute magie dans un rayon de cent mètres autour de la Tour Centrale. Plusieurs salles sont inutilisables. Les cours doivent être reorganisés. Et tous les six jours, à l\'exact moment de la prochaine mini-Éclipse, la perturbation s\'amplifie.
 
Morwen est vivant. Sol aussi. Mais tous deux savent — et vous savez — que votre choix dans la crypte a modifié l\'issue du rituel.
 
Personne ne vous le reproche publiquement. C\'est presque pire que des reproches : la politesse du silence.
 
Pendant les semaines qui suivent, vous travaillez avec une équipe de maîtres spécialistes des dimensions pour trouver comment extraire l\'éclat. C\'est votre façon de réparer ce qui a été brisé — pas par les paroles, mais par le travail.
 
L\'éclat sera extrait, un jour. Vous en avez fait la promesse, à personne en particulier, dans le silence de la crypte, les mains encore tremblantes d\'avoir lâché ce que vous auriez dû tenir.',
1, 'defaite');
 
-- ============================================================
-- DONNÉES : CHOIX
-- ============================================================
 
-- Depuis scène 1 — L'Arrivée
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(1, 2,  'Saluer poliment le garde et présenter votre lettre d\'admission avec courtoisie.', 0, 0, NULL),
(1, 3,  'Contourner discrètement le poste de garde par les jardins sur le côté.', 0, 2, 7),
(1, 4,  'Essayer de passer en force en jouant des coudes dans la foule.', -10, 0, NULL);
 
-- Depuis scène 2 — Hall des Premiers Pas
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(2, 5,  'Aider le vieux mage à retrouver son pendentif perdu — il semble très agité.', 5, 5, 4),
(2, 8,  'Consulter le tableau d\'affichage pour repérer une salle d\'étude isolée.', 0, 3, NULL),
(2, 6,  'Ignorer le mage et aller directement aux dortoirs vous installer.', 0, 0, NULL);
 
-- Depuis scène 3 — Jardins Secrets
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(3, 8,  'Ramasser le grimoire mystérieux et trouver un endroit pour l\'étudier.', 0, 8, 1),
(3, 6,  'Prendre la torche magique et rejoindre les dortoirs par l\'arrière.', 5, 0, 3);
 
-- Depuis scène 4 — Cellule de Détention
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(4, 7,  'S\'excuser sincèrement et expliquer votre motivation — vous vouliez juste entrer rapidement.', 0, 0, NULL),
(4, 60, 'Tenter de s\'échapper de la cellule par la force — vous n\'avez plus rien à perdre.', -25, 0, NULL);
 
-- Depuis scène 5 — Bibliothèque Secrète
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(5, 9,  'Ouvrir le journal sans nom dont les pages semblent changer de texte.', 0, 5, NULL),
(5, 23, 'Prendre le traité de combat magique relié de rouge.', 0, 12, 10),
(5, 6,  'Refermer les livres et aller vous préparer pour les cours.', 5, 0, 3);
 
-- Depuis scène 6 — Dortoirs
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(6, 10, 'Accepter la potion d\'Elara et se rendre au premier cours de magie élémentaire.', 10, 0, NULL),
(6, 20, 'Suivre Elara discrètement pour découvrir ce qu\'elle sait sur l\'aile est.', 0, 5, NULL);
 
-- Depuis scène 7 — Bureau du Directeur
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(7, 11, 'Accepter la mission et partir immédiatement vers la tour nord.', 0, 5, 1),
(7, 60, 'Refuser la mission — vous n\'êtes qu\'en première année, c\'est trop dangereux.', 0, 0, NULL);
 
-- Depuis scène 8 — Atelier des Illusions
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(8, 12, 'Accepter le marché de l\'entité — le pouvoir offert est immense.', -15, 15, 6),
(8, 13, 'Refuser fermement et tenter de sceller le miroir avec les runes que vous avez lues.', 10, 0, NULL);
 
-- Depuis scène 9 — Prophétie du Grimoire
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(9, 14, 'Aller immédiatement révéler la conspiration devant le Grand Conseil.', 0, 5, NULL),
(9, 6,  'Garder le journal et le secret pour l\'instant — observer avant d\'agir.', 5, 0, NULL);
 
-- Depuis scène 10 — Premier Cours
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(10, 15, 'Choisir l\'élément Feu — la puissance immédiate vous attire.', 0, 15, 1),
(10, 16, 'Choisir l\'élément Eau — la guérison et la protection sont votre nature.', 20, 0, 2);
 
-- Depuis scène 11 — Tour Nord
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(11, 17, 'Se plaquer contre le mur et laisser les deux silhouettes passer sans vous voir.', 0, 0, NULL),
(11, 18, 'Vous retourner et dévaler l\'escalier — tenter de semer les deux inconnus.', -5, 3, NULL);
 
-- Depuis scène 12 — Pacte Démoniaque
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(12, 61, 'Utiliser le pouvoir du démon sans restriction pour dominer vos adversaires.', -20, 0, NULL),
(12, 14, 'Résister à la corruption et alerter immédiatement le Grand Conseil.', 5, 0, NULL);
 
-- Depuis scène 13 — Épreuve des Valeurs
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(13, 55, 'Accepter la médaille d\'honneur avec modestie et gratitude.', 10, 5, 15),
(13, 30, 'Demander à rejoindre l\'équipe d\'enquête du Professeur Aldric.', 0, 10, NULL);
 
-- Depuis scène 14 — Salle du Conseil Convoqué
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(14, 26, 'Tout révéler en détail devant le Grand Conseil.', 0, 5, NULL),
(14, 62, 'Taire une partie de la vérité pour protéger ceux qui vous ont aidé.', 0, 0, NULL);
 
-- Depuis scène 15 — Voie du Feu
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(15, 23, 'Chercher à augmenter votre puissance en lisant le traité de combat magique.', 0, 10, NULL),
(15, 30, 'Suivre les conseils d\'Aldric et pratiquer la canalisation disciplinée.', 5, 5, 10);
 
-- Depuis scène 16 — Voie de l\'Eau
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(16, 20, 'Suivre Elara dans l\'aile est pour soigner d\'éventuelles victimes.', 5, 0, 3),
(16, 55, 'Vous concentrer sur votre formation et repousser les dangereuses propositions d\'Elara.', 10, 5, NULL);
 
-- Depuis scène 17 — Embuscade au Troisième Palier
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(17, 19, 'Monter rapidement au quatrième palier pendant qu\'ils sont encore dans l\'escalier.', 0, 5, NULL),
(17, 18, 'Suivre les deux silhouettes à distance pour connaître leur destination.', -5, 0, NULL);
 
-- Depuis scène 18 — Confrontation avec le Gardien
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(18, 33, 'Combattre le gardien masqué de front — votre force vous permettra de vaincre.', -15, 0, 8),
(18, 60, 'Fuir devant sa puissance — vous êtes trop inexpérimenté pour ce combat.', -5, 0, NULL);
 
-- Depuis scène 19 — Ruse et Illusion
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(19, 33, 'Bondir par la fenêtre avec l\'Orbe et rejoindre le directeur immédiatement.', -5, 0, 8),
(19, 60, 'Hésiter une seconde de trop — le gardien perce votre illusion.', -20, 0, NULL);
 
-- Depuis scène 20 — Nuit de l\'Aile Est
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(20, 21, 'Accepter le plan d\'Elara et agir cette nuit même.', 0, 5, NULL),
(20, 22, 'Refuser d\'agir seul et insister pour aller chercher du renfort auprès de Morwen.', 0, 0, NULL);
 
-- Depuis scène 21 — Alliance avec Elara
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(21, 35, 'Suivre le plan et vous faufiler dans la pièce par la lucarne.', 0, 5, NULL),
(21, 37, 'Improviser un plan différent — attaquer par la porte principale.', -10, 0, NULL);
 
-- Depuis scène 22 — Chercher du Renfort
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(22, 37, 'Accompagner Morwen et ses gardes dans l\'aile est.', 0, 5, NULL),
(22, 6,  'Rester en arrière — la situation est trop dangereuse pour un premier-an.', 5, 0, NULL);
 
-- Depuis scène 23 — Traité de Combat
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(23, 24, 'Dire la vérité à Aldric sur la provenance du traité.', 0, 5, NULL),
(23, 25, 'Mentir sur la provenance — prétendre avoir trouvé le traité dans les dortoirs.', 0, 0, NULL);
 
-- Depuis scène 24 — Vérité sur le Traité
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(24, 30, 'Accepter la mission d\'enquête proposée par Aldric.', 0, 8, 12),
(24, 20, 'Décliner la mission mais partager vos informations avec Elara à la place.', 5, 0, NULL);
 
-- Depuis scène 25 — Mensonge sur le Traité
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(25, 32, 'Préparer un piège pour identifier ceux qui vous ont envoyé cette note menaçante.', 0, 8, NULL),
(25, 64, 'Fuir l\'Académie cette nuit même — la Confrérie vous a dans le collimateur.', 0, 0, NULL);
 
-- Depuis scène 26 — Révélation devant le Conseil
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(26, 27, 'Rester dans la salle et combattre aux côtés des maîtres loyaux.', -5, 5, NULL),
(26, 28, 'Poursuivre le Professeur Wyrd dans les archives.', 0, 5, NULL);
 
-- Depuis scène 27 — Bataille dans la Salle du Conseil
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(27, 28, 'Courir après le maître traître qui s\'est précipité vers les archives.', -5, 5, NULL),
(27, 29, 'Rester et protéger la Maîtresse Suprême qui est sous pression.', 5, 5, 9);
 
-- Depuis scène 28 — Poursuite du Traître
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(28, 40, 'Capturer Wyrd et lui faire révéler ce que Morwen cache dans la crypte.', -10, 0, NULL),
(28, 29, 'Abandonner la poursuite et revenir protéger Sol qui est seule.', 0, 0, NULL);
 
-- Depuis scène 29 — Protéger la Maîtresse Suprême
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(29, 41, 'Accompagner Sol dans la crypte qu\'elle veut inspecter immédiatement.', 5, 5, NULL),
(29, 55, 'Rester en surface et coordonner l\'arrestation des membres de la Confrérie.', 10, 0, 15);
 
-- Depuis scène 30 — Investigation avec Aldric
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(30, 40, 'Inspecter la crypte sous la chapelle — le point central du pentagramme.', 0, 5, NULL),
(30, 26, 'Porter vos découvertes directement au Grand Conseil.', 0, 5, NULL);
 
-- Depuis scène 31 — Note de la Confrérie
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(31, 32, 'Tendre un piège à ceux qui vous ont envoyé cette note.', 0, 8, NULL),
(31, 64, 'Fuir l\'Académie cette nuit — votre vie est en danger.', 0, 0, NULL);
 
-- Depuis scène 32 — Piège à la Confrérie
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(32, 38, 'Se rendre au rendez-vous piégé et capturer les membres de la Confrérie.', -5, 5, NULL),
(32, 26, 'Annuler le piège et alerter le Grand Conseil à la place.', 0, 0, NULL);
 
-- Depuis scène 33 — Orbe Récupéré
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(33, 34, 'Demander au directeur les explications qu\'il vous doit.', 0, 5, NULL),
(33, 40, 'Accepter ses remerciements mais enquêter seul sur la crypte que vous avez entendu mentionner.', 0, 8, NULL);
 
-- Depuis scène 34 — Explications de Morwen
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(34, 41, 'Demander à Morwen de vous montrer la crypte et les deux Orbes.', 0, 5, NULL),
(34, 43, 'Chercher à vérifier indépendamment ce que Morwen vous a dit avant de lui faire confiance.', 5, 0, NULL);
 
-- Depuis scène 35 — Nuit du Rituel avec Elara
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(35, 36, 'Plonger et saisir la pierre de focus au centre du cercle rituel.', -10, 5, NULL),
(35, 22, 'Reculer et aller chercher Morwen et ses gardes en renfort.', 0, 0, NULL);
 
-- Depuis scène 36 — Détruire la Pierre de Focus
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(36, 45, 'Suivre Elara dans la préparation du rituel de scellement final.', 5, 5, NULL),
(36, 59, 'Remettre tout entre les mains du directeur Morwen — votre rôle est terminé.', 10, 0, NULL);
 
-- Depuis scène 37 — Intervention Tardive
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(37, 45, 'Participer au rituel de scellement final avec Morwen et Sol.', 0, 5, NULL),
(37, 59, 'Laisser les maîtres gérer la suite et rédiger un rapport détaillé sur ce que vous avez vu.', 5, 0, NULL);
 
-- Depuis scène 38 — Rendez-Vous Piégé
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(38, 39, 'Interroger les membres capturés pour en savoir plus.', 0, 5, NULL),
(38, 26, 'Livrer immédiatement les prisonniers au Grand Conseil sans les interroger.', 5, 0, NULL);
 
-- Depuis scène 39 — Un Maître Parmi les Traîtres
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(39, 40, 'Aller vérifier ce que Morwen cache dans la crypte — les doutes méritent d\'être levés.', 0, 5, NULL),
(39, 26, 'Ignorer la provocation de Cassin et témoigner directement devant le Grand Conseil.', 5, 5, NULL);
 
-- Depuis scène 40 — La Crypte
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(40, 41, 'Écouter la vérité complète que Morwen veut vous révéler.', 0, 5, NULL),
(40, 43, 'Sortir de la crypte et aller chercher Sol pour qu\'elle entende aussi.', 5, 0, NULL);
 
-- Depuis scène 41 — Vérité du Directeur
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(41, 42, 'Faire confiance à Morwen et accepter de l\'aider pour le rituel de scellement.', 0, 5, 13),
(41, 43, 'Poser des questions difficiles à Morwen avant de vous engager.', 5, 0, NULL);
 
-- Depuis scène 42 — Faire Confiance à Morwen
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(42, 45, 'Accepter votre rôle et préparer le rituel pour la nuit de l\'Éclipse.', 5, 5, NULL),
(42, 44, 'Insister pour inclure Sol dans le rituel malgré les réticences de Morwen.', 5, 0, NULL);
 
-- Depuis scène 43 — Douter de Morwen
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(43, 44, 'Aller chercher Yrenne Sol pour l\'inclure dans la décision.', 5, 5, NULL),
(43, 62, 'Signaler Morwen au Grand Conseil — trop de zones d\'ombre.', 0, 0, NULL);
 
-- Depuis scène 44 — Trouver Yrenne Sol
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(44, 45, 'Retourner dans la crypte avec Sol pour préparer le rituel collectif.', 5, 5, NULL),
(44, 41, 'Laisser Sol gérer Morwen seul et retourner vous reposer avant l\'Éclipse.', 10, 0, NULL);
 
-- Depuis scène 45 — Nuit de l\'Éclipse
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(45, 46, 'Prendre votre place dans le cercle de stabilisation et maintenir le rituel.', 0, 5, NULL),
(45, 64, 'Paniquer devant l\'ampleur de la situation et sortir de la crypte en courant.', -10, 0, NULL);
 
-- Depuis scène 46 — Tenir le Cercle
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(46, 47, 'Faire face aux membres de la Confrérie qui défoncent la porte.', 0, 5, NULL),
(46, 50, 'Maintenir le cercle malgré l\'intrusion et ne pas lâcher.', 5, 0, NULL);
 
-- Depuis scène 47 — Le Dernier Assaut
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(47, 48, 'Tenir le cercle coûte que coûte, même sous les attaques.', -15, 0, NULL),
(47, 49, 'Lâcher le cercle pour combattre et protéger Morwen et Sol.', -10, 5, NULL);
 
-- Depuis scène 48 — Tenir contre Tout
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(48, 51, 'Donner tout ce qui vous reste de magie pour alimenter le rituel.', -20, 0, NULL),
(48, 50, 'Tenir sans forcer — chaque seconde que vous gagnez aide Morwen et Sol.', -5, 0, NULL);
 
-- Depuis scène 49 — Lâcher le Cercle
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(49, 50, 'Rejoindre le cercle aussitôt les adversaires neutralisés.', -10, 0, NULL),
(49, 65, 'Le rituel déraille — vous n\'arrivez pas à rejoindre le cercle à temps.', -20, 0, NULL);
 
-- Depuis scène 50 — La Brèche Résiste
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(50, 51, 'Concentrer toute votre magie résiduelle pour soutenir Morwen et Sol.', -10, 0, NULL),
(50, 65, 'Vous effondrer sous la pression avant que le rituel se termine.', -25, 0, NULL);
 
-- Depuis scène 51 — Donner le Reste de sa Magie
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(51, 52, 'Tenir jusqu\'à la fin, même si ça vous vide entièrement.', -10, 0, NULL),
(51, 65, 'Vous écrouler — vous avez tout donné mais ce n\'était pas assez.', -30, 0, NULL);
 
-- Depuis scène 52 — La Brèche se Ferme
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(52, 53, 'Vous laisser tomber — vous avez accompli ce que vous pouviez.', 0, 0, NULL);
 
-- Depuis scène 53 — Académie Sauvée
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(53, 56, 'Accepter la cérémonie des Distinctions que Morwen annonce en votre honneur.', 5, 0, 15),
(53, 59, 'Décliner les honneurs et demander à rejoindre la Cellule de Veille discrète d\'Aldric.', 0, 5, NULL);
 
-- Depuis scène 54 — Les Traîtres Jugés
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(54, 56, 'Terminer l\'année scolaire et rejoindre la cérémonie des Distinctions.', 5, 5, NULL),
(54, 57, 'Rencontrer le Professeur Drast pour voir si vous pouvez compléter le journal de Serafina.', 0, 5, 4);
 
-- Depuis scène 55 — Proposition Inattendue
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(55, 57, 'Accepter de lire les pages de Serafina et de poursuivre son œuvre.', 0, 5, 4),
(55, 58, 'Décliner le rôle de chercheur et vous consacrer à la guérison à l\'infirmerie.', 10, 0, 3),
(55, 59, 'Rejoindre la Cellule de Veille d\'Aldric pour enquêter sur les membres en fuite.', 0, 10, 12);
