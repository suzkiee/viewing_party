class MovieFacade
  def self.forty_top_rated_movies
    service = MovieService.new
    movies = service.request_api("/3/movie/top_rated?page=1")[:results] + service.request_api("/3/movie/top_rated?page=2")[:results]
  end

  def self.search_movie_title(title)
    service = MovieService.new
    movies = service.request_api("/3/search/movie?query=#{title}")[:results]
  end

  def self.movie_details_by_id(movie_id)
    service = MovieService.new
    movie = service.request_api("/3/movie/#{movie_id}") 
    cast = service.request_api("/3/movie/#{movie_id}/credits")
    reviews = service.request_api("/3/movie/#{movie_id}/reviews")
    @movie = MovieDetails.new(movie, cast, reviews)
  end
end
