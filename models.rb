class User <ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :comments
end

class Post <ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
end

class Comment <ActiveRecord::Base
  belongs_to :post
  belongs_to :user
end

class Request <ActiveRecord::Base
  belongs_to :user
end

class Friendship <ActiveRecord::Base
  belongs_to :user
end
