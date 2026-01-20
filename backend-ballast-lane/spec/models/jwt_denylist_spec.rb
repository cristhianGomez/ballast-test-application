# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtDenylist do
  describe 'table name' do
    it 'uses jwt_denylist as table name' do
      expect(described_class.table_name).to eq('jwt_denylist')
    end
  end

  describe 'Devise JWT revocation strategy' do
    it 'includes Devise::JWT::RevocationStrategies::Denylist' do
      expect(described_class.ancestors).to include(Devise::JWT::RevocationStrategies::Denylist)
    end
  end

  describe 'token revocation' do
    let(:user) { create(:user) }

    it 'stores revoked tokens' do
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      jti = JWT.decode(token, nil, false).first['jti']

      expect do
        JwtDenylist.create!(jti: jti, exp: 1.day.from_now)
      end.to change(JwtDenylist, :count).by(1)
    end

    it 'can check if token is revoked' do
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      jti = JWT.decode(token, nil, false).first['jti']

      JwtDenylist.create!(jti: jti, exp: 1.day.from_now)

      expect(JwtDenylist.exists?(jti: jti)).to be true
    end
  end
end
