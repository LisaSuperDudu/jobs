require 'json'
require 'date'
require './car'
require './rental'
require './builder'

def my_app
  initialize_objects
  rentals_hash_array = []

  @rentals.each do |rental|
    rental.compute

    rental_hash = build_json(
      rental.id,
      rental.rental_price,
      rental.deductible_reduction,
      rental.insurance_fee,
      rental.assistance_fee,
      rental.drivy_fee
      )

    rentals_hash_array << rental_hash
  end
  build_output(rentals_hash_array)
end
