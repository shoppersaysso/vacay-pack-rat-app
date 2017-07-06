class User < ActiveRecord::Base

  has_secure_password

  has_many :lists
  has_many :items, through: :lists

  validates :email, :username, presence: true, uniqueness: true

  def slug
    username.downcase.gsub(" ","-")
  end

  def self.find_by_slug(slug)
    User.all.find{|user| user.slug == slug}
  end

end
