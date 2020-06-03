# frozen_string_literal: true

class PaymentDates < BaseService
  # Attribute accessor used in {matrix}[rdoc-ref:PaymentsController.matrix]
  attr_accessor :d_day_notice

  # date format used to display on the UI, eg. 'Fri 11 Oct'
  DISPLAY_DATE_FORMAT = '%a %d %b'
  # date format used to communicate with backend API, eg. '2019-05-14'
  VALUE_DATE_FORMAT = '%Y-%m-%d'

  ##
  # Initializer method.
  #
  # ==== Attributes
  # * +charge_start_date+ - date when CAZ started charging.
  #
  def initialize(charge_start_date:)
    @charge_start_date = charge_start_date
  end

  # Build the list of dates and return them, e.g.
  # {:past=>[{:name=>"Wed 27 May", :value=>"2020-05-27", :today=>false}],
  # :next=>[{:name=>"Fri 29 May", :value=>"2020-05-29", :today=>true}, ]}
  def chargeable_dates
    {
      past: past_dates,
      next: (Date.today..(Date.today + 6.days)).map { |date| parse(date) }
    }
  end

  private

  attr_reader :charge_start_date

  # Create hash of dates
  def parse(date)
    value = date.strftime(VALUE_DATE_FORMAT)
    {
      name: date.strftime(DISPLAY_DATE_FORMAT),
      value: value,
      today: date.today?
    }
  end

  # generates past dates to pay
  def past_dates
    return [] if charge_start_date >= Date.today

    (past_start_date..past_end_date).map { |date| parse(date) }
  end

  # set past dates start date and assigns +d_day_notice+
  def past_start_date
    past_start_date = Date.today - 6.days
    if charge_start_date > past_start_date
      @d_day_notice = true
      charge_start_date
    else
      @d_day_notice = false
      past_start_date
    end
  end

  # set past dates end date
  def past_end_date
    past_end_date = Date.today - 1.day
    past_end_date < charge_start_date ? charge_start_date : past_end_date
  end
end
