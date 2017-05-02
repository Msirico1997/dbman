
Drop table if exists "Class" cascade;
Drop table if exists "SubClass" cascade;
Drop table if exists "Weapon_Mastery" cascade;
Drop table if exists "Stats_Aptitude" cascade;
Drop Table if exists "Skills" cascade;
Drop Table if exists "Skill_Relations" cascade;
Drop Table if exists "Character" cascade;
Drop table if exists "Char_Skills" cascade;
Drop table if exists "Specialist" cascade;
Drop table if exists "Item_Type" cascade;
Drop table if exists "Item_Real" cascade;


Create Table If Not Exists "Class" (
  "Class_ID" Serial Primary Key,
  "Class_name" Text Not Null,
  "counter_base" Int Not Null,
  "move_base" Int Not Null,
  "jump_base" Int Not Null,
  "throw_base" Int
);



create table if not exists "SubClass" (
  "Class_ID" Int references "Class"("Class_ID"),
  "SubClass_ID" Serial primary key,
  "SubClass_name" Text Not Null,
  "atk_base" Int Not Null,
  "def_base" Int Not Null,
  "int_base" Int Not Null,
  "res_base" Int Not Null,
  "hit_base" Int Not Null,
  "spd_base" Int Not Null,
  "HP_base" Int Not Null,
  "SP_base" Int Not Null
); 


create table if not exists "Weapon_Mastery" (
  "SubClass_ID" Int references "SubClass"("SubClass_ID"),
  "Fist_Mastery" Text,
  "Sword_Mastery" Text,
  "Spear_Mastery" Text,
  "Bow_Mastery" Text,
  "Gun_Mastery" Text,
  "Axe_Mastery" Text,
  "Staff_Mastery" Text
);


create table if not exists "Stats_Aptitude" (
  "SubClass_ID" Int references "SubClass"("SubClass_ID"),
  "hp_apt" Int Not Null,
  "sp_apt" Int Not Null,
  "atk_apt" Int Not Null,
  "def_apt" Int Not Null,
  "int_apt" Int Not Null,
  "res_apt" Int Not Null,
  "hit_apt" Int Not Null,
  "spd_apt" Int Not Null
);


create table if not exists "Skills" (
  "Skill_ID" Serial primary key,
  "Skill_Name" Text Not Null,
  "Level_Aquired" Int Not Null,
  "SP_Required" Int Not Null,
  "Effect" Text Not Null,
  "Height" Int Not Null
);


create table if not exists "Skill_Relations" (
  "Class_ID" Int references "Class"("Class_ID"),
  "Skill_ID" Int references "Skills"("Skill_ID")
);

create table if not exists "Character" (
  "Char_ID" Serial primary key,
  "SubClass_ID" Int references "SubClass"("SubClass_ID"),
  "Name" Text,
  "Title" Text,
  "Level" Int,
  "Felony_count" Int,
  "exp" Int
);

create table if not exists "Char_Skills" (
  "Char_ID" Int references "Character"("Char_ID"),
  "Skill_ID" Int references "Skills"("Skill_ID")
);

create table if not exists "Specialist" (
  "Spec_ID" Int references "Character"("Char_ID") primary key,
  "Specialist_type" Text,
  "Effect_cap" Int,
  "Is_Subdued" Bool
);

create table if not exists "Item_Type" (
  "Itemtype_ID" Serial primary key,
  "Itemtype_name" Text,
  "Rank" Int,
  "Base_Price" Int Not Null,
  "atk_mod" Int Not Null,
  "def_mod" Int Not Null,
  "int_mod" Int Not Null,
  "res_mod" Int Not Null,
  "hit_mod" Int Not Null,
  "spd_mod" Int Not Null,
  "move_mod" Int Not Null,
  "jump_mod" Int Not Null,
  "HP_mod" Int Not Null,
  "SP_mod" Int Not Null,
  "Equippable" Bool Not Null,
  "EquipType" Text
);


create table if not exists "Item_Real" (
  "Itemtype_ID" Int references "Item_Type"("Itemtype_ID"),
  "RealItem_ID" Serial primary key,
  "Equipped" Int references "Character"("Char_ID"),
  "Resident" Int references "Specialist"("Spec_ID"),
  "Rarity" Int,
  "IsInInventory" Bool,
  Constraint Resident_Equip check ("Resident"<>"Equipped")
);



