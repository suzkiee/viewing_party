require 'rails_helper'

RSpec.describe Party, type: :model do
  describe 'relationships' do
    it { should belong_to(:host) }
    it { should have_many(:party_guests) }
    it { should have_many(:guests).through(:party_guests) }
  end

  describe 'validations' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:movie_id) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:title) }
    it { should validate_numericality_of(:movie_id) }
    it { should validate_presence_of(:duration) }
    it { should validate_numericality_of(:duration) }
  end
end
