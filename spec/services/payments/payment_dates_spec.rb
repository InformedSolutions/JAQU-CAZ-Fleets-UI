# frozen_string_literal: true

require 'rails_helper'

describe Payments::PaymentDates do
  subject(:service) do
    described_class.new(charge_start_date: charge_start_date, user_beta_tester: user_beta_tester)
  end

  let(:charge_start_date) { Time.zone.today }
  let(:user_beta_tester) { false }

  describe '.chargeable_dates' do
    subject { service.chargeable_dates }

    context 'when user is not beta tester' do
      context 'when charge_start_date was before 6 days ago' do
        let(:charge_start_date) { 10.days.ago }

        it 'returns next and past dates' do
          expect(subject.keys).to contain_exactly(:next, :past)
        end

        it 'returns 7 objects in :next block' do
          expect(subject[:next].size).to eq(7)
        end

        it 'returns 6 objects in :past block' do
          expect(subject[:past].size).to eq(6)
        end

        it 'returns a proper object' do
          expect(subject[:next].first).to eq(
            {
              name: Date.current.strftime(described_class::DISPLAY_DATE_FORMAT),
              value: Date.current.strftime(described_class::VALUE_DATE_FORMAT),
              today: true
            }
          )
        end
      end

      context 'when charge_start_date was before 3 days ago' do
        let(:charge_start_date) { Time.zone.today - 3.days }

        it 'returns next and past dates' do
          expect(subject.keys).to contain_exactly(:next, :past)
        end

        it 'returns 7 objects in :next block' do
          expect(subject[:next].size).to eq(7)
        end

        it 'returns 6 objects in :past block' do
          expect(subject[:past].size).to eq(3)
        end

        it 'returns a proper object' do
          expect(subject[:next].first).to eq(
            {
              name: Date.current.strftime(described_class::DISPLAY_DATE_FORMAT),
              value: Date.current.strftime(described_class::VALUE_DATE_FORMAT),
              today: true
            }
          )
        end
      end

      context 'when charge_start_date was before today ago' do
        it 'returns next and past dates' do
          expect(subject.keys).to contain_exactly(:next, :past)
        end

        it 'returns 7 objects in :next block' do
          expect(subject[:next].size).to eq(7)
        end

        it 'returns 6 objects in :past block' do
          expect(subject[:past]).to be_empty
        end

        it 'returns a proper object' do
          expect(subject[:next].first).to eq(
            {
              name: Date.current.strftime(described_class::DISPLAY_DATE_FORMAT),
              value: Date.current.strftime(described_class::VALUE_DATE_FORMAT),
              today: true
            }
          )
        end
      end
    end

    context 'when user is beta tester' do
      let(:charge_start_date) { 31.days.from_now }
      let(:user_beta_tester) { true }

      it 'returns next and past dates' do
        expect(subject.keys).to contain_exactly(:next, :past)
      end

      it 'returns 7 objects in :next block' do
        expect(subject[:next].size).to eq(7)
      end

      it 'returns 6 objects in :past block' do
        expect(subject[:past].size).to eq(6)
      end

      it 'returns a proper object' do
        expect(subject[:next].first).to eq(
          {
            name: Date.current.strftime(described_class::DISPLAY_DATE_FORMAT),
            value: Date.current.strftime(described_class::VALUE_DATE_FORMAT),
            today: true
          }
        )
      end
    end
  end

  describe '.d_day_notice' do
    context 'when #charge_start_date is yesterday' do
      let(:charge_start_date) { Time.zone.yesterday }

      it 'returns true' do
        expect(service.d_day_notice).to be_truthy
      end
    end

    context 'with #charge_start_date is today' do
      let(:charge_start_date) { Date.current }

      it 'returns true' do
        expect(service.d_day_notice).to be_truthy
      end
    end

    context 'when #charge_start_date is tomorrow' do
      let(:charge_start_date) { Date.current.tomorrow }

      it 'returns false' do
        expect(service.d_day_notice).to be_falsey
      end
    end

    context 'when #charge_start_date is not considered' do
      let(:charge_start_date) { Time.zone.today - 7.days }

      it 'returns false' do
        expect(service.d_day_notice).to be_falsey
      end
    end
  end

  describe '.d_day_content_tab' do
    subject { service.d_day_content_tab }

    context 'when #charge_start_date was 5 days ago' do
      let(:charge_start_date) { Time.zone.today - 5.days }

      it 'returns a proper value' do
        expect(service.d_day_content_tab).to eq('Previous Days')
      end
    end

    context 'when #charge_start_date was 6 days ago' do
      let(:charge_start_date) { Time.zone.today - 6.days }

      it 'returns a proper value' do
        expect(service.d_day_content_tab).to eq('Past 6 days')
      end
    end
  end
end