--This view  will return all Characters, along with their subclass name, and that subclass' Weapon Mastery

Create view CharacterClassMastery As
Select "Character"."Name", "SubClass"."SubClass_name", "Weapon_Mastery".*
from "Character"
Left outer join "SubClass" On
"Character"."SubClass_ID" = "SubClass"."SubClass_ID"
inner join "Weapon_Mastery" on
"SubClass"."SubClass_ID" = "Weapon_Mastery"."SubClass_ID";

select * from CharacterClassMastery;


--This view will return the name, rarity, and price of all Items in your inventory that are not 
-- equipped to any character And that have no residents, ordering them by Base_Price
Create view emptyItems As
Select "Item_Type"."Itemtype_name", "Item_Real"."Rarity", "Item_Type"."Base_Price"
from "Item_Type", "Item_Real"
where "Item_Real"."Resident" is null 
AND "Item_Real"."Equipped" is null
AND "Item_Real"."IsInInventory" = true
AND "Item_Real"."Itemtype_ID" = "Item_Type"."Itemtype_ID"
ORDER BY "Item_Type"."Base_Price" Asc;
drop view emptyItems;

Select * from emptyItems
select * from characterclassmastery


Insert Into "Class"("Class_name", "move_base", "jump_base", "counter_base", "throw_base")
Values
('Thief', 6, 25, 0, 3),
('Archer', 4, 10, 0, 3),
('Healer', 4, 20, 0, 3),
('Mage', 3, 15, 0, 3),
('Heavy_Knight', 3, 15, 1, 6),
('Gunner', 5, 20, 0, 4),
('Prinny', 4, 20, 0, null),
('Flora_Beast', 4, 25, 0, null);

Insert Into "SubClass"("Class_ID", "SubClass_name", "HP_base", "SP_base", "atk_base", "def_base", "int_base", "res_base", "spd_base", "hit_base")
Values
(1, 'Thief', 14, 11, 10, 7, 8, 10, 16, 12),
(1, 'Rogue', 15, 12, 11, 7, 8, 11, 17, 13),
(1, 'Scout', 16, 13, 12, 8, 9, 12, 18, 14),
(1, 'Bandit', 17, 14, 13, 8, 9, 13, 19, 15),
(1, 'Trickster', 18, 15, 14, 9, 10, 14, 20, 16),
(1, 'Master_Thief', 19, 16, 15, 9, 10, 15, 21, 17),
(2, 'Archer', 14, 12, 12, 7, 8, 14, 7, 16),
(2, 'Hunter', 15, 13, 13, 7, 8, 15, 7, 18),
(2, 'Shooter', 16, 14, 14, 8, 9, 16, 8, 20),
(2, 'Bow_Master', 17, 15, 15, 8, 9, 17, 8, 22),
(2, 'Cupid', 18, 16, 16, 9, 10, 18, 9, 24),
(2, 'Freischutz', 19, 17, 17, 9, 10, 19, 9, 26),
(3, 'Healer', 16, 16, 12, 8, 12, 16, 6, 12),
(3, 'Acolyte', 17, 17, 13, 8, 13, 18, 6, 13),
(3, 'Priest', 18, 18, 14, 9, 14, 20, 6, 14),
(3, 'Bishop', 19, 19, 15, 9, 15, 22, 7, 15),
(3, 'Cardinal', 20, 20, 16, 10, 16, 24, 7, 16),
(3, 'Saint', 21, 21, 17, 10, 17, 26, 7, 17),
(4, 'Red_Mage', 10, 18, 6, 6, 16, 14, 8, 10),
(4, 'Blue_Mage', 10, 18, 6, 6, 16, 14, 8, 10),
(4, 'Green_Mage', 10, 18, 6, 6, 16, 14, 8, 10),
(4, 'Star_Mage', 12, 20, 7, 7, 18, 16, 9, 13),
(4, 'Prism_Mage', 13, 22, 7, 7, 20, 18, 10, 14),
(4, 'Galaxy_Mage', 14, 24, 7, 7, 22, 20, 11, 15),
(5, 'Heavy_Knight', 28, 7, 15, 16, 6, 12, 6, 10),
(5, 'Iron_Knight', 32, 7, 16, 18, 6, 13, 6, 11),
(5, 'Steel_Knight', 36, 8, 17, 20, 6, 14, 6, 12),
(5, 'Mythril_Knight', 40, 8, 18, 22, 7, 15, 7, 13),
(5, 'Adamant_Knight', 44, 9, 19, 24, 7, 16, 7, 14),
(5, 'Aegis_Knight', 48, 9, 20, 26, 7, 17, 7, 15),
(6, 'Gunner', 16, 10, 6, 8, 7, 13, 14, 16),
(6, 'Sniper', 17, 11, 6, 8, 7, 14, 15, 17),
(6, 'Outlaw', 18, 12, 7, 9, 8, 15, 16, 18),
(6, 'Hitman', 19, 13, 7, 9, 8, 16, 17, 19),
(6, 'Bullseye', 20, 14, 8, 10, 9, 17, 18, 20),
(6, 'Desperado', 21, 15, 8, 10, 9, 18, 19, 21),
(7, 'Pvt. Prinny', 18, 12, 14, 8, 8, 10, 10, 14),
(7, 'Cpt. Prinny', 20, 13, 15, 8, 8, 10, 10, 15),
(7, 'Col. Prinny', 22, 14, 16, 9, 9, 11, 11, 16),
(7, 'Gen. Prinny', 24, 15, 17, 9, 9, 11, 11, 17),
(7, 'Prinny King', 26, 16, 18, 10, 10, 12, 12, 18),
(7, 'Prinny God', 28, 17, 19, 10, 10, 12, 12, 19),
(8, 'Alraune', 14, 13, 12, 7, 13, 16, 6, 12),
(8, 'Nemophila', 15, 14, 13, 7, 14, 18, 6, 13),
(8, 'Pharbitis', 16, 15, 14, 8, 15, 20, 6, 14),
(8, 'Belladonna', 17, 16, 15, 8, 16, 22, 7, 15),
(8, 'Photinia', 18, 17, 16, 9, 17, 24, 7, 16),
(8, 'Parthenocissus', 19, 18, 17, 9, 18, 26, 7, 17);

