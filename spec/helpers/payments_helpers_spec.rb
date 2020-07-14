# frozen_string_literal: true

require 'rails_helper'

describe PaymentsHelper do
  let(:date) { '2019-11-03' }

  describe '.checked?' do
    subject(:method) { helper.checked?(@vrn, date) }

    context 'when there is no date in the session' do
      it { is_expected.to be_falsey }
    end

    context 'when date is in the session' do
      before do
        session[:new_payment] = { details: { @vrn => { dates: [date, '2019-11-05'] } } }
      end

      it { is_expected.to be_truthy }
    end

    context 'when date is not in the session' do
      before do
        session[:new_payment] = { details: { @vrn => { dates: %w[2019-11-04 2019-11-05] } } }
      end

      it { is_expected.to be_falsey }
    end
  end

  describe '.paid?' do
    subject(:method) { helper.paid?(vehicle, date) }

    let(:vehicle) { instance_double(VehiclesManagement::ChargeableVehicle, paid_dates: dates) }

    context 'when there is no dates in the paid_dates' do
      let(:dates) { [] }

      it { is_expected.to be_falsey }
    end

    context 'when the given date is in the paid_dates' do
      let(:dates) { [date, '2019-11-05'] }

      it { is_expected.to be_truthy }
    end
  end
end
