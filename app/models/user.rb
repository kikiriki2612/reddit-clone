class User < ApplicationRecord
    attr_reader :password

    before_validation :ensure_session_token

    validates :username, :session_token, presence: true
    validates :password_digest, presence: { message: 'Password can\'t be black'}
    validates :password, length: { minimum: 6, allow_nil: true }
    validates :session_token, :username, uniqueness: true
    
    has_many :subs, 
        class_name: :Sub, 
        foreign_key: :moderator_id,
        primary_key: :id,
        inverse_of: :moderator
    
    has_many :posts, inverse_of: :author
    has_many :comments, inverse_of: :author
    has_many :user_votes, inverse_of: :user

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        user.try(:is_password?, password) ? user : nil
    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def reset_session_token!
        self.session_token = User.generate_session_token
        self.save!
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= User.generate_session_token
    end
end