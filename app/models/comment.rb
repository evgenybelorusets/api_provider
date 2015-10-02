class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates :user, presence: true
  validates :post, presence: true
  validates :content, presence: true, length: { maximum: 255 }

  attr_readonly :user_id, :post_id

  delegate :first_name, :last_name, :email, to: :user, prefix: true
end
