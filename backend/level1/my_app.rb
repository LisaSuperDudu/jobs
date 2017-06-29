require 'json'
require 'date'

def rental_period(start_date, end_date)
  start_date = Date.parse(start_date)
  end_date = Date.parse(end_date)
  (end_date - start_date).to_i + 1
end

def rental_price(distance, price_per_km, rental_period, price_per_day)
  (distance * price_per_km) + (rental_period * price_per_day)
end

def price_per_km(car)
  car.first["price_per_km"]
end

def price_per_day(car)
  car.first["price_per_day"]
end

def my_app
  json = File.read('data.json')
  data = JSON.parse(json)

  cars = data["cars"]
  rentals = data["rentals"]

  rental_hash = {}
  rentals_array = []

  rentals.each do |rental|
    start_date = rental["start_date"]
    end_date = rental["end_date"]
    rental_period = rental_period(start_date, end_date)
    rental_distance = rental["distance"]

    car_id = rental["car_id"]
    car = cars.select { |car|  car["id"] == car_id  }

    rental_price = rental_price(rental_distance, price_per_km(car), rental_period, price_per_day(car))

    rental_hash = {
        id: rental["id"],
        price: rental_price
    }

    rentals_array << rental_hash
  end

  rentals_json = {
    "rentals":
    rentals_array
  }

  File.open("my_output.json","w") do |f|
    f.write(JSON.pretty_generate(rentals_json))
  end
end
