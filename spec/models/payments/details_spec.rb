# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payments::Details, type: :model do
  subject(:details) do
    described_class.new(
      session_details: session_details,
      entries_paid: entries_paid,
      total_charge: total_charge
    )
  end

  let(:session_details) do
    {
      la_id: zone_id,
      external_id: id,
      user_email: email,
      payment_reference: reference
    }
  end
  let(:entries_paid) { 5 }
  let(:total_charge) { 150 }

  let(:zone_id) { SecureRandom.uuid }
  let(:reference) { SecureRandom.uuid }
  let(:id) { SecureRandom.uuid }
  let(:email) { 'test@example.com' }

  let(:caz_stub) { instance_double 'CleanAirZone', name: 'Leeds' }

  before do
    allow(CleanAirZone).to receive(:find).and_return(caz_stub)
  end

  it { expect(details.caz_name).to eq('Leeds') }
  it { expect(details.user_email).to eq(email) }
  it { expect(details.reference).to eq(reference) }
  it { expect(details.external_id).to eq(id) }
  it { expect(details.total_charge).to eq(total_charge) }
  it { expect(details.entries_paid).to eq(entries_paid) }
end
