class MovieDetails
  attr_reader :title,
              :vote_average,
              :runtime,
              :genres,
              :overview,
              :cast,
              :reviews,
              :id

  def initialize(movie, cast, reviews)
    @title = movie[:title]
    @vote_average = movie[:vote_average]
    @runtime = movie[:runtime]
    @genres = movie[:genres]
    @overview = movie[:overview]
    @cast = cast[:cast][0..9]
    @reviews = reviews[:results]
    @id = movie[:id]
  end
end
