class Topic < ApplicationRecord
  has_many :posts  # ← 缺这个
end
