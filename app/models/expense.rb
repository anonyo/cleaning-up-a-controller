class Expense < ActiveRecord::Base
  belongs_to :user

  validates :amount, presence: true

  def self.pending_users(user)
    self.where(user: user, deleted: false)
  end

  def self.approved_user(user, approved_params)
    self.where(user: user, approved: approved_params, deleted: false)
  end

  def self.more_than(min_amount)
    self.where('amount > ?', min_amount)
  end

  def self.less_than(max_amount)
    self.where('amount < ?', max_amount)
  end
end
