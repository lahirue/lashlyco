require 'users_helper'

class User < ActiveRecord::Base
  belongs_to :referrer, class_name: 'User', foreign_key: 'referrer_id'
  has_many :referrals, class_name: 'User', foreign_key: 'referrer_id'

  validates :email, presence: true, uniqueness: true, format: {
    with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i,
    message: 'Invalid email format.'
  }
  validates :referral_code, uniqueness: true

  before_create :create_referral_code
  after_create :send_welcome_email

  REFERRAL_STEPS = [
    {
      'count' => 5,
      'html' => 'POP<br>SOCKET',
      'class' => 'two',
      'image' =>  ActionController::Base.helpers.asset_path(
        '/assets/home/popsocket.jpg')
    },
    {
      'count' => 10,
      'html' => '1 MONTH<br>SUBSCRIPTION',
      'class' => 'three',
      'image' => ActionController::Base.helpers.asset_path(
        '/assets/home/1month.jpg')
    },
    {
      'count' => 25,
      'html' => '3 MONTH<br>SUBSCRIPTION',
      'class' => 'four',
      'image' => ActionController::Base.helpers.asset_path(
        '/assets/home/3month.jpg')
    },
    {
      'count' => 50,
      'html' => '6 MONTH<br>SUBSCRIPTION',
      'class' => 'five',
      'image' => ActionController::Base.helpers.asset_path(
        '/assets/home/6month.jpg')
    }
  ]

  private

  def create_referral_code
    self.referral_code = UsersHelper.unused_referral_code
  end

  def send_welcome_email
    UserMailer.delay.signup_email(self)
  end
end