Insert Into "Weapon_Mastery"("SubClass_ID", "Sword_Mastery", "Spear_Mastery", "Axe_Mastery", "Fist_Mastery", "Staff_Mastery", "Gun_Mastery", "Bow_Mastery")
Values
(1, 'C', 'D', 'E', 'C', 'D', 'C', 'C'),
(2, 'C', 'D', 'E', 'C', 'D', 'B', 'B'),
(3, 'C', 'C', 'E', 'C', 'D', 'B', 'B'),
(4, 'B', 'C', 'E', 'B', 'D', 'A', 'A'),
(5, 'B', 'C', 'E', 'B', 'C', 'A', 'A'),
(6, 'B', 'C', 'E', 'B', 'C', 'A', 'A'),

(7, 'D', 'C', 'E', 'D', 'D', 'C', 'A'),
(8, 'D', 'C', 'E', 'D', 'D', 'C', 'A'),
(9, 'C', 'C', 'E', 'D', 'C', 'C', 'A'),
(10, 'C', 'B', 'E', 'D', 'C', 'B', 'S'),
(11, 'C', 'B', 'E', 'D', 'C', 'B', 'S'),
(12, 'C', 'B', 'E', 'D', 'C', 'B', 'S'),

(13, 'C', 'C', 'D', 'D', 'C', 'D', 'C'),
(14, 'B', 'B', 'C', 'C', 'B', 'C', 'B'),
(15, 'B', 'B', 'C', 'C', 'B', 'C', 'B'),
(16, 'B', 'B', 'C', 'C', 'B', 'C', 'B'),
(17, 'A', 'A', 'C', 'C', 'A', 'C', 'A'),
(18, 'A', 'A', 'C', 'C', 'A', 'C', 'A'),

(19, 'D', 'D', 'E', 'D', 'A', 'C', 'C'),
(20, 'D', 'D', 'E', 'D', 'A', 'C', 'C'),
(21, 'D', 'D', 'E', 'D', 'A', 'C', 'C'),
(22, 'D', 'D', 'E', 'D', 'A', 'C', 'C'),
(23, 'D', 'D', 'E', 'D', 'S', 'C', 'C'),
(24, 'D', 'D', 'E', 'D', 'S', 'B', 'B'),

