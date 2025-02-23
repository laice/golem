CREATE TABLE skills (
    `id` BIGINT NOT NULL,

    `name` VARCHAR(255) NOT NULL UNIQUE,
    `type` ENUM('skill', 'spell', 'passive'),
    `intent` ENUM('offensive', 'curative', 'none') DEFAULT 'none',
    
    /* Timestamps */
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW(),

    PRIMARY KEY (id)
);

CREATE TABLE job_skill (
    `id` BIGINT NOT NULL,

    `job_id` BIGINT NOT NULL,
    `skill_id` BIGINT NOT NULL,
    `level` INT NOT NULL,

    `complexity` BIGINT NOT NULL,
    `cost` BIGINT NOT NULL,
    
    /* Timestamps */
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW(),

    `deleted_at` TIMESTAMP NULL DEFAULT NULL,
    `deleted_by` BIGINT DEFAULT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (job_id) REFERENCES jobs(id),
    FOREIGN KEY (skill_id) REFERENCES skills(id)
);

CREATE TABLE pc_skill_proficiency (
    `id` BIGINT NOT NULL AUTO_INCREMENT,

    `player_character_id` BIGINT NOT NULL,
    `skill_id` BIGINT NOT NULL,
    `job_id` BIGINT NOT NULL,
    `proficiency` INT NOT NULL,

    /* Timestamps */
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW(),

    PRIMARY KEY (id),
    FOREIGN KEY (player_character_id) REFERENCES player_characters(id),
    FOREIGN KEY (job_id) REFERENCES jobs(id),
    FOREIGN KEY (skill_id) REFERENCES skills(id)
);

INSERT INTO skills(id, name, type, intent) VALUES (1, 'dodge', 'passive', 'none');
INSERT INTO skills(id, name, type, intent) VALUES (2, 'unarmed combat', 'passive', 'none');
INSERT INTO skills(id, name, type, intent) VALUES (3, 'peek', 'passive', 'none');
INSERT INTO skills(id, name, type, intent) VALUES (4, 'armor', 'spell', 'curative');
INSERT INTO skills(id, name, type, intent) VALUES (5, 'fireball', 'spell', 'offensive');
INSERT INTO skills(id, name, type, intent) VALUES (6, 'bash', 'skill', 'offensive');
INSERT INTO skills(id, name, type, intent) VALUES (7, 'cure light', 'spell', 'curative');
INSERT INTO skills(id, name, type, intent) VALUES (8, 'magic map', 'spell', 'none');
INSERT INTO skills(id, name, type, intent) VALUES (9, 'sanctuary', 'spell', 'curative');
INSERT INTO skills(id, name, type, intent) VALUES (10, 'haste', 'spell', 'curative');
INSERT INTO skills(id, name, type, intent) VALUES (11, 'fireshield', 'spell', 'curative');
INSERT INTO skills(id, name, type, intent) VALUES (12, 'acrobatics', 'passive', 'none');
INSERT INTO skills(id, name, type, intent) VALUES (13, 'amazement', 'spell', 'none');
INSERT INTO skills(id, name, type, intent) VALUES (14, 'magical might', 'spell', 'curative');
INSERT INTO skills(id, name, type, intent) VALUES (15, 'steal', 'skill', 'offensive');
INSERT INTO skills(id, name, type, intent) VALUES (16, 'backstab', 'skill', 'offensive');
INSERT INTO skills(id, name, type, intent) VALUES (17, 'stun', 'skill', 'offensive');
INSERT INTO skills(id, name, type, intent) VALUES (18, 'group heal', 'spell', 'curative');

/* Grant unarmed combat as a seed skill for all four base jobs with varying complexity and cost */
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (1, 1, 2, 1, 1, 50);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (2, 2, 2, 2, 2, 50);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (3, 3, 2, 3, 5, 50);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (4, 4, 2, 4, 5, 50);

/* Warrior defaults: bash, dodge, stun */
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (5, 1, 6, 1, 5, 50);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (11, 1, 1, 10, 10, 50);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (21, 1, 17, 25, 10, 50);

/* Thief defaults: peek, dodge, steal, backstab, acrobatics */
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (6, 2, 3, 1, 5, 5);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (12, 2, 1, 5, 5, 5);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (16, 2, 12, 25, 5, 5);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (19, 2, 15, 1, 2, 2);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (20, 2, 16, 5, 5, 2);

/* Cleric defaults: armor, cure light, magic map, sanctuary, group heal */
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (7, 4, 4, 1, 1, 50);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (9, 4, 7, 1, 1, 50);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (10, 4, 8, 1, 1, 50);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (13, 4, 9, 5, 2, 100);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (22, 4, 18, 20, 3, 150);

/* Mage defaults: fireball, haste, magical might, fireshield, amazement */
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (8, 3, 5, 1, 5, 50);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (14, 3, 10, 5, 10, 75);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (15, 3, 11, 15, 6, 100);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (18, 3, 14, 10, 3, 75);
INSERT INTO job_skill(id, job_id, skill_id, level, complexity, cost) VALUES (17, 3, 13, 50, 100, 500);

/* Grant some skills mastered to the seed admin user as well */
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (1, 1, 1, 2, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (2, 1, 2, 1, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (3, 1, 3, 2, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (4, 1, 4, 4, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (5, 1, 5, 3, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (6, 1, 6, 1, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (7, 1, 7, 4, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (8, 1, 8, 4, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (9, 1, 9, 4, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (10, 1, 10, 3, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (11, 1, 11, 3, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (12, 1, 12, 2, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (13, 1, 13, 3, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (14, 1, 14, 3, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (15, 1, 15, 2, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (16, 1, 16, 2, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (17, 1, 17, 1, 100);
INSERT INTO pc_skill_proficiency(id, player_character_id, skill_id, job_id, proficiency) VALUES (18, 1, 18, 4, 100);

CREATE INDEX index_skill_name ON skills(name);