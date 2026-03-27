-- ============================================
-- BASE DE DONNÉES : academie
-- ============================================

CREATE DATABASE IF NOT EXISTS academie CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE academie;

-- ============================================
-- TABLES
-- ============================================

CREATE TABLE Scene (
    id_scene      INT AUTO_INCREMENT PRIMARY KEY,
    titre         VARCHAR(255) NOT NULL,
    description   TEXT NOT NULL,
    image         VARCHAR(255) DEFAULT NULL,
    est_fin       TINYINT(1) DEFAULT 0,
    type_fin      ENUM('victoire','defaite','neutre') DEFAULT 'neutre'
) ENGINE=InnoDB;

CREATE TABLE Objet (
    id_objet  INT AUTO_INCREMENT PRIMARY KEY,
    nom       VARCHAR(100) NOT NULL,
    icone     VARCHAR(10)  DEFAULT '📦',
    effet_vie INT DEFAULT 0,
    effet_force INT DEFAULT 0
) ENGINE=InnoDB;

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
) ENGINE=InnoDB;

CREATE TABLE Personnage (
    id_personnage INT AUTO_INCREMENT PRIMARY KEY,
    pseudo        VARCHAR(100) DEFAULT 'Héros',
    vie           INT DEFAULT 100,
    force         INT DEFAULT 10,
    id_scene_actuelle INT DEFAULT 1,
    nb_choix      INT DEFAULT 0,
    cree_le       DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_scene_actuelle) REFERENCES Scene(id_scene)
) ENGINE=InnoDB;

CREATE TABLE Inventaire (
    id_inventaire INT AUTO_INCREMENT PRIMARY KEY,
    id_personnage INT NOT NULL,
    id_objet      INT NOT NULL,
    obtenu_le     DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_personnage) REFERENCES Personnage(id_personnage),
    FOREIGN KEY (id_objet)      REFERENCES Objet(id_objet)
) ENGINE=InnoDB;

CREATE TABLE HistoriqueProgression (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    id_personnage INT NOT NULL,
    id_scene      INT NOT NULL,
    arrive_le     DATETIME DEFAULT NOW(),
    FOREIGN KEY (id_personnage) REFERENCES Personnage(id_personnage),
    FOREIGN KEY (id_scene)      REFERENCES Scene(id_scene)
) ENGINE=InnoDB;

-- ============================================
-- DONNÉES : OBJETS
-- ============================================

INSERT INTO Objet (id_objet, nom, icone, effet_vie, effet_force) VALUES
(1,  'Épée rouillée',    '⚔️',  0,  5),
(2,  'Bouclier en bois', '🛡️',  10, 0),
(3,  'Potion de soins',  '🧪',  25, 0),
(4,  'Grimoire ancien',  '📖',  0,  10),
(5,  'Arc elfique',      '🏹',  0,  8),
(6,  'Amulette maudite', '🔮',  -15, 15),
(7,  'Torche magique',   '🔦',  5,  0),
(8,  'Clé dorée',        '🗝️',  0,  0);

-- ============================================
-- DONNÉES : SCÈNES
-- ============================================

INSERT INTO Scene (id_scene, titre, description, est_fin, type_fin) VALUES
-- SCÈNE 1 : DÉPART
(1,  'Les Portes de l\'Académie',
     'Vous vous tenez devant les majestueuses portes de l\'Académie des Mages. La brume matinale enveloppe les tours de cristal. Votre cœur bat fort — c\'est votre premier jour. Un garde vous interpelle : "Halt ! Qui va là ?" Vous avez le choix de votre première impression.',
     0, 'neutre'),

-- SCÈNE 2 : Chemin diplomate
(2,  'L\'Entrée Principale',
     'Le garde, impressionné par votre politesse, vous laisse passer avec un sourire. "Bienvenue, jeune étudiant." Dans le hall, vous apercevez un vieux mage qui semble avoir perdu quelque chose, et un couloir menant aux dortoirs.',
     0, 'neutre'),

-- SCÈNE 3 : Chemin furtif
(3,  'Les Jardins Secrets',
     'Vous avez contourné le garde par les jardins. Dans les buissons, vous trouvez un livre abandonné et une torche magique. Mais une ombre vous observe depuis une fenêtre du premier étage...',
     0, 'neutre'),

-- SCÈNE 4 : Mauvaise entrée
(4,  'La Cellule de Garde',
     'Vous avez tenté de forcer le passage. Les gardes vous ont maîtrisé et vous attendent dans la cellule de détention. Le directeur de l\'Académie arrive, furieux. C\'est mal parti...',
     0, 'neutre'),

-- SCÈNE 5 : Aider le vieux mage
(5,  'La Bibliothèque Interdite',
     'Le vieux mage, reconnaissant, vous guide jusqu\'à la bibliothèque secrète. "Ces connaissances vous seront utiles", murmure-t-il. Les étagères regorgent de grimoires poussiéreux. Un livre particulier semble vous appeler...',
     0, 'neutre'),

