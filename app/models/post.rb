class Post < ActiveRecord::Base
  paginates_per 10

  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :user, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 5000 }

  attr_readonly :user_id

  delegate :first_name, :last_name, :email, to: :user, prefix: true
end
