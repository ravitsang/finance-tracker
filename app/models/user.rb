class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  def stock_already_add?(ticker_symbol)
    stock = Stock.find_by_ticker(ticker_symbol)
    return false unless stock
    user_stocks.where(stock_id: stock.id).exists?
  end

  def under_stock_limit?
    (user_stocks.count < 10)
  end

  def can_add_stock?(ticker_symbol)
    !stock_already_add?(ticker_symbol) && under_stock_limit?
  end

  def full_name
    return "#{first_name} #{last_name}".strip if (first_name || last_name)
    "Anonymous"
  end

  def self.search(param)
    param.strip!
    param.downcase!
    to_send_back = User.where('first_name LIKE ?', "%#{param}%")
    .or(User.where('last_name LIKE ?', "%#{param}%"))
    .or(User.where('email LIKE ?', "%#{param}%"))
  end

  def except_current_user(users)
    users.reject {|user| user.id == self.id }
  end


  def not_friend_with(friend)
    #debugger
    friendships.where(friend_id: friend.id).count < 1
  end
end