-- SCÈNE 6 : Aller aux dortoirs
(6,  'Les Dortoirs',
     'Dans le couloir, vous croisez Elara, une étudiante de deuxième année. "Prends ça", dit-elle en vous tendant une potion. "Tu en auras besoin avant ce soir." Elle disparaît avant que vous puissiez la questionner. Une cloche résonne : premier cours dans dix minutes.',
     0, 'neutre'),

-- SCÈNE 7 : Pardon du directeur
(7,  'Le Bureau du Directeur',
     'Après une explication maladroite, le directeur accepte vos excuses. "Une dernière chance", grogne-t-il. Il vous confie une mission de rédemption : récupérer une artefact volé dans la tour nord avant la nuit.',
     0, 'neutre'),

-- SCÈNE 8 : Prendre le grimoire trouvé
(8,  'L\'Atelier des Illusions',
     'Le grimoire révèle des sorts d\'illusion. Vous maîtrisez rapidement le sort "Miroir". Dans l\'atelier, un démon piégé dans un miroir vous propose un marché suspect : lui rendre sa liberté en échange de "tout ce que vous désirez".',
     0, 'neutre'),

-- SCÈNE 9 : Lire le grimoire de bibliothèque
(9,  'La Salle du Conseil',
     'Le grimoire contenait une prophétie : l\'Académie est en danger, infiltrée par une société secrète. Vous en savez trop. Les maîtres vous convoquent d\'urgence dans la salle du conseil. La vérité va éclater.',
     0, 'neutre'),

-- SCÈNE 10 : Entrer en cours
(10, 'Le Cours de Magie Élémentaire',
     'Le professeur Aldric teste les nouveaux étudiants. À votre tour, il vous demande de choisir votre élément. Chaque élément vous ouvrira un destin différent au sein de l\'Académie.',
     0, 'neutre'),

-- SCÈNE 11 : Tour nord - affrontement
(11, 'La Tour Nord',
     'Dans la tour, vous affrontez un voleur masqué. Il tient l\'artefact — un orbe de lumière pulsante. Le combat est inévitable. Votre force déterminera l\'issue.',
     0, 'neutre'),

-- SCÈNE 12 : Libérer le démon
(12, 'Le Pacte Démoniaque',
     'Vous avez libéré le démon. Il rit — un rire glacial — et disparaît dans une colonne de fumée noire. Soudain, l\'Académie tremble. L\'alarme sonne. Vous avez libéré quelque chose de terrible. Mais le démon vous a donné quelque chose : son pouvoir.',
     0, 'neutre'),

-- SCÈNE 13 : Refuser le démon
(13, 'L\'Académicien Vertueux',
     'Vous résistez à la tentation. Le démon disparaît dans un éclair de lumière blanche — il était en réalité un test du directeur ! "Impressionnant", dit une voix. Vous venez de passer l\'épreuve des valeurs. Une médaille d\'honneur vous est remise.',
     0, 'neutre'),

-- SCÈNE 14 : Révéler la conspiration
(14, 'L\'Heure de Vérité',
     'Devant le conseil, vous dévoilez tout. Plusieurs maîtres pâlissent — certains faisaient partie de la société secrète. Une bataille magique éclate dans la salle. Vous devez choisir votre camp.',
     0, 'neutre'),

-- SCÈNE 15 : Choisir le feu
(15, 'Apprenti du Feu',
     'Les flammes répondent à votre appel. Vous maîtrisez un sort puissant mais incontrôlable. Votre réputation à l\'Académie grandit rapidement — mais votre impulsivité vous attire des ennemis.',
     0, 'neutre'),

-- SCÈNE 16 : Choisir l'eau
(16, 'Apprenti de l\'Eau',
     'L\'eau coule autour de vous avec grâce. Vous maîtrisez les arts de guérison et de protection. Le professeur Aldric vous prend sous son aile. L\'avenir semble prometteur.',
     0, 'neutre'),

-- ============================================
-- FINS
-- ============================================

-- FIN VICTOIRE 1 : Héros de l'Académie
(17, 'Le Champion de l\'Académie',
     '🏆 VICTOIRE ! Vous avez vaincu le voleur, récupéré l\'artefact et révélé la conspiration. Le directeur vous nomme officiellement "Champion de l\'Académie". Votre légende commence. L\'avenir vous appartient.',
     1, 'victoire'),

-- FIN VICTOIRE 2 : Sage vertueux
(18, 'Le Sage Vertueux',
     '🏆 VICTOIRE ! Votre sagesse et votre vertu ont sauvé l\'Académie de l\'intérieur. Vous êtes nommé conseiller du directeur à seulement 18 ans. Une carrière brillante vous attend.',
     1, 'victoire'),

-- FIN VICTOIRE 3 : Guérisseur légendaire
(19, 'Le Grand Guérisseur',
     '🏆 VICTOIRE ! Votre maîtrise de l\'eau vous a permis de soigner les blessés lors de la bataille du conseil. Vous êtes acclamé par toute l\'Académie. Votre bonté a triomphé.',
     1, 'victoire'),

