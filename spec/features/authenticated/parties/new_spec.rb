require 'rails_helper'

RSpec.describe "Parties New form" do
  before(:each)do
    @user = User.create(email: 'test123@xyz.com', password: 'viewparty')
    visit welcome_path
    fill_in :email, with: "test123@xyz.com"
    fill_in :password, with: "viewparty"
    click_button "Sign In"
    visit "/movies/337404"
    click_on "Create Viewing Party"
  end
  
  context "if user has no friends" do 
    it "creates a party" do 
    
      fill_in 'date', with: '12/12/21'
      fill_in 'start_time', with: '5:00 PM'
      fill_in 'duration', with: 200
      click_on "Create Party"
      
      expect(page).to_not have_content("Invite:")
      expect(page).to have_content("You've created a Viewing Party!")
      expect(current_path).to eq(dashboard_path)
    end

    it "can't create party with a duration less than the movie runtime" do 
    
      fill_in 'date', with: '12/12/21'
      fill_in 'start_time', with: '5:00 PM'
      fill_in 'duration', with: 55
      click_on "Create Party"

      expect(page).to have_content("Party duration cannot be less than movie run time.")
      expect(current_path).to eq(parties_new_path)
    end
    
    it "can't create a party with empty fields" do
      
      fill_in 'duration', with: 190
      click_on "Create Party"
      
      expect(page).to have_content("You must enter a valid start time, date and duration.")
      expect(current_path).to eq(parties_new_path)
    end
  end

  context "if user has friends" do
    before(:each) do
      @friend_1 = create(:mock_user)
      @friend_2 = create(:mock_user)
      @friend_3 = create(:mock_user)
      @user.friends.push(@friend_1, @friend_2, @friend_3)
      visit "/movies/337404"
      click_on "Create Viewing Party"
    end

    it 'shows friends you can invite on the form' do
     
      expect(page).to have_content("Invite:")
      expect(page).to have_content(@friend_1.email)
      expect(page).to have_content(@friend_2.email)
      expect(page).to have_content(@friend_3.email)
    end

    it "creates party with invited friends" do
      
      fill_in 'date', with: '12/12/21'
      fill_in 'start_time', with: '5:00 PM'
      fill_in 'duration', with: 200
      check "friend[#{@friend_2.id}]"
      click_on "Create Party"

      expect(current_path).to eq(dashboard_path)
      # expect(page).to have_content("Cruella")
    end
  end
end