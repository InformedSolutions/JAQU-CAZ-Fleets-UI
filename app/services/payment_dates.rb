# frozen_string_literal: true

class PaymentDates < BaseService
  # date format used to display on the UI, eg. 'Fri 11 Oct'
  DISPLAY_DATE_FORMAT = '%a %d %b'
  # date format used to communicate with backend API, eg. '2019-05-14'
  VALUE_DATE_FORMAT = '%Y-%m-%d'

  def call
    today = Date.current
    {
      past: ((today - 6.days)..(today - 1.day)).map { |date| parse(date) },
      next: (today..(today + 6.days)).map { |date| parse(date) }
    }
  end

  private

  # Create hash of dates
  def parse(date)
    value = date.strftime(VALUE_DATE_FORMAT)
    {
      name: date.strftime(DISPLAY_DATE_FORMAT),
      value: value,
      today: date.today?
    }
  end
end
