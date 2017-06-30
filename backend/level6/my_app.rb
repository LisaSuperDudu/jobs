require 'json'
require 'date'
require './car'
require './rental'
require './actor'
require './builder'

def my_app
  initialize_objects
  rentals_hash_array = []

  @rentals.each do |rental|
    rental.compute()

    actors = [
      Actor.new("driver", "debit", rental.driver_money),
      Actor.new("owner", "credit", rental.owner_money),
      Actor.new("insurance", "credit", rental.insurance_fee),
      Actor.new("assistance", "credit", rental.assistance_fee),
      Actor.new("drivy", "credit", rental.drivy_fee)
    ]

    rentals_updated = []

    @updates.each do |update_data|
      if update_data["rental_id"] == rental.id
        rental.update(update_data)
        rental.compute()
        rentals_updated << rental
      end
    end

    rentals_updated.each do |rental_update|
      actors.each do |actor|
        actor.update(rental_update)
      end

      actions = []
      actors.each do |actor|
        action =
        {
          "who": actor.who,
          "type": actor.type,
          "amount": actor.amount
        }
        actions << action
      end

      rental_hash = build_json(rental.rental_modifications_id, rental.id, actions)
      rentals_hash_array << rental_hash
    end
  end

  build_output(rentals_hash_array)
end
