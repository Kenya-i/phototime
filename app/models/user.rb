class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    

    # has_many :sns_credentials, dependent: :destroy
    # devise   :database_authenticatable, :registerable,
    #          :recoverable, :rememberable, :validatable,
    #          :omniauthable
            #  , omniauth_providers: %i[facebook google_oauth2]
    before_save { self.email = email.downcase }

    has_many :posts, dependent: :destroy

    has_many :likes, dependent: :destroy

    has_many :liked_posts, through: :likes,  source: :post

    has_many :comments, dependent: :destroy

    has_many :active_relationships,  class_name: "Relationship",
                                     foreign_key: "follower_id",
                                     dependent: :destroy
    has_many :passive_relationships, class_name:  "Relationship",
                                     foreign_key: "followed_id",
                                     dependent: :destroy
    
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower

    has_many :active_notifications, class_name: 'Notification',
                                    foreign_key: "visitor_id",
                                    dependent: :destroy
    has_many :passive_notifications, class_name: 'Notification',
                                     foreign_key: "visited_id",
                                     dependent: :destroy

    has_secure_password

    # 画像アップロード実装(carrierwave)
    mount_uploader :image, ImageUploader

    validates :name ,    presence: { message: "を入力してください。"},
                         length: { maximum: 20 }

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email,    presence: { message: "を入力してください。"},
                         length: { maximum: 255 },
                         format: { with: VALID_EMAIL_REGEX },
                         uniqueness: { case_sensitive: false }

    validates :password, presence: true,
                         length: { minimum: 6},
                         allow_nil: true
    # validates :password_confirmation, presence: true, allow_nil: true
    validates :username, presence: true,
                         allow_nil: true,
                         length: { maximum: 20 }

    VALID_TELL_PHONE = /\A0[56789]0[-]?\d{4}[-]?\d{4}\z/
    validates :tell_number, format: { with: VALID_TELL_PHONE },
                            allow_blank: true

    validates :website,  length: { maximum: 255 }

    validates :self_introduce, length: { maximum: 300}

    # validates :image, presence: true

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end


    def feed
        Post.where("user_id = ?", id)
    end

    def follow(other_user)
        following << other_user
    end

    def unfollow(other_user)
        active_relationships.find_by(followed_id: other_user.id).destroy
    end

    def following?(other_user)
        following.include?(other_user)
    end

    def liked(post)
        liked_posts << post
    end

    def unliked(post)
        likes.find_by(post_id: post.id).destroy
    end

    def like?(post)
        liked_posts.include?(post)
    end

    def create_notification_follow!(current_user)
      temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ", current_user.id, id, 'follow'])

      if temp.blank?
        notification = current_user.active_notifications.new(visited_id: id,
                                                             action: 'follow')
        notification.save if notification.valid?
      end
    end


    def feed
      following_ids = "SELECT followed_id FROM relationships
                      WHERE follower_id = :user_id"           
      Post.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
    end


    # def self.without_sns_data(auth)
    #     user = User.where(email: auth.info.email).first

    #         if user.present?
    #             sns = SnsCredential.create(
    #                 uid: auth.uid,
    #                 provider: auth.provider,
    #                 user_id: user.id
    #             )
    #         else
    #             user = User.new(
    #                 nickname: auth.info.name,
    #                 email: auth.info.email,
    #             )
    #             sns = SnsCredential.new(
    #                 uid: auth.uid,
    #                 provider: auth.provider
    #             )
    #         end
    #         return { user: user, sns: sns }
    # end


    # def self.with_sns_data(auth, snsncredential)
    #     user = User.where(id: snscredential.user_id).first
    #     unless user.present?
    #         user = User.new(
    #             nickname: auth.info.name,
    #             email: auth.info.email,
    #         )
    #     end
    #     return { user: user}
    # end


    # def self.find_oauth(auth)
    #     uid = auth.uid
    #     provider = auth.provider
    #     snscredential = SnsCredential.where(uid: uid, provider: provider).first
    #     if snscredential.present?
    #         user = with_sns_data(auth, snscredential)[:user]
    #         sns = snscredential
    #     else
    #         user = without_sns_data(auth)[:user]
    #         sns = without_sns_data(auth)[:sns]
    #     end
    #     return { user: user, sns: sns }
    # end

    def self.find_for_oauth(auth)
        user = User.where(uid: auth.uid, provider: auth.provider).first
    
        unless user
          user = User.create(
            uid:      auth.uid,
            provider: auth.provider,
            email:    User.dummy_email(auth),
            password: Devise.friendly_token[0, 20]
          )
        end
    
        user
      end
    
      private
    
      def self.dummy_email(auth)
        "#{auth.uid}-#{auth.provider}@example.com"
      end

end
