class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true

  has_many :parties, dependent: :destroy, foreign_key: :host_id
  has_many :friendships, dependent: :destroy
  has_many :friends, class_name: :User, through: :friendships

  has_secure_password

  def invited_parties
    find_party_guests_user.map do |party_guest|
      Party.find(party_guest.party_id)
    end
  end

  def find_party_guests_user
    PartyGuest.where('guest_id = ?', self.id)
  end

  def self.guest_emails
    joins(:party_guests).where("party_guests.guest_id = users.id").pluck(:emails)
  end

  def friends_emails
    self.friends.pluck(:email)
  end
end
