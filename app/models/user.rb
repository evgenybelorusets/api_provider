class User < ActiveRecord::Base
  ROLES = [ :admin, :user, :guest ]

  belongs_to :client_application
  has_many :posts
  has_many :comments

  validates_presence_of :uid, :role
  validates :client_application, presence: true

  enum role: ROLES

  class << self
    def guest
      new(role: :guest)
    end
  end
end