(25, 'B', 'B', 'B', 'D', 'E', 'E', 'E'),
(26, 'B', 'A', 'B', 'D', 'E', 'E', 'E'),
(27, 'A', 'A', 'A', 'D', 'E', 'E', 'E'),
(28, 'A', 'A', 'A', 'D', 'E', 'E', 'E'),
(29, 'S', 'S', 'S', 'C', 'E', 'E', 'E'),
(30, 'S', 'S', 'S', 'C', 'E', 'E', 'E'),

(31, 'E', 'E', 'E', 'C', 'E', 'A', 'C'),
(32, 'E', 'E', 'E', 'C', 'E', 'A', 'C'),
(33, 'D', 'D', 'D', 'C', 'D', 'A', 'C'),
(34, 'D', 'D', 'D', 'C', 'D', 'S', 'C'),
(35, 'D', 'D', 'D', 'C', 'D', 'S', 'C'),
(36, 'D', 'D', 'D', 'B', 'D', 'S', 'B');

Insert into "Stats_Aptitude"("SubClass_ID", "hp_apt", "sp_apt", "atk_apt", "def_apt", "int_apt", "res_apt", "spd_apt", "hit_apt")
Values
(1, 80, 100, 100, 70, 80, 90, 110, 100),
(2, 80, 100, 100, 70, 80, 90, 110, 110),
(3, 80, 100, 100, 70, 80, 90, 120, 110),
(4, 90, 110, 110, 80, 90, 100, 120, 110),
(5, 90, 110, 110, 80, 90, 100, 130, 120),
(6, 90, 110, 110, 80, 90, 100, 130, 120),

(7, 80, 100, 100, 80, 80, 100, 80, 110),
(8, 80, 100, 100, 80, 80, 100, 80, 110),
(9, 80, 100, 100, 80, 80, 110, 80, 120),
(10, 90, 110, 110, 90, 90, 110, 90, 120),
(11, 90, 110, 110, 90, 90, 120, 90, 130),
(12, 90, 110, 110, 90, 90, 120, 90, 130),

(13, 90, 100, 90, 80, 90, 110, 60, 90),
(14, 90, 100, 90, 80, 90, 110, 60, 90),
(15, 90, 110, 100, 80, 100, 120, 60, 90),
(16, 100, 110, 100, 90, 100, 120, 70, 100),
(17, 100, 120, 110, 90, 110, 130, 100, 70),
(18, 100, 100, 110, 90, 110, 130, 70, 100),

(19, 70, 110, 70, 70, 110, 100, 80, 90),
(20, 70, 110, 70, 70, 110, 100, 80, 90),
(21, 70, 110, 70, 70, 110, 100, 80, 90),
(22, 70, 120, 70, 70, 120, 110, 80, 90),
(23, 80, 130, 80, 80, 130, 120, 90, 100),
(24, 80, 130, 80, 80, 130, 120, 90, 100),


(25, 120, 70, 100, 110, 60, 100, 60, 90),
(26, 120, 70, 100, 110, 60, 100, 60, 90),
(27, 130, 70, 110, 120, 60, 110, 60, 90),
(28, 130, 80, 110, 120, 70, 110, 70, 100),
(29, 140, 80, 120, 130, 70, 120, 70, 100),
(30, 140, 80, 120, 130, 70, 120, 70, 100),
(31, 90, 90, 70, 90, 70, 100, 100, 110),
(32, 90, 90, 70, 90, 70, 100, 100, 110),
(33, 90, 90, 70, 90, 70, 110, 110, 120),
(34, 100, 100, 80, 100, 80, 110, 110, 120),
(35, 100, 100, 80, 100, 80, 120, 120, 130),
(36, 100, 100, 80, 100, 80, 120, 120, 130),

(37, 100, 100, 100, 80, 80, 90, 90, 100),
(38, 100, 100, 100, 80, 80, 90, 90, 100),
(39, 110, 100, 110, 80, 80, 90, 90, 110),
(40, 110, 110, 110, 90, 90, 100, 100, 110),
(41, 120, 110, 120, 90, 90, 100, 100, 120),
(42, 120, 110, 120, 90, 90, 100, 100, 120),

