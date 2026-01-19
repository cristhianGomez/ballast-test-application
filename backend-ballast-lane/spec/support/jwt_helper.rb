module JwtHelper
  def auth_headers_for(user)
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    { "Authorization" => "Bearer #{token}" }
  end

  def auth_token_for(user)
    Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
  end
end

RSpec.configure do |config|
  config.include JwtHelper, type: :request
end
