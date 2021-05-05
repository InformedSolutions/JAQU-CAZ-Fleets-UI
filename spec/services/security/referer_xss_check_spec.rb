# frozen_string_literal: true

require 'rails_helper'

describe Security::RefererXssCheck do
  subject { described_class.call(referer: referer) }

  describe '#call' do
    context 'when referer includes inline javascript' do
      let(:referer) { 'javascript:alert("XSS");' }

      it 'raises RefererXssException' do
        expect { subject }.to raise_exception(RefererXssException)
      end
    end

    context 'when referer does not include inline javascript' do
      let(:referer) { 'http://localhost' }

      it 'does not raise exception RefererXssException' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
