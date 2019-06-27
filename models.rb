require 'bundler/setup'
Bundler.require

if development?
  ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class Project < ActiveRecord::Base
  has_many :phases
end

class Phase < ActiveRecord::Base
  has_many :tasks
  validates :deadline,
    presence: true,
    length: { is: 10 }
end

class Task < ActiveRecord::Base

end