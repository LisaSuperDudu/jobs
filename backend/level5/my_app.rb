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
    rental.compute

    actors = [
      Actor.new("driver", "debit", rental.driver_money),
      Actor.new("owner", "credit", rental.owner_money),
      Actor.new("insurance", "credit", rental.insurance_fee),
      Actor.new("assistance", "credit", rental.assistance_fee),
      Actor.new("drivy", "credit", rental.drivy_fee)
    ]

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

    rental_hash = build_json(rental.id, actions)
    rentals_hash_array << rental_hash

  end
  build_output(rentals_hash_array)
end
