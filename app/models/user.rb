class User < ActiveRecord::Base
  has_many :posts
  has_secure_password
  validates :username, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :email, presence: true
  validates :instrument, presence: true
  validates :style, presence: true
end
