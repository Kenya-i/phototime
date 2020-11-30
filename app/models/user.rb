class User < ApplicationRecord
    before_save { self.email = email.downcase }

    has_many :posts, dependent: :destroy

    has_secure_password

    # 画像アップロード実装(carrierwave)
    mount_uploader :image, ImageUploader

    validates :name ,    presence: { message: "を入力してください。"},
                         length: { maximum: 50 }

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email,    presence: { message: "を入力してください。"},
                         length: { maximum: 255 },
                         format: { with: VALID_EMAIL_REGEX },
                         uniqueness: { case_sensitive: false }

    validates :password, presence: true,
                         length: { minimum: 6},
                         allow_nil: true
    # validates :password_confirmation, presence: true, :on => :update, :unless => lambda{ |user| user.password.blank? }
    validates :username, presence: true,
                         allow_nil: true,
                         length: { maximum: 20 }

    VALID_TELL_PHONE = /\A0[56789]0[-]?\d{4}[-]?\d{4}\z/
    validates :tell_number, format: { with: VALID_TELL_PHONE },
                            allow_blank: true

    validates :website,  length: { maximum: 255 }

    validates :self_introduce, length: { maximum: 300}

    

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
end
