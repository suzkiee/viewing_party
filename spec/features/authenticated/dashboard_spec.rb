require 'rails_helper'

RSpec.describe 'dashboard page' do
  it 'can not access dashboard without login' do
    visit dashboard_path
    expect(current_path).to_not eq(dashboard_path)
    expect(current_path).to eq(welcome_path)
  end

  describe 'dashboard page with login' do
    before(:each)do
      User.destroy_all
      @user_1 = User.create!(email: 'test123@xyz.com', password: 'viewparty')

      visit welcome_path
      fill_in :email, with: "test123@xyz.com"
      fill_in :password, with: "viewparty"
      click_button "Sign In"
    end

    it 'has button to Discover Movies page' do
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("Welcome test123!")
      expect(page).to have_button("Discover Movies")
      click_button "Discover Movies"
      expect(current_path).to eq(discover_path)
    end

    it 'has Friends section with Add Field button' do
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("Friends")
      expect(page).to have_field('email')
      expect(page).to have_button('Add Friend')
    end

    it 'shows no listed friends message' do
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("No Friends Currently")
      expect(page).to_not have_content("lola_rabbit@aol.com")
    end

    it 'shows Sad Path, user not found' do
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_field('email')
      expect(page).to have_button('Add Friend')
      fill_in :email, with: "lola_rabbit@aol.com"
      click_button "Add Friend"
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("User not found")
      expect(page).to_not have_content("lola_rabbit@aol.com")
    end

    it 'shows Sad Path, user can not add own email to friend list' do
      expect(current_path).to eq(dashboard_path)
      fill_in :email, with: "test123@xyz.com"
      click_button "Add Friend"
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("Unable to Add User")
    end

    it 'shows Sad Path, user can not add existing friend' do
      click_link("Log out")
      @user_2 = User.create!(email: 'lola_rabbit@aol.com', password: 'lola')
      @user_1.friends.push(@user_2)
      fill_in :email, with: "test123@xyz.com"
      fill_in :password, with: "viewparty"
      click_button "Sign In"

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("lola_rabbit@aol.com")
      fill_in :email, with: "lola_rabbit@aol.com"
      click_button "Add Friend"
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("Unable to Add User")
    end

    it 'adds user to and shows in Friends list' do
      @user_2 = User.create(email: 'lola_rabbit@aol.com', password: 'lola')

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_field('email')
      expect(page).to have_button('Add Friend')
      fill_in :email, with: "lola_rabbit@aol.com"
      click_button "Add Friend"
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("#{@user_2.email[/[^@]+/]} Added as Friend")
      expect(page).to have_content("lola_rabbit@aol.com")
    end

    it 'shows friends in Friends section' do
      click_link("Log out")
      User.destroy_all
      @user_1 = User.create!(email: 'test123@xyz.com', password: 'viewparty')
      @user_2 = User.create!(email: 'lola_rabbit@aol.com', password: 'lola')
      @user_3 = User.create!(email: 'bugs_bunny@gmail.com', password: 'bugs')
      @user_4 = User.create!(email: 'daffy_duck@yahoo.com', password: 'daffy')
      @user_1.friends.push(@user_2, @user_3)

      fill_in :email, with: "test123@xyz.com"
      fill_in :password, with: "viewparty"
      click_button "Sign In"

      expect(current_path).to eq(dashboard_path)
      expect(page).to have_content("#{@user_2.email}")
      expect(page).to have_content("lola_rabbit@aol.com")
      expect(page).to have_content("bugs_bunny@gmail.com")
      expect(page).to_not have_content("daffy_duck@yahoo.com")
    end

    it 'has Logout link to Welcome Page' do
      expect(current_path).to eq(dashboard_path)
      expect(page).to have_link("Log out")
      click_link("Log out")
      expect(current_path).to eq(welcome_path)
      expect(page).to_not have_link("Log out")
      expect(page).to have_content("Welcome to Viewing Party")
      expect(page).to have_link("New to Viewing Party? Register Here")
    end

    context "User dashboard has viewing parties" do
      it 'shows viewing parties that user is invited to' do
        click_link("Log out")
        User.destroy_all
        movie = VCR.use_cassette("movie_details_by_id") do
          MovieFacade.movie_details_by_id(337404)
        end
        user = create(:mock_user, password: 'hello')
        friend = create(:mock_user)
        friend.friends << user
        party = create(:mock_party, host_id: friend.id, movie_id: movie.id, title: movie.title)
        party_guests = create(:mock_party_guest, party_id: party.id, guest: user )

        # user.friends << friend
        # party = create(:mock_party, host_id: user.id, movie_id: movie.id, title: movie.title)
        # party_guests = create(:mock_party_guest, party_id: party.id, guest: friend )

        fill_in :email, with: user.email
        fill_in :password, with: user.password
        click_button "Sign In"

        expect(page).to have_content("Parties You're In")
        expect(page).to have_content("Cruella")
        expect(page).to have_content(party.date.strftime("%B %d, %Y"))
        expect(page).to have_content(party.start_time.strftime("%l:%M %p"))
        expect(page).to have_content(user.email)
      end

      it 'shows viewing parties that user is hosting' do
        click_link("Log out")
        User.destroy_all
        movie = VCR.use_cassette("movie_details_by_id") do
          MovieFacade.movie_details_by_id(337404)
        end
        user = create(:mock_user, password: 'hello')
        friend = create(:mock_user)
        user.friends << friend
        party = create(:mock_party, host_id: user.id, movie_id: movie.id, title: movie.title)
        user.parties << party
        party_guests = create(:mock_party_guest, party_id: party.id, guest: friend)

        fill_in :email, with: user.email
        fill_in :password, with: user.password
        click_button "Sign In"

        expect(page).to have_content("Parties You're Hosting")
        expect(page).to have_content("Cruella")
        expect(page).to have_content(party.date.strftime("%B %d, %Y"))
        expect(page).to have_content(party.start_time.strftime("%l:%M %p"))
        expect(page).to have_content(friend.email)
      end
    end
  end
end
