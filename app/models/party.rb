class Party < ApplicationRecord
  validates :start_time, presence: true
  validates :date, presence: true
  validates :movie_id, :duration, presence: true, numericality: true
  validates :title, presence: true

  belongs_to :host, class_name: :User
  has_many :party_guests, dependent: :destroy
  has_many :guests, class_name: :User, through: :party_guests
end
