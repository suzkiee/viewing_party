class Authenticated::PartiesController < Authenticated::BaseController
  def new 
    @movie = MovieFacade.movie_details_by_id(params[:movie_id])
    @friends = current_user.friends
  end 

  def create 
    party = party_params
    movie = MovieFacade.movie_details_by_id(params[:movie_id])
    party[:host_id] = current_user.id 
    
    if party[:duration].to_i > movie.runtime
      new_party = Party.create(party)
      if new_party.save
        add_party_guest(new_party) if params[:friend]
        redirect_to dashboard_path
        flash[:success] = "You've created a Viewing Party!"
      else 
        redirect_to parties_new_path 
        flash[:error] = "You must enter a valid start time, date and duration."
      end 
    else 
      redirect_to parties_new_path 
      flash[:error] = "Party duration cannot be less than movie run time."
    end
  end

  private
    def add_party_guest(party)
      guests = friend_params.select { |friend_id, invited| invited == '1' }
      guests.each do |id, value|
        PartyGuest.create(party_id: party.id,  guest_id: id.to_i)
      end
    end

    def party_params
      params.permit(:movie_id, :duration, :start_time, :date, :title)
    end

    def friend_params
      params.require(:friend).permit!
    end
end