-- FIN DÉFAITE 1 : Vaincu
(20, 'La Défaite Amère',
     '💀 DÉFAITE. Vos forces ont été insuffisantes face au voleur. L\'artefact est perdu. Le directeur, déçu, vous expulse de l\'Académie. Tout cela n\'était qu\'un rêve brisé.',
     1, 'defaite'),

-- FIN DÉFAITE 2 : Consumé par le démon
(21, 'Consumé par les Ténèbres',
     '💀 DÉFAITE. Le pouvoir du démon vous a consumé de l\'intérieur. Vous avez perdu votre âme. L\'Académie vous chasse. Vous errez désormais entre deux mondes, ni vivant ni mort.',
     1, 'defaite'),

-- FIN DÉFAITE 3 : Trahi
(22, 'Trahi et Banni',
     '💀 DÉFAITE. Vous avez choisi le mauvais camp lors de la bataille du conseil. Les maîtres corrompus ont gagné. Vous êtes banni pour complicité. L\'Académie tombe dans l\'ombre.',
     1, 'defaite');

-- ============================================
-- DONNÉES : CHOIX
-- ============================================

-- Depuis scène 1
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(1, 2,  'Saluer poliment le garde et présenter votre lettre d\'admission.', 0, 0, NULL),
(1, 3,  'Contourner discrètement par les jardins sur le côté.', 0, 2, 7),
(1, 4,  'Essayer de passer en force en jouant des coudes.', -10, 0, NULL);

-- Depuis scène 2
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(2, 5,  'Aider le vieux mage à retrouver son objet perdu.', 5, 5, 4),
(2, 6,  'Ignorer le mage et aller directement aux dortoirs.', 0, 0, NULL);

-- Depuis scène 3
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(3, 8,  'Ramasser le grimoire abandonné et l\'étudier.', 0, 8, 1),
(3, 6,  'Ignorer le grimoire et rejoindre les dortoirs par l\'arrière.', 0, 0, 3);

-- Depuis scène 4
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(4, 7,  'S\'excuser sincèrement et expliquer votre motivation.', 0, 0, NULL),
(4, 20, 'Tenter de s\'échapper de la cellule par la force.', -20, 0, NULL);

-- Depuis scène 5
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(5, 9,  'Ouvrir le livre mystérieux qui vous attire.', 0, 10, NULL),
(5, 6,  'Ranger le livre et aller vous préparer pour les cours.', 5, 0, 3);

-- Depuis scène 6
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(6, 10, 'Se rendre au premier cours de magie élémentaire.', 0, 0, NULL),
(6, 7,  'Enquêter sur le mystérieux message d\'Elara.', 5, 5, NULL);

-- Depuis scène 7
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(7, 11, 'Accepter la mission et partir vers la tour nord.', 0, 5, 1),
(7, 20, 'Refuser la mission — c\'est trop dangereux.', 0, 0, NULL);

-- Depuis scène 8
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(8, 12, 'Accepter le marché du démon.', -15, 15, 6),
(8, 13, 'Refuser le démon et sceller le miroir.', 10, 0, NULL);

-- Depuis scène 9
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(9, 14, 'Révéler la conspiration devant le conseil.', 0, 0, NULL),
(9, 6,  'Garder le secret et faire comme si de rien n\'était.', 5, 0, NULL);

-- Depuis scène 10
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(10, 15, 'Choisir l\'élément Feu.', 0, 15, 1),
(10, 16, 'Choisir l\'élément Eau.', 20, 0, 2);

-- Depuis scène 11
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(11, 17, 'Combattre le voleur — votre force vous permettra de vaincre.', -10, 0, 8),
(11, 20, 'Fuir devant sa puissance — vous êtes trop faible.', 0, 0, NULL);

-- Depuis scène 12
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(12, 21, 'Utiliser le pouvoir du démon malgré les conséquences.', -30, 0, NULL),
(12, 14, 'Résister au pouvoir et alerter le conseil.', 0, 0, NULL);

-- Depuis scène 13
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(13, 18, 'Accepter la médaille d\'honneur avec modestie.', 10, 5, NULL),
(13, 14, 'Demander à rejoindre la brigade de l\'Académie.', 0, 10, NULL);

-- Depuis scène 14
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(14, 17, 'Vous battre aux côtés des maîtres loyaux.', -5, 0, NULL),
(14, 22, 'Rejoindre la société secrète pour le pouvoir.', 0, 0, NULL);

-- Depuis scène 15
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(15, 17, 'Maîtriser vos flammes et sauver l\'Académie.', -10, 0, NULL),
(15, 20, 'Perdre le contrôle et brûler l\'aile est du bâtiment.', -50, 0, NULL);

-- Depuis scène 16
INSERT INTO Choix (id_scene_source, id_scene_dest, texte, effet_vie, effet_force, id_objet_donne) VALUES
(16, 19, 'Soigner les blessés lors de la grande bataille.', 0, 0, 3),
(16, 17, 'Combattre pour protéger l\'Académie.', -5, 5, NULL);
