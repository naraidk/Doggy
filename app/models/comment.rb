class Comment < ApplicationRecord
  belongs_to :dog
  belongs_to :post
end
