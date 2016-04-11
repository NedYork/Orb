CREATE TABLE dragons (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES trainer(id)
);

CREATE TABLE trainers (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  hideout_id INTEGER,

  FOREIGN KEY(hideout_id) REFERENCES trainer(id)
);

CREATE TABLE hideouts (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  hideouts (id, address)
VALUES
  (1, "Cerulean City"), (2, "Vermillion City");

INSERT INTO
  trainers (id, fname, lname, hideout_id)
VALUES
  (1, "Gary", "Oak", 1),
  (2, "Ash", "Ketchum", 1),
  (3, "Team", "Rocket", 2),
  (4, "Ned", "He", NULL);

INSERT INTO
  dragons (id, name, owner_id)
VALUES
  (1, "Charizard", 1),
  (2, "Gyarados", 2),
  (3, "Ditto", 3),
  (4, "Dragonite", 3),
  (5, "Salamence", NULL);
