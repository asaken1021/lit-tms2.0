require 'bundler/setup'
Bundler.require

if development?
  ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
  has_many :projects
  has_secure_password
  validates :mail,
    presence: true,
    uniqueness: true,
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password,
    presence: true,
    length: { in: 8..24 }
end

class Project < ActiveRecord::Base
  has_many :phases
  validates :name,
    presence: true
end

class Phase < ActiveRecord::Base
  has_many :tasks
  validates :name,
    presence: true
  validates :deadline,
    presence: true,
    length: { is: 10 }
end

class Task < ActiveRecord::Base
  validates :name,
    presence: true
end

class Nonce < ActiveRecord::Base

end