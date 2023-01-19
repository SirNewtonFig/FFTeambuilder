class Character::MemgenContext < ActiveInteractor::Context::Base
  attributes :character, :slot, :palette
  attribute :block, default: -> { [] }

  validates :character, :slot, :palette, presence: true
end

class Character::Memgen < ActiveInteractor::Base
  RAW_CONST = 1638400

  CHARACTER_SETS = {
    'm' => '80',
    'f' => '81',
    'x' => '82'
  }

  SEXES = {
    'm' => '80',
    'f' => '40',
    'x' => '20'
  }

  ZODIACS = {
    'aries' => '00',
    'taurus' => '10',
    'gemini' => '20',
    'cancer' => '30',
    'leo' => '40',
    'virgo' => '50',
    'libra' => '60',
    'scorpio' => '70',
    'sagittarius' => '80',
    'capricorn' => '90',
    'aquarius' => 'A0',
    'pisces' => 'B0'
  }

  PRIMARIES = {
    'Squire' => '4a',
    'Chemist' => '4b',
    'Knight' => '4c',
    'Marksman' => '4d',
    'Monk' => '4e',
    'Priest' => '4f',
    'Wizard' => '50',
    'Time Mage' => '51',
    'Summoner' => '52',
    'Thief' => '53',
    'Mediator' => '54',
    'Oracle' => '55',
    'Geomancer' => '56',
    'Lancer' => '57',
    'Samurai' => '58',
    'Ninja' => '59',
    'Sage' => '5a',
    'Bard' => '5b',
    'Dancer' => '5c',
    'Mime' => '5d',
    'Chocobo' => '5e',
    'Black Chocobo' => '5f',
    'Red Chocobo' => '60',
    'Goblin' => '61',
    'Black Goblin' => '62',
    'Gobbledeguck' => '63',
    'Bomb' => '64',
    'Grenade' => '65',
    'Explosive' => '66',
    'Tonberry' => '67',
    'Master Tonberry' => '68',
    'Blood Stalker' => '69',
    'Pisco Demon' => '6a',
    'Squidlarkin' => '6b',
    'Mindflare' => '6c',
    'Skeleton' => '6d',
    'Bone Snatch' => '6e',
    'Living Bone' => '6f',
    'Ghoul' => '70',
    'Gust' => '71',
    'Revnant' => '72',
    'Flotiball' => '73',
    'Ahriman' => '74',
    'Plague' => '75',
    'Juravis' => '76',
    'Steel Hawk' => '77',
    'Cocatoris' => '78',
    'Uribo' => '79',
    'Porky' => '7a',
    'Wildbow' => '7b',
    'Woodman' => '7c',
    'Trent' => '7d',
    'Taiju' => '7e',
    'Bull Demon' => '7f',
    'Minitaurus' => '80',
    'Sacred' => '81',
    'Morbol' => '82',
    'Ochu' => '83',
    'Great Morbol' => '84',
    'Behemoth' => '85',
    'King Behemoth' => '86',
    'Dark Behemoth' => '87',
    'Dragon' => '88',
    'Blue Dragon' => '89',
    'Red Dragon' => '8a',
    'Hyudra' => '8b',
    'Hydra' => '8c',
    'Tiamat' => '8d'
  }

  SECONDARIES = {
    'Basic Skill' => '05',
    'Item' => '06',
    'Battle Skill' => '07',
    'Precision' => '08',
    'Punch Art' => '09',
    'White Magic' => '0a',
    'Black Magic' => '0b',
    'Time Magic' => '0c',
    'Summon Magic' => '0d',
    'Steal' => '0e',
    'Talk Skill' => '0f',
    'Yin Yang Magic' => '10',
    'Elemental' => '11',
    'Jump' => '12',
    'Draw Out' => '13',
    'Throw' => '14',
    'Planar Magic' => '15',
    'Sing' => '16',
    'Dance' => '17'
  }

  REACTIONS = {
    'A Save' => '01a6',
    'MA Save' => '01a7',
    'CT Save' => '01a8',
    'Sunken State' => '01a9',
    'Caution' => '01aa',
    'Dragon Spirit' => '01ab',
    'Regenerator' => '01ac',
    'Barrier' => '01ad',
    'Meditation' => '01ae',
    'HP Restore' => '01af',
    'MP Restore' => '01b0',
    'Critical Quick' => '01b1',
    'Meatbone Slash' => '01b2',
    'Counter Magic' => '01b3',
    'Counter Throw' => '01b4',
    'Counter Flood' => '01b5',
    'Absorb Used MP' => '01b6',
    'Gilgame Heart' => '01b7',
    'Reflect' => '01b8',
    'Auto Potion' => '01b9',
    'Counter' => '01ba',
    'Distribute' => '01bc',
    'MP Switch' => '01bd',
    'Damage Split' => '01be',
    'Weapon Guard' => '01bf',
    'Finger Guard' => '01c0',
    'Abandon' => '01c1',
    'Catch' => '01c2',
    'Blade Grasp' => '01c3',
    'Arrow Guard' => '01c4',
    'Hamedo' => '01c5'
  }

  SUPPORTS = {
    'Equip Armor' => '01c6',
    'Equip Shield' => '01c7',
    'Equip Sword' => '01c8',
    'Equip Katana' => '01c9',
    'Equip Bows' => '01ca',
    'Equip Spear' => '01cb',
    'Equip Axe' => '01cc',
    'Equip Gun' => '01cd',
    'Half of MP' => '01ce',
    'Gained JP UP' => '01cf',
    'Gained Exp UP' => '01d0',
    'Attack UP' => '01d1',
    'Defense UP' => '01d2',
    'Magic AttackUP' => '01d3',
    'Magic DefendUP' => '01d4',
    'Concentrate' => '01d5',
    'Train' => '01d6',
    'Secret Hunt' => '01d7',
    'Martial Arts' => '01d8',
    'Monster Talk' => '01d9',
    'Throw Item' => '01da',
    'Maintenance' => '01db',
    'Two Hands' => '01dc',
    'Two Swords' => '01dd',
    'Monster Skill' => '01de',
    'Defend' => '01df',
    'Equip Change' => '01e0',
    'EMPTY' => '01e1',
    'Short Charge' => '01e2',
    'Non-Charge' => '01e3'
  }

  MOVEMENTS = {
    'Move+1' => '01e6',
    'Move+2' => '01e7',
    'Move+3' => '01e8',
    'Jump+1' => '01e9',
    'Jump+2' => '01ea',
    'Jump+3' => '01eb',
    'Ignore Height' => '01ec',
    'Move-HP Up' => '01ed',
    'Move-MP Up' => '01ee',
    'Move-Get Exp' => '01ef',
    'Move-Get JP' => '01f0',
    'BLANK' => '01f1',
    'Teleport' => '01f2',
    'Teleport2' => '01f3',
    'Any Weather' => '01f4',
    'Any Ground' => '01f5',
    'Walk on Water' => '01f6',
    'Move in Water' => '01f7',
    'Move on Lava' => '01f8',
    'Move underwater' => '01f9',
    'Float' => '01fa',
    'Fly' => '01fb',
    'Silent Walk' => '01fc',
    'Move-Find Item' => '01fd'
  }

  HELMETS = {
    'Leather Helmet' => '90',
    'Bronze Helmet' => '91',
    'Iron Helmet' => '92',
    'Barbuta' => '93',
    'Mythril Helmet' => '94',
    'Gold Helmet' => '95',
    'Cross Helmet' => '96',
    'Diamond Helmet' => '97',
    'Platina Helmet' => '98',
    'Circlet' => '99',
    'Crystal Helmet' => '9a',
    'Genji Helmet' => '9b',
    'Grand Helmet' => '9c',
    'Leather Hat' => '9d',
    'Feather Hat' => '9e',
    'Red Hood' => '9f',
    'Headgear' => 'a0',
    'Triangle Hat' => 'a1',
    'Green Beret' => 'a2',
    'Twist Headband' => 'a3',
    'Holy Miter' => 'a4',
    'Black Hood' => 'a5',
    'Golden Hairpin' => 'a6',
    'Flash Hat' => 'a7',
    'Thief Hat' => 'a8',
    'Cachusha' => 'a9',
    'Barette' => 'aa',
    'Ribbon' => 'ab'
  }

  ARMORS = {
    'Leather Armor' => 'ac',
    'Linen Cuirass' => 'ad',
    'Bronze Armor' => 'ae',
    'Chain Mail' => 'af',
    'Mythril Armor' => 'b0',
    'Plate Mail' => 'b1',
    'Gold Armor' => 'b2',
    'Diamond Armor' => 'b3',
    'Platina Armor' => 'b4',
    'Carabini Mail' => 'b5',
    'Crystal Mail' => 'b6',
    'Genji Armor' => 'b7',
    'Reflect Mail' => 'b8',
    'Maximillian' => 'b9',
    'Clothes' => 'ba',
    'Leather Outfit' => 'bb',
    'Leather Vest' => 'bc',
    'Chain Vest' => 'bd',
    'Mythril Vest' => 'be',
    'Adaman Vest' => 'bf',
    'Wizard Outfit' => 'c0',
    'Brigandine' => 'c1',
    'Judo Outfit' => 'c2',
    'Power Sleeve' => 'c3',
    'Earth Clothes' => 'c4',
    'Secret Clothes' => 'c5',
    'Black Costume' => 'c6',
    'Rubber Costume' => 'c7',
    'Linen Robe' => 'c8',
    'Silk Robe' => 'c9',
    'Wizard Robe' => 'ca',
    'Chameleon Robe' => 'cb',
    'White Robe' => 'cc',
    'Black Robe' => 'cd',
    'Light Robe' => 'ce',
    'Robe of Lords' => 'cf'
  }

  ACCESSORIES = {
    'Battle Boots' => 'd0',
    'Spike Shoes' => 'd1',
    'Germinas Boots' => 'd2',
    'Rubber Shoes' => 'd3',
    'Feather Boots' => 'd4',
    'Sprint Shoes' => 'd5',
    'Red Shoes' => 'd6',
    'Power Wrist' => 'd7',
    'Genji Gauntlet' => 'd8',
    'Magic Gauntlet' => 'd9',
    'Heroic Gloves' => 'da',
    'Reflect Ring' => 'db',
    'Defense Ring' => 'dc',
    'Magic Ring' => 'dd',
    'Cursed Ring' => 'de',
    'Angel Ring' => 'df',
    'Diamond Armlet' => 'e0',
    'Jade Armlet' => 'e1',
    '108 Gems' => 'e2',
    'N-Kai Armlet' => 'e3',
    'Defense Armlet' => 'e4',
    'Small Mantle' => 'e5',
    'Leather Mantle' => 'e6',
    'Wizard Mantle' => 'e7',
    'Elf Mantle' => 'e8',
    'Dracula Mantle' => 'e9',
    'Feather Mantle' => 'ea',
    'Vanish Mantle' => 'eb',
    'Chantage' => 'ec',
    'Cherche' => 'ed',
    'Setiemson' => 'ee',
    'Salty Rage' => 'ef'
  }

  WEAPONS = {
    "Dagger" => '01',
    "Mythril Knife" => '02',
    "Blind Knife" => '03',
    "Mage Masher" => '04',
    "Platina Dagger" => '05',
    "Main Gauche" => '06',
    "Orichalcum" => '07',
    "Assassin Dagger" => '08',
    "Air Knife" => '09',
    "Tonberry Knife" => '0a',
    "Hidden Knife" => '0b',
    "Ninja Knife" => '0c',
    "Short Edge" => '0d',
    "Ninja Edge" => '0e',
    "Spell Edge" => '0f',
    "Sasuke Knife" => '10',
    "Iga Knife" => '11',
    "Koga Knife" => '12',
    "Broad Sword" => '13',
    "Long Sword" => '14',
    "Parrying Sword" => '15',
    "Mythril Sword" => '16',
    "Blood Sword" => '17',
    "Coral Sword" => '18',
    "Ancient Sword" => '19',
    "Scramasax" => '1a',
    "Paladin Sword" => '1b',
    "Demon Hilt" => '1c',
    "Ice Brand" => '1d',
    "Slasher" => '1e',
    "Nagrarock" => '1f',
    "Materia Blade" => '20',
    "Defender" => '21',
    "Save the Queen" => '22',
    "Excalibur" => '23',
    "Ragnarok" => '24',
    "Chaos Blade" => '25',
    "Asura Knife" => '26',
    "Koutetsu Knife" => '27',
    "Bizen Boat" => '28',
    "Murasame" => '29',
    "Heaven's Cloud" => '2a',
    "Kiyomori" => '2b',
    "Muramasa" => '2c',
    "Kikuichimonji" => '2d',
    "Masamune" => '2e',
    "Chirijiraden" => '2f',
    "Battle Axe" => '30',
    "Golem Axe" => '31',
    "Tidal Axe" => '32',
    "Rod" => '33',
    "Thunder Rod" => '34',
    "Flame Rod" => '35',
    "Water Rod" => '36',
    "Poison Rod" => '37',
    "Wizard Rod" => '38',
    "Dragon Rod" => '39',
    "Faith Rod" => '3a',
    "Oak Staff" => '3b',
    "White Staff" => '3c',
    "Healing Staff" => '3d',
    "Rainbow Staff" => '3e',
    "Wizard Staff" => '3f',
    "Gold Staff" => '40',
    "Mace of Zeus" => '41',
    "Sage Staff" => '42',
    "Flail" => '43',
    "Flame Whip" => '44',
    "Morning Star" => '45',
    "Scorpion Tail" => '46',
    "Romanda Gun" => '47',
    "Chocobo Gun" => '48',
    "Stone Gun" => '49',
    "Summon Gun" => '4a',
    "Magic Cannon" => '4b',
    "Engineer Rifle" => '4c',
    "Bow Gun" => '4d',
    "Night Killer" => '4e',
    "Lava Bolt" => '4f',
    "Arbalest" => '50',
    "Hunting Bow" => '51',
    "Gastrafitis" => '52',
    "Long Bow" => '53',
    "Silver Bow" => '54',
    "Ice Bow" => '55',
    "Lightning Bow" => '56',
    "Windslash Bow" => '57',
    "Mythril Bow" => '58',
    "Ultimus Bow" => '59',
    "Cupid Bow" => '5a',
    "Perseus Bow" => '5b',
    "Ramia Harp" => '5c',
    "Bloody Strings" => '5d',
    "Fairy Harp" => '5e',
    "Battle Dict" => '5f',
    "Monster Dict" => '60',
    "Papyrus Plate" => '61',
    "Madlemgen" => '62',
    "Javelin" => '63',
    "Spear" => '64',
    "Mythril Spear" => '65',
    "Partisan" => '66',
    "Oberisk" => '67',
    "Holy Lance" => '68',
    "Dragon Whisker" => '69',
    "Javelin II" => '6a',
    "Cypress Rod" => '6b',
    "Battle Bamboo" => '6c',
    "Musk Rod" => '6d',
    "Iron Fan" => '6e',
    "Gokuu Rod" => '6f',
    "Ivory Rod" => '70',
    "Octagon Rod" => '71',
    "Whale Whisker" => '72',
    "G Bag" => '73',
    "FS Bag" => '74',
    "P Bag" => '75',
    "H Bag" => '76',
    "Persia" => '77',
    "Cashmere" => '78',
    "Ryozan Silk" => '79'
  }

  SHIELDS = {
    'Escutcheon' => '80',
    'Buckler' => '81',
    'Bronze Shield' => '82',
    'Round Shield' => '83',
    'Mythril Shield' => '84',
    'Gold Shield' => '85',
    'Ice Shield' => '86',
    'Flame Shield' => '87',
    'Aegis Shield' => '88',
    'Diamond Shield' => '89',
    'Platina Shield' => '8a',
    'Crystal Shield' => '8b',
    'Genji Shield' => '8c',
    'Kaiser Plate' => '8d',
    'Venetian Shield' => '8e',
    'Escutcheon II' => '8f'
  }

  SKILLFLAGS_JOBS = ['Squire', 'Chemist', 'Knight', 'Marksman', 'Monk', 'Priest', 'Wizard', 'Time Mage', 'Summoner', 'Thief', 'Mediator', 'Oracle', 'Geomancer', 'Lancer', 'Samurai', 'Ninja', 'Sage', 'Bard', 'Dancer']

  SKILLFLAGS_MAP = {
    "Squire"=>                                                              
    {"Defy Pain"=>"0x8000",                                                
     "Throw Stone"=>"0x4000",                                              
     "Heal"=>"0x2000",                                                     
     "Wish"=>"0x1000",                                                     
     "Cheer Up"=>"0x0800",                                                 
     "Target"=>"0x0400",                                                   
     "Wild Swing"=>"0x0200",                                               
     "Warn"=>"0x0100"},                                                    
   "Chemist"=>                                                             
    {"Potion"=>"0x8000",
     "Hi-Potion"=>"0x4000",
     "X-Potion"=>"0x2000",
     "Ether"=>"0x1000",
     "Hi-Ether"=>"0x0800",
     "Mega Potion"=>"0x0200",
     "Echo Grass"=>"0x0080",
     "Maiden's Kiss"=>"0x0040",
     "Soft"=>"0x0020",
     "Holy Water"=>"0x0010",
     "Remedy"=>"0x0008",
     "Phoenix Down"=>"0x0004",
     "Power Source"=>"0x0002"},
   "Knight"=>
    {"Power Ruin"=>"0x8000",
     "Mind Ruin"=>"0x4000",
     "Speed Ruin"=>"0x2000",
     "Magic Ruin"=>"0x1000",
     "Shellbust Stab"=>"0x0800",
     "Blastar Punch"=>"0x0400",
     "Hellcry Punch"=>"0x0200",
     "Icewolf Bite"=>"0x0100"},
   "Marksman"=>
    {"Timed Strike"=>"0x8000",
     "Stunning Strike"=>"0x4000",
     "Cursed Strike"=>"0x2000",
     "Mocking Strike"=>"0x1000",
     "Heartache Strike"=>"0x0800",
     "Temporal Strike"=>"0x0400"},
   "Monk"=>
    {"Spin Fist"=>"0x8000",
     "Repeating Fist"=>"0x4000",
     "Wave Fist"=>"0x2000",
     "Earth Slash"=>"0x1000",
     "Secret Fist"=>"0x0800",
     "Stigma Magic"=>"0x0400",
     "Chakra"=>"0x0200",
     "Revive"=>"0x0100"},
   "Priest"=>
    {"Cure"=>"0x8000",
     "Holy Strike"=>"0x4000",
     "Rejuvenate"=>"0x2000",
     "Flash Heal"=>"0x1000",
     "Life"=>"0x0800",
     "Full Life"=>"0x0400",
     "Reraise"=>"0x0200",
     "Regen"=>"0x0100",
     "Protect"=>"0x0080",
     "Shell"=>"0x0040",
     "Wall"=>"0x0020",
     "Esuna"=>"0x0010",
     "Holy"=>"0x0008"},
   "Wizard"=>
    {"Explosion"=>"0x8000",
     "Chain Lightning"=>"0x4000",
     "Cyclone"=>"0x2000",
     "Mjollnir"=>"0x1000",
     "Blizzard"=>"0x0800",
     "Comet"=>"0x0400",
     "Meltdown"=>"0x0200",
     "Frog"=>"0x0100",
     "Dark Holy"=>"0x0080"},
   "Time Mage"=>
    {"Haste"=>"0x8000",
     "Haste 2"=>"0x4000",
     "Slow"=>"0x2000",
     "Slow 2"=>"0x1000",
     "Stop"=>"0x0800",
     "Don't Move"=>"0x0400",
     "Reflect"=>"0x0100",
     "Quick"=>"0x0080",
     "Demi"=>"0x0040",
     "Demi 2"=>"0x0020",
     "Meteor"=>"0x0010"},
   "Summoner"=>
    {"Moogle"=>"0x8000",
     "Shiva"=>"0x4000",
     "Ramuh"=>"0x2000",
     "Ifrit"=>"0x1000",
     "Fairy"=>"0x0800",
     "Silf"=>"0x0400",
     "Carbunkle"=>"0x0200",
     "Titan"=>"0x0100",
     "Odin"=>"0x0080",
     "Salamander"=>"0x0040",
     "Lich"=>"0x0020",
     "Leviathan"=>"0x0010",
     "Bahamut"=>"0x0008",
     "Cyclops"=>"0x0004",
     "Zodiac"=>"0x0002"},
   "Thief"=>
    {"Gil Toss"=>"0x8000",
     "Steal Energy"=>"0x4000",
     "Steal Heart"=>"0x2000",
     "Steal Strength"=>"0x1000",
     "Backstab"=>"0x0800",
     "Throat Punch"=>"0x0400",
     "Kidney Shot"=>"0x0200",
     "Disarm"=>"0x0100"},
   "Mediator"=>
    {"Invitation"=>"0x8000",
     "Persuade"=>"0x4000",
     "Threaten"=>"0x1000",
     "Preach"=>"0x0800",
     "Solution"=>"0x0400",
     "Death Sentence"=>"0x0200",
     "Insult"=>"0x0100",
     "Mimic Daravon"=>"0x0080"},
   "Oracle"=>
    {"Blind"=>"0x4000",
     "Spell Absorb"=>"0x2000",
     "Pray Faith"=>"0x1000",
     "Doubt Faith"=>"0x0800",
     "Zombie"=>"0x0400",
     "Silence Song"=>"0x0200",
     "Blind Rage"=>"0x0100",
     "Petrify"=>"0x0080",
     "Confusion Song"=>"0x0040",
     "Dispel Magic"=>"0x0020",
     "Paralyze"=>"0x0010",
     "Sleep"=>"0x0008"},
   "Geomancer"=>
    {"Pitfall"=>"0x8000",
     "Waterball"=>"0x4000",
     "Hell Ivy"=>"0x2000",
     "Carve Model"=>"0x1000",
     "Local Quake"=>"0x0800",
     "Kamaitachi"=>"0x0400",
     "Demon Fire"=>"0x0200",
     "Quicksand"=>"0x0100",
     "Sand Storm"=>"0x0080",
     "Blizzard"=>"0x0040",
     "Gusty Wind"=>"0x0020",
     "Lava Ball"=>"0x0010"},
   "Lancer"=>{"Range 4"=>"0x8000", "Range 5"=>"0x4000", "Range 6"=>"0x2000", "Vertical 5"=>"0x1000", "Vertical 7"=>"0x0800", "Infinite Vertical"=>"0x0400"},
   "Samurai"=>
    {"Asura"=>"0x8000",
     "Koutetsu"=>"0x4000",
     "Bizen Boat"=>"0x2000",
     "Murasame"=>"0x1000",
     "Heaven's Cloud"=>"0x0800",
     "Kiyomori"=>"0x0400",
     "Muramasa"=>"0x0200",
     "Kikuichimonji"=>"0x0100",
     "Masamune"=>"0x0080",
     "Chirijiraden"=>"0x0040",
     "Stasis Sword"=>"0x0020",
     "Split Punch"=>"0x0010",
     "Crush Punch"=>"0x0008",
     "Lightning Stab"=>"0x0004",
     "Holy Explosion"=>"0x0002"},
   "Ninja"=>
    {"Shuriken"=>"0x8000",
     "Ball"=>"0x4000",
     "Knife"=>"0x2000",
     "Sword"=>"0x1000",
     "Hammer"=>"0x0800",
     "Ninja Sword"=>"0x0200",
     "Stick"=>"0x0040",
     "Dictionary"=>"0x0010"},
   "Sage"=>
    {"Zombie 2"=>"0x8000",
     "Sleep 2"=>"0x4000",
     "Confuse 2"=>"0x2000",
     "Toad 2"=>"0x1000",
     "Gravi 2"=>"0x0800",
     "Flare 2"=>"0x0400",
     "Despair 2"=>"0x0200",
     "Deathspell 2"=>"0x0100"},
   "Bard"=>{"Angel Song"=>"0x8000", "Life Song"=>"0x4000", "Battle Song"=>"0x1000", "Magic Song"=>"0x0800", "Nameless Song"=>"0x0400", "Last Song"=>"0x0200"},
   "Dancer"=>{"Witch Hunt"=>"0x8000", "Wiznaibus"=>"0x4000", "Polka Polka"=>"0x1000", "Disillusion"=>"0x0800", "Nameless Dance"=>"0x0400"}
  }

  TEXT_ENCODINGS = {
    "0" => '00',
    "1" => '01',
    "2" => '02',
    "3" => '03',
    "4" => '04',
    "5" => '05',
    "6" => '06',
    "7" => '07',
    "8" => '08',
    "9" => '09',
    "A" => '0A',
    "B" => '0B',
    "C" => '0C',
    "D" => '0D',
    "E" => '0E',
    "F" => '0F',
    "G" => '10',
    "H" => '11',
    "I" => '12',
    "J" => '13',
    "K" => '14',
    "L" => '15',
    "M" => '16',
    "N" => '17',
    "O" => '18',
    "P" => '19',
    "Q" => '1A',
    "R" => '1B',
    "S" => '1C',
    "T" => '1D',
    "U" => '1E',
    "V" => '1F',
    "W" => '20',
    "X" => '21',
    "Y" => '22',
    "Z" => '23',
    "a" => '24',
    "b" => '25',
    "c" => '26',
    "d" => '27',
    "e" => '28',
    "f" => '29',
    "g" => '2A',
    "h" => '2B',
    "i" => '2C',
    "j" => '2D',
    "k" => '2E',
    "l" => '2F',
    "m" => '30',
    "n" => '31',
    "o" => '32',
    "p" => '33',
    "q" => '34',
    "r" => '35',
    "s" => '36',
    "t" => '37',
    "u" => '38',
    "v" => '39',
    "w" => '3A',
    "x" => '3B',
    "y" => '3C',
    "z" => '3D',
    "!" => '3E',
    "?" => '40',
    "+" => '42',
    "'" => '93',
    " " => 'fa'
  }

  delegate :character, :slot, :palette, :block, to: :context

  def perform
    serialize_character_set!
    serialize_roster_slot!
    serialize_primary!
    serialize_palette!
    serialize_sex!
    pad!('00', 1)
    serialize_zodiac!
    serialize_secondary!
    serialize_reaction!
    serialize_support!
    serialize_movement!
    serialize_helmet!
    serialize_armor!
    serialize_accessory!
    serialize_rhand_weapon!
    serialize_rhand_shield!
    serialize_lhand_weapon!
    serialize_lhand_shield!
    serialize_exp!
    serialize_level!
    serialize_brave!
    serialize_faith!
    serialize_hp!
    serialize_mp!
    serialize_sp!
    serialize_pa!
    serialize_ma!
    serialize_skills!
    serialize_jp!
    serialize_name!
    pad!('00', 17)
  end

  private

    def pad!(byte, n = 1)
      n.times do
        block << byte
      end
    end

    def serialize_character_set!
      block << CHARACTER_SETS[character.sex]
    end

    def serialize_roster_slot!      
      block << "%02x" % (slot + 8)
    end

    def serialize_primary!
      block << PRIMARIES[character.job.name]
    end

    def serialize_palette!
      block << "%02x" % (palette + 1)
    end

    def serialize_sex!
      block << SEXES[character.sex]
    end

    def serialize_zodiac!
      block << ZODIACS[character.zodiac]
    end

    def serialize_secondary!
      block << (SECONDARIES[character.secondary&.skillset] || backup_secondary)
    end

    def backup_secondary
      return '05' unless character.job.name == 'Squire'

      return '06'
    end

    def serialize_reaction!
      reaction = (REACTIONS[character.reaction&.name] || '0000')

      block << little_endian(reaction, 2)
    end

    def serialize_support!
      support = (SUPPORTS[character.support&.name] || '0000')
      
      block << little_endian(support, 2)
    end

    def serialize_movement!
      movement = (MOVEMENTS[character.movement&.name] || '0000')
      
      block << little_endian(movement, 2)
    end

    def serialize_helmet!
      block << (HELMETS[character.helmet&.name] || 'ff')
    end

    def serialize_armor!
      block << (ARMORS[character.armor&.name] || 'ff')
    end

    def serialize_accessory!
      block << (ACCESSORIES[character.accessory&.name] || 'ff')
    end

    def serialize_rhand_weapon!
      if character.two_hands_engaged?
        block << WEAPONS[character.weapon.name] || 'ff'
      elsif character.rhand&.weapon?
        block << WEAPONS[character.rhand.name] || 'ff'
      else
        pad!('ff', 1)
      end
    end

    def serialize_rhand_shield!
      if character.rhand&.shield?
        block << SHIELDS[character.rhand.name] || 'ff'
      else
        pad!('ff', 1)
      end
    end

    def serialize_lhand_weapon!
      if character.two_hands_engaged? || !character.lhand&.weapon?
        pad!('ff', 1)
      else
        block << WEAPONS[character.lhand.name] || 'ff'
      end
    end

    def serialize_lhand_shield!
      if character.lhand&.shield?
        block << SHIELDS[character.lhand.name] || 'ff'
      else
        pad!('ff', 1)
      end
    end

    def serialize_exp!
      block << '63'
    end

    def serialize_level!
      block << '23'
    end

    def serialize_brave!
      block << character.brave.to_i.to_s(16)
    end

    def serialize_faith!
      block << character.faith.to_i.to_s(16)
    end

    def serialize_hp!
      hp = solve_for_x('hp', character.job_data['hp'].to_i).to_s(16)

      block << little_endian(hp, 3)
    end

    def serialize_mp!
      mp = solve_for_x('mp', character.job_data['mp'].to_i).to_s(16)
      
      block << little_endian(mp, 3)
    end

    def serialize_sp!
      sp = solve_for_x('sp', character.job_data['speed'].to_i).to_s(16)
      
      block << little_endian(sp, 3)
    end

    def serialize_pa!
      pa = solve_for_x('pa', character.job_data['attack'].to_i).to_s(16)
      
      block << little_endian(pa, 3)
    end

    def serialize_ma!
      ma = solve_for_x('ma', character.job_data['magic'].to_i).to_s(16)
      
      block << little_endian(ma, 3)
    end

    def solve_for_x(stat, val)
      (val.to_f * RAW_CONST / character.job_data["#{stat}_mult"].to_i).ceil
    end

    def serialize_skills!
      pad!('00', 3)

      SKILLFLAGS_JOBS.each do |job|
        if job == character.job.name
          encode_skills!(job, character.primary_skills)
        elsif job == character.secondary&.name
          encode_skills!(job, character.secondary_skills)
        else
          pad!('00', 3)
        end
      end
    end

    def encode_skills!(job, skills)
      value = skills.pluck(:name)
        .map{|s| SKILLFLAGS_MAP[job][s].to_i(16) }
        .sum

      value = "%04x" % value

      block << value.first(2)
      block << value.last(2)
      block << '00'
    end

    def serialize_jp!
      pad!('88', 10)

      40.times do
        pad!('0F')
        pad!('27')
      end
    end

    def serialize_name!
      16.times do |i|
        block << 'FE' and next if character.name[i].nil?

        char = TEXT_ENCODINGS[character.name[i]]

        block << char unless char.blank?
      end

      block << 'FE'
    end

    def little_endian(str, bytes)
      padded_str = "%0#{bytes * 2}x" % str.to_i(16)

      padded_str.scan(/(..)/).reverse.join
    end
end
