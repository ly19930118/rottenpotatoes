class MoviesController < ApplicationController
  #before_filter :load_ratings, :only => :index
  
  #def load_ratings
  #  @all_ratings = Movie.find_all_ratings
  #end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.find_all_ratings
    session[:sort_by] = params[:sort_by] if params[:sort_by]
    
    if params.has_key?(:ratings) 
      session[:ratings] = params[:ratings]
      @checked_ratings = params[:ratings].keys
    else
      if session[:ratings]
        @checked_ratings = session[:ratings].keys
        flash.keep
        redirect_to movies_path(:sort_by =>session[:sort_by] ,:ratings => session[:ratings])
      else
        @checked_ratings = @all_ratings
      end
    end
    
    if params.has_key?(:sort_by)
      if params[:sort_by] == 'title'
        @title_header = 'hilite'
      elsif params[:sort_by] == 'release_date'
        @rdate_header = 'hilite'
      end
      @movies = Movie.order(params[:sort_by]).where('rating IN (?)', @checked_ratings)
    else
      @movies = Movie.where('rating IN (?)', @checked_ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def search_by_director
    @movie = Movie.find(params[:id]) 
    if @movie.director.blank?
      flash[:notice] = "'#{@movie.title}' has no director info"
      redirect_to movies_path
    else
      @mvs = @movie.find_same_director_movies
    end
  end
end