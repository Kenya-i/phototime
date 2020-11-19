class User < ApplicationRecord
    validates :name , presence: { message: "を入力してください。"}, length: { maximum: 50 }
    # VALID_EMAIL_REGEX = 
    validates :email, presence: { message: "を入力してください。"}, length: { maximum: 255 }
end
