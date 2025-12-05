// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HeroWithVector {
    struct Sword {
        uint256 strength;
    }

    struct Shield {
        uint256 strength;
    }

    struct Hat {
        uint256 strength;
    }

    struct Hero {
        Sword sword;
        Shield shield;
        Hat hat;
        bool exists;
    }

    mapping(uint256 => Hero) public heroes;

    //nested mapping for storing 20 accessories
    mapping(uint256 => mapping(uint256 => Sword)) public accessories;

    uint256 public nextId;
    uint256 public constant ACCESSORY_COUNT = 20;

    //create 10 heroes
    function createHeroes() public {
        for (uint256 i = 0; i < 10; i++) {
            uint256 heroId = nextId;

            //add 20 accessories to the hero
            for (uint256 j = 0; j < ACCESSORY_COUNT; j++) {
                accessories[heroId][j] = Sword(j);
            }

            heroes[heroId] = Hero(
                Sword(0),
                Shield(0),
                Hat(0),
                true
            );

            nextId++;
        }
    }

    //access hero (1000 iterations)
    function accessHero(uint256 heroId) public {
        require(heroes[heroId].exists, "Hero not found");

        for (uint256 i = 0; i < 1000; i++) {
            Hero storage h = heroes[heroId];
            uint256 a = h.sword.strength;
            uint256 b = h.shield.strength;
            uint256 c = h.hat.strength;
            //access last accessory
            uint256 x = accessories[heroId][19].strength;
        }
    }

    //update hero (1000 iterations)
    function updateHero(uint256 heroId) public {
        require(heroes[heroId].exists, "Hero not found");

        for (uint256 i = 0; i < 1000; i++) {
            heroes[heroId].sword.strength += 1;
            heroes[heroId].shield.strength += 1;
            heroes[heroId].hat.strength += 1;

            //update first accessory
            accessories[heroId][0].strength += 1;
        }
    }

    //delete one hero
    function deleteHero(uint256 heroId) public {
        require(heroes[heroId].exists, "Hero not found");
        delete heroes[heroId];

        //delete the 20 accessories
        for (uint256 i = 0; i < ACCESSORY_COUNT; i++) {
            delete accessories[heroId][i];
        }
    }
}
