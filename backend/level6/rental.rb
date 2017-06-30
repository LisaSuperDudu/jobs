class Rental
  attr_reader :id,
              :car,
              :deductible_reduction_boolean,
              :rental_price,
              :commission,
              :deductible_reduction,
              :insurance_fee,
              :assistance_fee,
              :drivy_fee,
              :driver_money,
              :owner_money

  attr_accessor :start_date, :end_date, :distance, :rental_modifications_id

  def initialize(id, car, start_date, end_date, distance, deductible_reduction)
    @id = id
    @car = car
    @start_date = start_date
    @end_date = end_date
    @distance = distance
    @deductible_reduction_boolean = deductible_reduction
  end

  def rental_period
    (Date.parse(@end_date) - Date.parse(@start_date)).to_i + 1
  end

  def compute_rental_price
    distance_price(car.price_per_km) + time_price(car.price_per_day)
  end

  def distance_price(price_per_km)
    distance * price_per_km
  end

  def time_price(price_per_day)
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

  def deductible_reduction?
    deductible_reduction_boolean
  end

  def compute_commission
    (rental_price * 0.3).to_i
  end

  def compute_insurance_fee
    commission / 2
  end

  def compute_assistance_fee
    rental_period * 100
  end

  def compute_drivy_fee
    commission - (insurance_fee + assistance_fee) + deductible_reduction
  end

  def compute_owner_money
    rental_price - commission
  end

  def compute_driver_money
    rental_price + deductible_reduction
  end

  def compute
    @rental_price = compute_rental_price
    @commission = compute_commission

    if deductible_reduction?
      @deductible_reduction = 400 * rental_period
    else
      @deductible_reduction = 0
    end

    @insurance_fee = compute_insurance_fee
    @assistance_fee = compute_assistance_fee
    @drivy_fee = compute_drivy_fee
    @owner_money = compute_owner_money
    @driver_money = compute_driver_money
  end

  def update(update_data)
    if update_data["distance"] != nil
      @distance = update_data["distance"]
    end

    if update_data["start_date"] != nil
      @start_date = update_data["start_date"]
    end

    if update_data["end_date"] != nil
      @end_date = update_data["end_date"]
    end
    @rental_modifications_id = update_data["id"]
  end
end
