# frozen_string_literal: true

require 'rails_helper'

describe 'FleetsController - #confirm_delete', type: :request do
  subject { post delete_fleets_path, params: { 'confirm-delete' => confirmation } }
  let(:confirmation) { 'yes' }
  let(:fleet) { create_fleet }

  it 'returns redirect to the login page' do
    subject
    expect(response).to redirect_to(new_user_session_path)
  end

  context 'when user is logged in' do
    before do
      sign_in create_user
      mock_fleet(fleet)
    end

    it 'returns redirect to fleets' do
      subject
      expect(response).to redirect_to(fleets_path)
    end

    context 'with VRN in the session' do
      before { add_to_session(vrn: @vrn) }

      context 'when user confirms form' do
        it 'redirects to fleets page' do
          subject
          expect(response).to redirect_to(fleets_path)
        end

        it 'calls Fleet#delete_vehicle' do
          expect(fleet).to receive(:delete_vehicle).with(@vrn)
          subject
        end

        it 'clears vrn in the session' do
          subject
          expect(session[:vrn]).to eq(nil)
        end

        it 'sets :success notification in flash' do
          subject
          expect(flash[:success])
            .to eq('You have successfully removed ABC123 from your vehicle list.')
        end

        context 'when it was the last vehicle' do
          before { mock_fleet(create_empty_fleet) }

          it 'redirects to dashboard' do
            subject
            expect(response).to redirect_to(dashboard_path)
          end
        end
      end

      context 'when user does not confirm details' do
        let(:confirmation) { 'no' }

        it 'redirects to fleets page' do
          subject
          expect(response).to redirect_to(fleets_path)
        end

        it 'does not call Fleet#delete_vehicle' do
          expect(fleet).not_to receive(:delete_vehicle)
          subject
        end
      end

      context 'when confirmation is empty' do
        let(:confirmation) { '' }

        it 'redirects to delete' do
          subject
          expect(response).to redirect_to(delete_fleets_path)
        end

        it 'flashes a right alert' do
          subject
          expect(flash[:alert]).to eq(I18n.t('confirmation_form.answer_missing'))
        end
      end
    end
  end
end
