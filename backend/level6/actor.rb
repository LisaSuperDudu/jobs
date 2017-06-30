class  Actor
  attr_reader :who, :type, :amount

  def initialize(who, type, amount )
    @who = who
    @type = type
    @amount = amount
  end

  def update(rental_update)
    if type == "debit"
      relative_credit = -amount
    else
      relative_credit = amount
    end

    if who == "driver"
      relative_credit = -(relative_credit + rental_update.driver_money)
    elsif who == "owner"
      relative_credit = rental_update.owner_money - relative_credit
    elsif who == "insurance"
      relative_credit = rental_update.insurance_fee - relative_credit
    elsif who == "assistance"
      relative_credit = rental_update.assistance_fee - relative_credit
    elsif who == "drivy"
      relative_credit = rental_update.drivy_fee - relative_credit
    end

    if relative_credit < 0
      @type = "debit"
    else
      @type = "credit"
    end
    @amount = relative_credit.abs
  end
end
