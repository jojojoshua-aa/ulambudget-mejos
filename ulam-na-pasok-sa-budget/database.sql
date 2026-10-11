-- Ulam na Pasok sa Budget - database export
-- Import via phpMyAdmin (Import tab). Safe to re-run: it recreates the database.

DROP DATABASE IF EXISTS ulam_budget;
CREATE DATABASE ulam_budget CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ulam_budget;

CREATE TABLE users (
    id            INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          ENUM('admin','user') NOT NULL DEFAULT 'user',
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE recipes (
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id      INT UNSIGNED NOT NULL,
    dish_name    VARCHAR(120) NOT NULL,
    category     ENUM('Almusal','Tanghalian','Hapunan') NOT NULL,
    budget       VARCHAR(30) NOT NULL,
    prep_time    SMALLINT UNSIGNED NOT NULL COMMENT 'minutes',
    ingredients  TEXT NOT NULL COMMENT 'one ingredient per line',
    instructions TEXT NOT NULL COMMENT 'one step per line',
    is_public    TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 = visible to every user (admin recipes)',
    created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_recipes_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_category (category),
    INDEX idx_public (is_public)
) ENGINE=InnoDB;

-- Test accounts
--   admin@ulam.test / Admin@123
--   user@ulam.test  / User@1234
INSERT INTO users (id, full_name, email, password_hash, role) VALUES
(1, 'Admin Ulam',  'admin@ulam.test', '$2y$10$lJlU5FbeW.jiqBAKXzhr8eIOjIU4cQl1qcpvA5jQQnM5Nr5o8NL9.', 'admin'),
(2, 'Juan Estudyante', 'user@ulam.test', '$2y$10$v02LrgctCEWidSlYZo/6Nuj0JC.QZY0avnw.9ks.BxO6NJxXi5fbq', 'user');

-- Admin recipes (public to everyone)
INSERT INTO recipes (user_id, dish_name, category, budget, prep_time, ingredients, instructions, is_public) VALUES
(1, 'Sinangag at Itlog', 'Almusal', 'Under ₱50', 10,
 'Kanin na tira kagabi (1 tasa)\nItlog (1 piraso)\nBawang (3 butil, dinikdik)\nMantika (1 kutsara)\nAsin (kaunti)',
 'Initin ang mantika sa kawali at igisa ang bawang hanggang mag-golden.\nIdagdag ang kanin at durugin ang mga buo-buo.\nTimplahan ng asin at haluin nang 3 minuto.\nSa gilid, magprito ng itlog at ihain kasama ng sinangag.', 1),
(1, 'Champorado', 'Almusal', 'Under ₱50', 25,
 'Malagkit na bigas (1/2 tasa)\nTablea o cocoa powder (2 kutsara)\nAsukal (3 kutsara)\nTubig (3 tasa)\nGatas na evaporada (pang-ibabaw)',
 'Pakuluan ang bigas sa tubig hanggang lumambot, haluin paminsan-minsan.\nIlagay ang tablea o cocoa at haluin hanggang matunaw.\nIdagdag ang asukal at hayaang lumapot.\nIhain nang mainit na may gatas sa ibabaw.', 1),
(1, 'Tortang Talong', 'Almusal', 'Under ₱50', 20,
 'Talong (2 piraso)\nItlog (2 piraso)\nBawang at sibuyas (kaunti, hiniwa)\nAsin\nMantika',
 'Ihawin o pakuluan ang talong hanggang lumambot, balatan at i-flatten gamit ang tinidor.\nBatihin ang itlog at lagyan ng asin, bawang, at sibuyas.\nIsawsaw ang talong sa itlog.\nPrituhin sa mainit na mantika hanggang golden brown sa magkabilang side.', 1),
(1, 'Ginisang Monggo', 'Tanghalian', 'Under ₱100', 45,
 'Monggo (1/2 tasa)\nBawang, sibuyas, at kamatis\nDahon ng malunggay o ampalaya\nDilis o tokwa (pamalit sa baboy)\nPatis o asin',
 'Pakuluan ang monggo hanggang lumambot (mga 30 minuto).\nIgisa ang bawang, sibuyas, at kamatis sa hiwalay na kawali.\nIsama ang dilis o tokwa at ibuhos ang nilutong monggo.\nTimplahan ng patis at idagdag ang dahon. Pakuluan ng 3 minuto.', 1),
(1, 'Pritong Galunggong at Kamatis', 'Tanghalian', 'Under ₱100', 20,
 'Galunggong (3 piraso)\nAsin\nMantika\nKamatis at sibuyas (pang-sawsaw)\nToyo at kalamansi',
 'Linisin ang isda at pahiran ng asin.\nPrituhin sa mainit na mantika hanggang malutong.\nHiwain ang kamatis at sibuyas, lagyan ng toyo at kalamansi.\nIhain kasama ng mainit na kanin.', 1),
(1, 'Ginisang Sardinas', 'Hapunan', 'Under ₱50', 10,
 'Sardinas na de-lata (1)\nBawang at sibuyas\nKamatis (1 piraso)\nSitsaro o repolyo (opsyonal)\nMantika',
 'Igisa ang bawang, sibuyas, at kamatis.\nIlagay ang sardinas kasama ang sarsa.\nIdagdag ang gulay kung mayroon at lutuin ng 3 minuto.\nIhain kasama ng kanin.', 1),
(1, 'Pinakbet', 'Hapunan', 'Under ₱100', 35,
 'Kalabasa, talong, okra, at sitaw\nAmpalaya (1/2 piraso)\nBagoong isda o alamang (2 kutsara)\nBawang, sibuyas, kamatis\nTubig (1/2 tasa)',
 'Igisa ang bawang, sibuyas, at kamatis.\nIdagdag ang bagoong at kaunting tubig.\nIlagay muna ang kalabasa at sitaw, takpan ng 5 minuto.\nIsunod ang talong, okra, at ampalaya at lutuin hanggang lumambot.', 1),
(1, 'Tinolang Manok', 'Hapunan', 'Under ₱150', 50,
 'Manok na pang-tinola (1/4 kilo)\nLuya (1 hinlalaki, hiniwang manipis)\nSayote o papaya (1 piraso)\nDahon ng sili o malunggay\nPatis at tubig',
 'Igisa ang luya, bawang, at sibuyas, saka ilagay ang manok hanggang mag-iba ang kulay.\nIbuhos ang tubig at pakuluan hanggang lumambot ang manok.\nIlagay ang sayote at lutuin ng 10 minuto.\nTimplahan ng patis, idagdag ang dahon, at patayin ang apoy.', 1);

-- A private recipe owned by the test user
INSERT INTO recipes (user_id, dish_name, category, budget, prep_time, ingredients, instructions, is_public) VALUES
(2, 'Pancit Canton na may Itlog', 'Hapunan', 'Under ₱50', 10,
 'Pancit canton (1 pack)\nItlog (1 piraso)\nRepolyo (kaunti, hiniwa)\nTubig',
 'Pakuluan ang repolyo sa tubig ng 2 minuto.\nIlagay ang pancit canton at lutuin hanggang lumambot.\nSalain, ihalo ang pampalasa, at itapon ang sobrang tubig.\nMagprito ng itlog at ilagay sa ibabaw.', 0);
