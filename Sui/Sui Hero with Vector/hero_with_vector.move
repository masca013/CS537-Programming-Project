module move_gas_optimization::hero_with_vector{
    use sui::dynamic_object_field;
    use sui::bag;
    use std::vector;
  

    // Set up Hero object structure (now includes accessories_vector)
    public struct Hero has key, store {
        id: UID,
        accessories_vector: vector<Sword>
    }

    // Set up individual accessories:
    public struct Sword has key, store {
        id: UID,
        strength: u64
    }

    public struct Shield has key, store {
        id: UID,
        strength: u64
    }

    public struct Hat has key, store {
        id: UID,
        strength: u64
    }

    // Create a single hero, create and add 3 accessories to a bag, add bag & vector to hero
    public entry fun create_hero_with_bag_in_dynamic_obj_field(ctx: &mut TxContext) {
        // create vector of 20 accessories
        let mut accessories_vector: vector<Sword> = vector::empty<Sword>();
        let mut j = 0;
        while (j < 20) {
            let sword = Sword {id: object::new(ctx), strength: 0};
            vector::push_back(&mut accessories_vector, sword);
            j = j + 1;
        };

        let mut hero: Hero = Hero {
            id: object::new(ctx),
            accessories_vector
        };

        // creating bag
        let mut bag_object = bag::new(ctx);

        // creating hero attributes
        let mut sword = Sword{id: object::new(ctx), strength: 0};
        let mut shield = Shield{id: object::new(ctx), strength: 0};
        let mut hat = Hat{id: object::new(ctx), strength: 0};

        // adding hero attributes to bag
        bag::add(&mut bag_object, 0, sword);
        bag::add(&mut bag_object, 1, shield);
        bag::add(&mut bag_object, 2, hat);

        // adding bag as dynamic object field
        dynamic_object_field::add(&mut hero.id, b"bag", bag_object);

        transfer::transfer(hero, tx_context::sender(ctx));
    }

    // Create many hero objects
    public entry fun create_heroes_with_bag_in_dynamic_obj_field(ctx: &mut TxContext) {
        let mut i = 0;
        //create 10 heroes per function call
        while (i < 10) {
            // create and initialize accessories_vector for each hero
            let mut accessories_vector: vector<Sword> = vector::empty<Sword>();
            let mut j = 0;
            while (j < 20) {
                let sword = Sword {id: object::new(ctx), strength: 0};
                vector::push_back(&mut accessories_vector, sword);
                j = j + 1;
            };

            // Create Hero object with vector
            let mut hero = Hero{
                id: object::new(ctx),
                accessories_vector
            };

            // creating bag
            let mut bag_object = bag::new(ctx);

            // creating hero attributes
            let mut sword = Sword{id: object::new(ctx), strength: 0};
            let mut shield = Shield{id: object::new(ctx), strength: 0};
            let mut hat = Hat{id: object::new(ctx), strength: 0};

            // adding hero attributes to bag
            bag::add(&mut bag_object, 0, sword);
            bag::add(&mut bag_object, 1, shield);
            bag::add(&mut bag_object, 2, hat);

            // adding bag as dynamic object field
            dynamic_object_field::add(&mut hero.id, b"bag", bag_object);
            transfer::transfer(hero, tx_context::sender(ctx));

            i = i + 1;
        }
    }

    // Repeatedly access hero accessories and element from the vector
    public entry fun access_hero_with_bag_in_dynamic_obj_field(hero_obj_ref: &mut Hero) {
        let mut i = 0;

        // initial borrow for bag items (existing behavior)
        let mut bag_ref: &mut bag::Bag = dynamic_object_field::borrow_mut(&mut hero_obj_ref.id, b"bag");
        let mut sword: &mut Sword = bag::borrow_mut(bag_ref, 0);
        let mut shield: &mut Shield = bag::borrow_mut(bag_ref, 1);
        let mut hat: &mut Hat = bag::borrow_mut(bag_ref, 2);
        let sword_ref: &Sword = vector::borrow(&hero_obj_ref.accessories_vector, 0);
        let _strength: u64 = sword_ref.strength;

        //access 1000 times per function call
        while (i < 1000) {
            bag_ref = dynamic_object_field::borrow_mut(&mut hero_obj_ref.id, b"bag");
            sword = bag::borrow_mut(bag_ref, 0);
            shield = bag::borrow_mut(bag_ref, 1);
            hat = bag::borrow_mut(bag_ref, 2);

            let _sword_ref: &Sword = vector::borrow(&hero_obj_ref.accessories_vector, 0);

            i = i + 1;
        }
    }

    // Repeatedly update hero accessories and modify element from the vector
    public entry fun update_hero_with_bag_in_dynamic_obj_field(hero_obj_ref: &mut Hero) {
        let mut i = 0;
        let mut bag_ref: &mut bag::Bag = dynamic_object_field::borrow_mut(&mut hero_obj_ref.id, b"bag");
        let mut sword: &mut Sword = bag::borrow_mut(bag_ref, 0);
        sword.strength = sword.strength + 10;
        let mut shield: &mut Shield = bag::borrow_mut(bag_ref, 1);
        shield.strength = shield.strength + 10;
        let mut hat: &mut Hat = bag::borrow_mut(bag_ref, 2);
        hat.strength = hat.strength + 10;
        let mut vec_item_ref: &mut Sword = vector::borrow_mut(&mut hero_obj_ref.accessories_vector, 0);
        vec_item_ref.strength = vec_item_ref.strength + 1;

        i = i + 1;
        //update 1000 times per function call
        while (i < 1000) {
            // update bag elements
            bag_ref = dynamic_object_field::borrow_mut(&mut hero_obj_ref.id, b"bag");

            sword = bag::borrow_mut(bag_ref, 0);
            sword.strength = sword.strength + 10;

            shield = bag::borrow_mut(bag_ref, 1);
            shield.strength = shield.strength + 10;

            hat = bag::borrow_mut(bag_ref, 2);
            hat.strength = hat.strength + 10;

            // update vector element
            let mut sword_ref: &mut Sword = vector::borrow_mut(&mut hero_obj_ref.accessories_vector, 0);
            sword_ref.strength = sword_ref.strength + 1;

            i = i + 1;
        }
    }
}
