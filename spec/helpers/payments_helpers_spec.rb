# frozen_string_literal: true

require 'rails_helper'

describe PaymentsHelper do
  let(:date) { '2019-11-03' }

  describe '.checked?' do
    subject { helper.checked?(@vrn, date) }

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
    subject { helper.paid?(vehicle, date) }

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

  describe '.parse_date' do
    subject { helper.parse_date('2020-09-04') }

    it 'returns a proper date format' do
      expect(subject).to eq('Friday 04 September 2020')
    end
  end

  describe '.single_vrn_parsed_charge' do
    subject { helper.single_vrn_parsed_charge(['03 September 2020'], 50.0) }

    it 'returns a proper value' do
      expect(subject).to eq('£50.00')
    end
  end

  describe '.exemption_url_for' do
    subject { helper.exemption_url_for(caz) }

    let(:caz) do
      instance_double 'CleanAirZone',
                      name: 'Leeds',
                      exemption_url: 'www.example.com'
    end

    it 'returns a `link_to` instance' do
      expect(subject).to be_an(ActiveSupport::SafeBuffer)
    end
  end
end
