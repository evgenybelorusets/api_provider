class ClientApplication < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :validatable
  before_create :generate_http_basic_credentials

  private

  def generate_http_basic_credentials
    begin
      self.key = SecureRandom.hex(16)
      self.secret = SecureRandom.hex(16)
    end while self.class.where(key: key, secret: secret).exists?
  end
end
