CREATE TABLE Specialite(
   Id_Specialite INT,
   nom VARCHAR(50),
   forces VARCHAR(50),
   faiblesses VARCHAR(50),
   description TEXT,
   PRIMARY KEY(Id_Specialite)
);

CREATE TABLE Niveau(
   Id_Niveau INT,
   PRIMARY KEY(Id_Niveau)
);

CREATE TABLE Personnage(
   Id_Personnage INT,
   pointsVie INT,
   pointsMagie INT,
   pointsEndurance INT,
   pointsStress INT,
   annee INT,
   Id_Specialite INT NOT NULL,
   PRIMARY KEY(Id_Personnage),
   UNIQUE(Id_Specialite),
   FOREIGN KEY(Id_Specialite) REFERENCES Specialite(Id_Specialite)
);

CREATE TABLE Histoire(
   Id_Histoire INT,
   titre VARCHAR(50),
   description TEXT,
   PRIMARY KEY(Id_Histoire)
);

CREATE TABLE Objet(
   Id_Objet INT,
   label VARCHAR(50),
   Effet VARCHAR(50),
   PRIMARY KEY(Id_Objet)
);

CREATE TABLE Monstre(
   Id_Monstre INT,
   nom VARCHAR(50),
   Id_Niveau INT NOT NULL,
   PRIMARY KEY(Id_Monstre),
   FOREIGN KEY(Id_Niveau) REFERENCES Niveau(Id_Niveau)
);

CREATE TABLE Cours(
   Id_Cours INT,
   nom VARCHAR(50),
   type VARCHAR(50),
   description TEXT,
   Id_Personnage INT,
   PRIMARY KEY(Id_Cours),
   FOREIGN KEY(Id_Personnage) REFERENCES Personnage(Id_Personnage)
);

CREATE TABLE Choix(
   Id_Histoire INT,
   Id_Histoire_1 INT,
   description TEXT,
   PRIMARY KEY(Id_Histoire, Id_Histoire_1),
   FOREIGN KEY(Id_Histoire) REFERENCES Histoire(Id_Histoire),
   FOREIGN KEY(Id_Histoire_1) REFERENCES Histoire(Id_Histoire)
);

CREATE TABLE Inventaire(
   Id_Personnage INT,
   Id_Objet INT,
   quantite INT,
   PRIMARY KEY(Id_Personnage, Id_Objet),
   FOREIGN KEY(Id_Personnage) REFERENCES Personnage(Id_Personnage),
   FOREIGN KEY(Id_Objet) REFERENCES Objet(Id_Objet)
);
