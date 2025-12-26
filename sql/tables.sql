-- CYV RP Framework Database Schema

-- Users table (linked to Steam ID)
CREATE TABLE IF NOT EXISTS `users` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `steam_id` varchar(20) NOT NULL,
    `license` varchar(50) NOT NULL,
    `name` varchar(100) DEFAULT NULL,
    `ip` varchar(15) DEFAULT NULL,
    `last_login` datetime DEFAULT NULL,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `steam_id` (`steam_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Characters table
CREATE TABLE IF NOT EXISTS `characters` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `firstname` varchar(50) NOT NULL,
    `lastname` varchar(50) NOT NULL,
    `dateofbirth` date NOT NULL,
    `gender` enum('male','female') NOT NULL,
    `height` int(11) DEFAULT 180,
    `model` varchar(100) DEFAULT 'mp_m_freemode_01',
    `position` longtext DEFAULT NULL,
    `money` int(11) DEFAULT 0,
    `bank` int(11) DEFAULT 0,
    `job` varchar(50) DEFAULT 'unemployed',
    `job_grade` int(11) DEFAULT 0,
    `inventory` longtext DEFAULT NULL,
    `skin` longtext DEFAULT NULL,
    `tattoos` longtext DEFAULT NULL,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `user_id` (`user_id`),
    CONSTRAINT `characters_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Inventory items table
CREATE TABLE IF NOT EXISTS `inventory_items` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `character_id` int(11) NOT NULL,
    `item` varchar(50) NOT NULL,
    `count` int(11) NOT NULL DEFAULT 1,
    `metadata` longtext DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `character_id` (`character_id`),
    CONSTRAINT `inventory_items_ibfk_1` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Vehicles table
CREATE TABLE IF NOT EXISTS `vehicles` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `character_id` int(11) NOT NULL,
    `model` varchar(50) NOT NULL,
    `plate` varchar(10) NOT NULL,
    `garage` varchar(50) DEFAULT 'A',
    `fuel` float DEFAULT 100.0,
    `engine` float DEFAULT 1000.0,
    `body` float DEFAULT 1000.0,
    `mods` longtext DEFAULT NULL,
    `stored` tinyint(1) DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE KEY `plate` (`plate`),
    KEY `character_id` (`character_id`),
    CONSTRAINT `vehicles_ibfk_1` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Houses table
CREATE TABLE IF NOT EXISTS `houses` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `owner` int(11) DEFAULT NULL,
    `price` int(11) NOT NULL,
    `rented` tinyint(1) DEFAULT 0,
    `rent_price` int(11) DEFAULT 0,
    `interior` varchar(50) DEFAULT 'default',
    `furniture` longtext DEFAULT NULL,
    `coords` longtext NOT NULL,
    PRIMARY KEY (`id`),
    KEY `owner` (`owner`),
    CONSTRAINT `houses_ibfk_1` FOREIGN KEY (`owner`) REFERENCES `characters` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Factions table
CREATE TABLE IF NOT EXISTS `factions` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `leader` int(11) DEFAULT NULL,
    `type` enum('gang','police','ems','government') DEFAULT 'gang',
    `funds` int(11) DEFAULT 0,
    `territory` longtext DEFAULT NULL,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `leader` (`leader`),
    CONSTRAINT `factions_ibfk_1` FOREIGN KEY (`leader`) REFERENCES `characters` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Faction members table
CREATE TABLE IF NOT EXISTS `faction_members` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `faction_id` int(11) NOT NULL,
    `character_id` int(11) NOT NULL,
    `rank` int(11) DEFAULT 0,
    `joined_at` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `faction_id` (`faction_id`),
    KEY `character_id` (`character_id`),
    CONSTRAINT `faction_members_ibfk_1` FOREIGN KEY (`faction_id`) REFERENCES `factions` (`id`) ON DELETE CASCADE,
    CONSTRAINT `faction_members_ibfk_2` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Logs table
CREATE TABLE IF NOT EXISTS `logs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `type` varchar(50) NOT NULL,
    `message` text NOT NULL,
    `character_id` int(11) DEFAULT NULL,
    `metadata` longtext DEFAULT NULL,
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `character_id` (`character_id`),
    CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Shops table
CREATE TABLE IF NOT EXISTS `shops` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(100) NOT NULL,
    `type` varchar(50) DEFAULT 'general',
    `coords` longtext NOT NULL,
    `items` longtext NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Skills table
CREATE TABLE IF NOT EXISTS `character_skills` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `character_id` int(11) NOT NULL,
    `skill` varchar(50) NOT NULL,
    `level` int(11) DEFAULT 1,
    `xp` int(11) DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `character_id` (`character_id`),
    CONSTRAINT `character_skills_ibfk_1` FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;