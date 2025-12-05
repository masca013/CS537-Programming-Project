// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HeroWithoutVector {

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
    uint256 public nextId;

    //create 10 heroes
    function createHeroes() public {
        for (uint256 i = 0; i < 10; i++) {
            heroes[nextId] = Hero(
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
        }
    }

    //update hero (1000 iterations)
    function updateHero(uint256 heroId) public {
        require(heroes[heroId].exists, "Hero not found");

        for (uint256 i = 0; i < 1000; i++) {
            heroes[heroId].sword.strength += 1;
            heroes[heroId].shield.strength += 1;
            heroes[heroId].hat.strength += 1;
        }
    }

    //delete one hero
    function deleteHero(uint256 heroId) public {
        require(heroes[heroId].exists, "Hero not found");
        delete heroes[heroId];
    }
}