(43, 90, 100, 100, 70, 100, 110, 60, 100),
(44, 90, 100, 100, 70, 100, 110, 60, 100),
(45, 90, 110, 100, 70, 110, 120, 60, 100),
(46, 100, 110, 110, 80, 110, 120, 70, 110),
(47, 100, 120, 110, 80, 120, 130, 80, 110),
(48, 100, 120, 110, 80, 120, 130, 80, 110);

Insert Into "Skills"("Skill_Name", "Level_Aquired", "Effect", "SP_Required", "Height")
Values
('Health', 1, 'Psn', 8, 16),
('Consciousness', 8, 'Slp', 16, 16),
('Freedom', 20, 'Prz', 8, 16),
('Memory', 40, 'Amn', 8, 16),

('Magic Wall', 10, 'Res', 8, 24),
('Braveheart', 13, 'Atk', 8, 24),
('Target Lock', 20, 'Hit', 8, 24),
('Speed Boost', 40, 'Spd', 8, 24),
('Magic Boost', 50, 'Int', 8, 24),

('Elem', 1, 'Int', 10, 48),
('Mega_Elem', 10, 'Int', 15, 48),
('Giga_Elem', 25, 'Int', 45, 48),
('Omega_Elem', 50, 'Int', 135, 48),
('Tera_Elem', 80, 'Int', 405, 48),

('Prinny_Dance', 14, 'Atk', 30, 24),
('Prinny_Bomb', 34, 'Atk', 80, 12),

('Flower_Dance', 15, 'Res', 28, 24),

('Tri_Burst', 1, 'Hit', 8, 20),
('Proximal_Shot', 6, 'Hit', 32, 12),
('Inferno', 21, 'Hit', 256, 18),

('Triple_strike', 1, 'Atk', 8, 12),
('Rising_Dragon', 15, 'Atk', 124, 12);

Insert Into "Skill_Relations"("Skill_ID", "Class_ID")
Values
(1,1),
(2,1),
(3,1),
(4,1),
(5,3),
(5,4),
(6,3),
(6,5),
(7,3),
(8,3),
(9,3),
(9,4),
(10,3),
(10,4), 
(11,3),
(11,4),
(12,3),
(12,4),
(13,3),
(13,4),
(14,3),
(14,4),
(15,7),
(16,7),
(17,8),
(18,1),
(18,2),
(18,6),
(19,1),
(19,2),
(19,6),
(20,1),
(20,2),
(20,6),
(21,1),
(21,5),
(21,6),
(22,1),
(22,5),
(22,6);

Insert Into "Character"("SubClass_ID", "Name", "Title", "Level", "Felony_count", "exp")
Values
(36, 'Alan', 'Awesome Badass', 33, 3, 67),
(26, 'Chris', 'Unwanted V7000', 2, 7, 12),
(4, 'Jess', 'Sneaky_Bandit', 34, 7, 78),
(46, 'Charles', 'Unfortunate_Soul', 21, 99, 6),
(8, 'Nat', 'Bow_Hunter', 18, 0, 12),
(40, 'Billy', 'Xbox_Player', 17, 2, 2),
(19, 'Maddie', 'The_Red_one', 6, 2, 47),
(20, 'Mattie', 'The_Blue_one', 25, 1, 89),
(34, 'Grumpus', 'One_Bad_Dude', 17, 0, 33);

Insert Into "Char_Skills"("Char_ID", "Skill_ID")
Values
(1,18),
(1,19),
(1,20),
(1,21),
(1,22),
(2,6),
(3,1),
(3,2),
(3,3),
(4,17),
(6,15),
(7,10),
(8,10),
(8,11),
(8,12),
(8,5),
(9,18),
(9,19),
(9,21),
(9,22);


Insert Into "Specialist"("Spec_ID", "Specialist_type", "Effect_cap", "Is_Subdued")
Values
(6, 'Nerd', 19998, True),
(9, 'Witch Doctor', 100, False);



