module move_gas_optimization::delete_hero_with_vector{
    use sui::dynamic_object_field;
    use sui::bag;
    use std::vector;

    // Set up Hero object structure
    public struct Hero has key, store{
        id: UID,
        accessories_vector: vector<Sword>
    }

    // Set up individual accessories:
    public struct Sword has key, store{
        id: UID,
        strength: u64
    }

    public struct Shield has key, store{
        id: UID,
        strength: u64
    }

    public struct Hat has key, store{
        id: UID,
        strength: u64
    }

    // Create a single hero, create and add 3 accessories to a bag, add bag to hero as a dynamic field
    public entry fun create_hero_with_bag_in_dynamic_obj_field(ctx: &mut TxContext){
        //create vector of 20 accessories
        let mut accessories_vector: vector<Sword> = vector::empty<Sword>();
        let mut j = 0;
        while (j < 20) {
            let sword = Sword {id: object::new(ctx), strength: 0};
            vector::push_back(&mut accessories_vector, sword);
            j = j + 1;
        };

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
    }

    //Helper Functions: Delete accessories
    public fun delete_sword_from_bag(bag_ref: &mut bag::Bag){
        //1) Unpack Sword
        let Sword {id, strength:_} = bag::remove(bag_ref, 0);
        //2) Delete ID
        object::delete(id);
    }

    public fun delete_shield_from_bag(bag_ref: &mut bag::Bag){
        //1) Unpack Shield
        let Shield {id, strength:_} = bag::remove(bag_ref, 1);
        //2) Delete ID
        object::delete(id);
    }

    public fun delete_hat_from_bag(bag_ref: &mut bag::Bag){
        //1) Unpack Hat
        let Hat {id, strength:_} = bag::remove(bag_ref, 2);
        //2) Delete ID
        object::delete(id);
    }

    // Delete elements within bag
    public fun delete_bag_contents(hero_obj_ref: &mut Hero){
        //1) Set up mut_ref to bag using borrow_mut
        let mut bag_ref: &mut bag::Bag = dynamic_object_field::borrow_mut(&mut hero_obj_ref.id, b"bag");
        //2) Call delete on accessories within bag
        delete_sword_from_bag(bag_ref);
        delete_shield_from_bag(bag_ref);
        delete_hat_from_bag(bag_ref);
    }

    // Delete accessories, bag, and hero objects
    public entry fun delete_hero_with_bag_in_dynamic_obj_fields_detach_and_delete_children(mut hero: Hero){
        //1) Call delete_bag_contents
        delete_bag_contents(&mut hero);
        //2) Unpack and delete Bag
        bag::destroy_empty(dynamic_object_field::remove(&mut hero.id, b"bag"));
        //3) unpack and delete vector of accessories
        let len = vector::length(&hero.accessories_vector);
        let mut i = 0;
        while (i < len) {
            let Sword { id, strength: _ } = vector::pop_back(&mut hero.accessories_vector);
            object::delete(id);
            i = i + 1;
        };
        //4) Unpack and delete Hero
        let Hero { id, accessories_vector } = hero;
        vector::destroy_empty(accessories_vector);
        object::delete(id);
    }
}
