class JwtService
  HMAC_SECRET = ENV['HMAC_SECRET']

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, HMAC_SECRET, 'HS256')
  end

  def self.decode(token)
    decoded_token = JWT.decode(token, HMAC_SECRET, true, { algorithm: 'HS256' })
    HashWithIndifferentAccess.new(decoded_token[0])
  rescue JWT::DecodeError
    nil
  end

  def self.refresh_token(old_token)
    decoded_token = decode(old_token)
    return nil unless decoded_token

    payload = decoded_token.except(:exp)
    encode(payload)
  end
end
