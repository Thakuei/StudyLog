class User < ApplicationRecord
  has_many :study_records, dependent: :destroy
end