Insert Into "Item_Type"("Itemtype_name", "Rank", "HP_mod", "SP_mod", "atk_mod", "def_mod", "int_mod", "res_mod", "hit_mod", "spd_mod", "move_mod", "jump_mod", "Base_Price", "Equippable", "EquipType")
Values
('Almighty_Armor', 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 10, True, 'Armor'),
('Magical_Vest', 12, 0, 12, 0, 91, 8, 26, 0, 0, 0, 0, 2400, True, 'Armor'),
('Iron_Dress', 27, 140, 80, 0, 406, 0, -20, 0, -90, 0, 0, 1000000, True, 'Armor'),
('Infernal_Armor', 39, 800, 300, 400, 1800, 200, 400, 0, 0, 0, 0, 125000000, True, 'Armor'),
('Dream_Muscle', 26, 900, 0, 0, 0, 0, 0, 0, 0, 0, 0, 800000, True, 'Armor'),
('Falcon_Shoes', 25, 0, 0, 0, 0, 0, 0, 0, 100, 1, 20, 650000, True, 'Armor'),
('Crosshair', 26, 0, 0, 0, 0, 90, 0, 220, 0, 0, 0, 800000, True, 'Armor'),

('Lazy_Sword', 1, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 30, True, 'Sword'),
('Ninja_Blade', 12, 0, 0, 105, 0, 0, 0, 15, 25, 0, 0, 24000, True, 'Sword'),
('Crystal_Sword', 25, 0, 60, 378, 0, 170, 100, 60, 0, 0, 0, 650000, True, 'Sword'),

('Spiked_Gloves', 10, 0, 0, 68, 0, 0, 0, 0, 68, 0, 0, 12500, True, 'Fist'),
('Knuckle_Bomber', 19, 60, 0, 212, 0, 0, 0, -10, 212, 0, 0, 160000, True, 'Fist'),

('Trident', 11, 0, 0, 80, 35, 0, 0, 12, 12, 0, 0, 18000, True, 'Spear'),

('Assassin_Bow', 6, 0, 0, 24, 0, 0, 0, 24, 10, 0, 0, 1800, True, 'Bow'),
('Luminous_Bow', 33, 0, 180, 564, 0, 0, 240, 564, 0, 0, 0, 8400000, True, 'Bow'),

('44_Magnum', 5, 0, 0, 0, 0, 0, 0, 18, 0, 0, 0, 1100, True, 'Gun'),
('Heroic_Gun', 37, 200, 160, 0, 80, 0, 180, 730, 200, 0, 0, 36000000, True, 'Gun'),

('Battle_Axe', 6, 0, 0, 48, 8, 0, 0, -12, 0, 0, 0, 1800, True, 'Axe'),
('Serial_Axe', 20, 85, 0, 294, 30, -40, -20, -102, 30, 0, 0, 200000, True, 'Axe'),

('Fancy_Rod', 11, 0, 10, 69, 0, 80, 0, 0, 10, 0, 0, 18000, True, 'Staff'),
('Wizards_Rod', 27, 0, 80, 381, 0, 408, 45, 75, 0, 0, 0, 1000000, True, 'Staff'),

('Pizza', 1, 500, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, False, 'Food'),
('Protein_Shake', 25, 0, 300, 0, 0, 0, 0, 0, 0, 0, 0, 2000, False, 'Food'),
('Chicken_Blood', 7, 150, 50, 0, 0, 0, 0, 0, 0, 0, 0, 600, False, 'Food'),

('Cell_Phone', 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5000, False, 'Misc');

Insert Into "Item_Real"("Itemtype_ID", "Equipped", "Resident", "Rarity", "IsInInventory")
Values
(25, Null, Null, 0, True),
(22, Null, Null, 2, True),
(22, Null, Null, 3, True),
(24, Null, Null, 0, True),
(20, 9, Null, 13, False),
(2, Null, Null, 0, True),
(3, Null, Null, 3, True),
(9, 4, Null, 12, True),
(10, 3, Null, 37, True),
(7, 1, 9, 33, True),
(4, 1, Null, 5, True),
(8, 2, Null, 2, True),
(6, 2, Null, 1, True),
(3, 8, Null, 7, True),
(23, Null, Null, 1, False),
(5, 6, Null, 13, True),
(1, Null, Null, 0, True),
(11, Null, Null, 44, False),
(12, 8, Null, 1, True),
(13, 7, Null, 2, True),
(4, 7, Null, 4, True),
(4, 6, Null, 5, True),
(5, 4, Null, 7, True),
(5, 2, Null, 2, True),
(6, 3, Null, 17, True),
(15, Null, Null, 22, True),
(16, Null, Null, 24, True),
(17, Null, Null, 22, True),
(18, 5, Null, 11, True),
(19, 9, Null, 12, False),
(20, Null, Null, 0, False);



 





