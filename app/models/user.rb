class User < ActiveRecord::Base
  ROLES = { admin: 0, user: 1, guest: 2 }

  belongs_to :client_application
  has_many :posts
  has_many :comments

  attr_readonly :uid, :client_application_id

  validates_presence_of :uid, :role
  validates :client_application, presence: true

  enum role: ROLES

  class << self
    def guest
      new(role: :guest)
    end
  end
end
