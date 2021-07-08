require 'rails_helper'

RSpec.describe MovieService do 
  before(:each) do
    @m = MovieService.new
  end

  it 'exists' do
    expect(@m).to be_a(MovieService)
  end

  describe 'instance methods' do 
    describe '#top_rated' do 
      it 'can return list of top rated movies' do
        response = @m.top_rated 
        
        expect(response).to have_key(:results)
        expect(response).to have_key(:page)
        expect(response[:results]).to be_an(Array)
        expect(response[:results].first[:title]).to eq("Dilwale Dulhania Le Jayenge")
        expect(response[:results].last[:title]).to eq("Cruella")
      end
    end

    describe '#find_by_title' do
      it 'can find movie '
    end
  end
end