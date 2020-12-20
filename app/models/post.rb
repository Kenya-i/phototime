class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :notifications, dependent: :destroy
  mount_uploader :photo, PhotoUploader
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :photo, presence: true
  validates :content, presence: true, length: { maximum: 140}


  def self.search search
    return Post.all unless search
    Post.where(['content LIKE ?', "%#{search}%"])
  end



  def create_notification_like!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ",
                               current_user.id, user_id, id, 'like'])
    if temp.blank?
      notification = current_user.active_notifications.new(post_id: id,
                                                           visited_id: user_id,
                                                           action: 'like' )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end



  def create_notification_comment!(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end



  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(post_id: id,
                                                         comment_id: comment_id,
                                                        visited_id: visited_id,
                                                      action: 'comment')
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end
