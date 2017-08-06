class User < ApplicationRecord
    has_many :books, dependent: :destroy
    before_save { self.email = email.downcase }
      validates :name,  presence: true, length: { maximum: 50 }
      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      validates :email, presence: true, length: { maximum: 255 },
                        format: { with: VALID_EMAIL_REGEX },
                        uniqueness: { case_sensitive: false }
      validates :budget, numericality: true
      validates :password, presence: true, length: { minimum: 6 }
      has_secure_password

      # 与えられた文字列のハッシュ値を返す
      def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end
end
