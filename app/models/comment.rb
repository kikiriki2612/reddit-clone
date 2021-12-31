class Comment < ApplicationRecord 
    validates :body, presence: true
    
    belongs_to :author, class_name: :User, foreign_key: :user_id, inverse_of: :comments
    belongs_to :post, inverse_of: :comments

    has_many :child_comments,
        class_name: :Comment,
        foreign_key: :parent_comment_id,
        primary_key: :id

    belongs_to :parent_comment,
        class_name: :Comment,
        foreign_key: :parent_comment_id,
        primary_key: :id,
        optional: true
end