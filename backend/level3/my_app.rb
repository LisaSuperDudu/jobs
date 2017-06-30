require 'json'
require 'date'

def rental_period(start_date, end_date)
  start_date = Date.parse(start_date)
  end_date = Date.parse(end_date)
  (end_date - start_date).to_i + 1
end

def distance_price(rental_distance, price_per_km)
  rental_distance * price_per_km
end

def time_price(rental_period, price_per_day)
  final_price = 0
  for i in 1..rental_period
    if i == 1
      final_price = price_per_day
    elsif i <= 4
      final_price += (price_per_day * 0.9).to_i
    elsif i <= 10
      final_price += (price_per_day * 0.7).to_i
    elsif i > 10
      final_price += (price_per_day * 0.5).to_i
    end
  end
  final_price
end

def rental_price(distance_price, time_price)
  distance_price + time_price
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

    price_per_day = price_per_day(car)
    price_per_km = price_per_km(car)

    rental_price = rental_price(distance_price(rental_distance, price_per_km), time_price(rental_period, price_per_day))

    commission = (rental_price * 0.3).to_i

    insurance_fee = commission / 2
    assistance_fee = rental_period * 100
    drivy_fee = commission - (insurance_fee + assistance_fee)

    rental_hash = {
        id: rental["id"],
        price: rental_price,
        commission: {
          insurance_fee: insurance_fee,
          assistance_fee: assistance_fee,
          drivy_fee: drivy_fee
        }
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
