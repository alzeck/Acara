class Comment < ApplicationRecord
  belongs_to :previous
  belongs_to :user
  belongs_to :event
end
