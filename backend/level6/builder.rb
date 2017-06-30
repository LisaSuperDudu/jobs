def initialize_objects
  json = File.read('data.json')
  data = JSON.parse(json)

  cars_parsed = data["cars"]
  rentals_parsed = data["rentals"]

  cars = []
  cars_parsed.each do |car|
    car = Car.new(car["id"], car["price_per_day"], car["price_per_km"] )
    cars << car
  end

  @rentals = []
  rentals_parsed.each do |rental|
    car = cars.find {|car| car.id == rental["car_id"]}
    rental = Rental.new(rental["id"], car, rental["start_date"], rental["end_date"], rental["distance"], rental["deductible_reduction"])
    @rentals << rental
  end

  @updates = data["rental_modifications"]
end

def build_json(id, rental_id, actions)
  rental_hash = {
    id: id,
    rental_id: rental_id,
    actions: actions
  }
end

def build_output(rentals_hash_array)
  rentals_json = {
    "rental_modifications":
    rentals_hash_array
  }

  File.open("my_output.json","w") do |f|
    f.write(JSON.pretty_generate(rentals_json) + "\n")
  end
end
